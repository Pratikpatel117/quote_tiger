import 'package:cloud_firestore/cloud_firestore.dart';

dynamic nullableDocumentFieldRead(DocumentSnapshot snapshot, String field) {
  try {
    return snapshot[field];
  } catch (e) {
    return null;
  }
}
