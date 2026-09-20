import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class RawTextExample extends StatelessWidget {
  const RawTextExample({super.key});
  Widget _buildRawText(BuildContext context) {
    return const TText(exampleText).getRawText(context: context);
  }

  static const exampleText = '文本 Text';

  @override
  Widget build(BuildContext context) {
    return _buildRawText(context);
  }
}
