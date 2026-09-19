import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'progress_examples.dart';

part 'progress_type.dart';
part 'progress_status.dart';

class TProgressPage extends StatelessWidget {
  const TProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于展示任务当前的进度。',
      exampleCodeGroup: 'progress',
      padding: const EdgeInsets.all(16),
      children: [_progressTypeModule, _progressStatusModule],
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildLinear(BuildContext context) {
    return TProgress(variant: TProgressVariant.linear, value: 0.8);
  }

  @ExampleCode(group: 'progress')
  Widget _buildPlump(BuildContext context) {
    return TProgress(variant: TProgressVariant.plump, value: 0.8);
  }

  @ExampleCode(group: 'progress')
  Widget _buildCircle(BuildContext context) {
    return TProgress(variant: TProgressVariant.circular, value: 0.3);
  }

  @ExampleCode(group: 'progress')
  Widget _buildMicroCircle(BuildContext context) {
    return TProgress(variant: TProgressVariant.microCircular, value: 0.3);
  }

  Widget _buildButton(BuildContext context) {
    return const ProgressButtonExample();
  }

  Widget _buildMicroButton(BuildContext context) {
    return const ProgressMicroButtonExample();
  }

  @ExampleCode(group: 'progress')
  Widget _buildLinearStatus(BuildContext context) {
    return Column(
      children: [
        TProgress(variant: TProgressVariant.linear, value: 0.8),
        const SizedBox(height: 12),
        TProgress(
          variant: TProgressVariant.linear,
          value: 0.8,
          status: TProgressStatus.warning,
        ),
        const SizedBox(height: 12),
        TProgress(
          variant: TProgressVariant.linear,
          value: 0.8,
          status: TProgressStatus.error,
        ),
        const SizedBox(height: 12),
        TProgress(
          variant: TProgressVariant.linear,
          value: 0.8,
          status: TProgressStatus.success,
        ),
        const SizedBox(height: 12),
        TProgress(
          variant: TProgressVariant.linear,
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

  @ExampleCode(group: 'progress')
  Widget _buildPlumpStatus(BuildContext context) {
    return Column(
      children: [
        TProgress(variant: TProgressVariant.plump, value: 0.8),
        const SizedBox(height: 8),
        TProgress(
          variant: TProgressVariant.plump,
          value: 1,
          status: TProgressStatus.success,
        ),
        const SizedBox(height: 8),
        TProgress(
          variant: TProgressVariant.plump,
          value: 0.8,
          status: TProgressStatus.warning,
        ),
        const SizedBox(height: 8),
        TProgress(
          variant: TProgressVariant.plump,
          value: 0.8,
          status: TProgressStatus.error,
        ),
        const SizedBox(height: 8),
        TProgress(
          variant: TProgressVariant.plump,
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

  @ExampleCode(group: 'progress')
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
}
