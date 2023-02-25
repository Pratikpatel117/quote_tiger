import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/sector/sector.dart';
import 'package:quote_tiger/models/sector/sector_category.dart';

import '../models/sector/empty_sector_category_model.dart';

class SectorService {
  final String collectionPath = 'sector_categories';
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<EmptySectorCategoryModel>> getEmptySectorCategories(
      {int limitPerCategory = 5}) async {
    List<EmptySectorCategoryModel> categories = [];
    var documentSnapshots = (await db.collection(collectionPath).get()).docs;

    for (var doc in documentSnapshots) {
      categories.add(EmptySectorCategoryModel.fromSnapshot(doc));
    }

    return categories;
  }

  Future<EmptySectorCategoryModel> getSectorCategoryFromName(
      String name) async {
    return EmptySectorCategoryModel.fromSnapshot(
      (await FirebaseFirestore.instance
              .collection('sector_categories')
              .limit(1)
              .where('name', isEqualTo: name)
              .get())
          .docs[0],
    );
  }

  Future<List<SectorModel>> getSectorsOfCategory(
      EmptySectorCategoryModel model) async {
    List<SectorModel> models = [];
    var docs = (await db
            .collection(collectionPath)
            .doc(model.id)
            .collection('sectors')
            .get())
        .docs;
    for (var doc in docs) {
      models.add(SectorModel.fromSnapshot(doc));
    }

    return models;
  }

  Future<List<SectorModel>> getSectorsFromPaths(List<String> paths) async {
    List<SectorModel> models = [];
    for (var path in paths) {
      models.add(SectorModel.fromSnapshot(await db.doc(path).get()));
    }
    return models;
  }

  Future<SectorCategoryModel?> getSectorCategory(String id) async {
    var document = await db.collection(collectionPath).doc(id).get();

    if (!document.exists) return null;

    List<DocumentSnapshot> sectors = ((await db
            .collection(collectionPath)
            .doc(id)
            .collection('sectors')
            .limit(5)
            .get())
        .docs);
    List<SectorModel> models = [];

    for (var snap in sectors) {
      models.add(SectorModel.fromSnapshot(snap));
    }

    return SectorCategoryModel.fromSnapshot(
        await db.collection(collectionPath).doc(id).get(), models);
  }

  Future<SectorCategoryModel> createSectorCategory(String name) async {
    var snapshot = await db.collection(collectionPath).add({
      'name': name,
      'creation_date': FieldValue.serverTimestamp(),
    });
    return SectorCategoryModel(
        name: name, id: snapshot.id, sectors: [], creationDate: DateTime.now());
  }

  Future<SectorModel> insertSector(String name, String sectorCategoryId) async {
    var reference = await db
        .collection(collectionPath)
        .doc(sectorCategoryId)
        .collection('sectors')
        .add(
      {
        'name': name,
        'creation_date': FieldValue.serverTimestamp(),
      },
    );

    return SectorModel(
        name: name, path: reference.path, creationDate: DateTime.now());
  }
}
