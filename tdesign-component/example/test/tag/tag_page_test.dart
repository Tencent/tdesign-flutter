import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';
import 'package:tdesign_flutter_example/page/tag/circle_fill_tag_example.dart';
import 'package:tdesign_flutter_example/page/tag/tag_page.dart';

import '../demo_page_test_utils.dart';

const _tagSpec = DemoPageTestSpec(
  name: 'tag',
  title: 'Tag 标签',
  page: TTagPage(),
  expectedTexts: [
    '01 组件类型',
    '基础标签',
    '圆弧标签',
    '超长省略文本标签',
    '可选中的标签',
    '02 组件状态',
    '展示型标签',
    '03 组件尺寸',
    'outline',
  ],
  componentType: TTag,
  useFeedbackGoldenFont: true,
  supplementalCjkFontFamily: 'TDesign Demo Review Golden CJK',
  supplementalCjkFontPath: 'test/fonts/DemoReviewGoldenCJK-Regular.otf',
);

void main() {
  registerDemoStructureTests(_tagSpec);
  registerDemoGoldenTests(_tagSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('tag selected ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, _tagSpec, mode);
      final selectable = find.byWidgetPredicate(
        (widget) =>
            widget is TSelectTag &&
            widget.text == '未选中态' &&
            widget.variant == TTagVariant.outline,
      );
      await tester.tap(selectable);
      await tester.pumpAndSettle();
      expect(tester.widget<TSelectTag>(selectable).value, isTrue);
      await expectLater(
        find.byKey(const ValueKey('tag-demo-page')),
        matchesGoldenFile('goldens/tag_selected_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }

  testWidgets('Tag Demo exposes every color scheme and variant', (
    tester,
  ) async {
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

  testWidgets('Tag Demo page copy and shape row match the design', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, _tagSpec, ThemeMode.light);

    expect(find.text('Tag'), findsOneWidget);
    expect(find.text('用于表明主体的类目，属性或状态。'), findsOneWidget);

    final shapeTags = find.descendant(
      of: find.byType(CircleFillTagExample),
      matching: find.byType(TTag),
    );
    expect(shapeTags, findsNWidgets(3));
    final tags = tester.widgetList<TTag>(shapeTags).toList();
    expect(
      tags.map((tag) => tag.variant),
      orderedEquals([
        TTagVariant.light,
        TTagVariant.outline,
        TTagVariant.outline,
      ]),
    );
    expect(
      shapeTags.evaluate().map(
        (element) => Theme.of(element).extension<TTagThemeData>()?.shape,
      ),
      orderedEquals([TTagShape.round, TTagShape.round, TTagShape.mark]),
    );

    final rects = List.generate(
      3,
      (index) => tester.getRect(shapeTags.at(index)),
    );
    expect(rects[1].left - rects[0].right, 16);
    expect(rects[2].left - rects[1].right, 16);
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Tag Demo exposes long ellipsis and selectable outline styles', (
    tester,
  ) async {
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
    expect(outlineSelectTags, hasLength(2));
    expect(
      outlineSelectTags.map((tag) => tag.value),
      orderedEquals([false, true]),
    );
    expect(
      tester.getTopLeft(find.widgetWithText(TSelectTag, '未选中态').first).dx,
      112,
    );

    final firstOutlineTag = find.byWidgetPredicate(
      (widget) =>
          widget is TSelectTag &&
          widget.text == '未选中态' &&
          widget.variant == TTagVariant.outline,
    );
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
          of: find.byWidgetPredicate(
            (widget) =>
                widget is TSelectTag &&
                widget.text == '未选中态' &&
                widget.variant == TTagVariant.outline,
          ),
          matching: find.byType(CodeWrapper),
        )
        .first;

    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();

    final entries = [
      (wrapper: longWrapper, asset: 'assets/code/tag.LongTextTagExample.txt'),
      (
        wrapper: outlineWrapper,
        asset: 'assets/code/tag.TagSelectVariantsExample.txt',
      ),
    ];
    for (final entry in entries) {
      final source = await rootBundle.loadString(entry.asset);
      await tester.tap(
        find.descendant(of: entry.wrapper, matching: find.text('code')),
      );
      await tester.pumpAndSettle();
      final panel = find.byType(Markdown);
      expect(tester.widget<Markdown>(panel).data, contains(source));
      Navigator.of(tester.element(panel)).pop();
      await tester.pumpAndSettle();
    }

    await disposeDemoPage(tester);
  }, tags: 'demo');
}
