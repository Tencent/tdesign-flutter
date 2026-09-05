import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_base.dart';
import '../../base/example_widget.dart';

import 't_sidebar_page_anchor.dart';
import 't_sidebar_page_custom.dart';
import 't_sidebar_page_icon.dart';
import 't_sidebar_page_pagination.dart';

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
      desc: '用于信息分类后的展示切换或锚点，位于页面左侧。',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '侧边导航用法',
              ignoreCode: true,
              builder: _buildNavigatorSideBar,
            ),
            ExampleItem(
              desc: '图标侧边导航',
              builder: _buildIconSideBar,
              methodName: '_buildIconSideBar',
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '侧边导航样式',
              ignoreCode: true,
              builder: _buildStyleSideBar,
            ),
          ],
        ),
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
          builder: (_) => getCustomButton(context, '自定义样式', 'SideBarCustom'),
          methodName: '_buildCustomSideBar',
        ),
      ],
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
      case 'SideBarCustom':
        title = 'SideBar 自定义样式';
        page = const TSideBarCustomPage();
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
        builder: (_) => ExamplePageInheritedTheme(model: model, child: page!),
      ),
    );
  }
}
