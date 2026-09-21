import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'progress')
class ProgressCircleStatusExample extends StatelessWidget {
  const ProgressCircleStatusExample({super.key});

  Widget _buildCircleStatus(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TProgress.circular(value: 0.3),
          const SizedBox(height: 24),
          TProgress.circular(value: 0.3, status: TProgressStatus.warning),
          const SizedBox(height: 24),
          TProgress.circular(value: 0.3, status: TProgressStatus.error),
          const SizedBox(height: 24),
          TProgress.circular(value: 1, status: TProgressStatus.success),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircleStatus(context);
  }
}
