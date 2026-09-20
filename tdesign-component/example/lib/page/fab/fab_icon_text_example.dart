import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'fab')
class FabIconTextExample extends StatelessWidget {
  const FabIconTextExample({super.key, required this.onSelected});

  final VoidCallback onSelected;

  static Widget buildFab(VoidCallback onPressed) {
    return TFab(
      icon: const Icon(TIcons.share),
      text: '分享给朋友',
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) => _selector('图标加文字悬浮按钮');

  Widget _selector(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity,
      child: TButton(
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: onSelected,
        child: Text(text),
      ),
    ),
  );
}
