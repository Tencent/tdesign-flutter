import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class CircleFillTagExample extends StatelessWidget {
  const CircleFillTagExample({super.key});

  Widget _buildCircleFillTag(BuildContext context) {
    // 圆弧标签：通过 TTagThemeData(shape: TTagShape.round) 子树注入
    return Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TTagThemeData(shape: TTagShape.round)),
      child: const TTag('标签文字', variant: TTagVariant.light),
    );
  }

  Widget _buildCircleOutlineTag(BuildContext context) {
    return Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TTagThemeData(shape: TTagShape.round)),
      child: const TTag('标签文字', variant: TTagVariant.outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Builder(builder: _buildCircleFillTag),
        const SizedBox(width: 16),
        Builder(builder: _buildCircleOutlineTag),
      ],
    );
  }
}
