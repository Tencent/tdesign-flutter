import 'package:flutter/material.dart';

import '../../annotation/example_code.dart';
import 'cascader_design_demo.dart';

@ExampleCode(group: 'cascader', includes: ['cascader_design_demo.dart'])
class CascaderAnyExample extends StatelessWidget {
  const CascaderAnyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const CascaderDesignDemo(id: 'without-title', showTitle: false);
  }
}
