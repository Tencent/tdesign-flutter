import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'api_widget.dart';


typedef PageBuilder = Widget Function(BuildContext context, ExamplePageModel model);

/// 示例页面数据
class ExamplePageModel{

  ExamplePageModel({required this.text,required this.path, this.apiPath, this.codePath, this.apiVisible = false, required this.pageBuilder,});

  final String text;
  final String path;
  final String? apiPath;
  String? codePath;
  bool apiVisible;
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

