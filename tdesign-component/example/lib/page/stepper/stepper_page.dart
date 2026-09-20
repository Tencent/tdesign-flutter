import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'stepper_base_example.dart';
import 'stepper_bounds_example.dart';
import 'stepper_disabled_example.dart';
import 'stepper_sizes_example.dart';
import 'stepper_variants_example.dart';

@ExampleCodeManifest()
class TStepperPage extends StatefulWidget {
  const TStepperPage({super.key});

  @override
  State<TStepperPage> createState() => _TStepperPageState();
}

class _TStepperPageState extends State<TStepperPage> {
  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(),
    desc: '用于数量的增减。',
    exampleCodeGroup: 'stepper',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(
            desc: '基础步进器',
            center: false,
            methodName: 'StepperBaseExample',
            builder: (_) => const StepperBaseExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '组件状态',
        children: [
          ExampleItem(
            desc: '最大最小状态',
            center: false,
            methodName: 'StepperBoundsExample',
            builder: (_) => const StepperBoundsExample(),
          ),
          ExampleItem(
            desc: '禁用状态',
            center: false,
            methodName: 'StepperDisabledExample',
            builder: (_) => const StepperDisabledExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '组件样式',
        children: [
          ExampleItem(
            desc: '步进器样式',
            center: false,
            methodName: 'StepperVariantsExample',
            builder: (_) => const StepperVariantsExample(),
          ),
          ExampleItem(
            desc: '步进器尺寸',
            center: false,
            methodName: 'StepperSizesExample',
            builder: (_) => const StepperSizesExample(),
          ),
        ],
      ),
    ],
  );
}
