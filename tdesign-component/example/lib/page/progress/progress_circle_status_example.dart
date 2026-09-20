import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'progress')
class ProgressCircleStatusExample extends StatelessWidget {
  const ProgressCircleStatusExample({super.key});

  Widget _buildCircleStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TProgress(variant: TProgressVariant.circular, value: 0.3),
        TProgress(
          variant: TProgressVariant.circular,
          value: 0.3,
          status: TProgressStatus.warning,
        ),
        TProgress(
          variant: TProgressVariant.circular,
          value: 0.3,
          status: TProgressStatus.error,
        ),
        TProgress(
          variant: TProgressVariant.circular,
          value: 1,
          status: TProgressStatus.success,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircleStatus(context);
  }
}
