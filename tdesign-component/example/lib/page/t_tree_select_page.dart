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
        TTreeSelectOption(label: '橙子', value: 'orange'),
        TTreeSelectOption(label: '草莓', value: 'strawberry'),
        TTreeSelectOption(label: '芒果', value: 'mango'),
        TTreeSelectOption(
          label: '榴莲（暂不可选）',
          value: 'durian',
          disabled: true,
        ),
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
            TTreeSelectOption(
              label: '珠海（暂不可选）',
              value: 'zhuhai',
              disabled: true,
            ),
            TTreeSelectOption(label: '东莞', value: 'dongguan'),
          ],
        ),
        TTreeSelectOption(
          label: '浙江',
          value: 'zhejiang',
          children: [
            TTreeSelectOption(label: '杭州', value: 'hangzhou'),
            TTreeSelectOption(label: '宁波', value: 'ningbo'),
            TTreeSelectOption(label: '温州', value: 'wenzhou'),
          ],
        ),
      ],
    ),
    TTreeSelectOption(
      label: '动物',
      value: 'animal',
      children: [
        TTreeSelectOption(label: '猫', value: 'cat'),
        TTreeSelectOption(label: '狗', value: 'dog'),
        TTreeSelectOption(label: '兔子', value: 'rabbit'),
        TTreeSelectOption(label: '鹦鹉', value: 'parrot'),
      ],
    ),
    TTreeSelectOption(
      label: '数码',
      value: 'digital',
      children: [
        TTreeSelectOption(label: '手机', value: 'phone'),
        TTreeSelectOption(label: '电脑', value: 'computer'),
        TTreeSelectOption(label: '平板', value: 'tablet'),
        TTreeSelectOption(label: '相机', value: 'camera'),
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
          ExampleItem(desc: '单选（包含局部禁用项）', builder: _buildSingle),
          ExampleItem(desc: '多选', builder: _buildMultiple),
          ExampleItem(desc: '整体禁用', builder: _buildDisabled),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'tree-select')
  Widget _buildSingle(BuildContext context) {
    return TTreeSelect(
      key: const Key('tree-select-single'),
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
            height: MediaQuery.sizeOf(context).height * 0.6,
            titleWidget: const TText('选择分类'),
            child: StatefulBuilder(
              builder: (context, setPopupState) => TTreeSelect(
                key: const Key('tree-select-popup'),
                options: _options,
                value: draft,
                multiple: true,
                onChanged: (value) {
                  setPopupState(() => draft = value);
                },
              ),
            ),
            onVisibleChange: (visible, trigger) {
              if (!visible && trigger == TPopupTrigger.confirm && mounted) {
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
