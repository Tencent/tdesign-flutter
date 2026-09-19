import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'radius_value.dart';
part 'radius_special.dart';

/// 圆角示例页面
class TRadiusPage extends StatelessWidget {
  const TRadiusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'radius',
      children: [_radiusValueModule, _radiusSpecialModule],
    );
  }

  @ExampleCode(group: 'radius')
  Widget _buildRadiusSmall(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
      ),
    );
  }

  @ExampleCode(group: 'radius')
  Widget _buildRadiusDefault(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @ExampleCode(group: 'radius')
  Widget _buildRadiusLarge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
      ),
    );
  }

  @ExampleCode(group: 'radius')
  Widget _buildRadiusExtraLarge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusExtraLarge),
      ),
    );
  }

  @ExampleCode(group: 'radius')
  Widget _buildRadiusRound(BuildContext context) {
    // 胶囊型，数值设置较大
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
      ),
    );
  }

  @ExampleCode(group: 'radius')
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
