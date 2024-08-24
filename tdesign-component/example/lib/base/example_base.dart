import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'api_widget.dart';


typedef PageBuilder = Widget Function(BuildContext context, ExamplePageModel model);

/// 示例页面数据
class ExamplePageModel{

  ExamplePageModel({required this.text,required this.name, this.apiVisible = false, this.showAction = false, this.isTodo = false,this.pageName,required this.pageBuilder,});

  final String text;
  final String name;
  String? codePath;
  String? spline;
  bool apiVisible;
  bool showAction;
  String? pageName;
  bool isTodo;
  final PageBuilder pageBuilder;
}



/// 存储主题数据的内部控件
class ExamplePageInheritedTheme extends InheritedWidget {
  final ExamplePageModel model;

  const ExamplePageInheritedTheme(
      {required this.model, Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant ExamplePageInheritedTheme oldWidget) {
    return model != oldWidget.model;
  }
}

class ScreenUtil{

  static bool isLargeScreen(BuildContext context){

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return width > height;
  }

  static bool isWebLargeScreen(BuildContext context){
    return PlatformUtil.isWeb && isLargeScreen(context);
  }
}