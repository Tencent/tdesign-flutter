import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'base_h5_navbar_example.dart';
import 'logo_navbar_example.dart';
import 'navbar_left_multi_action_example.dart';
import 'navbar_right_multi_action_example.dart';
import 'search_navbar_example.dart';
import 'set_bg_color_navbar_example.dart';
import 'title_below_navbar_example.dart';
import 'title_center_navbar_example.dart';
import 'title_left_navbar_example.dart';
import 'title_normal_navbar_example.dart';

@ExampleCodeManifest()
class TNavBarPage extends StatelessWidget {
  const TNavBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'navbar',
      desc: '用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础H5导航栏',
              key: const Key('navbar-demo-scene-base'),
              methodName: 'BaseH5NavbarExample',
              builder: (_) => const BaseH5NavbarExample(),
            ),
            ExampleItem(
              desc: '',
              key: const Key('navbar-demo-scene-left-multi'),
              methodName: 'NavbarLeftMultiActionExample',
              builder: (_) => const NavbarLeftMultiActionExample(),
            ),
            ExampleItem(
              desc: '',
              key: const Key('navbar-demo-scene-right-multi'),
              methodName: 'NavbarRightMultiActionExample',
              builder: (_) => const NavbarRightMultiActionExample(),
            ),
            ExampleItem(
              desc: '带搜索导航栏',
              key: const Key('navbar-demo-scene-search'),
              methodName: 'SearchNavbarExample',
              builder: (_) => const SearchNavbarExample(),
            ),
            ExampleItem(
              desc: '带图片导航栏',
              key: const Key('navbar-demo-scene-image'),
              methodName: 'LogoNavbarExample',
              builder: (_) => const LogoNavbarExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '标题对齐',
              key: const Key('navbar-demo-scene-title-center'),
              methodName: 'TitleCenterNavbarExample',
              builder: (_) => const TitleCenterNavbarExample(),
            ),
            ExampleItem(
              desc: '',
              key: const Key('navbar-demo-scene-title-left'),
              methodName: 'TitleLeftNavbarExample',
              builder: (_) => const TitleLeftNavbarExample(),
            ),
            ExampleItem(
              desc: '标题尺寸',
              key: const Key('navbar-demo-scene-title-normal'),
              methodName: 'TitleNormalNavbarExample',
              builder: (_) => const TitleNormalNavbarExample(),
            ),
            ExampleItem(
              desc: '',
              key: const Key('navbar-demo-scene-title-below'),
              methodName: 'TitleBelowNavbarExample',
              builder: (_) => const TitleBelowNavbarExample(),
            ),
            ExampleItem(
              desc: '自定义颜色',
              key: const Key('navbar-demo-scene-custom-color'),
              methodName: 'SetBgColorNavbarExample',
              builder: (_) => const SetBgColorNavbarExample(),
            ),
          ],
        ),
      ],
    );
  }
}
