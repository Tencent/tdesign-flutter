import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class TextLayoutExample extends StatelessWidget {
  const TextLayoutExample({super.key});

  Widget _buildLayout(BuildContext context) {
    return const SizedBox(
      width: 240,
      child: TText(
        '居中文本 Text',
        textAlign: TextAlign.center,
        textScaler: TextScaler.linear(1.25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context);
  }
}
