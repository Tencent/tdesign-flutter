import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class TdToastPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdToastPageState();
}

class _TdToastPageState extends State<TdToastPage> {
  void _showToast() {
    TDToast.showText(context, "我是Toast");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Toast组件'),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 100),
            color: Colors.white,
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: _showToast, child: const Text('点击弹出toast'))));
  }
}
