import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'badge_avatar_example.dart';
import 'display_avatar_example.dart';
import 'icon_avatar_example.dart';
import 'image_avatar_example.dart';
import 'operation_avatar_example.dart';
import 'size_avatar_example.dart';
import 'text_avatar_example.dart';

const _avatarItemPadding = EdgeInsets.symmetric(horizontal: 16);

@ExampleCodeManifest()
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
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '图片头像',
              padding: _avatarItemPadding,
              methodName: 'ImageAvatarExample',
              builder: (_) => const ImageAvatarExample(),
            ),
            ExampleItem(
              desc: '字符头像',
              padding: _avatarItemPadding,
              methodName: 'TextAvatarExample',
              builder: (_) => const TextAvatarExample(),
            ),
            ExampleItem(
              desc: '图标头像',
              padding: _avatarItemPadding,
              methodName: 'IconAvatarExample',
              builder: (_) => const IconAvatarExample(),
            ),
            ExampleItem(
              desc: '带徽标头像',
              padding: _avatarItemPadding,
              methodName: 'BadgeAvatarExample',
              builder: (_) => const BadgeAvatarExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '特殊类型',
          children: [
            ExampleItem(
              desc: '纯展示的头像组',
              padding: _avatarItemPadding,
              center: false,
              methodName: 'DisplayAvatarExample',
              builder: (_) => const DisplayAvatarExample(),
            ),
            ExampleItem(
              desc: '带操作的头像组',
              padding: _avatarItemPadding,
              center: false,
              methodName: 'OperationAvatarExample',
              builder: (_) => const OperationAvatarExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(
              desc: '组件尺寸',
              padding: _avatarItemPadding,
              methodName: 'SizeAvatarExample',
              builder: (_) => const SizeAvatarExample(),
            ),
          ],
        ),
      ],
    );
  }

  /// 图片头像

  /// 字符头像

  /// 图标头像

  /// 带徽标头像

  /// 纯展示的头像组

  /// 带操作的头像组

  /// 组件尺寸
}
