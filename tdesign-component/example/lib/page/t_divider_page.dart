import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TDividerPage extends StatelessWidget {
  const TDividerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(context),
        desc: '用于分割、组织、细化有一定逻辑的组织元素内容和页面结构。',
        exampleCodeGroup: 'divider',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '水平分割线', builder: _horizontalDivider),
            ExampleItem(desc: '带文字水平分割线', builder: _horizontalTextDivider),
            ExampleItem(desc: '垂直分割', builder: _verticalDivider),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '虚线样式', builder: _dashedDivider),
          ])
        ]);
  }

  @ExampleCode(group: 'divider')
  Widget _horizontalDivider(BuildContext context) {
    return const SizedBox(
      key: Key('divider-horizontal'),
      width: double.infinity,
      child: TDivider(),
    );
  }

  @ExampleCode(group: 'divider')
  Widget _horizontalTextDivider(BuildContext context) {
    return const SizedBox(
      key: Key('divider-text-group'),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TDivider(
            child: Text('文字信息'),
            align: TDividerAlign.left,
          ),
          SizedBox(height: 20),
          TDivider(
            child: Text('文字信息'),
            align: TDividerAlign.center,
          ),
          SizedBox(height: 20),
          TDivider(
            child: Text('文字信息'),
            align: TDividerAlign.right,
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'divider')
  Widget _verticalDivider(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TText(
            '文字信息',
            textColor: context.tTheme.textColorPlaceholder,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 12,
              child: TDivider(layout: TDividerLayout.vertical),
            ),
          ),
          TText('文字信息', textColor: context.tTheme.textColorPlaceholder),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 12,
              child: TDivider(layout: TDividerLayout.vertical),
            ),
          ),
          TText('文字信息', textColor: context.tTheme.textColorPlaceholder),
        ],
      ),
    );
  }

  @ExampleCode(group: 'divider')
  Widget _dashedDivider(BuildContext context) {
    return const SizedBox(
      key: Key('divider-dashed-group'),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TDivider(dashed: true),
          SizedBox(height: 20),
          TDivider(
            child: Text('文字信息'),
            align: TDividerAlign.left,
            dashed: true,
          ),
          SizedBox(height: 20),
          TDivider(
            child: Text('文字信息'),
            align: TDividerAlign.center,
            dashed: true,
          ),
          SizedBox(height: 20),
          TDivider(
            child: Text('文字信息'),
            align: TDividerAlign.right,
            dashed: true,
          ),
        ],
      ),
    );
  }
}
