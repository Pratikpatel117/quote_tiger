import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:quote_tiger/controllers/attached_file_controller.dart';
import 'package:quote_tiger/models/quote.dart';
import 'package:quote_tiger/models/request.dart';
import 'package:quote_tiger/services/request.dart';
import 'package:quote_tiger/services/user.dart';
import 'package:quote_tiger/utils/array_handler.dart';
import 'package:quote_tiger/utils/globals.dart';
import 'package:quote_tiger/utils/nullable_snapshot_field_handler.dart';

extension Limit<T> on List<T> {
  List<T> limit(int limit) {
    List<T> newList = [];
    for (var i = 0; i < limit && i < length; i++) {
      newList.add(this[i]);
    }
    return newList;
  }
}

class UserModel extends ChangeNotifier {
  final String? website;
  final String? instagram;
  final String? facebook;
  final String? twitter;
  final String? linkedin;
  final String id;
  final String username;
  String fullName;
  String image;

  final List<String> savedRequestIds;
  final List<String> savedProfiles;

  List<String> sectors;

  final String? email;
  String description;
  String location;
  final String? company;

  final bool isSuperUser;
  // this is for showing a dialog after creating a request

  UserModel(
      {required this.id,
      required this.username,
      required this.isSuperUser,
      required this.fullName,
      required this.savedRequestIds,
      required this.image,
      required this.location,
      required this.sectors,
      required this.savedProfiles,
      this.instagram,
      this.facebook,
      this.twitter,
      this.linkedin,
      this.website,
      this.company,
      this.email,
      this.description =
          'Here should have been some interesting things about you.'});
  factory UserModel.fromAlgoliaSnapshot(AlgoliaObjectSnapshot snapshot) {
    var data = snapshot.data;
    return UserModel(
        id: snapshot.objectID,
        username: data['username'],
        isSuperUser: false,
        fullName: data['display_name'],
        savedRequestIds: [],
        image: data['image'] ??
            'https://firebasestorage.googleapis.com/v0/b/pietrocka-ranking.appspot.com/o/user_not_found.jpg?alt=media&token=05a0e15f-47dd-4b22-bfcf-988fb8c5806e',
        location: data['location'] ?? 'no-country',
        sectors: [],
        savedProfiles: []);
  }

  factory UserModel.fromSnapshot(
    DocumentSnapshot document,
  ) {
    return UserModel(
      instagram: nullableDocumentFieldRead(document, 'instagram'),
      facebook: nullableDocumentFieldRead(document, 'facebook'),
      twitter: nullableDocumentFieldRead(document, 'twitter'),
      linkedin: nullableDocumentFieldRead(document, 'linkedin'),
      website: nullableDocumentFieldRead(document, 'website'),
      savedProfiles: arrayHandler(document, 'saved_profiles'),
      company: nullableDocumentFieldRead(document, 'company'),
      email: nullableDocumentFieldRead(document, 'email'),
      location: nullableDocumentFieldRead(document, 'location') ??
          'Location Not Picked',
      description: nullableDocumentFieldRead(document, 'about') ??
          'Here should have been some interesting things about you.',
      savedRequestIds: arrayHandler(document, 'saved_requests'),
      sectors: arrayHandler(document, 'sectors'),
      fullName: document['display_name'],
      image: document['image'] ??
          'https://firebasestorage.googleapis.com/v0/b/pietrocka-ranking.appspot.com/o/user_not_found.jpg?alt=media&token=05a0e15f-47dd-4b22-bfcf-988fb8c5806e',
      isSuperUser: document['is_admin'] ?? false,
      id: document.id,
      username: document['username'] ?? 'user-not-found',
    );
  }

  void notify() {
    notifyListeners();
  }

  Future<QuoteModel?> getQuoteByLocalUserFromRequest(String requestID) async {
    var snaps = (await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestID)
            .collection('quotes')
            .where('creator', isEqualTo: id)
            .limit(1)
            .get())
        .docs;
    if (snaps.isEmpty) {
      return null;
    }

