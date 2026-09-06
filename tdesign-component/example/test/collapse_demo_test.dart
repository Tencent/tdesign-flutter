import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_collapse_page.dart';

import 'demo_page_test_utils.dart';

const collapseDemoSpec = DemoPageTestSpec(
  name: 'collapse',
  title: 'Collapse',
  page: TCollapsePage(),
  expectedTexts: [
    '基础折叠面板',
    '向上展开',
    '带操作说明',
    '手风琴式',
    '卡片折叠面板',
  ],
  componentType: TCollapse,
);

void main() {
  registerDemoStructureTests(collapseDemoSpec);

  testWidgets('实例顺序和初始状态与设计稿一致', (tester) async {
    await pumpFullDemoPage(tester, collapseDemoSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.map((module) => module.title),
        ['01 组件类型', '02 组件样式']);
    expect(page.children[0].children.map((item) => item.desc),
        ['基础折叠面板', '向上展开', '带操作说明', '手风琴式']);

    final context = tester.element(find.byType(ExamplePage));
    TCollapse buildItem(int module, int item) =>
        page.children[module].children[item].builder(context) as TCollapse;

    expect(buildItem(0, 0).children.single.isExpanded, isTrue);
    expect(buildItem(0, 1).children.single.placement,
        TCollapsePlacement.top);
    expect(buildItem(0, 2).children.single.expandIconTextBuilder,
        isNotNull);
    final accordion = buildItem(0, 3);
    expect(accordion.mode, TCollapseMode.accordion);
    expect(accordion.value, '0');
    expect(accordion.children.last.disabled, isTrue);
    final card = buildItem(1, 0);
    expect(card.variant, TCollapseVariant.card);
    expect(card.children.last.isExpanded, isTrue);
    expect(card.children.last.disabled, isTrue);
  }, tags: 'demo');

  testWidgets('基础面板点击后收起内容', (tester) async {
    await pumpFullDemoPage(tester, collapseDemoSpec, ThemeMode.light);
    final collapse = find.byType(TCollapse).first;
    expect(tester.widget<TCollapse>(collapse).children.single.isExpanded,
        isTrue);
    await tester.tap(find.descendant(
      of: collapse,
      matching: find.text('折叠面板标题'),
    ));
    await tester.pumpAndSettle();
    expect(tester.widget<TCollapse>(collapse).children.single.isExpanded,
        isFalse);
  }, tags: 'demo');
}
