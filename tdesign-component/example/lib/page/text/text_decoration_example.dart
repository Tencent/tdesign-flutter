import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class TextDecorationExample extends StatelessWidget {
  const TextDecorationExample({super.key});

  Widget _buildDecoration(BuildContext context) {
    return TText(
      '已失效文本',
      fontWeight: FontWeight.w600,
      isTextThrough: true,
      lineThroughColor: context.tTheme.errorNormalColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDecoration(context);
  }
}
