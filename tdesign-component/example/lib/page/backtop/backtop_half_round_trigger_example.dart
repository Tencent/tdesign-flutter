import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'backtop')
class BacktopHalfRoundTriggerExample extends StatelessWidget {
  const BacktopHalfRoundTriggerExample({super.key, required this.onSelected});

  final ValueChanged<TBackTopShape> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        key: const Key('backtop-demo-half-round-trigger'),
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        size: TButtonSize.large,
        onPressed: () => onSelected(TBackTopShape.halfCircle),
        child: const TText('半圆形返回顶部'),
      ),
    );
  }
}