    return QuoteModel.fromSnapshot(snaps[0]);
  }

  //state management
  Future<UserModel> getSyncedModel({bool syncSectors = false}) async {
    var newModel = await UserService.getUserById(id, getSectors: syncSectors);
    if (!syncSectors) {
      newModel.sectors = sectors;
    }

    return newModel;
  }

  // quotes methods
  Future<List<QuoteModel>> get getSentQuotes async {
    List<QuoteModel> quoteModels = [];
    var snaps = (await FirebaseFirestore.instance
        .collectionGroup('quotes')
        .where('creator', isEqualTo: id)
        .orderBy('creation_date', descending: true)
        .limit(10)
        .get());
    for (var quote in snaps.docs) {
      quoteModels.add(QuoteModel.fromSnapshot(quote));
    }

    return quoteModels;
  }

  //bookmark methods
  Future<List<RequestModel>> get getSavedRequests async {
    List<RequestModel> requestModels = [];
    List<String> toDelete = [];
    for (var requestID in savedRequestIds.reversed.toList().limit(10)) {
      final requestModel =
          await RequestService.getNullableRequestById(requestID);
      if (requestModel != null) {
        requestModels.add(requestModel);
      } else {
        toDelete.add(requestID);
      }
    }

    _purgeSavedRequests(toDelete);

    return requestModels;
  }

  Future<void> _purgeSavedRequests(List<String> toDelete) async {
    for (var id in toDelete) {
      savedRequestIds.remove(id);
    }
    if (toDelete.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({"saved_requests": FieldValue.arrayRemove(toDelete)});
      notifyListeners();
    }
  }

  Future<void> addRequestBookmark(String requestID) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'saved_requests': FieldValue.arrayUnion([requestID])
    });

    savedRequestIds.add(requestID);
    notifyListeners();
  }

  Future<List<UserModel>> get getSavedUserProfiles async {
    List<UserModel> requestModels = [];
    for (var profile in savedProfiles) {
      requestModels
          .add(await UserService.getUserById(profile, getSectors: false));
    }

    return requestModels;
  }

  Future<void> removeRequestBookmark(String bookmarkID) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'saved_requests': FieldValue.arrayRemove([bookmarkID])
    });
    savedRequestIds.remove(bookmarkID);
    notifyListeners();
  }

  Future<void> addProfileBookmark(String bookmarkID) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'saved_profiles': FieldValue.arrayUnion([bookmarkID])
    });
    savedProfiles.add(bookmarkID);
    notifyListeners();
  }

  Future<void> removeProfileBookmark(String bookmarkID) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'saved_profiles': FieldValue.arrayRemove([bookmarkID])
    });
    savedProfiles.remove(bookmarkID);
    notifyListeners();
  }

  //requests methods
  Future<List<RequestModel>> get getCreatedRequests async {
    List<RequestModel> requestModels = [];
    var snaps = await FirebaseFirestore.instance
        .collection('requests')
        .where('creator', isEqualTo: id)
        .orderBy('creation_date', descending: true)
        .limit(10)
        .get();

    for (var request in snaps.docs) {
      requestModels.add(RequestModel.fromSnapshot(request));
    }

    return requestModels;
  }

  Future<RequestModel> createRequest(String title, String description,
      String? sector, String location, FileController fileController) async {
    return await RequestService.createRequest(
        title, description, sector, location, id, fileController);
  }

  Map<String, dynamic> get toMap {
    return {
      "sectors": sectors,
      "display_name": fullName,
      "username": username,
      "company": company,
      "is_admin": isSuperUser,
      'image': image == defaultUserImageUrl ? null : image,
      'saved_requests': savedRequestIds,
      'location': location,
      'about': description,
      'email': email,
      "id": id,
    };
  }
}
