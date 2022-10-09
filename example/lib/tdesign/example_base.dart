import 'package:flutter/material.dart';



/// 示例页面数据
class ExamplePageModel{

  ExamplePageModel({required this.text,required this.path,required this.pageBuilder,});

  final String text;
  final String path;
  final WidgetBuilder pageBuilder;
}

/// 示例页面控件，建议每个页面返回一个ExampleWidget即可，不用独自封装
class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key, required this.title, required this.children, this.padding, this.backgroundColor}) : super(key: key);

  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[
      for(var item in children)
        Container(
          padding: padding ?? const EdgeInsets.all(16),
          child: item,
        )
    ];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text("$title示例页"),),
      body: Center(child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: list,
        ),),
      ),
    );
  }
}

/// 示例样例，建议尽量使用该控件，写清晰说明内容
class ExampleItem extends StatelessWidget{
  // ignore: use_key_in_widget_constructors
  const ExampleItem({required this.desc, required this.builder});

  final String desc;

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('示例——$desc', style: const TextStyle(color: Colors.black45),),
        builder(context),
      ],
    );
  }
}

