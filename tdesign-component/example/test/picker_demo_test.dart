import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'picker_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(pickerDemoPageTestSpec);

  testWidgets('picker drag drafts are cancelled or committed by the toolbar', (
    tester,
  ) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      pickerDemoPageTestSpec,
      ThemeMode.light,
    );
    final trigger = find.byKey(const ValueKey('picker-city-trigger'));
    String note() => tester
        .widgetList<Text>(
          find.descendant(of: trigger, matching: find.byType(Text)),
        )
        .map((text) => text.data ?? '')
        .join('|');
    final initial = note();
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(ListWheelScrollView).first,
      const Offset(0, 80),
    );
    await tester.pumpAndSettle();
    expect(note(), initial);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(note(), initial);
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(ListWheelScrollView).first,
      const Offset(0, 80),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(note(), isNot(initial));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Picker Demo follows the official trigger order', (tester) async {
    await pumpFullDemoPage(tester, pickerDemoPageTestSpec, ThemeMode.light);
    final keys = ['city', 'time', 'area', 'title', 'without-title'];
    final tops = keys
        .map(
          (id) =>
              tester.getTopLeft(find.byKey(ValueKey('picker-$id-trigger'))).dy,
        )
        .toList();
    expect(tops, orderedEquals([...tops]..sort()));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Picker popup title ownership stays in composition', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, pickerDemoPageTestSpec, ThemeMode.light);
    await tester.tap(find.byKey(const ValueKey('picker-title-trigger')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(TPopupHeader),
        matching: find.text('选择地区'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('picker-title-panel')), findsOneWidget);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('picker-without-title-trigger')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('picker-without-title-panel')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(TPopupHeader),
        matching: find.text('选择地区'),
      ),
      findsNothing,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Picker popup is controlled until confirm', (tester) async {
    await pumpFullDemoPage(tester, pickerDemoPageTestSpec, ThemeMode.light);
    final trigger = find.byKey(const ValueKey('picker-city-trigger'));
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('picker-city-panel'));
    tester.widget<TPicker>(panel).onChanged!(
      const TPickerValue(
        selectedOptions: [TPickerOption(label: '上海市', value: 'shanghai')],
        indexes: [1],
      ),
    );
    await tester.pump();
    expect(
      find.descendant(of: trigger, matching: find.text('深圳市')),
      findsOneWidget,
    );
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: trigger, matching: find.text('上海市')),
      findsOneWidget,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
