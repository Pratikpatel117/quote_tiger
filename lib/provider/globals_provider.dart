import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalsProvider extends ChangeNotifier {
  int? timesAppOpened;
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void returnHome() {
    _currentPage = 0;
    notifyListeners();
  }

  void setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  GlobalsProvider.init() {
    _currentPage = 0;
    manageSharedPreferences();
  }

  Future<void> manageSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    int? _timesOpened = prefs.getInt('times_opened');
    _timesOpened ??= 0;
    prefs.setInt('times_opened', _timesOpened + 1);
    timesAppOpened = _timesOpened + 1;
    notifyListeners();
  }

  Future<void> resetTimesAppOpened() async {
    SharedPreferences.getInstance()
        .then((value) => value.setInt('times_opened', 1));
    timesAppOpened = 0;
  }

  Future<void> incrementTimesAppOpened() async {
    assert(timesAppOpened != null);
    SharedPreferences.getInstance()
        .then((value) => value.setInt('times_opened', timesAppOpened! + 1));
    timesAppOpened = timesAppOpened! + 1;
    notifyListeners();
  }
}
