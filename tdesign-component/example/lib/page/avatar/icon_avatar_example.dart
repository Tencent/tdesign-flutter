import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'avatar')
class IconAvatarExample extends StatelessWidget {
  const IconAvatarExample({super.key});

  /// 图标头像
  Widget _buildIconAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(size: TAvatarSize.medium),
        SizedBox(width: 32),
        TAvatar(size: TAvatarSize.medium, shape: TAvatarShape.square),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIconAvatar(context);
  }
}
