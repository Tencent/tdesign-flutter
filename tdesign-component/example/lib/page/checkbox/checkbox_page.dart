import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'card_checkboxes_example.dart';
import 'checkbox_check_all_example.dart';
import 'checkbox_positions_example.dart';
import 'checkbox_variants_example.dart';
import 'disabled_checkbox_example.dart';
import 'horizontal_checkbox_example.dart';
import 'non_full_width_checkbox_example.dart';
import 'vertical_checkbox_example.dart';

@ExampleCodeManifest()
class TCheckboxPage extends StatefulWidget {
  const TCheckboxPage({super.key});

  @override
  State<TCheckboxPage> createState() => _TCheckboxPageState();
}

class _TCheckboxPageState extends State<TCheckboxPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于预设的一组选项中执行多项选择，并呈现选择结果。',
      exampleCodeGroup: 'checkbox',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '纵向多选框',
              methodName: 'VerticalCheckboxExample',
              builder: (_) => const VerticalCheckboxExample(),
            ),
            ExampleItem(
              desc: '横向多选框',
              methodName: 'HorizontalCheckboxExample',
              builder: (_) => const HorizontalCheckboxExample(),
            ),
            ExampleItem(
              desc: '带全选多选框',
              methodName: 'CheckboxCheckAllExample',
              builder: (_) => const CheckboxCheckAllExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '多选框状态',
              methodName: 'DisabledCheckboxExample',
              builder: (_) => const DisabledCheckboxExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '勾选样式',
              methodName: 'CheckboxVariantsExample',
              builder: (_) => const CheckboxVariantsExample(),
            ),
            ExampleItem(
              desc: '勾选显示位置',
              methodName: 'CheckboxPositionsExample',
              builder: (_) => const CheckboxPositionsExample(),
            ),
            ExampleItem(
              desc: '非通栏多选样式',
              methodName: 'NonFullWidthCheckboxExample',
              builder: (_) => const NonFullWidthCheckboxExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [
            ExampleItem(
              desc: '纵向卡片多选框',
              methodName: 'CardCheckboxesExample',
              builder: (_) => const CardCheckboxesExample(),
            ),
          ],
        ),
      ],
    );
  }
}
