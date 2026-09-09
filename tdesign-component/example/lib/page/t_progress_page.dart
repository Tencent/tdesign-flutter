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
            ExampleItem(desc: '线性进度条', builder: _buildLinear),
            ExampleItem(desc: '百分比内显', builder: _buildPlump),
            ExampleItem(desc: '环形进度条', builder: _buildCircle),
            ExampleItem(desc: '微型环形进度条', builder: _buildMicroCircle),
            ExampleItem(desc: '带操作图片预览', builder: _buildButton),
            ExampleItem(desc: '微型按钮进度条', builder: _buildMicroButton),
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
    return TProgress(variant: TProgressVariant.microCircular, value: 0.3);
  }

  @ExampleCode(group: 'progress')
  Widget _buildButton(BuildContext context) {
    var value = 0.0;
    return StatefulBuilder(
      builder: (context, setState) {
        return TProgress(
          key: const Key('progress-button'),
          variant: TProgressVariant.button,
          value: value,
          label: Text(value == 0 ? '开始' : '${(value * 100).round()}%'),
          semanticsLabel: '上传进度',
          onTap: () => setState(() => value = value == 0 ? 0.8 : 0),
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
              variant: TProgressVariant.microButton,
              value: value,
              label: Icon(playing ? TIcons.pause : TIcons.play),
              semanticsLabel: '播放进度',
              onTap: () {
                setState(() {
                  playing = !playing;
                  value = playing ? 0.6 : 0.3;
                });
              },
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
