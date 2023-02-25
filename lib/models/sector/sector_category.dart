import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/sector/empty_sector_category_model.dart';
import 'package:quote_tiger/models/sector/sector.dart';

class SectorCategoryModel extends EmptySectorCategoryModel {
  final List<SectorModel> sectors;

  SectorCategoryModel(
      {required String name,
      required String id,
      required DateTime creationDate,
      required this.sectors})
      : super(name: name, id: id, creationDate: creationDate);

  factory SectorCategoryModel.fromSnapshot(
      DocumentSnapshot snapshot, List<SectorModel> sectors) {
    return SectorCategoryModel(
        name: snapshot['name'],
        id: snapshot.id,
        creationDate: snapshot['creation_date'].toDate(),
        sectors: sectors);
  }

  //factory SectorCategoryModel.fromSnapshot(
  //    DocumentSnapshot snapshot, List<SectorModel> sectors) {
  //  return SectorCategoryModel(
  //    name: snapshot['name'],
  //    id: snapshot.id,
  //    sectors: sectors,
  //    creationDate: snapshot['creation_date'].toDate(),
  //  );
  //}

}
