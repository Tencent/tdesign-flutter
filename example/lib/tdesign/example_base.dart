import 'package:flutter/material.dart';



/// 示例页面数据
class ExamplePageModel{

  ExamplePageModel({required this.text,required this.path,required this.pageBuilder,});

  final String text;
  final String path;
  final WidgetBuilder pageBuilder;
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key, required this.title, required this.children}) : super(key: key);

  final String title;
  final List<ExampleItem> children;

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[
      for(var item in children)
        Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("用例——${item.desc}", style: TextStyle(color: Colors.black45),),
              item.builder(context),
            ],
          ),
        )
    ];
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: list,
      ),),
    );
  }
}

/// 示例样例
class ExampleItem{
  const ExampleItem({required this.desc, required this.builder});

  final String desc;

  final WidgetBuilder builder;
}
