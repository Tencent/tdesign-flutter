import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class TextTokenStyleExample extends StatelessWidget {
  const TextTokenStyleExample({super.key});
  Widget _buildTokenStyle(BuildContext context) {
    return TText(
      exampleText,
      font: context.tTheme.fontHeadlineSmall,
      textColor: context.tTheme.brandNormalColor,
    );
  }

  static const exampleText = '文本 Text';

  @override
  Widget build(BuildContext context) {
    return _buildTokenStyle(context);
  }
}
