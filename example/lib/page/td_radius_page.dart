import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

/// 圆角示例页面
class TDRadiusPage extends StatelessWidget {
  const TDRadiusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: 'Radius 圆角',
        exampleCodeGroup: 'radius',
        children: [
          ExampleModule(title: '数值型', children: [
            ExampleItem(desc: '3px 极小组件圆角', builder: _buildRadiusSmall),
            ExampleItem(desc: '6px 组件圆角', builder: _buildRadiusDefault),
            ExampleItem(desc: '9px 卡片圆角', builder: _buildRadiusLarge),
            ExampleItem(desc: '12px 面板圆角', builder: _buildRadiusExtraLarge),
          ]),
          ExampleModule(title: '特殊', children: [
            ExampleItem(desc: '胶囊型', builder: _buildRadiusRound),
            ExampleItem(desc: '圆型', builder: _buildRadiusCircle),
          ]),
        ]);
  }

  @Demo(group: 'radius')
  Widget _buildRadiusSmall(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusSmall)),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusDefault(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusDefault)),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusLarge(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusExtraLarge(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusExtraLarge)),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusRound(BuildContext context) {
    // 胶囊型，数值设置较大
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusRound)),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusCircle(BuildContext context) {
    //  圆形与胶囊型一致，如果长款一致即是圆形
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: TDTheme.of(context).brandNormalColor,
          borderRadius:
              BorderRadius.circular(TDTheme.of(context).radiusCircle)),
    );
  }
}
