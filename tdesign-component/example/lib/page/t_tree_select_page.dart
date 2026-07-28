import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TTreeSelect 演示。
class TTreeSelectPage extends StatefulWidget {
  const TTreeSelectPage({super.key});

  @override
  State<TTreeSelectPage> createState() => _TTreeSelectPageState();
}

class _TTreeSelectPageState extends State<TTreeSelectPage> {
  static const _options = [
    TTreeSelectOption(
      label: '水果',
      value: 'fruit',
      children: [
        TTreeSelectOption(label: '苹果', value: 'apple'),
        TTreeSelectOption(label: '香蕉', value: 'banana'),
      ],
    ),
    TTreeSelectOption(
      label: '城市',
      value: 'city',
      children: [
        TTreeSelectOption(
          label: '广东',
          value: 'guangdong',
          children: [
            TTreeSelectOption(label: '深圳', value: 'shenzhen'),
            TTreeSelectOption(label: '广州', value: 'guangzhou'),
          ],
        ),
      ],
    ),
  ];

  List<List<Object?>> _singleValue = [
    ['fruit', 'apple'],
  ];
  List<List<Object?>> _multipleValue = [];
  List<List<Object?>> _popupValue = [
    ['fruit', 'banana'],
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于从层级数据中选择一个或多个叶子节点。',
      exampleCodeGroup: 'tree-select',
      children: [
        ExampleModule(title: '弹出层用法', children: [
          ExampleItem(desc: '底部弹出多选', builder: _buildPopup),
        ]),
        ExampleModule(title: '基础能力', children: [
          ExampleItem(desc: '单选', builder: _buildSingle),
          ExampleItem(desc: '多选', builder: _buildMultiple),
          ExampleItem(desc: '禁用', builder: _buildDisabled),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'tree-select')
  Widget _buildSingle(BuildContext context) {
    return TTreeSelect(
      options: _options,
      value: _singleValue,
      onChanged: (value) => setState(() => _singleValue = value),
    );
  }

  @ExampleCode(group: 'tree-select')
  Widget _buildMultiple(BuildContext context) {
    return TTreeSelect(
      options: _options,
      value: _multipleValue,
      multiple: true,
      onChanged: (value) => setState(() => _multipleValue = value),
    );
  }

  @ExampleCode(group: 'tree-select')
  Widget _buildDisabled(BuildContext context) {
    return TTreeSelect(options: _options, value: _singleValue);
  }

  @ExampleCode(group: 'tree-select')
  Widget _buildPopup(BuildContext context) {
    return TCell(
      title: const TText('选择分类'),
      trailing: TText(
        '已选择 ${_popupValue.length} 项',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      arrow: true,
      onTap: () {
        var draft = [
          for (final path in _popupValue) List<Object?>.of(path),
        ];
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
            titleWidget: const TText('选择分类'),
            child: StatefulBuilder(
              builder: (context, setPopupState) => TTreeSelect(
                options: _options,
                value: draft,
                multiple: true,
                onChanged: (value) {
                  setPopupState(() => draft = value);
                },
              ),
            ),
            onVisibleChange: (visible, trigger) {
              if (!visible && trigger == TPopupTrigger.confirm) {
                setState(() {
                  _popupValue = [
                    for (final path in draft) List<Object?>.of(path),
                  ];
                });
              }
            },
          ),
        );
      },
    );
  }
}
