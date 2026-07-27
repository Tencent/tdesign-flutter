import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TDropdownMenuPage extends StatelessWidget {
  const TDropdownMenuPage({super.key});

  static const options = <TDropdownItemOption<String>>[
    TDropdownItemOption(value: 'all', label: '全部'),
    TDropdownItemOption(value: 'active', label: '进行中'),
    TDropdownItemOption(value: 'done', label: '已完成'),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '使用不可变选项和受控回调构建下拉菜单。',
      exampleCodeGroup: 'dropdown_menu',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '单选菜单', builder: _single),
          ExampleItem(desc: '多选菜单', builder: _multiple),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _single(BuildContext context) {
    return TDropdownMenu<String>(
      items: [
        TDropdownItem<String>(
          label: '状态',
          options: options,
          value: 'all',
          onChanged: (_) {},
        ),
      ],
    );
  }

  @ExampleCode(group: 'dropdown_menu')
  Widget _multiple(BuildContext context) {
    return TDropdownMenu<String>(
      items: [
        TDropdownItem<String>(
          label: '筛选',
          multiple: true,
          options: options,
          values: const {'all'},
          onValuesChanged: (_) {},
          onConfirm: (_) {},
        ),
      ],
    );
  }
}
