import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDProgressPage extends StatefulWidget {
  const TDProgressPage({Key? key}) : super(key: key);

  final examplePadding = const EdgeInsets.symmetric(horizontal: 16);

  @override
  State<StatefulWidget> createState() {
    return _TDProgressPageState();
  }
}

class _TDProgressPageState extends State<TDProgressPage> {
  TDLabelWidget buttonLabel = const TDTextLabel('开始');
  double progressValue = 0.0;
  Timer? _timer;
  bool isProgressing = false;
  bool isPlaying = false;
  double microProgressValue = 0.3;
  Timer? _microTimer;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于展示任务当前的进度',
        exampleCodeGroup: 'progress',
        backgroundColor: TDTheme.of().whiteColor1,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: '线性进度条',
                padding: widget.examplePadding,
                builder: _buildRightLabelLinear),
            ExampleItem(
                desc: '百分比内显',
                padding: widget.examplePadding,
                builder: _buildInsideLabelLinear),
            ExampleItem(
                desc: '环形进度条',
                padding: widget.examplePadding,
                center: false,
                builder: _buildCircle),
            ExampleItem(
                desc: '微型环形进度条',
                padding: widget.examplePadding,
                center: false,
                builder: _buildMicro),
            ExampleItem(
                desc: '按钮进度条',
                padding: widget.examplePadding,
                builder: _buildButton),
            ExampleItem(
                desc: '微型按钮进度条',
                padding: widget.examplePadding,
                center: false,
                builder: _buildMicroButton),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(
                desc: '线性进度条',
                padding: widget.examplePadding,
                builder: _buildPrimary),
            ExampleItem(padding: widget.examplePadding, builder: _buildWarning),
            ExampleItem(padding: widget.examplePadding, builder: _buildDanger),
            ExampleItem(padding: widget.examplePadding, builder: _buildSuccess),
            ExampleItem(
                desc: '环形进度条',
                padding: widget.examplePadding,
                center: false,
                builder: _buildCirclePrimary),
            ExampleItem(
                padding: widget.examplePadding,
                center: false,
                builder: _buildCircleWarning),
            ExampleItem(
                padding: widget.examplePadding,
                center: false,
                builder: _buildCircleDanger),
            ExampleItem(
                padding: widget.examplePadding,
                center: false,
                builder: _buildCircleSuccess),
          ])
        ]);
  }

  @Demo(group: 'progress')
  Widget _buildRightLabelLinear(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }

  @Demo(group: 'progress')
  Widget _buildInsideLabelLinear(BuildContext context) {
    return TDProgress(type: TDProgressType.linear, value: 0.8);
  }

  @Demo(group: 'progress')
  Widget _buildCircle(BuildContext context) {
    return TDProgress(type: TDProgressType.circular, value: 0.3);
  }

  @Demo(group: 'progress')
  Widget _buildMicro(BuildContext context) {
    return TDProgress(type: TDProgressType.micro, value: 0.75);
  }

  @Demo(group: 'progress')
  Widget _buildButton(BuildContext context) {
    return TDProgress(
        type: TDProgressType.button,
        onTap: _toggleProgress,
        onLongPress: _resetProgress,
        value: progressValue,
        label: buttonLabel);
  }

  @Demo(group: 'progress')
  Widget _buildMicroButton(BuildContext context) {
    return TDProgress(
      type: TDProgressType.micro,
      value: microProgressValue,
      onTap: _toggleMicroProgress,
      label: TDIconLabel(isPlaying ? Icons.pause : Icons.play_arrow,
          color: TDTheme.of(context).brandNormalColor),
    );
  }

  @Demo(group: 'progress')
  Widget _buildPrimary(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.primary,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }

  @Demo(group: 'progress')
  Widget _buildWarning(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.warning,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right,
    );
  }

  @Demo(group: 'progress')
  Widget _buildDanger(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.danger,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }

  @Demo(group: 'progress')
  Widget _buildSuccess(BuildContext context) {
    return TDProgress(
        type: TDProgressType.linear,
        progressStatus: TDProgressStatus.success,
        value: 0.8,
        strokeWidth: 6,
        progressLabelPosition: TDProgressLabelPosition.right);
  }

  @Demo(group: 'progress')
  Widget _buildCirclePrimary(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.primary,
        value: 0.3);
  }

  @Demo(group: 'progress')
  Widget _buildCircleWarning(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.warning,
        value: 0.3);
  }

  @Demo(group: 'progress')
  Widget _buildCircleDanger(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.danger,
        value: 0.3);
  }

  @Demo(group: 'progress')
  Widget _buildCircleSuccess(BuildContext context) {
    return TDProgress(
        type: TDProgressType.circular,
        progressStatus: TDProgressStatus.success,
        value: 1);
  }

  void _toggleProgress() {
    if (isProgressing) {
      // 暂停进度
      _timer?.cancel();
      setState(() {
        buttonLabel = const TDTextLabel('继续');
        isProgressing = false;
      });
    } else {
      // 开始或继续进度
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (progressValue < 1.0) {
            progressValue += 0.01;
            buttonLabel = TDTextLabel('${(progressValue * 100).toInt()}%');
          } else {
            _timer?.cancel();
            buttonLabel = const TDTextLabel('完成');
            isProgressing = false;
          }
        });
      });
      setState(() {
        isProgressing = true;
      });
    }
  }

  void _resetProgress() {
    _timer?.cancel();
    setState(() {
      progressValue = 0.0;
      buttonLabel = const TDTextLabel('开始');
      isProgressing = false;
    });
  }

  void _toggleMicroProgress() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      _microTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (microProgressValue < 1.0) {
            microProgressValue += 0.01;
          } else {
            _microTimer?.cancel();
            isPlaying = false;
            microProgressValue = 0.0;
          }
        });
      });
    } else {
      _microTimer?.cancel();
    }
  }
}
