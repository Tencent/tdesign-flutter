import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_base.dart';
import '../../base/example_widget.dart';

import 't_sidebar_page_anchor.dart';
import 't_sidebar_page_custom.dart';
import 't_sidebar_page_icon.dart';
import 't_sidebar_page_loading.dart';
import 't_sidebar_page_outline.dart';
import 't_sidebar_page_pagination.dart';
import 't_sidebar_page_unselected_color.dart';

///
/// TSideBarPage演示
///
class TSideBarPage extends StatefulWidget {
  const TSideBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarPageState();
  }
}

class TSideBarPageState extends State<TSideBarPage> {
  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'sideBar',
      desc: '用于内容分类后的展示切换。',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
              desc: '侧边导航用法',
              ignoreCode: true,
              builder: _buildNavigatorSideBar),
          ExampleItem(
              desc: '图标侧边导航',
              builder: _buildIconSideBar,
              methodName: '_buildIconSideBar')
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(
              desc: '侧边导航样式', ignoreCode: true, builder: _buildStyleSideBar),
        ])
      ],
      test: [
        ExampleItem(desc: '延迟加载', ignoreCode: true, builder: _loadingSideBar),
        ExampleItem(
            desc: '自定义未选中颜色',
            ignoreCode: true,
            builder: _unSelectedColorSideBar),
      ],
    );
  }

  Widget _buildNavigatorSideBar(BuildContext context) {
    return Column(
      // spacing: 16,
      children: [
        CodeWrapper(
          builder: (_) => getCustomButton(context, '锚点用法', 'SideBarAnchor'),
          methodName: '_buildAnchorSideBar',
        ),
        const SizedBox(height: 16),
        CodeWrapper(
          builder: (_) => getCustomButton(context, '切页用法', 'SideBarPagination'),
          methodName: '_buildPaginationSideBar',
        ),
      ],
    );
  }

  Widget _buildIconSideBar(BuildContext context) {
    return getCustomButton(context, '带图标侧边导航', 'SideBarIcon');
  }

  Widget _buildStyleSideBar(BuildContext context) {
    return Column(
      children: [
        CodeWrapper(
          builder: (_) => getCustomButton(context, '非通栏选项样式', 'SideBarOutline'),
          methodName: '_buildOutlineSideBar',
        ),
        const SizedBox(height: 16),
        CodeWrapper(
          builder: (_) => getCustomButton(context, '自定义样式', 'SideBarCustom'),
          methodName: '_buildCustomSideBar',
        ),
      ],
    );
  }

  Widget _loadingSideBar(BuildContext context) {
    return CodeWrapper(
      builder: (_) => getCustomButton(context, '延迟加载', 'SideBarLoading'),
      methodName: '_buildLoadingSideBar',
    );
  }

  Widget _unSelectedColorSideBar(BuildContext context) {
    return CodeWrapper(
      builder: (_) =>
          getCustomButton(context, '未选中颜色自定义', 'SideBarUnselectedColor'),
      methodName: '_buildUnselectedColorSideBar',
    );
  }

  Widget getCustomButton(BuildContext context, String text, String routeName) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: Text(text),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () => _openSideBarDemo(context, routeName),
      ),
    );
  }

  void _openSideBarDemo(BuildContext context, String routeName) {
    Widget? page;
    var title = '';

    switch (routeName) {
      case 'SideBarAnchor':
        title = 'SideBar 锚点';
        page = const TSideBarAnchorPage();
        break;
      case 'SideBarPagination':
        title = 'SideBar 切页';
        page = const TSideBarPaginationPage();
        break;
      case 'SideBarIcon':
        title = 'SideBar 带图标';
        page = const TSideBarIconPage();
        break;
      case 'SideBarOutline':
        title = 'SideBar 非通栏选项样式';
        page = const TSideBarOutlinePage();
        break;
      case 'SideBarCustom':
        title = 'SideBar 自定义样式';
        page = const TSideBarCustomPage();
        break;
      case 'SideBarLoading':
        title = 'SideBar 延迟加载';
        page = const TSideBarLoadingPage();
        break;
      case 'SideBarUnselectedColor':
        title = 'SideBar 自定义未选中颜色';
        page = const TSideBarUnSelectedColorPage();
        break;
    }
    if (page == null) {
      return;
    }
    final model = ExamplePageModel(
      text: title,
      name: routeName,
      showAction: false,
      pageBuilder: (_, __) => page!,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExamplePageInheritedTheme(
          model: model,
          child: page!,
        ),
      ),
    );
  }
}
