import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'avatar')
class OperationAvatarExample extends StatelessWidget {
  const OperationAvatarExample({super.key});

  /// 带操作的头像组
  Widget _buildOperationAvatar(BuildContext context) {
    return TAvatarGroup(
      dimension: 48,
      cascading: TAvatarGroupCascading.endUp,
      children: [
        const TAvatar(image: AssetImage('assets/img/t_avatar_1.png')),
        const TAvatar(image: AssetImage('assets/img/t_avatar_2.png')),
        const TAvatar(image: AssetImage('assets/img/t_avatar_3.png')),
        const TAvatar(image: AssetImage('assets/img/t_avatar_4.png')),
        const TAvatar(image: AssetImage('assets/img/t_avatar_5.png')),
        TAvatar(
          child: const Icon(TIcons.user_add),
          onTap: () => TToast.showText('点击了操作', context: context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildOperationAvatar(context);
  }
}
