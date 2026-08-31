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
    TDropdownMenuOption(value: 'phone', label: '手机', group: '数码'),
    TDropdownMenuOption(value: 'computer', label: '电脑', group: '数码'),
    TDropdownMenuOption(value: 'audio', label: '影音', group: '数码'),
    TDropdownMenuOption(value: 'clothes', label: '服饰', group: '生活'),
    TDropdownMenuOption(value: 'food', label: '食品', group: '生活'),
    TDropdownMenuOption(
      value: 'limited',
      label: '限量',
      group: '生活',
      disabled: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于商品列表等页面的排序和多维筛选；表单选择请使用 Picker。',
      exampleCodeGroup: 'dropdown_menu',
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
    var singleColumn = <String>{'phone'};
    var doubleColumn = <String>{'phone'};
    var tripleColumn = <String>{'phone'};
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
                  maxHeight: 280,
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
