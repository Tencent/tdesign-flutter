import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'progress')
class ProgressLinearStatusExample extends StatelessWidget {
  const ProgressLinearStatusExample({super.key});

  Widget _buildLinearStatus(BuildContext context) {
    return Column(
      children: [
        TProgress.linear(value: 0.8),
        const SizedBox(height: 18),
        TProgress.linear(value: 0.8, status: TProgressStatus.warning),
        const SizedBox(height: 18),
        TProgress.linear(value: 0.8, status: TProgressStatus.error),
        const SizedBox(height: 18),
        TProgress.linear(value: 0.8, status: TProgressStatus.success),
        const SizedBox(height: 18),
        TProgress.linear(
          value: 0.8,
          gradient: LinearGradient(
            colors: [
              context.tTheme.brandNormalColor,
              context.tTheme.successNormalColor,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLinearStatus(context);
  }
}
