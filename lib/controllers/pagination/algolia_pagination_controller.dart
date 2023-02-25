import 'package:algolia/algolia.dart';

class AlgoliaPaginationService<T> {
  final AlgoliaQuery query;
  final int hitsPerPage;
  final int initialPage;
  T Function(AlgoliaObjectSnapshot) snapToModel;

  AlgoliaPaginationService({
    this.hitsPerPage = 10,
    this.initialPage = 0,
    required this.snapToModel,

    /// a reference to the query that will be paginated. Don't include any limits or stuff like that here though. It would  break things, (I think)
    required this.query,
  });

  List<T> items = [];
  int _currentPage = 0;
  bool done = false;

  Future<void> getFirstBatch() async {
    _currentPage = initialPage;
    var docs = await query
        .setHitsPerPage(hitsPerPage)
        .setPage(_currentPage)
        .getObjects();
    for (var documentSnapshot in docs.hits) {
      items.add(snapToModel(documentSnapshot));
    }
    if (items.isEmpty) {
      done = true;
    }
  }

  Future<void> getNextBatch() async {
    _currentPage++;
    final int oldLength = items.length;

    var docs = await query
        .setHitsPerPage(hitsPerPage)
        .setPage(_currentPage)
        .getObjects();
    for (var documentSnapshot in docs.hits) {
      items.add(snapToModel(documentSnapshot));
    }

    if (oldLength == items.length) {
      done = true;
    }
  }
}
