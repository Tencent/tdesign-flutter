import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TProgressPage extends StatefulWidget {
  const TProgressPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TProgressPageState();
  }
}

class _TProgressPageState extends State<TProgressPage> {
  Widget buttonLabel = const Text('开始');
  double progressValue = 0.0;
  double microProgressValue = 0.3;
  Timer? _buttonTimer;
  Timer? _microTimer;
  bool _isProgressing = false;
  bool _isMicroPlaying = false;

  double value = 0.1;

  bool isPlusOperation = true;

  @override
  void dispose() {
    _buttonTimer?.cancel();
    _microTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
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
          isPlusOperation ? TIcons.plus : TIcons.minus,
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

  @ExampleCode(group: 'progress')
  Widget _buildRightLabelLinear(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildInsideLabelLinear(BuildContext context) {
    return TProgress(variant: TProgressVariant.linear, value: value);
  }

  @ExampleCode(group: 'progress')
  Widget _buildCircle(BuildContext context) {
    return TProgress(variant: TProgressVariant.circular, value: value);
  }

  @ExampleCode(group: 'progress')
  Widget _buildMicro(BuildContext context) {
    return TProgress(variant: TProgressVariant.micro, value: value);
  }

  @ExampleCode(group: 'progress')
  Widget _buildButton(BuildContext context) {
    return TProgress(
      key: const Key('progress-button'),
      variant: TProgressVariant.button,
      value: progressValue,
      label: buttonLabel,
      onTap: () {
        TToast.showText('onTap 已触发', context: context);
        _toggleProgress();
      },
      onLongPress: () {
        TToast.showText(
          'onLongPress 已触发，onTap 未触发',
          context: context,
        );
      },
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildMicroButton(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.micro,
      value: microProgressValue,
      label: Icon(
        _isMicroPlaying ? Icons.pause : Icons.play_arrow,
        color: context.tTheme.brandNormalColor,
      ),
      onTap: _toggleMicroProgress,
    );
  }

  void _toggleProgress() {
    if (_isProgressing) {
      _buttonTimer?.cancel();
      setState(() {
        _isProgressing = false;
        buttonLabel = const Text('继续');
      });
      return;
    }

    setState(() {
      _isProgressing = true;
      buttonLabel = const Text('进行中');
    });
    _buttonTimer?.cancel();
    _buttonTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        progressValue += 0.01;
        if (progressValue >= 1) {
          progressValue = 1;
          buttonLabel = const Text('完成');
          _isProgressing = false;
          timer.cancel();
        } else {
          buttonLabel = Text('${(progressValue * 100).round()}%');
        }
      });
    });
  }

  void _toggleMicroProgress() {
    if (_isMicroPlaying) {
      _microTimer?.cancel();
      setState(() => _isMicroPlaying = false);
      return;
    }

    setState(() => _isMicroPlaying = true);
    _microTimer?.cancel();
    _microTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        microProgressValue += 0.01;
        if (microProgressValue >= 1) {
          microProgressValue = 0;
          _isMicroPlaying = false;
          timer.cancel();
        }
      });
    });
  }

  @ExampleCode(group: 'progress')
  Widget _buildPrimary(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildWarning(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildDanger(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildSuccess(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: 1,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildPrimaryInside(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildWarningInside(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildDangerInside(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildSuccessInside(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.linear,
      value: 1,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildCirclePrimary(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.circular,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildCircleWarning(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.circular,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildCircleDanger(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.circular,
      value: value,
    );
  }

  @ExampleCode(group: 'progress')
  Widget _buildCircleSuccess(BuildContext context) {
    return TProgress(
      variant: TProgressVariant.circular,
      value: 1,
    );
  }
}
