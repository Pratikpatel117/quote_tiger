import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/controllers/attached_file_controller.dart';
import 'package:quote_tiger/models/request.dart';

class RequestService {
  static Future<RequestModel> createRequest(
    String title,
    String description,
    String? sector,
    String location,
    String userID,
    FileController controller,
  ) async {
    var docID = FirebaseFirestore.instance.collection('f').doc().id;

    List<String> urls = await controller.uploadAll('requests/$docID/');

    await FirebaseFirestore.instance.collection('requests').doc(docID).set({
      'title': title,
      'description': description,
      'sector': sector,
      'location': location,
      'creation_date': FieldValue.serverTimestamp(),
      'creator': userID,
      'files': urls,
      'is_active': true,
    });

    return RequestModel(
      isActive: true,
      fileUrls: urls,
      creatorID: userID,
      id: docID,
      creationDate: DateTime.now(),
      title: title,
      description: description,
      sector: sector,
      location: location,
    );
  }

  static Future<RequestModel> getRequestById(String requestID) async {
    var doc = await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestID)
        .get();
    return RequestModel.fromSnapshot(doc);
  }

  static Future<RequestModel?> getNullableRequestById(String requestId) async {
    try {
      return await getRequestById(requestId);
    } catch (e) {
      return null;
    }
  }
}
