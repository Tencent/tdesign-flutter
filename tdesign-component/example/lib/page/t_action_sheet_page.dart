import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TActionSheetPage extends StatelessWidget {
  const TActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '命令式展示列表、宫格和分组动作面板。',
      exampleCodeGroup: 'action_sheet',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '列表动作面板', builder: _list),
          ExampleItem(desc: '宫格动作面板', builder: _grid),
          ExampleItem(desc: '分组动作面板', builder: _group),
        ]),
      ],
    );
  }

  static List<TActionSheetItem> get _items => [
        TActionSheetItem(label: '编辑', icon: const Icon(Icons.edit)),
        TActionSheetItem(label: '分享', icon: const Icon(Icons.share)),
        TActionSheetItem(label: '删除', icon: const Icon(Icons.delete)),
      ];

  @ExampleCode(group: 'action_sheet')
  Widget _list(BuildContext context) {
    return TButton(
      child: const Text('打开列表面板'),
      onPressed: () => TActionSheet.showList(
        context,
        items: _items,
        onChanged: (item, index) => debugPrint('$index: ${item.label}'),
      ),
    );
  }

  @ExampleCode(group: 'action_sheet')
  Widget _grid(BuildContext context) {
    return TButton(
      child: const Text('打开宫格面板'),
      onPressed: () => TActionSheet.showGrid(
        context,
        items: _items,
        showPagination: true,
      ),
    );
  }

  @ExampleCode(group: 'action_sheet')
  Widget _group(BuildContext context) {
    return TButton(
      child: const Text('打开分组面板'),
      onPressed: () => TActionSheet.showGroup(
        context,
        items: [
          TActionSheetItem(label: '微信', group: '分享'),
          TActionSheetItem(label: '朋友圈', group: '分享'),
          TActionSheetItem(label: '复制', group: '操作'),
        ],
      ),
    );
  }
}
