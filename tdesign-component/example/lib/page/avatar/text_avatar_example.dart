import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'avatar')
class TextAvatarExample extends StatelessWidget {
  const TextAvatarExample({super.key});

  /// 字符头像
  Widget _buildTextAvatar(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        TAvatarThemeData(
          backgroundColor: context.tTheme.brandColor,
          foregroundColor: context.tTheme.whiteColor1,
        ),
      ),
      child: const Row(
        // spacing: 32,
        children: [
          TAvatar(size: TAvatarSize.medium, child: Text('A')),
          SizedBox(width: 32),
          TAvatar(
            size: TAvatarSize.medium,
            shape: TAvatarShape.square,
            child: Text('A'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextAvatar(context);
  }
}
