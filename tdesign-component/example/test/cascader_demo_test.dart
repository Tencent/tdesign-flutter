import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'cascader_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(cascaderDemoPageTestSpec);

  test(
    'Cascader code panel contains the four-level controlled value',
    () async {
      final source = await rootBundle.loadString(
        'assets/code/cascader.CascaderBaseExample.txt',
      );
      expect(source, contains("TCascaderOption(label: '粤海街道'"));
      expect(source, contains("'guangdong'"));
      expect(source, contains("title: const TText('选择地区')"));
      expect(source, contains('height: 580'));
    },
  );

  testWidgets('Cascader Demo follows the official trigger order', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, ThemeMode.light);

    final keys = <ValueKey<String>>[
      const ValueKey('cascader-vertical-trigger'),
      const ValueKey('cascader-vertical-locator-trigger'),
      const ValueKey('cascader-horizontal-trigger'),
      const ValueKey('cascader-horizontal-locator-trigger'),
      const ValueKey('cascader-with-title-trigger'),
      const ValueKey('cascader-without-title-trigger'),
    ];
    final tops = keys
        .map((key) => tester.getTopLeft(find.byKey(key)).dy)
        .toList();
    expect(tops, orderedEquals([...tops]..sort()));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Cascader variants and typed option mapping stay explicit', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, ThemeMode.light);

    await tester.tap(find.byKey(const ValueKey('cascader-vertical-trigger')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TCascader>(find.byType(TCascader)).variant,
      TCascaderVariant.step,
    );
    await tester.tap(find.byIcon(TIcons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('cascader-horizontal-trigger')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TCascader>(find.byType(TCascader)).variant,
      TCascaderVariant.tab,
    );
    await tester.tap(find.byIcon(TIcons.close));
    await tester.pumpAndSettle();

    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Cascader advanced compositions remain functional', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, ThemeMode.light);

    await tester.tap(
      find.byKey(const ValueKey('cascader-vertical-locator-trigger')),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<TCascader>(find.byType(TCascader)).subtitles, const [
      '一级选项标题',
      '二级选项标题',
      '三级选项标题',
      '四级选项标题',
    ]);
    expect(find.text('四级选项标题'), findsOneWidget);
    expect(find.text('标题文字'), findsOneWidget);
    await tester.tap(find.byIcon(TIcons.close));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('cascader-without-title-trigger')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TCascader), findsOneWidget);
    expect(find.text('标题文字'), findsNothing);

    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('basic Cascader commits and closes after selecting a leaf', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, ThemeMode.light);

    await tester.tap(find.byKey(const ValueKey('cascader-vertical-trigger')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('南头街道'));
    await tester.pumpAndSettle();

    expect(find.byType(TCascader), findsNothing);
    expect(find.text('广东 深圳 南山区 南头街道'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
