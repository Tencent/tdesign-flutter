import 'package:flutter/material.dart';

import 'package:tdesign_flutter/td_export.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDBackTopPage extends StatefulWidget {
  const TDBackTopPage({Key? key}) : super(key: key);

  @override
  State<TDBackTopPage> createState() => _TDBackTopPageState();
}

class _TDBackTopPageState extends State<TDBackTopPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于当页面过长往下滑动时，帮助用户快速回到页面顶部。',
        exampleCodeGroup: 'backtop',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: 'Round BackTop 圆形返回顶部', builder: _buildCircleBackTop),
            ExampleItem(
                desc: 'Half-Round BackTop 半圆形返回顶部',
                builder: _buildHalfCircleBackTop),
          ]),
        ]);
  }

  @Demo(group: 'backtop')
  Widget _buildCircleBackTop(BuildContext context) {
    return _buildRowDemo(
      context,
      [
        TDBackTop(
          showText: true,
          controller: controller,
          onClick: () {
            print('点击');
          },
        ),
        TDBackTop(
          showText: true,
          theme: TDBackTopTheme.dark,
          controller: controller,
          onClick: () {
            print('点击');
          },
        ),
        TDBackTop(
          controller: controller,
          onClick: () {
            print('点击');
          },
        ),
        TDBackTop(
          theme: TDBackTopTheme.dark,
          controller: controller,
          onClick: () {
            print('点击');
          },
        )
      ],
    );
  }

  @Demo(group: 'backtop')
  Widget _buildHalfCircleBackTop(BuildContext context) {
    return _buildRowDemo(
      context,
      [
        TDBackTop(
          showText: true,
          style: TDBackTopStyle.halfCircle,
          controller: controller,
          onClick: () {
            print('点击');
          },
        ),
        TDBackTop(
          showText: true,
          theme: TDBackTopTheme.dark,
          style: TDBackTopStyle.halfCircle,
          controller: controller,
          onClick: () {
            print('点击');
          },
        ),
        TDBackTop(
          style: TDBackTopStyle.halfCircle,
          controller: controller,
          onClick: () {
            print('点击');
          },
        ),
        TDBackTop(
          theme: TDBackTopTheme.dark,
          style: TDBackTopStyle.halfCircle,
          controller: controller,
          onClick: () {
            print('点击');
          },
        )
      ],
    );
  }

  Widget _buildRowDemo(BuildContext context, List<TDBackTop> children) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
          children: children
              .map((child) => Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: child,
                  ))
              .toList()),
    );
  }
}
