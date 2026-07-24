import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

/// TCascader 演示。
class TCascaderPage extends StatefulWidget {
  const TCascaderPage({super.key});

  @override
  State<TCascaderPage> createState() => _TCascaderPageState();
}

class _TCascaderPageState extends State<TCascaderPage> {
  static const _options = [
    TCascaderOption(
      label: '广东省',
      value: 'gd',
      children: [
        TCascaderOption(
          label: '深圳市',
          value: 'sz',
          children: [
            TCascaderOption(label: '南山区', value: 'ns'),
            TCascaderOption(label: '福田区', value: 'ft'),
          ],
        ),
        TCascaderOption(label: '广州市', value: 'gz'),
      ],
    ),
    TCascaderOption(
      label: '浙江省',
      value: 'zj',
      children: [
        TCascaderOption(label: '杭州市', value: 'hz'),
      ],
    ),
  ];

  List<Object?> _value = const [];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于从层级数据中选择一条路径。',
      exampleCodeGroup: 'cascader',
      children: [
        ExampleModule(title: '基础能力', children: [
          ExampleItem(desc: '标签导航', builder: _buildTab),
          ExampleItem(desc: '步骤导航', builder: _buildStep),
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
        ]),
      ],
    );
  }

  @Demo(group: 'cascader')
  Widget _buildTab(BuildContext context) {
    return TCascader(
      options: _options,
      value: _value,
      onChanged: (value) => setState(() => _value = value),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildStep(BuildContext context) {
    return TCascader(
      options: _options,
      value: _value,
      variant: TCascaderVariant.step,
      onChanged: (value) => setState(() => _value = value),
    );
  }

  @Demo(group: 'cascader')
  Widget _buildDisabled(BuildContext context) {
    return TCascader(options: _options, value: _value);
  }
}
