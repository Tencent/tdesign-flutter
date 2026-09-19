import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_base.dart';
import '../../base/example_widget.dart';

import 'sidebar_anchor_example.dart';
import 'sidebar_custom_example.dart';
import 'sidebar_icon_example.dart';
import 'sidebar_pagination_example.dart';

part 'sidebar_type.dart';
part 'sidebar_style.dart';

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
      compactDemo: true,
      showTestModule: false,
      children: [_sidebarTypeModule, _sidebarStyleModule],
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
          builder: (_) => getCustomButton(context, '非通栏选项样式', 'SideBarAnchor'),
          methodName: '_buildAnchorSideBar',
        ),
        const SizedBox(height: 16),
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
