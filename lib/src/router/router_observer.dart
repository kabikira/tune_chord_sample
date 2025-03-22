import 'package:flutter/material.dart';
import 'package:tune_chord_sample/src/log/logger.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? 'unknown';
    logger.i('➡️ didPush: $routeName');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      final prevRouteName = previousRoute.settings.name ?? 'unknown';
      logger.i('⬅️ didPop: $prevRouteName');
    }
    super.didPop(route, previousRoute);
  }
}
