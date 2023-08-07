import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

/// 圆角示例页面
class TDShadowsPage extends StatelessWidget {
  const TDShadowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: TDTheme.of(context).whiteColor1,
        title: tdTitle(context),
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
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: TDTheme.of(context).whiteColor1,
          boxShadow: TDTheme.of(context).shadowsBase,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusDefault)),
    );
  }

  @Demo(group: 'shadows')
  Widget _buildShadowsMiddle(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).whiteColor1,
          boxShadow: TDTheme.of(context).shadowsMiddle,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusDefault)),
    );
  }

  @Demo(group: 'shadows')
  Widget _buildShadowsTop(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).whiteColor1,
          boxShadow: TDTheme.of(context).shadowsTop,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusDefault)),
    );
  }
}
