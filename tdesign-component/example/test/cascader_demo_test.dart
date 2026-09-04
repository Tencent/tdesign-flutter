import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'cascader_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(cascaderDemoPageTestSpec);

  testWidgets('Cascader Demo follows the official trigger order', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, ThemeMode.light);

    final keys = <ValueKey<String>>[
      const ValueKey('cascader-base-trigger'),
      const ValueKey('cascader-tab-trigger'),
      const ValueKey('cascader-initial-trigger'),
      const ValueKey('cascader-keys-trigger'),
      const ValueKey('cascader-subtitle-trigger'),
      const ValueKey('cascader-any-trigger'),
      const ValueKey('cascader-search-trigger'),
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

    await tester.tap(find.byKey(const ValueKey('cascader-base-trigger')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TCascader>(find.byType(TCascader)).variant,
      TCascaderVariant.step,
    );
    await tester.tap(find.byIcon(TIcons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('cascader-tab-trigger')));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TCascader>(find.byType(TCascader)).variant,
      TCascaderVariant.tab,
    );
    await tester.tap(find.byIcon(TIcons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('cascader-keys-trigger')));
    await tester.pumpAndSettle();
    expect(find.text('北京市'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Cascader advanced compositions remain functional', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, ThemeMode.light);

    await tester.tap(find.byKey(const ValueKey('cascader-subtitle-trigger')));
    await tester.pumpAndSettle();
    expect(tester.widget<TCascader>(find.byType(TCascader)).subtitles, const [
      '请选择省份',
      '请选择城市',
      '请选择区/县',
    ]);
    expect(find.text('请选择省份'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cascader-beijing')));
    await tester.pump();
    expect(find.text('请选择城市'), findsOneWidget);
    await tester.tap(find.byIcon(TIcons.close));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('cascader-any-trigger')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cascader-guangdong')));
    await tester.pump();
    expect(find.byType(TCascader), findsOneWidget);
    await tester.tap(find.byIcon(TIcons.close));
    await tester.pumpAndSettle();
    expect(find.text('广东省'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('cascader-search-trigger')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '南山');
    await tester.pump();
    expect(find.text('广东省 / 深圳市 / 南山区'), findsOneWidget);
    await tester.tap(find.text('广东省 / 深圳市 / 南山区'));
    await tester.pumpAndSettle();
    expect(find.byType(TCascader), findsNothing);
    expect(find.text('广东省/深圳市/南山区'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('basic Cascader commits and closes after selecting a leaf', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, ThemeMode.light);

    await tester.tap(find.byKey(const ValueKey('cascader-base-trigger')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cascader-beijing')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cascader-beijing-city')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cascader-dongcheng')));
    await tester.pumpAndSettle();

    expect(find.byType(TCascader), findsNothing);
    expect(find.text('北京市/北京市/东城区'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
