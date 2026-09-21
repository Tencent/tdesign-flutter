import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class LongTextTagExample extends StatelessWidget {
  const LongTextTagExample({super.key});

  Widget _buildLongTextTag(BuildContext context) {
    return Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TTagThemeData(fixedWidth: 130)),
      child: const TTag('超长省略文本标签超长省略文本标签'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: context.tTheme.spacer16),
        Builder(builder: _buildLongTextTag),
      ],
    );
  }
}
