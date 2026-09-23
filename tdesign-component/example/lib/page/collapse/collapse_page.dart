import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'accordion_collapse_example.dart';
import 'basic_collapse_example.dart';
import 'card_collapse_example.dart';
import 'collapse_with_operation_text_example.dart';

@ExampleCodeManifest()
class TCollapsePage extends StatefulWidget {
  const TCollapsePage({Key? key}) : super(key: key);

  @override
  TCollapsePageState createState() => TCollapsePageState();
}

class TCollapsePageState extends State<TCollapsePage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'collapse',
      desc: '可以折叠/展开的内容区域。',
      showTestModule: false,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF6F6F6)
          : context.tTheme.bgColorPage,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础折叠面板',
              methodName: 'BasicCollapseExample',
              builder: (_) => const BasicCollapseExample(),
            ),
            ExampleItem(
              desc: '带操作说明',
              methodName: 'CollapseWithOperationTextExample',
              builder: (_) => const CollapseWithOperationTextExample(),
            ),
            ExampleItem(
              desc: '手风琴式',
              center: false,
              methodName: 'AccordionCollapseExample',
              builder: (_) => const AccordionCollapseExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '卡片折叠面板',
              methodName: 'CardCollapseExample',
              builder: (_) => const CardCollapseExample(),
            ),
          ],
        ),
      ],
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_basicValue` 是由 State 持有的展开值列表，
  /// 初始包含唯一面板值；`onChanged` 通过 `setState` 写回完整列表。
  /// `randomString` 是页面级常量，仅作为面板正文示例。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_cardValue` 是由 State 持有的展开值列表，
  /// 初始仅包含三项中的首项；`onChanged` 通过 `setState` 写回完整列表。
  /// `randomString` 是页面级常量，仅作为面板正文示例。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_operationValue` 是由 State 持有的展开值列表，
  /// 初始包含唯一面板值；`onChanged` 通过 `setState` 写回完整列表，
  /// `trailingBuilder` 根据展开状态显示操作文案。`randomString` 是页面级常量，
  /// 仅作为面板正文示例。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_accordionValue` 由页面 State 持有，
  /// `onChanged` 回写完整列表，避免其他示例重建时重置展开项。
  /// `randomString` 是页面级常量，仅作为面板正文示例。
}
