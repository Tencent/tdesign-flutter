import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

const titleText = '标题文字';

class TNavBarPage extends StatelessWidget {
  const TNavBarPage({Key? key}) : super(key: key);

  void _showAction(BuildContext context, String label) {
    TToast.showText('点击了$label', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'navbar',
      desc: '用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础H5导航栏', builder: _baseH5Navbar),
            ExampleItem(builder: _leftMultiAction),
            ExampleItem(builder: _rightMultiAction),
            ExampleItem(desc: '带搜索导航栏', builder: _searchNavbar),
            ExampleItem(desc: '带图片导航栏', builder: _logoNavbar),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '标题对齐', builder: _titleCenterNavbar),
            ExampleItem(builder: _titleLeftNavbar),
            ExampleItem(desc: '标题尺寸', builder: _titleNormalNavbar),
            ExampleItem(builder: _titleBelowNavbar),
            ExampleItem(desc: '自定义颜色', builder: _setBgColorNavbar),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _baseH5Navbar(BuildContext context) {
    return const TNavBar(
      key: Key('navbar-demo-base'),
      title: titleText,
      useDefaultBack: true,
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _leftMultiAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TNavBar(
        key: const Key('navbar-demo-left-multi-action'),
        title: titleText,
        useDefaultBack: true,
        leading: [
          TNavBarItem(
            icon: TIcons.close,
            iconSize: 24,
            onTap: () => _showAction(context, '关闭'),
          ),
        ],
        actions: [
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => _showAction(context, '更多'),
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
        title: titleText,
        useDefaultBack: true,
        actions: [
          TNavBarItem(
            icon: TIcons.home,
            iconSize: 24,
            onTap: () => _showAction(context, '首页'),
          ),
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => _showAction(context, '更多'),
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
      titleWidget: Theme(
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
          onTap: () => _showAction(context, '首页'),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => _showAction(context, '更多'),
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
      titleWidget: const TImage(
        src: 'assets/img/t_brand.png',
        width: 87,
        height: 24,
        variant: TImageVariant.fitWidth,
        fit: BoxFit.contain,
      ),
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => _showAction(context, '首页'),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => _showAction(context, '更多'),
        ),
      ],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _titleCenterNavbar(BuildContext context) {
    return TNavBar(
      title: titleText,
      useDefaultBack: true,
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => _showAction(context, '首页'),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => _showAction(context, '更多'),
        ),
      ],
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _titleLeftNavbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TNavBar(
        title: titleText,
        centerTitle: false,
        titleMargin: 0,
        useDefaultBack: true,
        actions: [
          TNavBarItem(
            icon: TIcons.home,
            iconSize: 24,
            onTap: () => _showAction(context, '首页'),
          ),
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => _showAction(context, '更多'),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _titleNormalNavbar(BuildContext context) {
    return TNavBar(
      title: titleText,
      useDefaultBack: true,
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => _showAction(context, '首页'),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => _showAction(context, '更多'),
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
        title: '返回',
        titleColor: context.tTheme.textColorPrimary,
        belowTitleWidget: SizedBox(
          height: 36,
          child: TText(
            titleText,
            font: Font(size: 28, lineHeight: 36),
            fontWeight: FontWeight.w600,
          ),
        ),
        titleFont: Font(size: 16, lineHeight: 24),
        centerTitle: false,
        titleMargin: 8,
        useDefaultBack: false,
        leading: [
          TNavBarItem(
            icon: TIcons.chevron_left,
            iconSize: 24,
            onTap: () => _showAction(context, '返回'),
          ),
        ],
        actions: [
          TNavBarItem(
            icon: TIcons.home,
            iconSize: 24,
            onTap: () => _showAction(context, '首页'),
          ),
          TNavBarItem(
            icon: TIcons.ellipsis,
            iconSize: 24,
            onTap: () => _showAction(context, '更多'),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'navbar')
  Widget _setBgColorNavbar(BuildContext context) {
    return TNavBar(
      title: titleText,
      titleColor: Colors.white,
      backgroundColor: context.tTheme.brandNormalColor,
      titleFontWeight: FontWeight.w600,
      useDefaultBack: false,
      leading: [
        TNavBarItem(
          icon: TIcons.chevron_left,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => _showAction(context, '返回'),
        ),
      ],
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => _showAction(context, '首页'),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          iconColor: Colors.white,
          onTap: () => _showAction(context, '更多'),
        ),
      ],
    );
  }
}
