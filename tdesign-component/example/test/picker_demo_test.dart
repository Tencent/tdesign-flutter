import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:tdesign_flutter_example/base/notification_center.dart';

import 'demo_page_test_utils.dart';
import 'picker_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(pickerDemoPageTestSpec);

  testWidgets('all Picker code panels expose the live controlled composition', (
    tester,
  ) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      pickerDemoPageTestSpec,
      ThemeMode.light,
    );
    await tester.pumpAndSettle();
    TNotification.postNotification('onApiVisibleChange', {'apiVisible': true});
    await tester.pumpAndSettle();
    for (var index = 0; index < 4; index++) {
      final entry = find.text('code').at(index);
      await tester.ensureVisible(entry);
      await tester.tap(entry);
      await tester.pumpAndSettle();
      final markdown = tester.widget<Markdown>(find.byType(Markdown));
      expect(markdown.data, contains('return TCell('));
      expect(markdown.data, contains('TPopup.show'));
      expect(markdown.data, contains('StatefulBuilder'));
      expect(markdown.data, contains('onConfirm(List<Object?>.of(draft))'));
      Navigator.of(tester.element(find.byType(Markdown))).pop();
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  for (final column in [0, 1, 2]) {
    testWidgets('area popup column $column keeps continuous drag and inertia', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        pickerDemoPageTestSpec,
        ThemeMode.light,
      );
      final trigger = find.byKey(const ValueKey('picker-area-trigger'));
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      final panel = find.byKey(const ValueKey('picker-area-panel'));
      final wheel = find.byType(ListWheelScrollView).at(column);
      final controller =
          tester.widget<ListWheelScrollView>(wheel).controller!
              as FixedExtentScrollController;
      final initial = List<Object?>.of(tester.widget<TPicker>(panel).value);
      final gesture = await tester.startGesture(tester.getCenter(wheel));
      await gesture.moveBy(const Offset(0, 30));
      await tester.pump();
      final firstOffset = controller.offset;
      final firstValue = tester.widget<TPicker>(panel).value[column];
      expect(firstValue, isNot(initial[column]));
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump();
      expect(
        tester.widget<ListWheelScrollView>(wheel).controller,
        same(controller),
      );
      expect(controller.offset, lessThan(firstOffset));
      expect(tester.widget<TPicker>(panel).value[column], isNot(firstValue));
      expect(
        tester.widget<TPicker>(panel).value.take(column),
        initial.take(column),
      );
      await gesture.up();
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(tester.widget<TPicker>(panel).value, initial);
      final flingController =
          tester.widget<ListWheelScrollView>(wheel).controller!
              as FixedExtentScrollController;
      await tester.fling(wheel, const Offset(0, 50), 600);
      await tester.pump(const Duration(milliseconds: 16));
      final releaseOffset = flingController.offset;
      await tester.pump(const Duration(milliseconds: 50));
      expect(
        tester.widget<ListWheelScrollView>(wheel).controller,
        same(flingController),
      );
      expect(flingController.offset, lessThan(releaseOffset));
      await tester.pumpAndSettle();
      final draft = List<Object?>.of(tester.widget<TPicker>(panel).value);
      expect(draft[column], isNot(initial[column]));
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      expect(tester.widget<TPicker>(panel).value, draft);
      expect(tester.takeException(), isNull);
      await disposeDemoPage(tester);
    }, tags: 'demo');
  }

  testWidgets('Picker popup preserves wheel height and centers selection', (
    tester,
  ) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      pickerDemoPageTestSpec,
      ThemeMode.light,
    );
    await tester.tap(find.byKey(const ValueKey('picker-city-trigger')));
    await tester.pumpAndSettle();
    final wheel = find.byType(ListWheelScrollView);
    expect(tester.getSize(wheel).height, 200);
    expect(tester.widget<ListWheelScrollView>(wheel).itemExtent, 40);
    final tokens = tester.element(wheel).tTheme;
    final highlight = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color ==
              tokens.bgColorSecondaryContainer,
    );
    expect(tester.getSize(highlight), const Size(343, 40));
    expect(tester.getCenter(highlight).dy, tester.getCenter(wheel).dy);
    final title = find.descendant(
      of: find.byType(TPopupHeader),
      matching: find.text('选择地区'),
    );
    final richTitle = find.descendant(
      of: title,
      matching: find.byType(RichText),
    );
    expect(
      tester.widget<RichText>(richTitle).text.style?.decoration,
      TextDecoration.none,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

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
