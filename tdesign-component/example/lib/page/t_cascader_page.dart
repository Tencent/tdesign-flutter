import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
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
        TCascaderOption(
          label: '广州市',
          value: 'gz',
          children: [
            TCascaderOption(label: '越秀区', value: 'yx'),
            TCascaderOption(label: '天河区', value: 'th'),
          ],
        ),
      ],
    ),
    TCascaderOption(
      label: '浙江省',
      value: 'zj',
      children: [
        TCascaderOption(
          label: '杭州市',
          value: 'hz',
          children: [
            TCascaderOption(label: '西湖区', value: 'xh'),
            TCascaderOption(label: '余杭区', value: 'yh'),
          ],
        ),
        TCascaderOption(label: '宁波市', value: 'nb'),
      ],
    ),
    TCascaderOption(label: '香港特别行政区', value: 'hk'),
  ];

  static const _optionsWithDisabled = [
    TCascaderOption(
      label: '广东省',
      value: 'gd',
      children: [
        TCascaderOption(label: '深圳市', value: 'sz', disabled: true),
        TCascaderOption(label: '广州市', value: 'gz'),
      ],
    ),
    TCascaderOption(label: '暂不可选地区', value: 'disabled', disabled: true),
  ];

  List<Object?> _tabValue = const [];
  List<Object?> _stepValue = const ['gd'];
  List<Object?> _presetValue = const ['zj', 'hz', 'xh'];
  List<Object?> _placeholderValue = const ['gd'];
  List<Object?> _disabledOptionValue = const [];
  List<Object?> _popupValue = const ['gd', 'sz', 'ns'];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于从层级数据中选择一条路径。',
      exampleCodeGroup: 'cascader',
      children: [
        ExampleModule(
          title: '弹出层用法',
          children: [ExampleItem(desc: '底部弹出选择（确认后提交）', builder: _buildPopup)],
        ),
        ExampleModule(
          title: '基础用法',
          children: [
            ExampleItem(desc: '标签导航', builder: _buildTab),
            ExampleItem(desc: '步骤导航', builder: _buildStep),
          ],
        ),
        ExampleModule(
          title: '选择状态',
          children: [
            ExampleItem(desc: '默认选中路径', builder: _buildPreset),
            ExampleItem(desc: '自定义占位文案', builder: _buildPlaceholder),
          ],
        ),
        ExampleModule(
          title: '禁用状态',
          children: [
            ExampleItem(desc: '禁用部分选项', builder: _buildDisabledOption),
            ExampleItem(desc: '整体禁用', builder: _buildDisabled),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildTab(BuildContext context) {
    return TCascader(
      options: _options,
      value: _tabValue,
      onChanged: (value) => setState(() => _tabValue = value),
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildPreset(BuildContext context) {
    return TCascader(
      options: _options,
      value: _presetValue,
      onChanged: (value) => setState(() => _presetValue = value),
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildPlaceholder(BuildContext context) {
    return TCascader(
      options: _options,
      value: _placeholderValue,
      placeholder: '请选择下一级',
      onChanged: (value) => setState(() => _placeholderValue = value),
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildStep(BuildContext context) {
    return TCascader(
      options: _options,
      value: _stepValue,
      variant: TCascaderVariant.step,
      onChanged: (value) => setState(() => _stepValue = value),
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildDisabledOption(BuildContext context) {
    return TCascader(
      options: _optionsWithDisabled,
      value: _disabledOptionValue,
      onChanged: (value) => setState(() => _disabledOptionValue = value),
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildDisabled(BuildContext context) {
    return const TCascader(options: _options, value: ['gd', 'sz', 'ns']);
  }

  @ExampleCode(group: 'cascader')
  Widget _buildPopup(BuildContext context) {
    List<String> selectedLabels(List<Object?> value) {
      var options = _options;
      final labels = <String>[];
      for (final selectedValue in value) {
        final matches = options
            .where((option) => option.value == selectedValue)
            .toList();
        if (matches.isEmpty) {
          break;
        }
        labels.add(matches.first.label);
        options = matches.first.children;
      }
      return labels;
    }

    return TCell(
      title: const TText('选择地区'),
      note: TText(selectedLabels(_popupValue).join(' / ')),
      arrow: true,
      onTap: () {
        var draft = List<Object?>.of(_popupValue);
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
            height: MediaQuery.sizeOf(context).height * 0.6,
            headerBuilder: (_, close) => TPopupHeader(
              cancelButton: TextButton(
                onPressed: close,
                child: const TText('取消'),
              ),
              title: const TText('选择地区'),
              confirmButton: TextButton(
                onPressed: () {
                  if (mounted) {
                    setState(() => _popupValue = List<Object?>.of(draft));
                  }
                  close();
                },
                child: const TText('确定'),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setPopupState) => TCascader(
                key: const Key('cascader-popup'),
                options: _options,
                value: draft,
                onChanged: (value) {
                  setPopupState(() => draft = value);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
