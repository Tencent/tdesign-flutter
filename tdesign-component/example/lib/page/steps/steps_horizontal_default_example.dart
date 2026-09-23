import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'steps')
class StepsHorizontalDefaultExample extends StatelessWidget {
  const StepsHorizontalDefaultExample({super.key});

  /// Horizontal Default Steps 水平默认步骤条
  Widget _buildHorizontalDefault(BuildContext context) {
    return const TSteps.progress(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Content'),
        TStepsItemData(title: 'Process', content: 'Content'),
        TStepsItemData(title: 'Default', content: 'Content'),
        TStepsItemData(title: 'Default', content: 'Content'),
      ],
      value: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalDefault(context);
  }
}
