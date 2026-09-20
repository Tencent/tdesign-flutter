import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'steps')
class StepsHorizontalDotExample extends StatelessWidget {
  const StepsHorizontalDotExample({super.key});

  /// Horizontal Dot Steps 水平简略步骤条
  Widget _buildHorizontalDot(BuildContext context) {
    return const TSteps.progress(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Content'),
        TStepsItemData(title: 'Process', content: 'Content'),
        TStepsItemData(title: 'Default', content: 'Content'),
        TStepsItemData(title: 'Default', content: 'Content'),
      ],
      value: 1,
      indicator: TStepsIndicator.dot,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalDot(context);
  }
}
