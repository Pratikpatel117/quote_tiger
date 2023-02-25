import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

enum PaginationState { empty, loading, waiting, done, none }

class PaginationController<T> extends ChangeNotifier {
  // no limit;
  Query query;
  final bool Function(T first, T second)? isEqual;
  PaginationController({
    required this.query,
    required this.documentToModel,
    this.isEqual,
  });
  T Function(DocumentSnapshot) documentToModel;

  List<T> _documentModels = [];

  PaginationState _state = PaginationState.none;

  PaginationState get getState => _state;

  List<T> get documentModels => _documentModels;

  void insertModel(T model, int position) {
    _documentModels.insert(position, model);
    notifyListeners();
  }

  bool isInTheList(T target) {
    for (var model in documentModels) {
      if (isEqual!(target, model)) {
        return true;
      }
    }
    return false;
  }

  DocumentSnapshot? _lastDocument;

  Future<void> firstBatch({int limit = 10}) async {
    /// while retrieving a batch, show a loading tile
    _state = PaginationState.loading;

    List<DocumentSnapshot> snaps = (await query.limit(limit).get()).docs;
    // enforce that it's not empty;
    if (snaps.isEmpty) {
      _state = PaginationState.empty;
      return notifyListeners();
    }

    if (snaps.length < limit) {
      _state = PaginationState.done;
    }

    for (var document in snaps) {
      if (!documentModels.contains(documentToModel(document))) {
        _documentModels.add(documentToModel(document));
      }
    }
    if (_state == PaginationState.loading) {
      _lastDocument = snaps.last;
      _state = PaginationState.waiting;
    }
    return notifyListeners();
  }

  Future<void> nextBatch({int limit = 10}) async {
    /// if the last document is null we can't continue the pagination unfortunately;
    if (_lastDocument == null) {
      print("Ignoring");
      return;
    }

    List<DocumentSnapshot> snaps =
        (await query.startAfterDocument(_lastDocument!).limit(limit).get())
            .docs;
    // make sure the list is not empty
    if (snaps.isEmpty) {
      _state = PaginationState.done;
      notifyListeners();
      return;
    }

    // if there are less snaps than the limit then we're done
    if (snaps.length < limit) {
      _state = PaginationState.done;
    }

    for (var document in snaps) {
      _documentModels.add(documentToModel(document));
    }

    _lastDocument = snaps.last;
    notifyListeners();
  }

  void resetWithNewQuery(Query query) {
    this.query = query;
    _documentModels = [];
    _lastDocument = null;
    _state = PaginationState.none;
  }

  void deleteModel(bool Function(T) condition) {
    int index = documentModels.indexWhere((element) => condition(element));
    documentModels.removeAt(index);
    return notifyListeners();
  }

  void refresh() {
    _documentModels = [];
    _lastDocument = null;
    _state = PaginationState.none;
    notifyListeners();
  }
}
