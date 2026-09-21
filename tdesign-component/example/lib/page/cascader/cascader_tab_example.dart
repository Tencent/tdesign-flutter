import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import 'cascader_design_demo.dart';

@ExampleCode(group: 'cascader', includes: ['cascader_design_demo.dart'])
class CascaderTabExample extends StatelessWidget {
  const CascaderTabExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const CascaderDesignDemo(
      id: 'horizontal',
      variant: TCascaderVariant.tab,
    );
  }
}
