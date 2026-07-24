import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

/// TPicker 演示。
class TPickerPage extends StatefulWidget {
  const TPickerPage({super.key});

  @override
  State<TPickerPage> createState() => _TPickerPageState();
}

class _TPickerPageState extends State<TPickerPage> {
  static const _columns = TPickerColumns([
    [
      TPickerOption(label: '广东', value: 'gd'),
      TPickerOption(label: '浙江', value: 'zj'),
    ],
    [
      TPickerOption(label: '第一项', value: 1),
      TPickerOption(label: '第二项', value: 2),
    ],
  ]);
  static const _linked = TPickerLinked([
    TPickerOption(
      label: '广东',
      value: '广东',
      children: [
        TPickerOption(
          label: '深圳',
          value: '深圳',
          children: [
            TPickerOption(label: '南山', value: '南山'),
            TPickerOption(label: '福田', value: '福田'),
          ],
        ),
        TPickerOption(
          label: '广州',
          value: '广州',
          children: [
            TPickerOption(label: '天河', value: '天河'),
            TPickerOption(label: '越秀', value: '越秀'),
          ],
        ),
      ],
    ),
    TPickerOption(
      label: '浙江',
      value: '浙江',
      children: [
        TPickerOption(
          label: '杭州',
          value: '杭州',
          children: [TPickerOption(label: '西湖', value: '西湖')],
        ),
      ],
    ),
  ]);

  List<dynamic> _columnValue = ['gd', 1];
  List<dynamic> _linkedValue = ['广东', '深圳', '南山'];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于从独立列或联动数据中选择值。',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(title: '基础能力', children: [
          ExampleItem(desc: '独立列', builder: _buildColumns),
          ExampleItem(desc: '联动列', builder: _buildLinked),
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
          ExampleItem(desc: '主题尺寸', builder: _buildThemed),
        ]),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget _buildColumns(BuildContext context) {
    return TPicker(
      items: _columns,
      value: _columnValue,
      onChanged: (value) => setState(() => _columnValue = value.values),
    );
  }

  @Demo(group: 'picker')
  Widget _buildLinked(BuildContext context) {
    return TPicker(
      items: _linked,
      value: _linkedValue,
      onChanged: (value) => setState(() => _linkedValue = value.values),
    );
  }

  @Demo(group: 'picker')
  Widget _buildDisabled(BuildContext context) {
    return TPicker(items: _columns, value: _columnValue);
  }

  @Demo(group: 'picker')
  Widget _buildThemed(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TPickerThemeData(height: 160, itemCount: 3),
      ),
      child: TPicker(
        items: _columns,
        value: _columnValue,
        onChanged: (value) => setState(() => _columnValue = value.values),
      ),
    );
  }
}
