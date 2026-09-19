import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import 'stepper_examples.dart';

part 'stepper_type.dart';
part 'stepper_status.dart';
part 'stepper_style.dart';

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
    children: [_stepperTypeModule, _stepperStatusModule, _stepperStyleModule],
  );

  Widget _container(Widget child) => ColoredBox(
    color: context.tTheme.bgColorContainer,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}
