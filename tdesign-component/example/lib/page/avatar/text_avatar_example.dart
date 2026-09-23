import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'avatar')
class TextAvatarExample extends StatelessWidget {
  const TextAvatarExample({super.key});

  /// 字符头像
  Widget _buildTextAvatar(BuildContext context) {
    return Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          backgroundColor: context.tTheme.brandNormalColor,
          foregroundColor: context.tTheme.whiteColor1,
          child: const Text('A'),
        ),
        const SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          shape: TAvatarShape.square,
          backgroundColor: context.tTheme.brandNormalColor,
          foregroundColor: context.tTheme.whiteColor1,
          child: const Text('A'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextAvatar(context);
  }
}
