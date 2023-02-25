import 'package:cloud_firestore/cloud_firestore.dart';

  /// create(String Map) ||
  /// update(String, Map) ||
  /// delete(String) ||
class BatchService {
  var db = FirebaseFirestore.instance;
  var batch = FirebaseFirestore.instance.batch();

  void create(String collectionPath, Map<String, dynamic> data) {
    batch.set(db.collection(collectionPath).doc(), data);
  }

  void update(String documentPath, Map<String, dynamic> data) {
    batch.update(db.doc(documentPath), data);
  }

  void delete(String documentPath) {
    batch.delete(db.doc(documentPath));
  }

  Future<void> commit() async {
    await batch.commit();
  }
}
