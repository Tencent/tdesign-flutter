import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';
import 'package:tdesign_flutter_example/page/t_tag_page.dart';

import 'demo_page_test_utils.dart';

const _tagSpec = DemoPageTestSpec(
  name: 'tag',
  title: 'Tag 标签',
  page: TTagPage(),
  expectedTexts: [
    '01 组件类型',
    '基础标签',
    '圆弧标签',
    'Mark标签',
    '超长省略文本标签',
    '02 组件状态（主题）',
    '填充型各主题',
    '描边型各主题',
    '03 组件尺寸',
    '04 可选标签',
    '描边形态',
  ],
  componentType: TTag,
);

void main() {
  registerDemoStructureTests(_tagSpec);
  registerDemoGoldenTests(_tagSpec);

  testWidgets('Tag Demo exposes every color scheme and variant', (tester) async {
    await pumpFullDemoPage(tester, _tagSpec, ThemeMode.light);

    final tags = tester.widgetList<TTag>(find.byType(TTag)).toList();
    expect(
      tags.map((tag) => tag.colorScheme).toSet(),
      containsAll(TTagColorScheme.values),
    );
    expect(
      tags.map((tag) => tag.variant).toSet(),
      containsAll(TTagVariant.values),
    );
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Tag Demo exposes long ellipsis and selectable outline styles',
      (tester) async {
    await pumpFullDemoPage(tester, _tagSpec, ThemeMode.light);

    const longText = '超长省略文本标签超长省略文本标签';
    final longTag = tester.widget<TTag>(find.widgetWithText(TTag, longText));
    expect(longTag.variant, TTagVariant.light);

    final longTextWidget = tester.widget<Text>(find.text(longText));
    expect(longTextWidget.maxLines, 1);
    expect(longTextWidget.overflow, TextOverflow.ellipsis);
    expect(tester.getSize(find.widgetWithText(TTag, longText)).width, 130);

    final outlineSelectTags = tester
        .widgetList<TSelectTag>(find.byType(TSelectTag))
        .where((tag) => tag.variant == TTagVariant.outline)
        .toList();
    expect(outlineSelectTags, hasLength(3));
    expect(outlineSelectTags.map((tag) => tag.value),
        orderedEquals([false, true, false]));

    final firstOutlineTag = find.byWidgetPredicate((widget) =>
        widget is TSelectTag &&
        widget.text == '标签一' &&
        widget.variant == TTagVariant.outline);
    await tester.tap(firstOutlineTag);
    await tester.pump();
    expect(tester.widget<TSelectTag>(firstOutlineTag).value, isTrue);

    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    expect(tester.widget<TSelectTag>(firstOutlineTag).value, isTrue);
    TNotification.postNotification('onApiVisibleChange', {'apiVisible': false});
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Tag 新增示例代码入口展示对应的生成片段', (tester) async {
    await pumpFullDemoPage(tester, _tagSpec, ThemeMode.light);

    const longText = '超长省略文本标签超长省略文本标签';
    final longWrapper = find
        .ancestor(
          of: find.widgetWithText(TTag, longText),
          matching: find.byType(CodeWrapper),
        )
        .first;
    final outlineWrapper = find
        .ancestor(
          of: find.byWidgetPredicate((widget) =>
              widget is TSelectTag &&
              widget.text == '标签一' &&
              widget.variant == TTagVariant.outline),
          matching: find.byType(CodeWrapper),
        )
        .first;

    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();

    final entries = [
      (wrapper: longWrapper, asset: 'assets/code/tag._buildLongTextTag.txt'),
      (
        wrapper: outlineWrapper,
        asset: 'assets/code/tag.TagSelectOutlineExample.txt'
      ),
    ];
    for (final entry in entries) {
      final source = await rootBundle.loadString(entry.asset);
      await tester.tap(
          find.descendant(of: entry.wrapper, matching: find.text('code')));
      await tester.pumpAndSettle();
      final panel = find.byType(Markdown);
      expect(tester.widget<Markdown>(panel).data, contains(source));
      Navigator.of(tester.element(panel)).pop();
      await tester.pumpAndSettle();
    }

    await disposeDemoPage(tester);
  }, tags: 'demo');
}
