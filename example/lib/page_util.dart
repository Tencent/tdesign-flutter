import 'package:flutter/material.dart';
import 'package:tdesign/tdesign.dart';

/// 示例页的统一框架
class ExamplePage extends StatelessWidget {
  final Widget child;
  final String title;
  ExamplePage({required this.child, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: TDColors.blue, title: Text(title)),
      body: SafeArea(bottom: false, child: child),
    );
  }
}

class PageUtil {
  static Widget buildSubTitle(String text, {double height = 60}) {
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(text, style: TextStyle(fontSize: 17, color: Colors.grey)),
      ),
    );
  }

  static Widget buildTile(BuildContext context, Widget child,
      {double? height = 80, Alignment alignment = Alignment.centerLeft}) {
    return Container(
      color: Theme.of(context).dialogBackgroundColor,
      height: height,
      alignment: alignment,
      child:
          Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: child),
    );
  }
}