import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class PlainTextExample extends StatefulWidget {
  const PlainTextExample({super.key});

  @override
  State<PlainTextExample> createState() => _PlainTextExampleState();
}

class _PlainTextExampleState extends State<PlainTextExample> {
  Widget _buildPlainText(BuildContext context) {
    return const TText(exampleText);
  }

  static const exampleText = '文本 Text';

  @override
  Widget build(BuildContext context) {
    return _buildPlainText(context);
  }
}
