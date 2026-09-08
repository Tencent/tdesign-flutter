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
      label: '甘肃省',
      value: 'gansu',
      children: [TTreeSelectOption(label: '兰州市', value: 'lanzhou')],
    ),
    TTreeSelectOption(
      label: '广东省',
      value: 'guangdong',
      children: [
        TTreeSelectOption(label: '汕头市', value: 'shantou'),
        TTreeSelectOption(label: '汕尾市', value: 'shanwei'),
        TTreeSelectOption(label: '韶关市', value: 'shaoguan'),
        TTreeSelectOption(label: '深圳市', value: 'shenzhen'),
        TTreeSelectOption(label: '阳江市', value: 'yangjiang'),
        TTreeSelectOption(label: '云浮市', value: 'yunfu'),
      ],
    ),
    TTreeSelectOption(
      label: '贵州省',
      value: 'guizhou',
      children: [TTreeSelectOption(label: '贵阳市', value: 'guiyang')],
    ),
    TTreeSelectOption(
      label: '海南省',
      value: 'hainan',
      children: [TTreeSelectOption(label: '海口市', value: 'haikou')],
    ),
    TTreeSelectOption(
      label: '河北省',
      value: 'hebei',
      children: [TTreeSelectOption(label: '石家庄市', value: 'shijiazhuang')],
    ),
    TTreeSelectOption(
      label: '黑龙江省',
      value: 'heilongjiang',
      children: [TTreeSelectOption(label: '哈尔滨市', value: 'haerbin')],
    ),
  ];

  static const _threeColumnOptions = [
    TTreeSelectOption(
      label: '甘肃省',
      value: 'gansu',
      children: [
        TTreeSelectOption(
          label: '兰州市',
          value: 'lanzhou',
          children: [TTreeSelectOption(label: '城关区', value: 'chengguan')],
        ),
      ],
    ),
    TTreeSelectOption(
      label: '广东省',
      value: 'guangdong',
      children: [
        TTreeSelectOption(
          label: '汕头市',
          value: 'shantou',
          children: [TTreeSelectOption(label: '金平区', value: 'jinping')],
        ),
        TTreeSelectOption(
          label: '汕尾市',
          value: 'shanwei',
          children: [TTreeSelectOption(label: '城区', value: 'chengqu')],
        ),
        TTreeSelectOption(
          label: '韶关市',
          value: 'shaoguan',
          children: [TTreeSelectOption(label: '浈江区', value: 'zhenjiang')],
        ),
        TTreeSelectOption(
          label: '深圳市',
          value: 'shenzhen',
          children: [
            TTreeSelectOption(label: '龙华区', value: 'longhua'),
            TTreeSelectOption(label: '罗湖区', value: 'luohu'),
            TTreeSelectOption(label: '南山区', value: 'nanshan'),
            TTreeSelectOption(label: '坪山区', value: 'pingshan'),
            TTreeSelectOption(label: '其它区', value: 'other'),
            TTreeSelectOption(label: '盐田区', value: 'yantian'),
          ],
        ),
        TTreeSelectOption(
          label: '阳江市',
          value: 'yangjiang',
          children: [TTreeSelectOption(label: '江城区', value: 'jiangcheng')],
        ),
        TTreeSelectOption(
          label: '云浮市',
          value: 'yunfu',
          children: [TTreeSelectOption(label: '云城区', value: 'yuncheng')],
        ),
      ],
    ),
    TTreeSelectOption(
      label: '贵州省',
      value: 'guizhou',
      children: [
        TTreeSelectOption(
          label: '贵阳市',
          value: 'guiyang',
          children: [TTreeSelectOption(label: '南明区', value: 'nanming')],
        ),
      ],
    ),
    TTreeSelectOption(
      label: '海南省',
      value: 'hainan',
      children: [
        TTreeSelectOption(
          label: '海口市',
          value: 'haikou',
          children: [TTreeSelectOption(label: '秀英区', value: 'xiuying')],
        ),
      ],
    ),
    TTreeSelectOption(
      label: '河北省',
      value: 'hebei',
      children: [
        TTreeSelectOption(
          label: '石家庄市',
          value: 'shijiazhuang',
          children: [TTreeSelectOption(label: '长安区', value: 'changan')],
        ),
      ],
    ),
    TTreeSelectOption(
      label: '黑龙江省',
      value: 'heilongjiang',
      children: [
        TTreeSelectOption(
          label: '哈尔滨市',
          value: 'haerbin',
          children: [TTreeSelectOption(label: '道里区', value: 'daoli')],
        ),
      ],
    ),
  ];

  List<List<Object?>> _single = const [
    ['guangdong', 'shanwei'],
  ];
  List<List<Object?>> _multiple = const [
    ['guangdong', 'shanwei'],
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
            children: [
              ExampleItem(desc: '树形选择器-三列', builder: _buildThreeColumns)
            ],
          ),
        ],
      );

  @ExampleCode(group: 'tree-select')
  Widget _buildSingle(BuildContext context) {
    // 页面持有完整路径，选择后使用回调值重建受控组件。
    return TTreeSelect(
      key: const ValueKey('tree-select-single'),
      options: _basicOptions,
      value: _single,
      onChanged: (value) => setState(() => _single = value),
    );
  }

  @ExampleCode(group: 'tree-select')
  Widget _buildMultiple(BuildContext context) {
    // 多选仍使用从根节点到叶子节点的完整路径。
    return TTreeSelect(
      key: const ValueKey('tree-select-multiple'),
      options: _basicOptions,
      value: _multiple,
      multiple: true,
      onChanged: (value) => setState(() => _multiple = value),
    );
  }

  @ExampleCode(group: 'tree-select')
  Widget _buildThreeColumns(BuildContext context) {
    // 第三级数据自然生成第三列，无需额外指定列数。
    return TTreeSelect(
      key: const ValueKey('tree-select-three-columns'),
      options: _threeColumnOptions,
      value: _threeColumn,
      onChanged: (value) => setState(() => _threeColumn = value),
    );
  }
}
