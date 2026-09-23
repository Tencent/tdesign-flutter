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
    'sidebar_example_scaffold.dart',
  ],
)
class StyleSideBarExample extends StatelessWidget {
  const StyleSideBarExample({super.key});

  Widget _buildStyleSideBar(BuildContext context) {
    return Column(
      children: [
        Builder(
          builder: (_) => getCustomButton(context, '非通栏选项样式', 'SideBarAnchor'),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (_) => getCustomButton(context, '自定义样式', 'SideBarCustom'),
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
    switch (routeName) {
      case 'SideBarAnchor':
        page = const TSideBarAnchorPage();
        break;
      case 'SideBarPagination':
        page = const TSideBarPaginationPage();
        break;
      case 'SideBarIcon':
        page = const TSideBarIconPage();
        break;
      case 'SideBarCustom':
        page = const TSideBarCustomPage();
        break;
    }
    if (page == null) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page!));
  }

  @override
  Widget build(BuildContext context) {
    return _buildStyleSideBar(context);
  }
}
