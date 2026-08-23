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
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              key: const Key('divider-base-example'),
              desc: '水平分割线',
              center: false,
              builder: _buildBaseDividers,
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              key: const Key('divider-dashed-example'),
              desc: '虚线样式',
              center: false,
              builder: _buildDashedDividers,
            ),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'divider')
  Widget _buildBaseDividers(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TDivider(),
          _sectionTitle(context, '带文字水平分割线'),
          const TDivider(child: Text('文字信息'), align: TDividerAlign.left),
          const TDivider(child: Text('文字信息')),
          const TDivider(child: Text('文字信息'), align: TDividerAlign.right),
          _sectionTitle(context, '垂直分割线'),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 16),
            child: Row(
              children: [
                Text('文字信息'),
                TDivider(layout: TDividerLayout.vertical),
                Text('文字信息'),
                TDivider(layout: TDividerLayout.vertical),
                Text('文字信息'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'divider')
  Widget _buildDashedDividers(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TDivider(dashed: true),
          TDivider(
            dashed: true,
            child: Text('文字信息'),
            align: TDividerAlign.left,
          ),
          TDivider(dashed: true, child: Text('文字信息')),
          TDivider(
            dashed: true,
            child: Text('文字信息'),
            align: TDividerAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TText(
        text,
        font: context.tTheme.fontBodyMedium,
        style: const TextStyle(height: 20 / 14),
        textColor: context.tTheme.textColorSecondary,
      ),
    );
  }
}
