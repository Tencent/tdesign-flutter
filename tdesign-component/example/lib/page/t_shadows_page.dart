import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

/// 圆角示例页面
class TShadowsPage extends StatelessWidget {
  const TShadowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(context),
        exampleCodeGroup: 'shadows',
        children: [
          ExampleModule(title: '投影', children: [
            ExampleItem(desc: '基础投影', builder: _buildShadowsBase),
            ExampleItem(desc: '中层投影', builder: _buildShadowsMiddle),
            ExampleItem(desc: '上层投影', builder: _buildShadowsTop),
          ]),
        ]);
  }

  @Demo(group: 'shadows')
  Widget _buildShadowsBase(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsBase,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @Demo(group: 'shadows')
  Widget _buildShadowsMiddle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsMiddle,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @Demo(group: 'shadows')
  Widget _buildShadowsTop(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsTop,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }
}
