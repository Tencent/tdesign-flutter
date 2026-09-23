import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'steps')
class StepsHorizontalIconExample extends StatelessWidget {
  const StepsHorizontalIconExample({super.key});

  /// Horizontal Icon Steps 水平图标步骤条
  Widget _buildHorizontalIcon(BuildContext context) {
    return const TSteps.progress(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Content', icon: TIcons.cart),
        TStepsItemData(title: 'Process', content: 'Content', icon: TIcons.cart),
        TStepsItemData(title: 'Default', content: 'Content', icon: TIcons.cart),
        TStepsItemData(title: 'Default', content: 'Content', icon: TIcons.cart),
      ],
      value: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalIcon(context);
  }
}
