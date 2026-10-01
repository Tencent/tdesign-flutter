import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class CircleFillTagExample extends StatelessWidget {
  const CircleFillTagExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 16),
        TTag('标签文字', shape: TTagShape.round, variant: TTagVariant.light),
        SizedBox(width: 16),
        TTag('标签文字', shape: TTagShape.round, variant: TTagVariant.outline),
        SizedBox(width: 16),
        TTag('标签文字', shape: TTagShape.mark, variant: TTagVariant.outline),
      ],
    );
  }
}
