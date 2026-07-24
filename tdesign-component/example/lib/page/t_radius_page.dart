import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

/// 圆角示例页面
class TRadiusPage extends StatelessWidget {
  const TRadiusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(context),
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
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
      ),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusDefault(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusLarge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
      ),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusExtraLarge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius:
            BorderRadius.circular(context.tTheme.radiusExtraLarge),
      ),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusRound(BuildContext context) {
    // 胶囊型，数值设置较大
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
      ),
    );
  }

  @Demo(group: 'radius')
  Widget _buildRadiusCircle(BuildContext context) {
    //  圆形与胶囊型一致，如果长宽一致即是圆形
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusCircle),
      ),
    );
  }
}
