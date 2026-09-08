import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../base/example_widget.dart';
import 'stepper/stepper_examples.dart';

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
            builder: (_) => _container(const StepperBaseExample()),
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
            builder: (_) => _container(const StepperBoundsExample()),
          ),
          ExampleItem(
            desc: '禁用状态',
            center: false,
            methodName: 'StepperDisabledExample',
            builder: (_) => _container(const StepperDisabledExample()),
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
            builder: (_) => _container(const StepperVariantsExample()),
          ),
          ExampleItem(
            desc: '步进器尺寸',
            center: false,
            methodName: 'StepperSizesExample',
            builder: (_) => _container(const StepperSizesExample()),
          ),
        ],
      ),
    ],
  );

  Widget _container(Widget child) => ColoredBox(
    color: context.tTheme.bgColorContainer,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}
