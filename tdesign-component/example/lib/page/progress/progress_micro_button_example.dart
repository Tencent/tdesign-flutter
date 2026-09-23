import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

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
  var _value = 0.75;

  void _togglePlaying() {
    setState(() {
      _playing = !_playing;
      _value = _playing ? 1 : 0.75;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TProgress.microButton(
        key: const Key('progress-micro-button'),
        value: _value,
        label: Icon(_playing ? TIcons.pause : TIcons.play),
        semanticsLabel: '播放进度',
        onTap: _togglePlaying,
      ),
    );
  }
}
