import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_date_time_picker_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TDateTimePickerPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<Finder> openPopup(
    WidgetTester tester,
    Key triggerKey,
  ) async {
    final trigger = find.byKey(triggerKey);
    final scrollableState =
        tester.state<ScrollableState>(find.byType(Scrollable).first);
    for (var index = 0; index < 5 && trigger.evaluate().isEmpty; index++) {
      scrollableState.position
          .jumpTo(scrollableState.position.maxScrollExtent);
      await tester.pumpAndSettle();
    }
    expect(trigger, findsOneWidget);
    await Scrollable.ensureVisible(
      tester.element(trigger),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    return trigger;
  }

  Future<void> openCalendarTimePopup(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    await openPopup(tester, const Key('calendar-time-trigger'));
  }

  testWidgets('内嵌示例保留滚动实时更新', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final inlinePicker = find.byType(TDateTimePicker).first;
    tester.widget<TDateTimePicker>(inlinePicker).onChanged!(
          const TDateTimePickerValue(
            year: 2027,
            month: 6,
            day: 20,
            hour: 13,
            minute: 45,
          ),
        );
    await tester.pump();

    expect(find.text('当前选择：2027-06-20 13:45'), findsOneWidget);
  });

  final popupCases = <({
    String name,
    Key triggerKey,
    String initial,
    TDateTimePickerValue draft,
    String committed,
    String golden,
  })>[
    (
      name: '年月日',
      triggerKey: const Key('date-time-picker-base-trigger'),
      initial: '2026-05-15 12:30',
      draft: const TDateTimePickerValue(year: 2027, month: 6, day: 20),
      committed: '2027-06-20',
      golden: 'date_time_picker_popup_date.png',
    ),
    (
      name: '年月',
      triggerKey: const Key('date-time-picker-year-month-trigger'),
      initial: '2026-05',
      draft: const TDateTimePickerValue(year: 2027, month: 6),
      committed: '2027-06',
      golden: 'date_time_picker_popup_month.png',
    ),
    (
      name: '时分',
      triggerKey: const Key('date-time-picker-time-trigger'),
      initial: '12:30',
      draft: const TDateTimePickerValue(hour: 13, minute: 45),
      committed: '13:45',
      golden: 'date_time_picker_popup_time.png',
    ),
    (
      name: '自定义范围',
      triggerKey: const Key('date-time-picker-range-trigger'),
      initial: '请选择',
      draft: const TDateTimePickerValue(
        year: 2026,
        month: 6,
        day: 20,
        hour: 13,
        minute: 10,
        second: 20,
      ),
      committed: '2026-06-20 13:10:20',
      golden: 'date_time_picker_popup_range.png',
    ),
    (
      name: '星期',
      triggerKey: const Key('date-time-picker-week-trigger'),
      initial: '2026-05-15 12:30 周五',
      draft: const TDateTimePickerValue(year: 2026, month: 5, day: 20),
      committed: '2026-05-20 周三',
      golden: 'date_time_picker_popup_week.png',
    ),
  ];

  for (final popupCase in popupCases) {
    testWidgets('${popupCase.name}弹窗取消丢弃草稿、确定后提交', (tester) async {
      configurePhone(tester);
      await tester.pumpWidget(buildPage());
      await tester.pump();

      final trigger = await openPopup(tester, popupCase.triggerKey);
      String committedValue() =>
          (tester.widget<TCell>(trigger).note! as Text).data!;
      expect(committedValue(), popupCase.initial);

      var wheel = find.byKey(const Key('date-time-picker-popup-wheel'));
      tester.widget<TDateTimePicker>(wheel).onChanged!(popupCase.draft);
      await tester.pump();
      expect(committedValue(), popupCase.initial);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(committedValue(), popupCase.initial);

      await openPopup(tester, popupCase.triggerKey);
      wheel = find.byKey(const Key('date-time-picker-popup-wheel'));
      tester.widget<TDateTimePicker>(wheel).onChanged!(popupCase.draft);
      await tester.pump();
      expect(committedValue(), popupCase.initial);

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(committedValue(), popupCase.committed);
      expect(tester.takeException(), isNull);
    });

    testWidgets('${popupCase.name}弹窗视觉快照', (tester) async {
      configurePhone(tester);
      await tester.pumpWidget(buildPage());
      await tester.pump();
      await openPopup(tester, popupCase.triggerKey);

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/${popupCase.golden}'),
      );
    });
  }

  testWidgets('日历与时间滚轮共用草稿并在确认后提交', (tester) async {
    configurePhone(tester);
    final semantics = tester.ensureSemantics();

    await openCalendarTimePopup(tester);

    final popup = find.byKey(const Key('calendar-time-popup'));
    final calendar = find.byKey(const Key('calendar-time-calendar'));
    final wheel = find.byKey(const Key('calendar-time-wheel'));
    expect(popup, findsOneWidget);
    expect(calendar, findsOneWidget);
    expect(wheel, findsOneWidget);
    final trigger = find.byKey(const Key('calendar-time-trigger'));
    String committedValue() =>
        (tester.widget<TCell>(trigger).note! as Text).data!;
    expect(committedValue(), '2026-05-15 12:30');

    await tester.tap(
      find
          .descendant(of: calendar, matching: find.text('20'))
          .hitTestable()
          .first,
    );
    await tester.pump();

    final hour = find.descendant(
      of: wheel,
      matching: find.bySemanticsLabel(RegExp('小时')),
    );
    final hourNode = tester.getSemantics(hour);
    hourNode.owner!.performAction(hourNode.id, SemanticsAction.increase);
    await tester.pumpAndSettle();

    expect(committedValue(), '2026-05-15 12:30');
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(committedValue(), '2026-05-20 13:30');
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('日历与时间滚轮复合弹窗视觉快照', (tester) async {
    configurePhone(tester);

    await openCalendarTimePopup(tester);

    await expectLater(
      find.byType(Overlay),
      matchesGoldenFile('goldens/date_time_picker_calendar_time.png'),
    );
  });
}
