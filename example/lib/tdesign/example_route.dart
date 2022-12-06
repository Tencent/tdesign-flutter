import 'package:flutter/material.dart';
import 'package:tdesign_flutter_example/about.dart';
import '../main.dart';
import 'example_base.dart';
import 'example_widget.dart';


class TDExampleRoute {
  static final Map<String, ExamplePageModel> pageModelList = {};
  static const String aboutPath = 'about';

  static void init(){
    for(var model in examplePageList){
      pageModelList[model.path] = model;
    }
    // 添加关于页路由
    pageModelList[aboutPath] = ExamplePageModel(
      text: '关于',
        path: 'AboutPage',
        pageBuilder: (context,model)=> const AboutPage());
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? 'unknown';
    var model = pageModelList[name];
    if (model != null) {
      final Route route = MaterialPageRoute(
          settings: settings,
          builder: (context) => model.pageBuilder(context, model));
      return route;
    } else {
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Center(
                child: Text('error'),
              ));
    }
  }
}
