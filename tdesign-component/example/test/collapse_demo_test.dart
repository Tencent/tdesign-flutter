import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_collapse_page.dart';

import 'demo_page_test_utils.dart';

const collapseDemoSpec = DemoPageTestSpec(
  name: 'collapse',
  title: 'Collapse 折叠面板',
  page: TCollapsePage(),
  expectedTexts: ['基础折叠面板', '带操作说明', '手风琴式', '卡片折叠面板'],
  componentType: TCollapse<String>,
  useMaterialIcons: true,
  supplementalCjkFontFamily: 'TDesign Collapse Golden CJK',
  supplementalCjkFontPath: 'test/fonts/CollapseGoldenCJK-Regular.otf',
);

void main() {
  registerDemoStructureTests(collapseDemoSpec);

  testWidgets('实例顺序和初始状态与设计稿一致', (tester) async {
    await pumpFullDemoPage(tester, collapseDemoSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.showTestModule, isFalse);
    expect(page.children.map((module) => module.title), ['组件类型', '组件样式']);
    expect(page.children[0].children.map((item) => item.desc), [
      '基础折叠面板',
      '带操作说明',
      '手风琴式',
    ]);

    final context = tester.element(find.byType(ExamplePage));
    Widget buildItem(int module, int item) =>
        page.children[module].children[item].builder(context);

    expect((buildItem(0, 0) as TCollapse).value, ['basic']);
    expect(
      (buildItem(0, 1) as TCollapse).children.single.trailingBuilder,
      isNotNull,
    );
    final accordion = buildItem(0, 2);
    expect(accordion, isA<TCollapse<String>>());
    final accordionCollapse = tester.widget<TCollapse>(
      find.byWidgetPredicate(
        (widget) =>
            widget is TCollapse && widget.mode == TCollapseMode.accordion,
      ),
    );
    expect(accordionCollapse.mode, TCollapseMode.accordion);
    expect(accordionCollapse.value, ['0']);
    expect(accordionCollapse.children, hasLength(3));
    expect(
      accordionCollapse.children.first.body,
      isA<Text>().having((text) => text.data, 'data', randomString),
    );
    expect(
      accordionCollapse.children.every((panel) => !panel.disabled),
      isTrue,
    );
    final card = buildItem(1, 0) as TCollapse;
    expect(card.variant, TCollapseVariant.card);
    expect(card.children, hasLength(3));
    expect(card.value, ['card-0']);
    expect(card.children.every((panel) => !panel.disabled), isTrue);
  }, tags: 'demo');

  testWidgets('手风琴状态不被其他组更新重置', (tester) async {
    await pumpFullDemoPage(tester, collapseDemoSpec, ThemeMode.light);
    final accordion = find.byWidgetPredicate(
      (widget) => widget is TCollapse && widget.mode == TCollapseMode.accordion,
    );
    final headers = find.descendant(
      of: accordion,
      matching: find.text('折叠面板标题'),
    );

    await tester.tap(headers.last);
    await tester.pumpAndSettle();

    expect(tester.widget<TCollapse<String>>(accordion).value, ['2']);

    final card = find.byWidgetPredicate(
      (widget) =>
          widget is TCollapse && widget.variant == TCollapseVariant.card,
    );
    final cardHeaders = find.descendant(
      of: card,
      matching: find.text('折叠面板标题'),
    );
    await tester.ensureVisible(cardHeaders.at(1));
    await tester.tap(cardHeaders.at(1));
    await tester.pumpAndSettle();

    expect(tester.widget<TCollapse<String>>(accordion).value, ['2']);
    expect(tester.widget<TCollapse<String>>(card).value, ['card-0', 'card-1']);
  }, tags: 'demo');

  testWidgets('卡片第一项可以点击收起', (tester) async {
    await pumpFullDemoPage(tester, collapseDemoSpec, ThemeMode.light);
    final card = find.byWidgetPredicate(
      (widget) =>
          widget is TCollapse && widget.variant == TCollapseVariant.card,
    );
    final headers = find.descendant(of: card, matching: find.text('折叠面板标题'));

    await tester.ensureVisible(headers.first);
    await tester.tap(headers.first);
    await tester.pumpAndSettle();

    expect(tester.widget<TCollapse>(card).value, isEmpty);
  }, tags: 'demo');

  testWidgets('基础面板点击后收起内容', (tester) async {
    await pumpFullDemoPage(tester, collapseDemoSpec, ThemeMode.light);
    final collapse = find.byType(TCollapse<String>).first;
    expect(tester.widget<TCollapse<String>>(collapse).value, ['basic']);
    await tester.tap(
      find.descendant(of: collapse, matching: find.text('折叠面板标题')),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<TCollapse<String>>(collapse).value, isEmpty);
  }, tags: 'demo');
}
