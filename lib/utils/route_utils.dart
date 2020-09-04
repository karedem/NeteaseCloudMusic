import 'package:flutter/material.dart';

class RouteUtils {
  static final GlobalKey<NavigatorState> KEY = GlobalKey<NavigatorState>();

  static Future<Object> pushNamed(String routeName, {Object arguments}) {
    return KEY.currentState.pushNamed(routeName, arguments: arguments);
  }

  static void pop<T extends Object>({T result}) {
    KEY.currentState.pop(result);
  }

  static Future<Object> pushNamedAndrRemoveUtil(
    String newRouteName,
    RoutePredicate predicate, {
    Object arguments,
  }) {
    return KEY.currentState
        .pushNamedAndRemoveUntil(newRouteName, predicate, arguments: arguments);
  }
}
