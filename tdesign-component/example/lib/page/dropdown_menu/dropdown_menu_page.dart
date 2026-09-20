import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'dropdown_menu_disabled_example.dart';
import 'dropdown_menu_multiple_example.dart';
import 'dropdown_menu_sorting_example.dart';

@ExampleCodeManifest()
class TDropdownMenuPage extends StatelessWidget {
  const TDropdownMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '菜单呈现数个并列的选项栏目，用于整个页面的内容筛选，由菜单面板和菜单选项组成。',
      exampleCodeGroup: 'dropdown_menu',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '单选下拉菜单',
              methodName: 'DropdownMenuSortingExample',
              builder: (_) => const DropdownMenuSortingExample(),
            ),
            ExampleItem(
              desc: '分栏下拉菜单',
              methodName: 'DropdownMenuMultipleExample',
              builder: (_) => const DropdownMenuMultipleExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '禁用状态',
              methodName: 'DropdownMenuDisabledExample',
              builder: (_) => const DropdownMenuDisabledExample(),
            ),
          ],
        ),
      ],
    );
  }
}
