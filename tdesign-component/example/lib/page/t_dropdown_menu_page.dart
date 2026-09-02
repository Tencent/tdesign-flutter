import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TDropdownMenuPage extends StatelessWidget {
  const TDropdownMenuPage({super.key});

  static const productOptions = <TDropdownMenuOption<String>>[
    TDropdownMenuOption(value: 'all', label: '全部产品'),
    TDropdownMenuOption(value: 'new', label: '最新产品'),
    TDropdownMenuOption(value: 'hot', label: '最火产品'),
    TDropdownMenuOption(value: 'disabled', label: '禁用选项', disabled: true),
  ];

  static const categoryOptions = <TDropdownMenuOption<String>>[
    TDropdownMenuOption(value: 'option-1', label: '选项名称'),
    TDropdownMenuOption(value: 'option-2', label: '选项名称'),
    TDropdownMenuOption(value: 'option-3', label: '选项名称'),
    TDropdownMenuOption(value: 'option-4', label: '选项名称'),
    TDropdownMenuOption(value: 'option-5', label: '选项名称'),
    TDropdownMenuOption(value: 'option-6', label: '选项名称'),
    TDropdownMenuOption(value: 'option-7', label: '选项名称'),
    TDropdownMenuOption(value: 'option-8', label: '选项名称'),
    TDropdownMenuOption(value: 'option-9', label: '选项名称'),
    TDropdownMenuOption(value: 'option-10', label: '选项名称'),
    TDropdownMenuOption(value: 'option-11', label: '选项名称'),
    TDropdownMenuOption(value: 'option-12', label: '选项名称'),
    TDropdownMenuOption(value: 'option-13', label: '禁用选项', disabled: true),
    TDropdownMenuOption(value: 'option-14', label: '禁用选项', disabled: true),
    TDropdownMenuOption(value: 'option-15', label: '禁用选项', disabled: true),
  ];

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
            ExampleItem(desc: '单选下拉菜单', builder: _sorting),
            ExampleItem(desc: '分栏下拉菜单', builder: _multiple),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(desc: '禁用状态', builder: _disabled)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _sorting(BuildContext context) {
    var product = 'all';
    var sorter = 'default';
    return StatefulBuilder(
      builder: (context, setState) {
        return TDropdownMenu(
          items: [
            TDropdownMenuItem(
              label: switch (product) {
                'new' => '最新产品',
                'hot' => '最火产品',
                _ => '全部产品',
              },
              panelBuilder: (context, controller) =>
                  TDropdownSingleSelectPanel<String>(
                    controller: controller,
                    value: product,
                    options: productOptions,
                    onChanged: (value) => setState(() => product = value),
                  ),
            ),
            TDropdownMenuItem(
              label: sorter == 'default' ? '默认排序' : '价格从高到低',
              panelBuilder: (context, controller) =>
                  TDropdownSingleSelectPanel<String>(
                    controller: controller,
                    value: sorter,
                    options: const [
                      TDropdownMenuOption(value: 'default', label: '默认排序'),
                      TDropdownMenuOption(value: 'price', label: '价格从高到低'),
                    ],
                    onChanged: (value) => setState(() => sorter = value),
                  ),
            ),
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _multiple(BuildContext context) {
    var singleColumn = <String>{'option-1'};
    var doubleColumn = <String>{'option-1'};
    var tripleColumn = <String>{'option-1'};
    return StatefulBuilder(
      builder: (context, setState) {
        TDropdownMenuItem menuItem(
          String label,
          int columns,
          Set<String> selected,
          ValueChanged<Set<String>> onConfirm,
        ) {
          return TDropdownMenuItem(
            label: label,
            panelBuilder: (context, controller) =>
                TDropdownMultiSelectPanel<String>(
                  controller: controller,
                  options: categoryOptions,
                  values: selected,
                  columns: columns,
                  onConfirm: onConfirm,
                ),
          );
        }

        return TDropdownMenu(
          items: [
            menuItem('单列多选', 1, singleColumn, (values) {
              setState(() => singleColumn = values);
            }),
            menuItem('双列多选', 2, doubleColumn, (values) {
              setState(() => doubleColumn = values);
            }),
            menuItem('三列多选', 3, tripleColumn, (values) {
              setState(() => tripleColumn = values);
            }),
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _disabled(BuildContext context) {
    return TDropdownMenu(
      items: [
        TDropdownMenuItem(
          label: '禁用菜单',
          enabled: false,
          panelBuilder: (context, controller) => const SizedBox.shrink(),
        ),
        TDropdownMenuItem(
          label: '禁用菜单',
          enabled: false,
          panelBuilder: (context, controller) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
