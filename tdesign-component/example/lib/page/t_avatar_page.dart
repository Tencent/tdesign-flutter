import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

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
      title: tdTitle(),
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
  @Demo(group: 'avatar')
  Widget _buildImageAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.normal,
          shape: TAvatarShape.square,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
      ],
    );
  }

  /// 字符头像
  @Demo(group: 'avatar')
  Widget _buildTextAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.customText,
          shape: TAvatarShape.square,
          text: 'A',
        ),
      ],
    );
  }

  /// 图标头像
  @Demo(group: 'avatar')
  Widget _buildIconAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.icon,
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.icon,
          shape: TAvatarShape.square,
        ),
      ],
    );
  }

  /// 带徽标头像
  @Demo(group: 'avatar')
  Widget _buildBadgeAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        SizedBox(
          height: 51,
          width: 51,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(
                size: TAvatarSize.medium,
                type: TAvatarType.normal,
                defaultUrl: 'assets/img/t_avatar_1.png',
              ),
              Positioned(child: TBadge(TBadgeType.redPoint), right: 0, top: 0)
            ],
          ),
        ),
        SizedBox(width: 32),
        SizedBox(
          height: 51,
          width: 51,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(
                size: TAvatarSize.medium,
                type: TAvatarType.customText,
                text: 'A',
              ),
              Positioned(
                child: TBadge(TBadgeType.message, count: '8'),
                right: 0,
                top: 0,
              )
            ],
          ),
        ),
        SizedBox(width: 32),
        SizedBox(
          width: 51,
          height: 51,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TAvatar(size: TAvatarSize.medium, type: TAvatarType.icon),
              Positioned(
                child: TBadge(TBadgeType.message, count: '12'),
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
  @Demo(group: 'avatar')
  Widget _buildDisplayAvatar(BuildContext context) {
    var assetUrl = 'assets/img/t_avatar_1.png';
    var assetUrl2 = 'assets/img/t_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return TAvatar(
      size: TAvatarSize.medium,
      type: TAvatarType.display,
      displayText: '+5',
      avatarDisplayListAsset: avatarList,
    );
  }

  /// 带操作的头像组
  @Demo(group: 'avatar')
  Widget _buildOperationAvatar(BuildContext context) {
    var assetUrl = 'assets/img/t_avatar_1.png';
    var assetUrl2 = 'assets/img/t_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return TAvatar(
      size: TAvatarSize.medium,
      type: TAvatarType.operation,
      avatarDisplayListAsset: avatarList,
      onTap: () {
        TToast.showText('点击了操作', context: context);
      },
    );
  }

  /// 组件尺寸 大尺寸
  @Demo(group: 'avatar')
  Widget _buildLargeAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TAvatar(
          size: TAvatarSize.large,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.large,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 32),
        TAvatar(
          size: TAvatarSize.large,
          type: TAvatarType.icon,
        ),
      ],
    );
  }

  /// 组件尺寸 中尺寸
  @Demo(group: 'avatar')
  Widget _buildMediumAvatar(BuildContext context) {
    return const Row(
      // spacing: 48,
      children: [
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 48),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 48),
        TAvatar(
          size: TAvatarSize.medium,
          type: TAvatarType.icon,
        ),
      ],
    );
  }

  /// 组件尺寸 小尺寸
  @Demo(group: 'avatar')
  Widget _buildSmallAvatar(BuildContext context) {
    return const Row(
      // spacing: 56,
      children: [
        TAvatar(
          size: TAvatarSize.small,
          type: TAvatarType.normal,
          defaultUrl: 'assets/img/t_avatar_1.png',
        ),
        SizedBox(width: 56),
        TAvatar(
          size: TAvatarSize.small,
          type: TAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 56),
        TAvatar(
          size: TAvatarSize.small,
          type: TAvatarType.icon,
        ),
      ],
    );
  }
}
