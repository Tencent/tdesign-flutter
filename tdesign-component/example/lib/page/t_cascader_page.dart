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
  List<Object?> _popupValue = const ['gd', 'sz', 'ns'];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于从层级数据中选择一条路径。',
      exampleCodeGroup: 'cascader',
      children: [
        ExampleModule(title: '弹出层用法', children: [
          ExampleItem(desc: '底部弹出选择', builder: _buildPopup),
        ]),
        ExampleModule(title: '基础能力', children: [
          ExampleItem(desc: '标签导航', builder: _buildTab),
          ExampleItem(desc: '步骤导航', builder: _buildStep),
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildTab(BuildContext context) {
    return TCascader(
      options: _options,
      value: _value,
      onChanged: (value) => setState(() => _value = value),
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildStep(BuildContext context) {
    return TCascader(
      options: _options,
      value: _value,
      variant: TCascaderVariant.step,
      onChanged: (value) => setState(() => _value = value),
    );
  }

  @ExampleCode(group: 'cascader')
  Widget _buildDisabled(BuildContext context) {
    return TCascader(options: _options, value: _value);
  }

  @ExampleCode(group: 'cascader')
  Widget _buildPopup(BuildContext context) {
    List<String> selectedLabels(List<Object?> value) {
      var options = _options;
      final labels = <String>[];
      for (final selectedValue in value) {
        final matches =
            options.where((option) => option.value == selectedValue).toList();
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
            titleWidget: const TText('选择地区'),
            child: StatefulBuilder(
              builder: (context, setPopupState) => TCascader(
                options: _options,
                value: draft,
                onChanged: (value) {
                  setPopupState(() => draft = value);
                },
              ),
            ),
            onVisibleChange: (visible, trigger) {
              if (!visible && trigger == TPopupTrigger.confirm) {
                setState(() => _popupValue = List<Object?>.of(draft));
              }
            },
          ),
        );
      },
    );
  }
}
