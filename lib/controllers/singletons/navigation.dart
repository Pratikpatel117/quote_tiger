import 'package:flutter/widgets.dart';

class NavigationSingleton {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  static final NavigationSingleton _singleton = NavigationSingleton._internal();

  factory NavigationSingleton() {
    return _singleton;
  }

  NavigationSingleton._internal();
}

