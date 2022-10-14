import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';


class TDEmptyPage extends StatefulWidget {
  const TDEmptyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDEmptyPageState();
}

class _TDEmptyPageState extends State<TDEmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('空状态 Empty'),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDEmpty(
                type: TDEmptyType.operation,
                operationText: '操作按钮',
                emptyText: '描述文字',
                image: Icon(
                  TDIcons.info_circle_filled,
                  size: 84,
                  color: TDTheme.of(context).fontGyColor3,
                ),
              ),
            ],
          ),
        ));
  }
}
