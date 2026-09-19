import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'avatar_size.dart';
part 'avatar_special.dart';
part 'avatar_type.dart';

const _avatarItemPadding = EdgeInsets.symmetric(horizontal: 16);

class TAvatarPage extends StatefulWidget {
  const TAvatarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TAvatarPageState();
}

class _TAvatarPageState extends State<TAvatarPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'avatar',
      showTestModule: false,
      desc: '用于展示用户头像信息，除了纯展示也可点击进入个人详情等操作。',
      children: [_avatarTypeModule, _avatarSpecialModule, _avatarSizeModule],
    );
  }

  /// 图片头像
  @ExampleCode(group: 'avatar')
  Widget _buildImageAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          image: AssetImage('assets/img/t_avatar_1.png'),
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          shape: TAvatarShape.square,
          image: AssetImage('assets/img/t_avatar_1.png'),
        ),
      ],
    );
  }

  /// 字符头像
  @ExampleCode(group: 'avatar')
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

  /// 图标头像
  @ExampleCode(group: 'avatar')
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

  /// 带徽标头像
  @ExampleCode(group: 'avatar')
  Widget _buildBadgeAvatar(BuildContext context) {
    return Row(
      // spacing: 32,
      children: [
        const BadgeTheme(
          data: BadgeThemeData(smallSize: 10),
          child: TBadge(
            variant: TBadgeVariant.dot,
            offset: Offset(-1, 2),
            child: TAvatar(
              size: TAvatarSize.medium,
              image: AssetImage('assets/img/t_avatar_1.png'),
            ),
          ),
        ),
        const SizedBox(width: 32),
        TBadge(
          label: '8',
          offset: const Offset(-5, 6),
          child: TAvatar(
            size: TAvatarSize.medium,
            backgroundColor: context.tTheme.brandNormalColor,
            foregroundColor: context.tTheme.whiteColor1,
            child: const Text('A'),
          ),
        ),
        const SizedBox(width: 32),
        const TBadge(
          label: '12',
          offset: Offset(-5, 6),
          child: TAvatar(size: TAvatarSize.medium),
        ),
      ],
    );
  }

  /// 纯展示的头像组
  @ExampleCode(group: 'avatar')
  Widget _buildDisplayAvatar(BuildContext context) {
    return const TAvatarGroup(
      dimension: 48,
      cascading: TAvatarGroupCascading.startUp,
      maxCount: 5,
      overflow: TAvatar(child: Text('+5')),
      children: [
        TAvatar(image: AssetImage('assets/img/t_avatar_1.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_2.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_3.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_4.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_5.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_1.png')),
      ],
    );
  }

  /// 带操作的头像组
  @ExampleCode(group: 'avatar')
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

  /// 组件尺寸
  @ExampleCode(group: 'avatar')
  Widget _buildSizeAvatar(BuildContext context) {
    Widget avatarRow(TAvatarSize size) {
      return Row(
        children: [
          TAvatar(
            size: size,
            image: const AssetImage('assets/img/t_avatar_1.png'),
          ),
          const SizedBox(width: 32),
          TAvatar(
            size: size,
            backgroundColor: context.tTheme.brandNormalColor,
            foregroundColor: context.tTheme.whiteColor1,
            child: const Text('A'),
          ),
          const SizedBox(width: 32),
          TAvatar(size: size),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        avatarRow(TAvatarSize.large),
        const SizedBox(height: 24),
        avatarRow(TAvatarSize.medium),
        const SizedBox(height: 24),
        avatarRow(TAvatarSize.small),
      ],
    );
  }
}
