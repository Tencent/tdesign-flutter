import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'textarea')
class TextareaAutosizeExample extends StatelessWidget {
  const TextareaAutosizeExample({super.key});

  Widget _buildAutosize(BuildContext context) =>
      const TTextarea(label: '标签文字', hintText: '请输入文字', minLines: 1);

  @override
  Widget build(BuildContext context) {
    return _buildAutosize(context);
  }
}
