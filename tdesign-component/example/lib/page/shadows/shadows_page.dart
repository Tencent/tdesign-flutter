import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'shadows_base_example.dart';
import 'shadows_middle_example.dart';
import 'shadows_top_example.dart';

@ExampleCodeManifest()
/// 圆角示例页面
class TShadowsPage extends StatelessWidget {
  const TShadowsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'shadows',
      children: [
        ExampleModule(
          title: '投影',
          children: [
            ExampleItem(
              desc: '基础投影',
              methodName: 'ShadowsBaseExample',
              builder: (_) => const ShadowsBaseExample(),
            ),
            ExampleItem(
              desc: '中层投影',
              methodName: 'ShadowsMiddleExample',
              builder: (_) => const ShadowsMiddleExample(),
            ),
            ExampleItem(
              desc: '上层投影',
              methodName: 'ShadowsTopExample',
              builder: (_) => const ShadowsTopExample(),
            ),
          ],
        ),
      ],
    );
  }
}
