import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import 'sidebar_anchor_example.dart';
import 'sidebar_custom_example.dart';
import 'sidebar_icon_example.dart';
import 'sidebar_pagination_example.dart';

@ExampleCode(
  group: 'sideBar',
  includes: [
    'sidebar_anchor_example.dart',
    'sidebar_pagination_example.dart',
    'sidebar_icon_example.dart',
    'sidebar_custom_example.dart',
  ],
)
class NavigatorSideBarExample extends StatelessWidget {
  const NavigatorSideBarExample({super.key});

  Widget _buildNavigatorSideBar(BuildContext context) {
    return Column(
      // spacing: 16,
      children: [
        Builder(
          builder: (_) => getCustomButton(context, '锚点用法', 'SideBarAnchor'),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (_) => getCustomButton(context, '切页用法', 'SideBarPagination'),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: SafeArea(child: page!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildNavigatorSideBar(context);
  }
}
