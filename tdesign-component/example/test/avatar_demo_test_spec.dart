import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:tdesign_flutter_example/page/t_avatar_page.dart';

import 'demo_page_test_utils.dart';

const avatarDemoPageTestSpec = DemoPageTestSpec(
  name: 'avatar',
  title: 'Avatar 头像',
  page: TAvatarPage(),
  expectedTexts: [
    '01 组件类型',
    '图片头像',
    '字符头像',
    '图标头像',
    '带徽标头像',
    '02 特殊类型',
    '纯展示的头像组',
    '带操作的头像组',
    '03 组件尺寸',
    '+2',
  ],
  componentType: TAvatar,
  expectedComponentCount: 30,
  supplementalCjkFontFamily: 'Avatar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/AvatarGoldenCJK-Regular.otf',
  precacheAssetImages: [
    'assets/img/t_avatar_1.png',
    'assets/img/t_avatar_2.png',
    'assets/img/t_avatar_3.png',
    'assets/img/t_avatar_4.png',
    'assets/img/t_avatar_5.png',
  ],
);
