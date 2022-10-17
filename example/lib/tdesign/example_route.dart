import 'package:flutter/material.dart';
import 'package:tdesign_flutter_example/about.dart';
import '../main.dart';


class TDExampleRoute {
  static final Map<String, Function> _routes = {};
  static const String aboutPath = 'about';

  static void init(){
    for(var model in examplePageList){
      _routes[model.path] = model.pageBuilder;
    }
    // 添加关于页路由
    _routes[aboutPath] = (context)=> const AboutPage();
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
