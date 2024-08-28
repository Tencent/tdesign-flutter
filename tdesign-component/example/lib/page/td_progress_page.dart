import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDProgressPage extends StatefulWidget {
  const TDProgressPage({Key? key}) : super(key: key);

  final examplePadding = const EdgeInsets.symmetric(horizontal: 16);

  @override
  State<StatefulWidget> createState() => _TDProgressPageState();
}

class _TDProgressPageState extends State<TDProgressPage> {
  TDLabelWidget buttonLabel = const TDTextLabel('开始');
  double progressValue = 0.0;
  Timer? _timer;
  bool isProgressing = false;
  bool isPlaying = false;
  double microProgressValue = 0.0;
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
            builder: _buildRightLabelLinear,
          ),
          ExampleItem(
            desc: '百分比内显',
            padding: widget.examplePadding,
            builder: _buildInsideLabelLinear,
          ),
          ExampleItem(
              desc: '环形进度条',
              padding: widget.examplePadding,
              builder: _buildCircle,
              center: false),
          ExampleItem(
              desc: '微型环形进度条',
              padding: widget.examplePadding,
              builder: _buildMicro,
              center: false),
          ExampleItem(
            desc: '按钮进度条',
            padding: widget.examplePadding,
            builder: _buildResizedButton,
            center: false,
          ),
          ExampleItem(
            desc: '微型按钮进度条',
            padding: widget.examplePadding,
            builder: _buildMicroButton,
          ),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(
            desc: '线性进度条状态',
            padding: widget.examplePadding,
            builder: _buildLinearProgressStatus,
          ),
          ExampleItem(
            desc: '环形进度条状态',
            padding: widget.examplePadding,
            builder: _buildCircularProgressStatus,
          ),
        ])
      ],
    );
  }

  @Demo(group: 'progress')
  Widget _buildRightLabelLinear(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      value: 0.8,
      strokeWidth: 6,
      progressLabelPosition: TDProgressLabelPosition.right,
      animationDuration: 1000,
    );
  }

  Widget _buildInsideLabelLinear(BuildContext context) {
    return Column(
      children: [
        TDProgress(type: TDProgressType.linear, value: 0.8),
        const SizedBox(height: 16),
        TDProgress(type: TDProgressType.linear, value: 0.1),
      ],
    );
  }

  @Demo(group: 'progress')
  Widget _buildCircle(BuildContext context) {
    return TDProgress(type: TDProgressType.circular, value: 0.3);
  }

  @Demo(group: 'progress')
  Widget _buildMicro(BuildContext context) {
    return TDProgress(type: TDProgressType.micro, value: 0.75);
  }

  Widget _buildResizedButton(BuildContext context) {
    return SizedBox(
      width: 300,
      child: _buildButton(context),
    );
  }

  @Demo(group: 'progress')
  Widget _buildButton(BuildContext context) {
    return TDProgress(
      type: TDProgressType.button,
      onTap: _toggleProgress,
      onLongPress: _resetProgress,
      value: progressValue,
      label: buttonLabel,
    );
  }

  Widget _buildMicroButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TDProgress(
          type: TDProgressType.micro,
          value: microProgressValue,
          onTap: _toggleMicroProgress,
          label: TDIconLabel(isPlaying ? Icons.pause : Icons.play_arrow,
              color: TDTheme.of(context).brandNormalColor),
        ),
        const SizedBox(width: 10),
        TDProgress(
          type: TDProgressType.micro,
          value: microProgressValue,
          onTap: _resetMicroProgress,
          label: TDIconLabel(Icons.stop,
              color: TDTheme.of(context).brandNormalColor),
        ),
      ],
    );
  }

  Widget _buildLinearProgressStatus(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabeledLinearProgress('Primary', TDProgressStatus.primary),
        _buildLabeledLinearProgress('Warning', TDProgressStatus.warning),
        _buildLabeledLinearProgress('Danger', TDProgressStatus.danger),
        _buildLabeledLinearProgress('Success', TDProgressStatus.success),
      ],
    );
  }

  Widget _buildLabeledLinearProgress(String label, TDProgressStatus status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            child: TDProgress(
              type: TDProgressType.linear,
              progressStatus: status,
              value: 0.8,
              strokeWidth: 6,
              progressLabelPosition: TDProgressLabelPosition.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgressStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildLabeledCircularProgress('Primary', TDProgressStatus.primary),
        const SizedBox(width: 24),
        _buildLabeledCircularProgress('Warning', TDProgressStatus.warning),
        const SizedBox(width: 24),
        _buildLabeledCircularProgress('Danger', TDProgressStatus.danger),
        const SizedBox(width: 24),
        _buildLabeledCircularProgress('Success', TDProgressStatus.success),
      ],
    );
  }

  Widget _buildLabeledCircularProgress(String label, TDProgressStatus status) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TDProgress(
          type: TDProgressType.circular,
          progressStatus: status,
          value: status == TDProgressStatus.success ? 1 : 0.3,
        ),
      ],
    );
  }

  void _toggleProgress() {
    if (isProgressing) {
      _timer?.cancel();
      setState(() {
        buttonLabel = const TDTextLabel('继续');
        isProgressing = false;
      });
    } else {
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

  void _resetMicroProgress() {
    _microTimer?.cancel();
    setState(() {
      isPlaying = false;
      microProgressValue = 0.0;
    });
  }
}