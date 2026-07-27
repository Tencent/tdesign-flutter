import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TAvatarPage extends StatefulWidget {
  const TAvatarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TAvatarPageState();
}

class _TAvatarPageState extends State<TAvatarPage> {
  static const padding = EdgeInsets.symmetric(horizontal: 16);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'avatar',
      desc: '用于展示用户头像信息，除了纯展示也可点击进入个人详情等操作。',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
              desc: '图片头像', padding: padding, builder: _buildImageAvatar),
          ExampleItem(
              desc: '字符头像', padding: padding, builder: _buildTextAvatar),
          ExampleItem(
              desc: '图标头像', padding: padding, builder: _buildIconAvatar),
          ExampleItem(
              desc: '带徽标头像', padding: padding, builder: _buildBadgeAvatar),
        ]),
        ExampleModule(title: '特殊类型', children: [
          ExampleItem(
              desc: '纯展示的头像组', padding: padding, builder: _buildDisplayAvatar),
          ExampleItem(
              desc: '带操作的头像组',
              padding: padding,
              builder: _buildOperationAvatar),
        ]),
        ExampleModule(title: '组件尺寸', children: [
          ExampleItem(
              desc: '大尺寸：64px', padding: padding, builder: _buildLargeAvatar),
          ExampleItem(
              desc: '中尺寸：48px', padding: padding, builder: _buildMediumAvatar),
          ExampleItem(
              desc: '小尺寸：40px', padding: padding, builder: _buildSmallAvatar),
        ])
      ],
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
          variant: TAvatarVariant.square,
          image: AssetImage('assets/img/t_avatar_1.png'),
        ),
      ],
    );
  }

  /// 字符头像
  @ExampleCode(group: 'avatar')
  Widget _buildTextAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          child: Text('A'),
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          variant: TAvatarVariant.square,
          child: Text('A'),
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
        TAvatar(
          size: TAvatarSize.medium,
          variant: TAvatarVariant.square,
        ),
      ],
    );
  }

  /// 带徽标头像
  @ExampleCode(group: 'avatar')
  Widget _buildBadgeAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        SizedBox(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(
                size: TAvatarSize.medium,
                image: AssetImage('assets/img/t_avatar_1.png'),
              ),
              Positioned(
                  child: TBadge(variant: TBadgeVariant.dot), right: 0, top: 0)
            ],
          ),
        ),
        SizedBox(width: 32),
        SizedBox(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(
                size: TAvatarSize.medium,
                child: Text('A'),
              ),
              Positioned(
                child: TBadge(count: 8),
                right: 0,
                top: 0,
              )
            ],
          ),
        ),
        SizedBox(width: 32),
        SizedBox(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(size: TAvatarSize.medium),
              Positioned(
                child: TBadge(count: 12),
                right: 0,
                top: 0,
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 纯展示的头像组
  @ExampleCode(group: 'avatar')
  Widget _buildDisplayAvatar(BuildContext context) {
    return const TAvatarGroup(
      maxCount: 4,
      overflow: TAvatar(child: Text('+1')),
      children: [
        TAvatar(image: AssetImage('assets/img/t_avatar_1.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_2.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_1.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_2.png')),
        TAvatar(image: AssetImage('assets/img/t_avatar_1.png')),
      ],
    );
  }

  /// 带操作的头像组
  @ExampleCode(group: 'avatar')
  Widget _buildOperationAvatar(BuildContext context) {
    return TAvatarGroup(
      children: [
        const TAvatar(image: AssetImage('assets/img/t_avatar_1.png')),
        const TAvatar(image: AssetImage('assets/img/t_avatar_2.png')),
        TAvatar(
          child: const Icon(Icons.add),
          onTap: () => TToast.showText('点击了操作', context: context),
        ),
      ],
    );
  }

  /// 组件尺寸 大尺寸
  @ExampleCode(group: 'avatar')
  Widget _buildLargeAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.large,
          image: AssetImage('assets/img/t_avatar_1.png'),
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.large,
          child: Text('A'),
        ),
        SizedBox(width: 32),
        TAvatar(size: TAvatarSize.large),
      ],
    );
  }

  /// 组件尺寸 中尺寸
  @ExampleCode(group: 'avatar')
  Widget _buildMediumAvatar(BuildContext context) {
    return const Row(
      // spacing: 48,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          image: AssetImage('assets/img/t_avatar_1.png'),
        ),
        SizedBox(width: 48),
        TAvatar(
          size: TAvatarSize.medium,
          child: Text('A'),
        ),
        SizedBox(width: 48),
        TAvatar(size: TAvatarSize.medium),
      ],
    );
  }

  /// 组件尺寸 小尺寸
  @ExampleCode(group: 'avatar')
  Widget _buildSmallAvatar(BuildContext context) {
    return const Row(
      // spacing: 56,
      children: [
        TAvatar(
          size: TAvatarSize.small,
          image: AssetImage('assets/img/t_avatar_1.png'),
        ),
        SizedBox(width: 56),
        TAvatar(
          size: TAvatarSize.small,
          child: Text('A'),
        ),
        SizedBox(width: 56),
        TAvatar(size: TAvatarSize.small),
      ],
    );
  }
}
