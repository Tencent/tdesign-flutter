import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'shadows_shadow.dart';

/// 圆角示例页面
class TShadowsPage extends StatelessWidget {
  const TShadowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'shadows',
      children: [_shadowsShadowModule],
    );
  }

  @ExampleCode(group: 'shadows')
  Widget _buildShadowsBase(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsBase,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @ExampleCode(group: 'shadows')
  Widget _buildShadowsMiddle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsMiddle,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @ExampleCode(group: 'shadows')
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
