import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class EmptyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('空白页面'),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              TDEmpty(
                type: TDEmptyType.operation,
                operationText: "操作按钮",
                image: Icon(
                  TDIcons.info_circle_filled,
                  size: 84,
                ),
              ),
            ],
          ),
        ));
  }
}
