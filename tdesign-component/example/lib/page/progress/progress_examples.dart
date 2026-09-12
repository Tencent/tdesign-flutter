import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'progress')
class ProgressButtonExample extends StatefulWidget {
  const ProgressButtonExample({super.key});

  @override
  State<ProgressButtonExample> createState() => _ProgressButtonExampleState();
}

class _ProgressButtonExampleState extends State<ProgressButtonExample> {
  static const _target = 0.8;
  static const _step = 0.01;
  static const _stepDuration = Duration(milliseconds: 30);

  double _value = 0;
  Timer? _timer;

  bool get _advancing => _timer?.isActive ?? false;

  void _advance() {
    if (_advancing || _value >= _target) {
      return;
    }
    _increaseValue();
    _timer = Timer.periodic(_stepDuration, (_) => _increaseValue());
  }

  void _increaseValue() {
    setState(() => _value = (_value + _step).clamp(0, _target));
    if (_value >= _target) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TProgress(
      key: const Key('progress-button'),
      variant: TProgressVariant.button,
      value: _value,
      label: Text(_value == 0 ? '开始' : '${(_value * 100).round()}%'),
      semanticsLabel: '上传进度',
      onTap: _advance,
    );
  }
}

@ExampleCode(group: 'progress')
class ProgressMicroButtonExample extends StatefulWidget {
  const ProgressMicroButtonExample({super.key});

  @override
  State<ProgressMicroButtonExample> createState() =>
      _ProgressMicroButtonExampleState();
}

class _ProgressMicroButtonExampleState
    extends State<ProgressMicroButtonExample> {
  var _playing = false;
  var _value = 0.3;

  void _togglePlaying() {
    setState(() {
      _playing = !_playing;
      _value = _playing ? 0.6 : 0.3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TProgress(
      key: const Key('progress-micro-button'),
      variant: TProgressVariant.microButton,
      value: _value,
      label: Icon(_playing ? TIcons.pause : TIcons.play),
      semanticsLabel: '播放进度',
      onTap: _togglePlaying,
    );
  }
}
