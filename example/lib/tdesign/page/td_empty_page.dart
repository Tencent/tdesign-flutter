import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_widget.dart';


class TDEmptyPage extends StatefulWidget {
  const TDEmptyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDEmptyPageState();
}

class _TDEmptyPageState extends State<TDEmptyPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: '空状态 Empty',
        children: [
        ExampleModule(title: '默认',
        children: [
          ExampleItem(builder: (_) => Container(
            height: 720,
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
          ))
        ])]);
  }
}
