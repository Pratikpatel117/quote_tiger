import 'package:algolia/algolia.dart';

class AlgoliaSingleton {
  static final AlgoliaSingleton _singleton = AlgoliaSingleton._internal();

  factory AlgoliaSingleton() {
    return _singleton;
  }
  final Algolia algolia = const Algolia.init(
    applicationId: 'HN5QWSQ9D4',
    apiKey: '0795395c739214e39e327dcbd24d3ebe',
  );

  AlgoliaSingleton._internal();
}

class Placeholder {
  static final Placeholder _singleton = Placeholder._internal();

  factory Placeholder() {
    return _singleton;
  }

  Placeholder._internal();
}
