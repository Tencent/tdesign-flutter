import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TTreeSelectPage extends StatefulWidget {
  const TTreeSelectPage({super.key});

  @override
  State<TTreeSelectPage> createState() => _TTreeSelectPageState();
}

class _TTreeSelectPageState extends State<TTreeSelectPage> {
  static const _basicOptions = [
    TTreeSelectOption(
      label: '广东',
      value: 'guangdong',
      children: [
        TTreeSelectOption(label: '深圳', value: 'shenzhen'),
        TTreeSelectOption(label: '广州', value: 'guangzhou'),
        TTreeSelectOption(label: '珠海', value: 'zhuhai'),
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
  ];

  static const _threeColumnOptions = [
    TTreeSelectOption(
      label: '广东',
      value: 'guangdong',
      children: [
        TTreeSelectOption(
          label: '深圳',
          value: 'shenzhen',
          children: [
            TTreeSelectOption(label: '南山区', value: 'nanshan'),
            TTreeSelectOption(label: '福田区', value: 'futian'),
          ],
        ),
        TTreeSelectOption(
          label: '广州',
          value: 'guangzhou',
          children: [
            TTreeSelectOption(label: '天河区', value: 'tianhe'),
            TTreeSelectOption(label: '越秀区', value: 'yuexiu'),
          ],
        ),
      ],
    ),
    TTreeSelectOption(
      label: '浙江',
      value: 'zhejiang',
      children: [
        TTreeSelectOption(
          label: '杭州',
          value: 'hangzhou',
          children: [TTreeSelectOption(label: '西湖区', value: 'xihu')],
        ),
      ],
    ),
  ];

  List<List<Object?>> _single = const [
    ['guangdong', 'shenzhen'],
  ];
  List<List<Object?>> _multiple = const [
    ['guangdong', 'shenzhen'],
    ['guangdong', 'guangzhou'],
  ];
  List<List<Object?>> _threeColumn = const [
    ['guangdong', 'shenzhen', 'nanshan'],
  ];

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(),
    desc: '用于多层级数据的逐级选择。',
    exampleCodeGroup: 'tree-select',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(desc: '基础树形选择器', builder: _buildSingle),
          ExampleItem(desc: '多选树形选择器', builder: _buildMultiple),
        ],
      ),
      ExampleModule(
        title: '组件状态',
        children: [ExampleItem(desc: '树形选择器-三列', builder: _buildThreeColumns)],
      ),
    ],
  );

  @ExampleCode(group: 'tree-select')
  Widget _buildSingle(BuildContext context) => TTreeSelect(
    key: const ValueKey('tree-select-single'),
    options: _basicOptions,
    value: _single,
    onChanged: (value) => setState(() => _single = value),
  );

  @ExampleCode(group: 'tree-select')
  Widget _buildMultiple(BuildContext context) => TTreeSelect(
    key: const ValueKey('tree-select-multiple'),
    options: _basicOptions,
    value: _multiple,
    multiple: true,
    onChanged: (value) => setState(() => _multiple = value),
  );

  @ExampleCode(group: 'tree-select')
  Widget _buildThreeColumns(BuildContext context) => TTreeSelect(
    key: const ValueKey('tree-select-three-columns'),
    options: _threeColumnOptions,
    value: _threeColumn,
    onChanged: (value) => setState(() => _threeColumn = value),
  );
}
