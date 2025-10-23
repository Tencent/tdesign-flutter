import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDAvatarPage extends StatefulWidget {
  const TDAvatarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDAvatarPageState();
}

class _TDAvatarPageState extends State<TDAvatarPage> {
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
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.normal,
          defaultUrl: 'assets/img/td_avatar_1.png',
        ),
        SizedBox(width: 32),
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.normal,
          shape: TDAvatarShape.square,
          defaultUrl: 'assets/img/td_avatar_1.png',
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
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 32),
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.customText,
          shape: TDAvatarShape.square,
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
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.icon,
        ),
        SizedBox(width: 32),
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.icon,
          shape: TDAvatarShape.square,
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
              TDAvatar(
                size: TDAvatarSize.medium,
                type: TDAvatarType.normal,
                defaultUrl: 'assets/img/td_avatar_1.png',
              ),
              Positioned(child: TDBadge(TDBadgeType.redPoint), right: 0, top: 0)
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
              TDAvatar(
                size: TDAvatarSize.medium,
                type: TDAvatarType.customText,
                text: 'A',
              ),
              Positioned(
                child: TDBadge(TDBadgeType.message, count: '8'),
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
              TDAvatar(size: TDAvatarSize.medium, type: TDAvatarType.icon),
              Positioned(
                child: TDBadge(TDBadgeType.message, count: '12'),
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
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return TDAvatar(
      size: TDAvatarSize.medium,
      type: TDAvatarType.display,
      displayText: '+5',
      avatarDisplayListAsset: avatarList,
    );
  }

  /// 带操作的头像组
  @Demo(group: 'avatar')
  Widget _buildOperationAvatar(BuildContext context) {
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';
    var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
    return TDAvatar(
      size: TDAvatarSize.medium,
      type: TDAvatarType.operation,
      avatarDisplayListAsset: avatarList,
      onTap: () {
        TDToast.showText('点击了操作', context: context);
      },
    );
  }

  /// 组件尺寸 大尺寸
  @Demo(group: 'avatar')
  Widget _buildLargeAvatar(BuildContext context) {
    return const Row(
      // spacing: 32,
      children: [
        TDAvatar(
          size: TDAvatarSize.large,
          type: TDAvatarType.normal,
          defaultUrl: 'assets/img/td_avatar_1.png',
        ),
        SizedBox(width: 32),
        TDAvatar(
          size: TDAvatarSize.large,
          type: TDAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 32),
        TDAvatar(
          size: TDAvatarSize.large,
          type: TDAvatarType.icon,
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
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.normal,
          defaultUrl: 'assets/img/td_avatar_1.png',
        ),
        SizedBox(width: 48),
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 48),
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.icon,
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
        TDAvatar(
          size: TDAvatarSize.small,
          type: TDAvatarType.normal,
          defaultUrl: 'assets/img/td_avatar_1.png',
        ),
        SizedBox(width: 56),
        TDAvatar(
          size: TDAvatarSize.small,
          type: TDAvatarType.customText,
          text: 'A',
        ),
        SizedBox(width: 56),
        TDAvatar(
          size: TDAvatarSize.small,
          type: TDAvatarType.icon,
        ),
      ],
    );
  }
}
