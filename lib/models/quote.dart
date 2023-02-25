import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/utils/array_handler.dart';

class QuoteModel {
  final String id;
  final String creatorID;
  final String content;
  final String requestID;
  final DateTime creationDate;
  final String path;
  final List<String> fileURLs;
  final String requestCreatorID;

  QuoteModel({
    required this.id,
    required this.content,
    required this.requestID,
    required this.creatorID,
    required this.creationDate,
    required this.fileURLs,
    required this.path,
    required this.requestCreatorID,
  });

  factory QuoteModel.fromSnapshot(DocumentSnapshot snapshot) {
    return QuoteModel(
        requestCreatorID: snapshot['target_uid'],
        fileURLs: arrayHandler(snapshot, 'files'),
        path: snapshot.reference.path,
        id: snapshot.id,
        content: snapshot['content'],
        requestID: snapshot.reference.parent.parent!.id,
        creatorID: snapshot['creator'],
        creationDate: snapshot['creation_date'].toDate());
  }
}
