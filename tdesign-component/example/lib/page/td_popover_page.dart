import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDPopoverPage extends StatefulWidget {

  const  TDPopoverPage();

  @override
  State<StatefulWidget> createState() => _TDPopoverPage();
}

class _TDPopoverPage extends State<TDPopoverPage> {

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于文字提示的气泡框。',
      exampleCodeGroup: 'popover',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '带箭头的弹出气泡', builder: _buildPopover),
          ],
        )
      ],
    );
  }

  @Demo(group: 'popover')
  Widget _buildPopover(BuildContext context) {
    return TDButton(
      text: '带箭头',
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      onTap: () {
        TDPopover.showPopover(context: context, content: '弹出气泡内容');
      },
    );
  }
}