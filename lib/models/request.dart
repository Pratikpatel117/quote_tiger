import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/quote.dart';
import 'package:quote_tiger/models/user.dart';
import 'package:quote_tiger/services/quote.dart';
import 'package:quote_tiger/services/storage/storage.dart';

DateTime dateTimeConverter(Map<String, dynamic> data) {
  var creationDate = data['creation_date'];

  try {
    return DateTime.fromMillisecondsSinceEpoch(creationDate);
  } catch (e) {
    return DateTime.fromMillisecondsSinceEpoch(creationDate['_seconds'] * 1000);
  }
}

class RequestModel {
  final String id;
  bool isActive;
  final String title;
  String description;
  final String? sector;
  final DateTime creationDate;
  final String location;
  final String creatorID;
  final List<String> fileUrls;

  RequestModel({
    this.sector,
    required this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.location,
    required this.creatorID,
    required this.isActive,
    this.fileUrls = const [],
  });
  //{path: requests/jEmlG7gDQrROCOiPu1at, description: as;dlfkjasd;fkjsdafasdf, title: algolia_test_#3, location: Bahamas, creator: 9QL9XxpgzpdtxvSiB2Xt4iyOI303, creation_date: 1653067309648, files: [], sector: seagull, lastmodified: 1653067309701, objectID: jEmlG7gDQrROCOiPu1at}

  factory RequestModel.fromAlgoliaSnapshot(AlgoliaObjectSnapshot snapshot) {
    var snapData = snapshot.data;

    return RequestModel(
      fileUrls: List<String>.from(snapData['files']),
      id: snapData['objectID'],
      title: snapData['title'],
      description: snapData['description'],
      creationDate: dateTimeConverter(snapData),
      location: snapData['location'],
      creatorID: snapData['creator'],
      isActive: true,
    );
  }

  factory RequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    return RequestModel(
      sector: defaultValueRetriever(snapshot, 'sector', defaultValue: null),
      isActive:
          defaultValueRetriever(snapshot, 'is_active', defaultValue: true),
      fileUrls: defaultListRetriever<String>(snapshot, 'files',
          defaultValue: <String>['test']),
      creatorID: snapshot['creator'],
      id: snapshot.id,
      title: snapshot['title'],
      description: snapshot['description'],
      creationDate:
          DateTime.parse(snapshot['creation_date'].toDate().toString()),
      location: snapshot['location'],
    );
  }

  void toggleActivation() {
    isActive = !isActive;
    FirebaseFirestore.instance.collection('requests').doc(id).update({
      'is_active': isActive,
    });
  }

  Future<QuoteModel> sendQuote(
      String content, List<File> files, UserModel localUser) async {
    var urls = files.isNotEmpty
        ? await StorageService()
            .uploadFilesToFolder(files, 'requests/$id/quotes')
        : <String>[];
    var quoteReference =
        await QuoteService.createQuote(id, content, localUser, urls, creatorID);

    return QuoteModel(
        requestCreatorID: creatorID,
        fileURLs: urls,
        id: quoteReference.id,
        content: content,
        requestID: id,
        creatorID: localUser.id,
        creationDate: DateTime.now(),
        path: quoteReference.path);
  }

  List<String> get fileNames {
    var ss = StorageService();

    List<String> names = [];
    for (var url in fileUrls) {
      names.add(ss.getFileName(url));
    }
    return names;
  }

  Map<String, dynamic> get toMap {
    return {
      'title': title,
      'description': description,
      'sector': sector,
      'location': location,
      'creation_date': creationDate,
      'creator': creatorID,
      'files': fileUrls,
      'is_active': isActive,
    };
  }

  Future<void> update(
      {required String title,
      required String description,
      required String country,
      required String sector}) async {
    await FirebaseFirestore.instance.collection('requests').doc(id).update(
      {
        'title': title,
        'description': description,
        'country': country,
        'sector': sector,
      },
    );

    title = title;
    description = description;
    country = country;
  }
}

dynamic defaultValueRetriever(DocumentSnapshot snapshot, String fieldName,
    {required dynamic defaultValue}) {
  try {
    return snapshot[fieldName];
  } catch (e) {
    return defaultValue;
  }
}

dynamic defaultListRetriever<T>(DocumentSnapshot snapshot, String fieldName,
    {required List<T> defaultValue}) {
  try {
    return List<T>.from(snapshot[fieldName]);
  } catch (e) {
    return defaultValue;
  }
}
