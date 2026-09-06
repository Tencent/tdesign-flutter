import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TProgressPage extends StatelessWidget {
  const TProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于展示任务当前的进度。',
      exampleCodeGroup: 'progress',
      padding: const EdgeInsets.all(16),
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: 'Line 线性进度条', builder: _buildLinear),
            ExampleItem(desc: 'Plump 百分比内显', builder: _buildPlump),
            ExampleItem(desc: 'Circle 环形进度条', builder: _buildCircle),
            ExampleItem(
              desc: 'Micro Circle 微型环形进度条',
              builder: _buildMicroCircle,
            ),
            ExampleItem(desc: 'Button 按钮进度', builder: _buildButton),
            ExampleItem(
              desc: 'Micro Button 微型按钮进度',
              builder: _buildMicroButton,
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '线性进度条', builder: _buildLinearStatus),
            ExampleItem(desc: '百分比内显进度条', builder: _buildPlumpStatus),
            ExampleItem(desc: '环形进度条', builder: _buildCircleStatus),
          ],
        ),
      ],
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
    return TProgress(
      variant: TProgressVariant.micro,
      value: 0.3,
      label: const SizedBox.shrink(),
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildButton(BuildContext context) {
    var value = 0.8;
    return StatefulBuilder(
      builder: (context, setState) {
        void advance() {
          setState(() => value = value >= 1 ? 0 : value + 0.1);
        }

        return Column(
          children: [
            TProgress(
              key: const Key('progress-button-value'),
              variant: TProgressVariant.button,
              value: value,
              onTap: advance,
            ),
            SizedBox(height: context.tTheme.spacer8),
            TProgress(
              key: const Key('progress-button-continue'),
              variant: TProgressVariant.button,
              value: value,
              label: const Text('Continue'),
              onTap: advance,
            ),
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildMicroButton(BuildContext context) {
    var playing = false;
    var value = 0.3;
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            TProgress(
              key: const Key('progress-micro-button'),
              variant: TProgressVariant.micro,
              value: value,
              label: Icon(playing ? TIcons.pause : TIcons.play),
              onTap: () {
                setState(() {
                  playing = !playing;
                  value = playing ? 0.6 : 0.3;
                });
              },
            ),
            SizedBox(width: context.tTheme.spacer16),
            TProgress(
              variant: TProgressVariant.micro,
              value: 1,
              status: TProgressStatus.success,
            ),
            SizedBox(width: context.tTheme.spacer16),
            TProgress(
              variant: TProgressVariant.micro,
              value: 0.3,
              status: TProgressStatus.error,
            ),
          ],
        );
      },
    );
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
          status: TProgressStatus.success,
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
