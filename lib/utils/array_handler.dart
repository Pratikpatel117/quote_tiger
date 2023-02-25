import 'package:cloud_firestore/cloud_firestore.dart';

List<String> arrayHandler(DocumentSnapshot snapshot, String field) {
  List<String> items = [];
  try {
    for (var item in snapshot[field]) {
      items.add(item.toString());
    }
    // print("this is it " + snapshot[field]);
    return items;
  } catch (e) {
    // print(
        // 'error "$e" when taking $field out of snapshot with id: ${snapshot.id}');
    return [];
  }
}
