import 'package:flutter/cupertino.dart';
import 'package:quote_tiger/models/sector/sector.dart';

class SectorPickerController extends ChangeNotifier {
  List<SectorModel> _pickedSectors = [];

  List<String> get getSectorPaths {
    List<String> paths = [];
    for (var item in _pickedSectors) {
      paths.add(item.path);
    }

    return paths;
  }

  List<SectorModel> get getSectorModels => _pickedSectors;

  void clear() {
    _pickedSectors = [];
    notifyListeners();
  }

  void pickSector(SectorModel model) {
    bool alreadyIn = false;
    for (var sectorModel in _pickedSectors) {
      if (sectorModel.path == model.path) {
        alreadyIn = true;
      }
    }
    if (!alreadyIn) {
      _pickedSectors.add(model);
      notifyListeners();
    } 
    
  }

  void unpickSector(SectorModel model) {
    _pickedSectors.removeWhere((element) => element.path == model.path);
    notifyListeners();
  }
}
