import 'package:flutter/material.dart';

import '../../base/example_widget.dart';
import 'divider_status.dart';
import 'divider_type.dart';

class TDividerPage extends StatelessWidget {
  const TDividerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于分割、组织、细化有一定逻辑的组织元素内容和页面结构。',
      exampleCodeGroup: 'divider',
      children: [dividerTypeModule(), dividerStatusModule()],
    );
  }
}
