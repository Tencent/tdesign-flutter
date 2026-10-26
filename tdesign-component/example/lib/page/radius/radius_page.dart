import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'radius_circle_example.dart';
import 'radius_default_example.dart';
import 'radius_extra_large_example.dart';
import 'radius_large_example.dart';
import 'radius_round_example.dart';
import 'radius_small_example.dart';

@ExampleCodeManifest()
/// 圆角示例页面
class TRadiusPage extends StatelessWidget {
  const TRadiusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'radius',
      children: [
        ExampleModule(
          title: '数值型',
          children: [
            ExampleItem(
              desc: '3px 极小组件圆角',
              methodName: 'RadiusSmallExample',
              builder: (_) => const RadiusSmallExample(),
            ),
            ExampleItem(
              desc: '6px 组件圆角',
              methodName: 'RadiusDefaultExample',
              builder: (_) => const RadiusDefaultExample(),
            ),
            ExampleItem(
              desc: '9px 卡片圆角',
              methodName: 'RadiusLargeExample',
              builder: (_) => const RadiusLargeExample(),
            ),
            ExampleItem(
              desc: '12px 面板圆角',
              methodName: 'RadiusExtraLargeExample',
              builder: (_) => const RadiusExtraLargeExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '特殊',
          children: [
            ExampleItem(
              desc: '胶囊型',
              methodName: 'RadiusRoundExample',
              builder: (_) => const RadiusRoundExample(),
            ),
            ExampleItem(
              desc: '圆型',
              methodName: 'RadiusCircleExample',
              builder: (_) => const RadiusCircleExample(),
            ),
          ],
        ),
      ],
    );
  }
}
