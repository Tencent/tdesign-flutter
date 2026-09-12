import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

/// 在已配置 TDesign 主题的应用中使用 `TreeSelectSingleExample()`。
@ExampleCode(group: 'tree-select')
class TreeSelectSingleExample extends StatefulWidget {
  const TreeSelectSingleExample({super.key});

  @override
  State<TreeSelectSingleExample> createState() =>
      _TreeSelectSingleExampleState();
}

class _TreeSelectSingleExampleState extends State<TreeSelectSingleExample> {
  static const _options = [
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

  List<List<Object?>> _value = const [
    ['guangdong', 'shanwei'],
  ];

  @override
  Widget build(BuildContext context) => TTreeSelect(
    key: const ValueKey('tree-select-single'),
    options: _options,
    value: _value,
    onChanged: (value) => setState(() => _value = value),
  );
}

/// 在已配置 TDesign 主题的应用中使用 `TreeSelectMultipleExample()`。
@ExampleCode(group: 'tree-select')
class TreeSelectMultipleExample extends StatefulWidget {
  const TreeSelectMultipleExample({super.key});

  @override
  State<TreeSelectMultipleExample> createState() =>
      _TreeSelectMultipleExampleState();
}

class _TreeSelectMultipleExampleState extends State<TreeSelectMultipleExample> {
  static const _options = [
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

  List<List<Object?>> _value = const [
    ['guangdong', 'shanwei'],
  ];

  @override
  Widget build(BuildContext context) => TTreeSelect(
    key: const ValueKey('tree-select-multiple'),
    options: _options,
    value: _value,
    multiple: true,
    onChanged: (value) => setState(() => _value = value),
  );
}

/// 在已配置 TDesign 主题的应用中使用 `TreeSelectThreeColumnsExample()`。
@ExampleCode(group: 'tree-select')
class TreeSelectThreeColumnsExample extends StatefulWidget {
  const TreeSelectThreeColumnsExample({super.key});

  @override
  State<TreeSelectThreeColumnsExample> createState() =>
      _TreeSelectThreeColumnsExampleState();
}

class _TreeSelectThreeColumnsExampleState
    extends State<TreeSelectThreeColumnsExample> {
  static const _options = [
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

  List<List<Object?>> _value = const [
    ['guangdong', 'shenzhen', 'nanshan'],
  ];

  @override
  Widget build(BuildContext context) => TTreeSelect(
    key: const ValueKey('tree-select-three-columns'),
    options: _options,
    value: _value,
    onChanged: (value) => setState(() => _value = value),
  );
}
