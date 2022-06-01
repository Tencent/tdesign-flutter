import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_base.dart';

// ignore: use_key_in_widget_constructors
class TdToastPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdToastPageState();
}

class _TdToastPageState extends State<TdToastPage> {

  @override
  Widget build(BuildContext context) {
    return ExampleWidget(title: "Toast组件", children: [
      ElevatedButton(
          onPressed: (){
            TDToast.showText(context, "我是Toast");
          },
          child: const Text('普通toast')),

      ElevatedButton(
          onPressed: (){
            var sb = StringBuffer("我是");
            for(var i = 0; i < 20; i++){
              sb.write("很长$i");
            }
            sb.write("toast");
            TDToast.showText(context, sb.toString());
          },
          child: const Text('超长toast')),

      ElevatedButton(
          onPressed: (){
            var sb = StringBuffer("我是");
            for(var i = 0; i < 20; i++){
              sb.write("很长$i");
            }
            sb.write("toast");
            TDToast.showText(context, sb.toString(),duration: Duration(seconds: 10));
          },
          child: const Text('10秒再消失toast')),

    ]);
  }
}
