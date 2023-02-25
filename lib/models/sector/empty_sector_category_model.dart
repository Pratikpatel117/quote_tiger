import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/sector/sector_category.dart';
import 'package:quote_tiger/services/sector_service.dart';

class EmptySectorCategoryModel {
  final String name;
  final String id;
  final DateTime creationDate;

  EmptySectorCategoryModel(
      {required this.name, required this.id, required this.creationDate});

  factory EmptySectorCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return EmptySectorCategoryModel(
      name: snapshot['name'],
      id: snapshot.id,
      creationDate: snapshot['creation_date'].toDate(),
    );
  }

  Future<SectorCategoryModel> get addSectors async {
    var sectors = await SectorService().getSectorsOfCategory(this);
    return SectorCategoryModel(
        name: name, id: id, creationDate: creationDate, sectors: sectors);
  }
}
