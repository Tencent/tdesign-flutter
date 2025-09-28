import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDDividerPage extends StatelessWidget {
  const TDDividerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(context),
        desc: '用于分割、组织、细化有一定逻辑的组织元素内容和页面结构。',
        exampleCodeGroup: 'divider',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '水平分割线', builder: _verticalDivider),
            ExampleItem(desc: '带文字水平分割线', builder: _verticalTextDivider),
            ExampleItem(desc: '垂直分割', builder: _horizontalTextDivider),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '虚线样式', builder: _dashedDivider),
          ])
        ]);
  }

  @Demo(group: 'divider')
  Widget _verticalDivider(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Container(
        alignment: Alignment.center,
        child: const TDDivider(),
      ),
    );
  }

  @Demo(group: 'divider')
  Widget _verticalTextDivider(BuildContext context) {
    return const Column(
      children: [
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.left,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.center,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.right,
        ),
      ],
    );
  }

  @Demo(group: 'divider')
  Widget _horizontalTextDivider(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 16,
          ),
          TDText(
            '文字信息',
            textColor: TDTheme.of(context).textColorPlaceholder,
          ),
          const TDDivider(
            width: 0.5,
            height: 12,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          TDText('文字信息', textColor: TDTheme.of(context).textColorPlaceholder),
          const TDDivider(
            width: 0.5,
            height: 12,
            margin: EdgeInsets.symmetric(horizontal: 16),
            isDashed: true,
            direction: Axis.vertical,
          ),
          TDText('文字信息', textColor: TDTheme.of(context).textColorPlaceholder),
        ],
      ),
    );
  }

  @Demo(group: 'divider')
  Widget _dashedDivider(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 20,
        ),
        TDDivider(
          isDashed: true,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.left,
          isDashed: true,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.center,
          isDashed: true,
        ),
        SizedBox(
          height: 20,
        ),
        TDDivider(
          text: '文字信息',
          alignment: TextAlignment.right,
          isDashed: true,
        ),
      ],
    );
  }
}
