import 'package:flutter/material.dart';
import '../main.dart';


class TdExampleRoute {
  static final Map<String, Function> _routes = {};

  static void init(){
    for(var model in examplePageList){
      _routes[model.path] = model.pageBuilder;
    }
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? 'unknown';
    var pageContentBuilder = _routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return pageContentBuilder(context, arguments: settings.arguments);
            });
        return route;
      } else {
        final Route route = MaterialPageRoute(
            settings: settings,
            builder: (context) => pageContentBuilder(context));
        return route;
      }
    } else {
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Center(
                child: Text('error'),
              ));
    }
  }
}
