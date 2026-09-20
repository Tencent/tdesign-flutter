import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'disabled_radios_example.dart';
import 'horizontal_radios_example.dart';
import 'radio_positions_example.dart';
import 'radio_themes_example.dart';
import 'special_radios_example.dart';
import 'vertical_card_radios_example.dart';
import 'vertical_radios_example.dart';

@ExampleCodeManifest()
class TRadioPage extends StatefulWidget {
  const TRadioPage({super.key});

  @override
  State<TRadioPage> createState() => _TRadioPageState();
}

class _TRadioPageState extends State<TRadioPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于在预设的一组选项中执行单项选择，并呈现选择结果。',
      exampleCodeGroup: 'radio',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '纵向单选框',
              methodName: 'VerticalRadiosExample',
              builder: (_) => const VerticalRadiosExample(),
            ),
            ExampleItem(
              desc: '横向单选框',
              center: false,
              methodName: 'HorizontalRadiosExample',
              builder: (_) => const HorizontalRadiosExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '单选框状态',
              methodName: 'DisabledRadiosExample',
              builder: (_) => const DisabledRadiosExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '勾选样式',
              methodName: 'RadioThemesExample',
              builder: (_) => const RadioThemesExample(),
            ),
            ExampleItem(
              desc: '勾选显示位置',
              methodName: 'RadioPositionsExample',
              builder: (_) => const RadioPositionsExample(),
            ),
            ExampleItem(
              desc: '非通栏单选样式',
              methodName: 'VerticalCardRadiosExample',
              builder: (_) => const VerticalCardRadiosExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [
            ExampleItem(
              desc: '纵向卡片单选框',
              methodName: 'SpecialRadiosExample',
              builder: (_) => const SpecialRadiosExample(),
            ),
          ],
        ),
      ],
    );
  }
}
