import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'steps')
class DisplayStepsExample extends StatelessWidget {
  const DisplayStepsExample({super.key});

  /// Read-only Steps 纯展示步骤条
  Widget _buildDisplaySteps(BuildContext context) {
    return const TSteps.display(
      steps: [
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
      ],
      direction: TStepsDirection.vertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDisplaySteps(context);
  }
}
