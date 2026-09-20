import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'result')
class DescriptionResultsExample extends StatelessWidget {
  const DescriptionResultsExample({super.key});

  Widget _buildDescriptionResults(BuildContext context) {
    return const Column(
      children: [
        TResult(
          status: TResultStatus.success,
          title: '成功状态',
          description: '描述文字',
        ),
        SizedBox(height: 48),
        TResult(
          status: TResultStatus.error,
          title: '失败状态',
          description: '描述文字',
        ),
        SizedBox(height: 48),
        TResult(
          status: TResultStatus.warning,
          title: '警示状态',
          description: '描述文字',
        ),
        SizedBox(height: 48),
        TResult(title: '默认状态', description: '描述文字'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDescriptionResults(context);
  }
}
