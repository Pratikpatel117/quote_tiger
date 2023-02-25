import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/controllers/sector_picker_controller.dart';

class SectorModel {
  final String path;
  final String name;
  final DateTime creationDate;
  bool picked;

  SectorModel({
    required this.name,
    required this.path,
    required this.creationDate,
    this.picked = false,
  });
  factory SectorModel.fromSnapshot(
      DocumentSnapshot snapshot) {
    return SectorModel(
      name: snapshot['name'],
      path: snapshot.reference.path,
      creationDate: snapshot['creation_date'].toDate(),
    );
  }

  void toggle(SectorPickerController controller) {
    picked = !picked;
    if (picked) {
      controller.pickSector(this);
    } else {
      controller.unpickSector(this);
    }
  }
}
