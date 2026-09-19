import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'navbar_style.dart';
part 'navbar_type.dart';

class TNavBarPage extends StatelessWidget {
  const TNavBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'navbar',
      desc: '用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。',
      children: [_navbarTypeModule, _navbarStyleModule],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _baseH5Navbar(BuildContext context) {
    return const TNavBar(
      key: Key('navbar-demo-base'),
      title: Text('标题文字'),
      useDefaultBack: true,
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _leftMultiAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TNavBar(
        key: const Key('navbar-demo-left-multi-action'),
        title: const Text('标题文字'),
        useDefaultBack: true,
        leading: [
          TNavBarItem(
            icon: TIcons.close,
            iconSize: 24,
            onTap: () => TToast.showText('点击了关闭', context: context),
          ),
        ],
        actions: [
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => TToast.showText('点击了更多', context: context),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _rightMultiAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TNavBar(
        key: const Key('navbar-demo-right-multi-action'),
        title: const Text('标题文字'),
        useDefaultBack: true,
        actions: [
          TNavBarItem(
            icon: TIcons.home,
            iconSize: 24,
            onTap: () => TToast.showText('点击了首页', context: context),
          ),
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => TToast.showText('点击了更多', context: context),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _searchNavbar(BuildContext context) {
    return TNavBar(
      key: const Key('navbar-demo-search'),
      centerTitle: false,
      titleMargin: 0,
      title: Theme(
        data: Theme.of(context).mergeExtension(
          const TSearchBarThemeData(variant: TSearchBarVariant.round),
        ),
        child: TSearchBar(
          hintText: '搜索预设文案',
          onChanged: (String text) {
            print('input：$text');
          },
        ),
      ),
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _logoNavbar(BuildContext context) {
    return TNavBar(
      key: const Key('navbar-demo-image'),
      centerTitle: false,
      titleMargin: 0,
      title: const TImage(
        src: 'assets/img/t_brand.png',
        width: 87,
        height: 24,
        fit: BoxFit.contain,
      ),
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _titleCenterNavbar(BuildContext context) {
    return TNavBar(
      title: const Text('标题文字'),
      useDefaultBack: true,
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _titleLeftNavbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TNavBar(
        title: const Text('标题文字'),
        centerTitle: false,
        titleMargin: 0,
        useDefaultBack: true,
        actions: [
          TNavBarItem(
            icon: TIcons.home,
            iconSize: 24,
            onTap: () => TToast.showText('点击了首页', context: context),
          ),
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => TToast.showText('点击了更多', context: context),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _titleNormalNavbar(BuildContext context) {
    return TNavBar(
      title: const Text('标题文字'),
      useDefaultBack: true,
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _titleBelowNavbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TNavBar(
        key: const Key('navbar-demo-custom-height'),
        height: 80,
        title: TText('返回', font: context.tTheme.fontBodyLarge),
        belowTitleWidget: SizedBox(
          height: 36,
          child: TText(
            '标题文字',
            font: Font(size: 28, lineHeight: 36),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        titleMargin: 8,
        useDefaultBack: false,
        leading: [
          TNavBarItem(
            icon: TIcons.chevron_left,
            iconSize: 24,
            onTap: () => TToast.showText('点击了返回', context: context),
          ),
        ],
        actions: [
          TNavBarItem(
            icon: TIcons.home,
            iconSize: 24,
            onTap: () => TToast.showText('点击了首页', context: context),
          ),
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => TToast.showText('点击了更多', context: context),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _setBgColorNavbar(BuildContext context) {
    return TNavBar(
      title: const Text('标题文字', style: TextStyle(fontWeight: FontWeight.w600)),
      titleColor: Colors.white,
      backgroundColor: context.tTheme.brandNormalColor,
      useDefaultBack: false,
      leading: [
        TNavBarItem(
          icon: TIcons.chevron_left,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => TToast.showText('点击了返回', context: context),
        ),
      ],
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }
}
