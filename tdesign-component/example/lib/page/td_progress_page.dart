import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDProgressPage extends StatefulWidget {
  const TDProgressPage({Key? key}) : super(key: key);

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

  double value = 0.1;

  bool isPlusOperation = true;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于展示任务当前的进度',
      exampleCodeGroup: 'progress',
      padding: const EdgeInsets.all(16),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '线性进度条', builder: _buildRightLabelLinear),
          ExampleItem(desc: '百分比内显', builder: _buildInsideLabelLinear),
          ExampleItem(desc: '环形进度条', builder: _buildCircle),
          ExampleItem(desc: '微型环形进度条', builder: _buildMicro),
          ExampleItem(desc: '按钮进度条', builder: _buildButton),
          ExampleItem(desc: '微型按钮进度条', builder: _buildMicroButton),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '线性进度条', builder: _buildPrimary),
          ExampleItem(builder: _buildWarning),
          ExampleItem(builder: _buildDanger),
          ExampleItem(builder: _buildSuccess),
          ExampleItem(builder: _buildPrimaryInside),
          ExampleItem(builder: _buildWarningInside),
          ExampleItem(builder: _buildDangerInside),
          ExampleItem(builder: _buildSuccessInside),
          ExampleItem(desc: '环形进度条', builder: _buildCirclePrimary),
          ExampleItem(builder: _buildCircleWarning),
          ExampleItem(builder: _buildCircleDanger),
          ExampleItem(builder: _buildCircleSuccess),
        ])
      ],
      floatingActionButton: FloatingActionButton(
        child: Icon(
          isPlusOperation ? TDIcons.plus : TDIcons.minus,
        ),
        onPressed: () {
          setState(() {
            // 加到1时为减，减到0时为加
            value += isPlusOperation ? 0.05 : -0.05;
            if (value >= 1) {
              isPlusOperation = false;
            }
            if (value <= 0) {
              isPlusOperation = true;
            }
          });
        },
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildRightLabelLinear(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      value: value,
      strokeWidth: 6,
      progressLabelPosition: TDProgressLabelPosition.right,
    );
  }

  @Demo(group: 'progress')
  Widget _buildInsideLabelLinear(BuildContext context) {
    return TDProgress(type: TDProgressType.linear, value: value);
  }

  @Demo(group: 'progress')
  Widget _buildCircle(BuildContext context) {
    return TDProgress(type: TDProgressType.circular, value: value);
  }

  @Demo(group: 'progress')
  Widget _buildMicro(BuildContext context) {
    return TDProgress(type: TDProgressType.micro, value: value);
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

  @Demo(group: 'progress')
  Widget _buildMicroButton(BuildContext context) {
    return TDProgress(
      type: TDProgressType.micro,
      value: microProgressValue,
      onTap: _toggleMicroProgress,
      label: TDIconLabel(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: TDTheme.of(context).brandNormalColor,
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildPrimary(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.primary,
      value: value,
      strokeWidth: 6,
      progressLabelPosition: TDProgressLabelPosition.right,
    );
  }

  @Demo(group: 'progress')
  Widget _buildWarning(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.warning,
      value: value,
      strokeWidth: 6,
      progressLabelPosition: TDProgressLabelPosition.right,
    );
  }

  @Demo(group: 'progress')
  Widget _buildDanger(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.danger,
      value: value,
      strokeWidth: 6,
      progressLabelPosition: TDProgressLabelPosition.right,
    );
  }

  @Demo(group: 'progress')
  Widget _buildSuccess(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.success,
      value: 1,
      strokeWidth: 6,
      progressLabelPosition: TDProgressLabelPosition.right,
    );
  }

  @Demo(group: 'progress')
  Widget _buildPrimaryInside(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.primary,
      value: value,
      progressLabelPosition: TDProgressLabelPosition.inside,
    );
  }

  @Demo(group: 'progress')
  Widget _buildWarningInside(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.warning,
      value: value,
      progressLabelPosition: TDProgressLabelPosition.inside,
    );
  }

  @Demo(group: 'progress')
  Widget _buildDangerInside(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.danger,
      value: value,
      progressLabelPosition: TDProgressLabelPosition.inside,
    );
  }

  @Demo(group: 'progress')
  Widget _buildSuccessInside(BuildContext context) {
    return TDProgress(
      type: TDProgressType.linear,
      progressStatus: TDProgressStatus.success,
      value: 1,
      progressLabelPosition: TDProgressLabelPosition.inside,
    );
  }

  @Demo(group: 'progress')
  Widget _buildCirclePrimary(BuildContext context) {
    return TDProgress(
      type: TDProgressType.circular,
      progressStatus: TDProgressStatus.primary,
      value: value,
    );
  }

  @Demo(group: 'progress')
  Widget _buildCircleWarning(BuildContext context) {
    return TDProgress(
      type: TDProgressType.circular,
      progressStatus: TDProgressStatus.warning,
      value: value,
    );
  }

  @Demo(group: 'progress')
  Widget _buildCircleDanger(BuildContext context) {
    return TDProgress(
      type: TDProgressType.circular,
      progressStatus: TDProgressStatus.danger,
      value: value,
    );
  }

  @Demo(group: 'progress')
  Widget _buildCircleSuccess(BuildContext context) {
    return TDProgress(
      type: TDProgressType.circular,
      progressStatus: TDProgressStatus.success,
      value: 1,
    );
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
