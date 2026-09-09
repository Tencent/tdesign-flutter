import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TCollapsePage extends StatefulWidget {
  const TCollapsePage({Key? key}) : super(key: key);

  @override
  TCollapsePageState createState() => TCollapsePageState();
}

const String randomString =
    '此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容';

class TCollapsePageState extends State<TCollapsePage> {
  List<String> _basicValue = const ['basic'];
  List<String> _cardValue = const ['card-0'];
  List<String> _operationValue = const ['operation'];
  List<String> _accordionValue = const ['0'];

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
            ExampleItem(desc: '基础折叠面板', builder: _buildBasicCollapse),
            ExampleItem(
              desc: '带操作说明',
              builder: _buildCollapseWithOperationText,
            ),
            ExampleItem(
              desc: '手风琴式',
              builder: _buildAccordionCollapse,
              center: false,
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [ExampleItem(desc: '卡片折叠面板', builder: _buildCardCollapse)],
        ),
      ],
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_basicValue` 是由 State 持有的展开值列表，
  /// 初始包含唯一面板值；`onChanged` 通过 `setState` 写回完整列表。
  /// `randomString` 是页面级常量，仅作为面板正文示例。
  @ExampleCode(group: 'collapse')
  Widget _buildBasicCollapse(BuildContext context) {
    return TCollapse<String>(
      value: _basicValue,
      onChanged: (value) => setState(() => _basicValue = value),
      children: [
        TCollapsePanel<String>(
          value: 'basic',
          headerBuilder: (context, isExpanded) => const Text('折叠面板标题'),
          body: const Text(randomString),
        ),
      ],
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_cardValue` 是由 State 持有的展开值列表，
  /// 初始仅包含三项中的首项；`onChanged` 通过 `setState` 写回完整列表。
  /// `randomString` 是页面级常量，仅作为面板正文示例。
  @ExampleCode(group: 'collapse')
  Widget _buildCardCollapse(BuildContext context) {
    return TCollapse<String>(
      variant: TCollapseVariant.card,
      value: _cardValue,
      onChanged: (value) => setState(() => _cardValue = value),
      children: List.generate(3, (index) {
        return TCollapsePanel<String>(
          value: 'card-$index',
          headerBuilder: (context, isExpanded) => const Text('折叠面板标题'),
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_operationValue` 是由 State 持有的展开值列表，
  /// 初始包含唯一面板值；`onChanged` 通过 `setState` 写回完整列表，
  /// `trailingBuilder` 根据展开状态显示操作文案。`randomString` 是页面级常量，
  /// 仅作为面板正文示例。
  @ExampleCode(group: 'collapse')
  Widget _buildCollapseWithOperationText(BuildContext context) {
    return TCollapse<String>(
      value: _operationValue,
      onChanged: (value) => setState(() => _operationValue = value),
      children: [
        TCollapsePanel<String>(
          value: 'operation',
          headerBuilder: (context, isExpanded) => const Text('折叠面板标题'),
          trailingBuilder: (context, isExpanded) =>
              Text(isExpanded ? '收起' : '展开'),
          body: const Text(randomString),
        ),
      ],
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart，并放入
  /// StatefulWidget 的 State。`_accordionValue` 由页面 State 持有，
  /// `onChanged` 回写完整列表，避免其他示例重建时重置展开项。
  /// `randomString` 是页面级常量，仅作为面板正文示例。
  @ExampleCode(group: 'collapse')
  Widget _buildAccordionCollapse(BuildContext context) {
    final values = List.generate(3, (index) => '$index');
    return TCollapse<String>(
      mode: TCollapseMode.accordion,
      value: _accordionValue,
      onChanged: (value) => setState(() => _accordionValue = value),
      children: values.map((panelValue) {
        return TCollapsePanel(
          value: panelValue,
          headerBuilder: (context, isExpanded) {
            return const Text('折叠面板标题');
          },
          body: const Text(randomString),
        );
      }).toList(),
    );
  }
}
