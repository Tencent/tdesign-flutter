import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class TextOverflowExample extends StatelessWidget {
  const TextOverflowExample({super.key});

  Widget _buildOverflow(BuildContext context) {
    return const SizedBox(
      width: 240,
      child: TText(
        '这是一段用于展示多行省略的较长文本，超出两行后使用省略号。',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildOverflow(context);
  }
}
