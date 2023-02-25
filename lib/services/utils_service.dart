import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quote_tiger/models/sector/sector.dart';

class DiverseServices {
  static Future<List<SectorModel>> getSectors({int limit = 10}) async {
    var snaps = (await FirebaseFirestore.instance
            .collectionGroup('sectors')
            .orderBy('creation_date', descending: true)
            .limit(10)
            .get())
        .docs;

    if (snaps.isEmpty) {
      return <SectorModel>[];
    }
    List<SectorModel> models = [];
    for (var item in snaps) {
      models.add(SectorModel.fromSnapshot(item));
    }

    return models;
  }
}
