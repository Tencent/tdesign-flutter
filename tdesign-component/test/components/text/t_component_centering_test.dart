import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_list.dart';
import 'package:tdesign_flutter/src/components/text/t_text_styled.dart';
import 'package:tdesign_flutter/src/theme/t_internal_material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  _lateBoundaryTests();
  _remainingGrowthTests();
  _pickerGrowthTests();
  _defaultSlotGrowthTests();
  _indexesGrowthTests();
  _calendarGrowthTests();
  _editorGrowthTests();
  setUpAll(() async {
    await (FontLoader('TDesignGoldenCJK')..addFont(
          File(
            'example/test/fonts/TDesignGoldenCJK-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    await (FontLoader('packages/tdesign_flutter/TCloudNumber')..addFont(
          File(
            'assets/tdesign/TCloudNumberVF.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    await (FontLoader('Roboto')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    await (FontLoader('TDesignAlignmentCJK')..addFont(
          File(
            'example/test/fonts/TDesignAlignmentCJK-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
  });

  for (final scale in [1.0, 1.5, 2.0]) {
    testWidgets('Tag centers its actual line across states at scale $scale', (
      tester,
    ) async {
      for (final size in TTagSize.values) {
        for (final variant in TTagVariant.values) {
          for (final enabled in [true, false]) {
            for (final icons in [false, true]) {
              const label = '标签 Ag8';
              await tester.pumpWidget(
                MaterialApp(
                  theme: ThemeData(
                    extensions: [
                      TThemeData.defaultData().copyWith(
                        fontFamilyMap: {
                          'fontFamily': FontFamily(
                            fontFamily: 'Roboto',
                            fallback: [
                              'TDesignAlignmentCJK',
                              'TDesignGoldenCJK',
                            ],
                          ),
                        },
                      ),
                    ],
                  ),
                  home: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: Scaffold(
                      body: Center(
                        child: TTag(
                          label,
                          size: size,
                          variant: variant,
                          enabled: enabled,
                          icon: icons ? Icons.add : null,
                          needCloseIcon: icons,
                        ),
                      ),
                    ),
                  ),
                ),
              );
              final paragraph = tester.renderObject<RenderParagraph>(
                find.text(label),
              );
              final boxes = paragraph.getBoxesForSelection(
                const TextSelection(baseOffset: 0, extentOffset: label.length),
                boxHeightStyle: ui.BoxHeightStyle.max,
              );
              final line = boxes
                  .map((b) => b.toRect())
                  .reduce((a, b) => a.expandToInclude(b));
              final tag = tester.getRect(find.byType(TTag));
              final center = paragraph.localToGlobal(line.center);
              expect(
                center.dy,
                closeTo(tag.center.dy, 0.01),
                reason: '$size $variant enabled=$enabled icons=$icons',
              );
              expect(
                paragraph.size.height,
                greaterThanOrEqualTo(line.height - 0.01),
                reason: 'The actual line must fit, not just its render box',
              );
              expect(tester.takeException(), isNull);
            }
          }
        }
      }
    });
  }
  for (final scale in [1.0, 1.5, 2.0]) {
    testWidgets('Badge centers rendered text across shapes at scale $scale', (
      tester,
    ) async {
      for (final variant in [
        TBadgeVariant.circle,
        TBadgeVariant.square,
        TBadgeVariant.bubble,
      ]) {
        for (final size in TBadgeSize.values) {
          for (final border in [false, true]) {
            for (final label in ['8', '99+', 'NEW', '徽标', 'long Ag8']) {
              await tester.pumpWidget(
                MaterialApp(
                  theme: ThemeData(
                    extensions: [
                      TThemeData.defaultData().copyWith(
                        fontFamilyMap: {
                          'fontFamily': FontFamily(
                            fontFamily: 'Roboto',
                            fallback: [
                              'TDesignAlignmentCJK',
                              'TDesignGoldenCJK',
                            ],
                          ),
                        },
                      ),
                    ],
                  ),
                  home: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: Scaffold(
                      body: Center(
                        child: TBadge(
                          label: label,
                          size: size,
                          variant: variant,
                          border: border,
                        ),
                      ),
                    ),
                  ),
                ),
              );
              final paragraph = tester.renderObject<RenderParagraph>(
                find.text(label),
              );
              final boxes = paragraph.getBoxesForSelection(
                TextSelection(baseOffset: 0, extentOffset: label.length),
                boxHeightStyle: ui.BoxHeightStyle.max,
              );
              final line = boxes
                  .map((b) => b.toRect())
                  .reduce((a, b) => a.expandToInclude(b));
              final badge = tester.getRect(find.byType(TBadge));
              final center = paragraph.localToGlobal(line.center);
              // Font ascent/descent are rounded by the engine; first assert the
              // actual transformed layout center exactly, then bound metric rounding.
              final layoutCenter = paragraph.localToGlobal(
                paragraph.size.center(Offset.zero),
              );
              expect(layoutCenter.dy, closeTo(badge.center.dy, 0.01));
              expect(
                center.dy,
                closeTo(badge.center.dy, 0.5),
                reason: '$variant $size border=$border label=$label',
              );
              final top = paragraph.localToGlobal(line.topLeft).dy;
              final bottom = paragraph.localToGlobal(line.bottomRight).dy;
              expect(top, greaterThanOrEqualTo(badge.top - 0.01));
              expect(bottom, lessThanOrEqualTo(badge.bottom + 0.01));
              expect(tester.takeException(), isNull);
            }
          }
        }
      }
    });
  }
  for (final scale in [1.0, 1.5, 2.0]) {
    testWidgets(
      'Switch actual text fits and centers in every thumb state $scale',
      (tester) async {
        for (final size in TSwitchSize.values) {
          for (final value in [true, false]) {
            for (final enabled in [true, false]) {
              await tester.pumpWidget(
                MaterialApp(
                  theme: ThemeData(
                    extensions: [
                      TThemeData.defaultData().copyWith(
                        fontFamilyMap: {
                          'fontFamily': FontFamily(fontFamily: 'Roboto'),
                        },
                      ),
                    ],
                  ),
                  home: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: Scaffold(
                      body: Center(
                        child: TSwitch(
                          value: value,
                          size: size,
                          variant: TSwitchVariant.text,
                          onChanged: enabled ? (_) {} : null,
                          openText: 'I',
                          closeText: 'l',
                        ),
                      ),
                    ),
                  ),
                ),
              );
              await tester.pumpAndSettle();
              final label = value ? 'I' : 'l';
              final paragraph = tester.renderObject<RenderParagraph>(
                find.text(label),
              );
              final line = paragraph
                  .getBoxesForSelection(
                    TextSelection(baseOffset: 0, extentOffset: label.length),
                    boxHeightStyle: ui.BoxHeightStyle.max,
                  )
                  .map((b) => b.toRect())
                  .reduce((a, b) => a.expandToInclude(b));
              final control = tester.getRect(find.byType(TSwitch));
              expect(
                paragraph.localToGlobal(line.center).dy,
                closeTo(control.center.dy, 0.5),
                reason: '$size $value $enabled',
              );
              expect(
                paragraph.size.height,
                greaterThanOrEqualTo(line.height - 0.01),
              );
              expect(tester.takeException(), isNull);
            }
          }
        }
      },
    );
  }
  testWidgets(
    'constrained TD labels center their real lines without changing typography',
    (tester) async {
      for (final leading in TextLeadingDistribution.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [TThemeData.defaultData()]),
            home: const SizedBox.shrink(),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [TThemeData.defaultData()]),
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  key: const Key('slot'),
                  width: 120,
                  height: 10,
                  child: TTextStyled(
                    'Ag8',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18,
                      height: 2,
                      leadingDistribution: leading,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text('Ag8'),
        );
        final line = paragraph
            .getBoxesForSelection(
              const TextSelection(baseOffset: 0, extentOffset: 3),
              boxHeightStyle: ui.BoxHeightStyle.max,
            )
            .map((b) => b.toRect())
            .reduce((a, b) => a.expandToInclude(b));
        expect(paragraph.size.height, greaterThanOrEqualTo(line.height - 0.01));
        expect(
          paragraph.localToGlobal(line.center).dy,
          closeTo(tester.getRect(find.byKey(const Key('slot'))).center.dy, 0.5),
        );
        final native = tester.widget<Text>(find.text('Ag8'));
        expect(native.style!.fontSize, 18);
        expect(native.style!.height, 2);
        expect(native.style!.leadingDistribution, leading);
        expect(tester.takeException(), isNull);
      }
    },
  );
  testWidgets(
    'explicit height behavior controls actual baseline, not just stored fields',
    (tester) async {
      const behavior = TextHeightBehavior(
        leadingDistribution: TextLeadingDistribution.proportional,
      );
      for (final viaTheme in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              extensions: [
                TThemeData.defaultData(),
                if (viaTheme)
                  const TTextThemeData(textHeightBehavior: behavior),
              ],
            ),
            home: Scaffold(
              body: Center(
                child: TTextStyled(
                  'Ag8',
                  style: const TextStyle(fontFamily: 'Roboto'),
                  maxLines: 1,
                  textHeightBehavior: viaTheme ? null : behavior,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final native = tester.widget<Text>(find.text('Ag8'));
        expect(native.style!.leadingDistribution, isNull);
        expect(native.textHeightBehavior, behavior);
        final painter = TextPainter(
          text: TextSpan(text: native.data, style: native.style),
          textDirection: TextDirection.ltr,
          textHeightBehavior: behavior,
        )..layout();
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text('Ag8'),
        );
        expect(
          paragraph.getDryBaseline(
            paragraph.constraints,
            TextBaseline.alphabetic,
          ),
          closeTo(painter.computeLineMetrics().single.baseline, 0.01),
        );
        painter.dispose();
      }
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              TThemeData.defaultData(),
              const TTextThemeData(textHeightBehavior: behavior),
            ],
          ),
          home: const Scaffold(
            body: Center(child: TBadge(label: '8')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.text('8')).textHeightBehavior, behavior);
    },
  );
}

void _pickerGrowthTests() {
  testWidgets('picker growth uses the final explicit TD text typography', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            const TTextThemeData(textStyle: TextStyle(fontSize: 50, height: 2)),
          ],
        ),
        home: Scaffold(
          body: TPicker(
            items: const TPickerColumns([
              [TPickerOption(label: 'Ag8', value: 1)],
            ]),
            value: const [1],
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final text = tester.widget<Text>(find.text('Ag8'));
    expect(text.style!.fontSize, 50);
    expect(text.style!.height, 2);
    final wheel = tester.widget<ListWheelScrollView>(
      find.byType(ListWheelScrollView),
    );
    expect(wheel.itemExtent, greaterThanOrEqualTo(100));
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'default picker grows and resizing retains selection without callbacks',
    (tester) async {
      var callbacks = 0;
      const items = TPickerColumns([
        [
          TPickerOption(label: 'A', value: 0),
          TPickerOption(label: 'B', value: 1),
          TPickerOption(label: 'C', value: 2),
          TPickerOption(label: 'D', value: 3),
        ],
      ]);
      Widget page(
        double scale, {
        double? height,
        TPickerItemBuilder? builder,
      }) => MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            if (height != null) TPickerThemeData(height: height),
          ],
        ),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: TPicker(
                items: items,
                value: const [2],
                onChanged: (_) => callbacks++,
                itemBuilder: builder,
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page(1));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TPicker)).height, 200);
      final scrollable = find.byType(ListWheelScrollView);
      expect(
        tester
            .widget<ListWheelScrollView>(scrollable)
            .controller!
            .position
            .pixels,
        80,
      );
      await tester.pumpWidget(page(3));
      await tester.pumpAndSettle();
      final enlarged = tester.getSize(find.byType(TPicker)).height;
      expect(enlarged, greaterThan(200));
      final wheel = tester.widget<ListWheelScrollView>(scrollable);
      expect(
        wheel.controller!.position.pixels / wheel.itemExtent,
        closeTo(2, .001),
      );
      expect(callbacks, 0);
      await tester.drag(scrollable, const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(callbacks, greaterThan(0));
      await tester.pumpWidget(page(3, height: 200));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TPicker)).height, 200);
      await tester.pumpWidget(
        page(3, builder: (_, option, __, ___, ____) => Text(option.label)),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TPicker)).height, 200);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'default date time picker grows but explicit height remains fixed',
    (tester) async {
      Widget page({double? height}) => MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            if (height != null) TPickerThemeData(height: height),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: TDateTimePicker(
                value: const TDateTimePickerValue(month: 10, day: 14),
                mode: DateTimePickerMode(dateMode: DateMode.monthDay),
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(TDateTimePicker)).height,
        greaterThan(200),
      );
      await tester.pumpWidget(page(height: 220));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TDateTimePicker)).height, 220);
      expect(tester.takeException(), isNull);
    },
  );
}

void _defaultSlotGrowthTests() {
  Widget page(
    Widget child, {
    double scale = 3,
    List<ThemeExtension<dynamic>> extra = const [],
  }) => MaterialApp(
    theme: ThemeData(extensions: [TThemeData.defaultData(), ...extra]),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(body: Center(child: child)),
    ),
  );
  testWidgets(
    'default text switch grows while explicit size and native toggling remain',
    (tester) async {
      var value = true;
      var changes = 0;
      await tester.pumpWidget(
        page(
          StatefulBuilder(
            builder: (_, setState) => TSwitch(
              value: value,
              variant: TSwitchVariant.text,
              onChanged: (next) => setState(() {
                value = next;
                changes++;
              }),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final size = tester.getSize(find.byType(TSwitch));
      expect(size.height, greaterThan(28));
      await tester.tap(find.byType(TSwitch));
      await tester.pumpAndSettle();
      expect(value, isFalse);
      expect(changes, 1);
      expect(tester.getSize(find.byType(TSwitch)), size);
      await tester.pumpWidget(
        page(
          TSwitch(
            value: true,
            variant: TSwitchVariant.text,
            size: TSwitchSize.medium,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TSwitch)).height, 28);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'steps serial number naturally lays out inside the grown marker in both directions',
    (tester) async {
      for (final direction in TStepsDirection.values) {
        for (final status in TStepsStatus.values) {
          await tester.pumpWidget(
            page(
              TSteps.progress(
                steps: const [
                  TStepsItemData(title: 'Ag8'),
                  TStepsItemData(title: 'Label'),
                ],
                value: 0,
                direction: direction,
                status: status,
              ),
            ),
          );
          await tester.pumpAndSettle();
          final paragraph = tester.renderObject<RenderParagraph>(
            find.text('2'),
          );
          final line = paragraph
              .getBoxesForSelection(
                const TextSelection(baseOffset: 0, extentOffset: 1),
                boxHeightStyle: ui.BoxHeightStyle.max,
              )
              .single
              .toRect();
          expect(paragraph.size.height, greaterThanOrEqualTo(line.height - .5));
          var marker = paragraph.parent;
          while (marker != null && marker is! RenderDecoratedBox) {
            marker = marker.parent;
          }
          final box = marker! as RenderDecoratedBox;
          expect(box.size.height, greaterThan(22));
          expect(
            paragraph.localToGlobal(line.center).dy,
            closeTo(box.localToGlobal(box.size.center(Offset.zero)).dy, .5),
          );
          expect(tester.takeException(), isNull);
        }
      }
    },
  );
  testWidgets(
    'time counter default blocks grow, explicit size and controller remain available',
    (tester) async {
      for (final variant in [
        TTimeCounterVariant.round,
        TTimeCounterVariant.square,
      ]) {
        await tester.pumpWidget(
          page(
            TTimeCounter(
              time: 5000,
              format: 'ss',
              variant: variant,
              autoStart: false,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final paragraph = tester.renderObject<RenderParagraph>(find.text('05'));
        var marker = paragraph.parent;
        while (marker != null && marker is! RenderDecoratedBox) {
          marker = marker.parent;
        }
        expect((marker! as RenderDecoratedBox).size.height, greaterThan(24));
        await tester.pumpWidget(
          page(
            TTimeCounter(
              time: 5000,
              format: 'ss',
              size: TTimeCounterSize.medium,
              variant: variant,
              autoStart: false,
            ),
          ),
        );
        await tester.pumpAndSettle();
        marker = tester.renderObject<RenderParagraph>(find.text('05')).parent;
        while (marker != null && marker is! RenderDecoratedBox) {
          marker = marker.parent;
        }
        expect((marker! as RenderDecoratedBox).size.height, 24);
        expect(tester.takeException(), isNull);
      }
    },
  );
  testWidgets(
    'automatic progress label grows its default track, explicit TD stroke stays fixed',
    (tester) async {
      for (final button in [false, true]) {
        final progress = button
            ? TProgress.button(value: .5)
            : TProgress.plump(value: .5);
        await tester.pumpWidget(page(progress));
        await tester.pumpAndSettle();
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text('50%'),
        );
        final line = paragraph
            .getBoxesForSelection(
              const TextSelection(baseOffset: 0, extentOffset: 3),
              boxHeightStyle: ui.BoxHeightStyle.max,
            )
            .map((b) => b.toRect())
            .reduce((a, b) => a.expandToInclude(b));
        expect(paragraph.size.height, greaterThanOrEqualTo(line.height - .5));
        expect(
          tester.getSize(find.byType(TProgress)).height,
          greaterThan(button ? 40 : 20),
        );
        await tester.pumpWidget(
          page(progress, extra: [const TProgressThemeData(strokeWidth: 20)]),
        );
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byType(TProgress)).height, 20);
        expect(tester.takeException(), isNull);
      }
    },
  );
}

void _indexesGrowthTests() {
  testWidgets(
    'overflowing index strip scrolls without selecting, then tap selects the visible item',
    (tester) async {
      final active = ValueNotifier('A');
      addTearDown(active.dispose);
      var callbacks = 0;
      Widget page({
        double scale = 3,
        int count = 26,
        double height = 250,
        TIndexesThemeData? theme,
      }) => MaterialApp(
        theme: ThemeData(
          extensions: [TThemeData.defaultData(), if (theme != null) theme],
        ),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: height,
                child: Stack(
                  children: [
                    TIndexesList(
                      indexList: List.generate(
                        count,
                        (i) => String.fromCharCode(65 + i),
                      ),
                      activeIndex: active,
                      onSelect: (_, __) => callbacks++,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      final scroller = find.byType(SingleChildScrollView);
      expect(scroller, findsOneWidget);
      final controller = tester
          .widget<SingleChildScrollView>(scroller)
          .controller!;
      await tester.drag(scroller, const Offset(0, -130));
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(0));
      expect(callbacks, 0);
      expect(active.value, 'A');
      final visible = find.byType(Text).evaluate().where((e) {
        final box = e.renderObject! as RenderBox;
        final y = box.localToGlobal(box.size.center(Offset.zero)).dy;
        final view = tester.getRect(scroller);
        return y > view.top + 30 && y < view.bottom - 30;
      }).first;
      final letter = (visible.widget as Text).data!;
      await tester.tap(find.byWidget(visible.widget));
      await tester.pump();
      expect(active.value, letter);
      expect(callbacks, 1);
      active.value = 'Z';
      await tester.pumpAndSettle();
      expect(controller.offset, greaterThan(130));
      await tester.pumpWidget(page(scale: 3, height: 180));
      await tester.pumpAndSettle();
      final viewport = tester.getRect(scroller);
      final activeRect = tester.getRect(find.text('Z'));
      expect(activeRect.top, greaterThanOrEqualTo(viewport.top));
      expect(activeRect.bottom, lessThanOrEqualTo(viewport.bottom + .01));
      expect(callbacks, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(page(scale: 1, count: 2));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsNothing);
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(active.value, 'B');
      expect(callbacks, 2);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('A').last),
      );
      await gesture.moveTo(tester.getCenter(find.text('B').last));
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.text('A').last));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(active.value, 'A');
      expect(callbacks, greaterThan(2));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'index strip preserves explicit TD slots and custom content theme',
    (tester) async {
      final active = ValueNotifier('A');
      addTearDown(active.dispose);
      final font = Font(size: 18, lineHeight: 24);
      Widget page({bool custom = false}) => MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.purple),
          ),
          extensions: [
            TThemeData.defaultData(),
            TIndexesThemeData(
              indexItemSize: 20,
              tipSize: 40,
              indexFont: font,
              activeIndexFont: font,
              indexColor: Colors.orange,
            ),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Scaffold(
            body: SizedBox(
              height: 200,
              child: Stack(
                children: [
                  TIndexesList(
                    indexList: const ['A', 'B'],
                    activeIndex: active,
                    onSelect: (_, __) {},
                    builderIndex: custom
                        ? (context, index, _) => Text(
                            'custom $index',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.text('B'));
      expect(text.style!.fontSize, 18);
      expect(text.style!.color, Colors.orange);
      final slot = find
          .ancestor(
            of: find.text('B'),
            matching: find.byWidgetPredicate(
              (w) => w is Container && w.constraints?.maxHeight == 20,
            ),
          )
          .first;
      expect(tester.getSize(slot).height, 20);
      expect(find.byType(SingleChildScrollView), findsNothing);
      await tester.pumpWidget(page(custom: true));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('custom A')).style!.color,
        Colors.purple,
      );
      final customSlot = find
          .ancestor(
            of: find.text('custom A'),
            matching: find.byWidgetPredicate(
              (w) => w is SizedBox && w.height == 20,
            ),
          )
          .first;
      expect(tester.getSize(customSlot).height, 20);
      expect(tester.takeException(), isNull);
    },
  );
}

void _calendarGrowthTests() {
  testWidgets(
    'calendar wraps default month and weekday labels without clamping their real paragraphs',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [TThemeData.defaultData()]),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(3)),
            child: Scaffold(
              body: SizedBox(
                width: 320,
                child: TCalendar(
                  weekdayNames: const [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ],
                  value: [DateTime(2026, 10, 14)],
                  minDate: DateTime(2026, 10, 1),
                  maxDate: DateTime(2026, 10, 31),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final text in ['Sun', 'Wed']) {
        final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
        final boxes = paragraph.getBoxesForSelection(
          TextSelection(baseOffset: 0, extentOffset: text.length),
          boxHeightStyle: ui.BoxHeightStyle.max,
        );
        final bounds = boxes
            .map((b) => b.toRect())
            .reduce((a, b) => a.expandToInclude(b));
        expect(paragraph.size.height, greaterThanOrEqualTo(bounds.height - .5));
        final clip = tester.getRect(find.text(text));
        expect(clip.height, greaterThan(46));
      }
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('calendar default month title keeps explicit TD typography', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            const TCalendarThemeData(
              monthTitleStyle: TextStyle(
                fontSize: 28,
                height: 2,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        home: Scaffold(
          body: TCalendar(
            value: [DateTime(2026, 10, 14)],
            minDate: DateTime(2026, 10, 1),
            maxDate: DateTime(2026, 10, 31),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final native = tester.widget<Text>(find.textContaining('2026').first);
    expect(native.style!.fontSize, 28);
    expect(native.style!.height, 2);
    expect(native.style!.color, Colors.purple);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'calendar grows built-in date slots and viewport but retains explicit TD cell heights',
    (tester) async {
      var changes = 0;
      Widget page(double scale, {double? cellHeight}) => MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            if (cellHeight != null) TCalendarThemeData(cellHeight: cellHeight),
          ],
        ),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: TCalendar(
              value: [DateTime(2026, 10, 14)],
              minDate: DateTime(2026, 10, 1),
              maxDate: DateTime(2026, 10, 31),
              onChanged: (_) => changes++,
            ),
          ),
        ),
      );
      await tester.pumpWidget(page(1));
      await tester.pumpAndSettle();
      final initialHeight = tester.getSize(find.byType(TCalendar)).height;
      await tester.pumpWidget(page(3));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(TCalendar)).height,
        greaterThan(initialHeight),
      );
      final paragraph = tester.renderObject<RenderParagraph>(find.text('14'));
      var marker = paragraph.parent;
      while (marker != null && marker is! RenderDecoratedBox) {
        marker = marker.parent;
      }
      expect((marker! as RenderDecoratedBox).size.height, greaterThan(60));
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(changes, 1);
      await tester.pumpWidget(page(3, cellHeight: 60));
      await tester.pumpAndSettle();
      marker = tester.renderObject<RenderParagraph>(find.text('14')).parent;
      while (marker != null && marker is! RenderDecoratedBox) {
        marker = marker.parent;
      }
      expect((marker! as RenderDecoratedBox).size.height, 60);
      expect(tester.takeException(), isNull);
    },
  );
}

void _editorGrowthTests() {
  testWidgets(
    'search grows its editor and hint while explicit height and editing remain',
    (tester) async {
      final controller = TextEditingController(text: 'Ag8');
      addTearDown(controller.dispose);
      Widget page({double? height}) => MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            if (height != null) TSearchBarThemeData(height: height),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Scaffold(
            body: Center(
              child: TSearchBar(
                controller: controller,
                hintText: 'Search',
                actionText: 'Cancel',
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      final editor = tester.allRenderObjects.whereType<RenderEditable>().single;
      expect(tester.getSize(find.byType(TSearchBar)).height, greaterThan(40));
      expect(
        editor.size.height,
        greaterThanOrEqualTo(editor.preferredLineHeight - .5),
      );
      await tester.enterText(find.byType(TextField), 'Ag8 input');
      expect(controller.text, 'Ag8 input');
      await tester.pumpWidget(page(height: 40));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TSearchBar)).height, 40);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'stepper default grows real editor and keeps fixed TD dimensions and value interaction',
    (tester) async {
      var value = 12;
      Widget page({bool fixed = false}) => MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            if (fixed) const TStepperThemeData(controlSize: 24, inputWidth: 38),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (_, setState) => TStepper(
                  value: value,
                  onChanged: (next) => setState(() => value = next.toInt()),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(page());
      await tester.pumpAndSettle();
      final editor = tester.allRenderObjects.whereType<RenderEditable>().single;
      expect(tester.getSize(find.byType(TStepper)).height, greaterThan(24));
      expect(
        editor.size.height,
        greaterThanOrEqualTo(editor.preferredLineHeight - .5),
      );
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, '12');
      await tester.enterText(find.byType(EditableText), '25');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(value, 25);
      await tester.pumpWidget(page(fixed: true));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TStepper)).height, 24);
      expect(
        tester.getSize(find.byType(EditableText)).width,
        lessThanOrEqualTo(38),
      );
      expect(tester.takeException(), isNull);
    },
  );
}

void _remainingGrowthTests() {
  Widget host(Widget child, {List<ThemeExtension<dynamic>> extra = const []}) =>
      MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData(), ...extra]),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(800, 600),
            textScaler: TextScaler.linear(3),
          ),
          child: Scaffold(body: child),
        ),
      );
  testWidgets(
    'card groups grow with natural multiline TD labels and retain controlled selection',
    (tester) async {
      List<String>? checked;
      await tester.pumpWidget(
        host(
          TCheckboxGroup<String>(
            value: const [],
            cardMode: true,
            options: const [
              TCheckboxOption(
                value: 'a',
                label: '真实居中 Ag8',
                subTitle: '说明 Ag8',
              ),
            ],
            onChanged: (value) => checked = value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final checkbox = find.byType(TCheckboxGroup<String>);
      expect(tester.getSize(checkbox).height, greaterThan(84));
      await tester.tap(find.text('真实居中 Ag8'));
      await tester.pump();
      expect(checked, ['a']);
      expect(tester.takeException(), isNull);
      String? selected;
      await tester.pumpWidget(
        host(
          TRadioGroup<String>(
            value: 'b',
            onChanged: (value) => selected = value,
            child: const TRadio<String>(
              value: 'a',
              variant: TRadioVariant.card,
              title: '真实居中 Ag8',
              subTitle: '说明 Ag8',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('真实居中 Ag8'));
      await tester.pump();
      expect(selected, 'a');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'explicit textarea viewport reserves the scaled counter and retains native editing',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        host(
          SizedBox(
            height: 128,
            child: TTextarea(
              controller: controller,
              maxLength: 20,
              indicator: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Ag8\n第二行');
      await tester.pumpAndSettle();
      expect(controller.text, 'Ag8\n第二行');
      expect(tester.getSize(find.byType(TTextarea)).height, 128);
      final counter = tester
          .widgetList<Text>(find.byType(Text))
          .firstWhere((w) => w.data?.contains('/20') ?? false);
      expect(
        tester.getRect(find.byWidget(counter)).bottom,
        lessThanOrEqualTo(tester.getRect(find.byType(TTextarea)).bottom),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'textarea preserves the focused native editor across ordinary viewport resizing',
    (tester) async {
      final controller = TextEditingController(text: 'Ag8');
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      Widget page(double height) => host(
        SizedBox(
          height: height,
          child: TTextarea(
            label: '标签文字',
            layout: TTextareaLayout.vertical,
            controller: controller,
            focusNode: focus,
            minLines: 2,
            maxLength: 500,
            indicator: true,
          ),
        ),
      );
      await tester.pumpWidget(page(400));
      await tester.pumpAndSettle();
      await tester.showKeyboard(find.byType(TextField));
      final editor = tester.state(find.byType(TextField));
      final selection = controller.selection;
      await tester.pumpWidget(page(260));
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(TextField)), same(editor));
      expect(focus.hasFocus, isTrue);
      expect(controller.text, 'Ag8');
      expect(controller.selection, selection);
      expect(tester.getSize(find.byType(TTextarea)).height, 260);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'upload default grid grows for owned labels while explicit TD size and file tap stay active',
    (tester) async {
      const file = TUploadFile(
        id: 'centering-file',
        name: 'document.txt',
        status: TUploadFileStatus.uploading,
        progress: .5,
      );
      var tapped = 0;
      Widget upload() => TUpload(
        files: const [file],
        onChanged: (_) {},
        onFileTap: (_) => tapped++,
      );
      await tester.pumpWidget(host(upload()));
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('upload-file-centering-file')))
            .height,
        greaterThan(80),
      );
      await tester.tap(
        find.byKey(const ValueKey('upload-status-centering-file')),
      );
      await tester.pump();
      expect(tapped, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        host(
          upload(),
          extra: const [
            TUploadThemeData(
              itemSize: 80,
              statusTextStyle: TextStyle(color: Colors.purple),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('upload-file-centering-file')))
            .height,
        80,
      );
      final label = tester.widget<Text>(find.text('50%'));
      expect(label.style!.color, Colors.purple);
      expect(
        label.style!.fontSize,
        TThemeData.defaultData().fontBodySmall!.size,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'calendar default month keeps public TD typography while explicit month style wins',
    (tester) async {
      final date = DateTime(2026, 10, 1);
      Widget calendar() => TCalendar(
        value: [date],
        minDate: date,
        maxDate: DateTime(2026, 10, 31),
        onChanged: (_) {},
      );
      await tester.pumpWidget(host(calendar()));
      await tester.pumpAndSettle();
      final title = tester
          .widgetList<Text>(find.byType(Text))
          .firstWhere((w) => w.data?.contains('2026') ?? false);
      final expected = TThemeData.defaultData().fontBodyMedium!;
      expect(title.style!.fontSize, expected.size);
      expect(title.style!.fontWeight, expected.fontWeight);
      await tester.pumpWidget(
        host(
          calendar(),
          extra: const [
            TCalendarThemeData(
              monthTitleStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 2,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      final explicit = tester
          .widgetList<Text>(find.byType(Text))
          .firstWhere((w) => w.data?.contains('2026') ?? false);
      expect(explicit.style!.fontSize, 24);
      expect(explicit.style!.fontWeight, FontWeight.w700);
      expect(explicit.style!.color, Colors.purple);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'ActionSheet grows default labels but keeps explicit grid extent and native selection',
    (tester) async {
      var selected = -1;
      final items = [
        const TActionSheetItem(
          value: 0,
          label: 'disabled',
          disabled: true,
          icon: Icon(Icons.add),
        ),
        const TActionSheetItem(
          value: 1,
          label: 'Ag8',
          textStyle: TextStyle(fontSize: 30, height: 2),
          icon: Icon(Icons.add),
        ),
      ];
      await tester.pumpWidget(
        host(
          TActionSheetGrid(
            items: items,
            showCancel: false,
            onSelected: (item) => selected = item.value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      final itemWidth =
          tester.getSize(find.byType(GridView)).width / delegate.crossAxisCount;
      expect(
        itemWidth / delegate.childAspectRatio,
        greaterThanOrEqualTo(180 + 40),
      );
      await tester.tap(find.text('disabled'));
      await tester.pump();
      expect(selected, -1);
      await tester.tap(find.text('Ag8'));
      await tester.pumpAndSettle();
      expect(selected, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(
        host(TActionSheetGrid(items: items, itemHeight: 96, showCancel: false)),
      );
      await tester.pumpAndSettle();
      final explicit =
          tester.widget<GridView>(find.byType(GridView)).gridDelegate
              as SliverGridDelegateWithFixedCrossAxisCount;
      expect(
        tester.getSize(find.byType(GridView)).width /
            explicit.crossAxisCount /
            explicit.childAspectRatio,
        96,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        host(
          const TActionSheetList(
            items: [
              TActionSheetItem(value: 2, label: 'Ag8', subtitle: '说明 Ag8'),
            ],
            showCancel: false,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final label = tester.getRect(find.text('Ag8'));
      final subtitle = tester.getRect(find.text('说明 Ag8'));
      expect(subtitle.top, greaterThanOrEqualTo(label.bottom));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Refresh grows only default trigger and preserves explicit native thresholds',
    (tester) async {
      await tester.pumpWidget(
        host(
          TPullDownRefresh(
            onRefresh: () async {},
            child: ListView(children: const [Text('content')]),
          ),
        ),
      );
      await tester.pump();
      final grown = tester
          .widget<EasyRefresh>(find.byType(EasyRefresh))
          .header!;
      expect(grown.triggerOffset, greaterThanOrEqualTo(66));
      await tester.pumpWidget(
        host(
          TPullDownRefresh(
            loadingBarHeight: 50,
            maxBarHeight: 80,
            onRefresh: () async {},
            child: ListView(children: const [Text('content')]),
          ),
        ),
      );
      await tester.pump();
      final fixed = tester
          .widget<EasyRefresh>(find.byType(EasyRefresh))
          .header!;
      expect(fixed.triggerOffset, 50);
      expect(fixed.maxOverOffset, 80);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

void _lateBoundaryTests() {
  Widget page(Widget child, {List<ThemeExtension<dynamic>> extra = const []}) =>
      MaterialApp(
        themeAnimationDuration: Duration.zero,
        theme: ThemeData(extensions: [TThemeData.defaultData(), ...extra]),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: Scaffold(body: Center(child: child)),
        ),
      );
  testWidgets(
    'circular owned percentage grows but explicit diameter and opaque label remain',
    (tester) async {
      await tester.pumpWidget(page(TProgress.circular(value: 1)));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TProgress)).width, greaterThan(112));
      final rect = tester.getRect(find.text('100%'));
      final circle = tester.getRect(find.byType(TProgress));
      expect(circle.contains(rect.topLeft), isTrue);
      expect(circle.contains(rect.bottomRight), isTrue);
      await tester.pumpWidget(
        page(
          TProgress.circular(value: 1),
          extra: [const TProgressThemeData(circleSize: 112)],
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('progress-circle-inner')))
            .width,
        100,
      );
      await tester.pumpWidget(
        page(
          TProgress.circular(
            value: 1,
            label: const Text(
              'custom',
              style: TextStyle(fontSize: 7, color: Colors.purple),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('progress-circle-inner')))
            .width,
        100,
      );
      expect(
        tester.widget<Text>(find.text('custom')).style!.color,
        Colors.purple,
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'narrow calendar dates retain every wrapped line in the real cell',
    (tester) async {
      await tester.pumpWidget(
        page(
          SizedBox(
            width: 375,
            child: TCalendar(
              minDate: DateTime(2022, 2, 1),
              maxDate: DateTime(2022, 2, 28),
              value: [DateTime(2022, 2, 9)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final paragraph = tester.renderObject<RenderParagraph>(find.text('22'));
      final boxes = paragraph.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 2),
        boxHeightStyle: ui.BoxHeightStyle.max,
      );
      final full = boxes
          .map((b) => b.toRect())
          .reduce((a, b) => a.expandToInclude(b));
      expect(paragraph.size.height, greaterThanOrEqualTo(full.height - .5));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'sidebar reveals distant large text selection without emitting a value change',
    (tester) async {
      var callbacks = 0;
      var selected = 0;
      late StateSetter update;
      await tester.pumpWidget(
        page(
          StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return SizedBox(
                width: 103,
                height: 200,
                child: TSideBar(
                  value: selected,
                  onChanged: (_) => callbacks++,
                  children: List.generate(
                    40,
                    (i) => TSideBarItem(value: i, label: '项目 $i'),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      update(() => selected = 39);
      await tester.pumpAndSettle();
      expect(find.text('项目 39').hitTestable(), findsOneWidget);
      expect(callbacks, 0);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'fixed native hint viewport keeps natural paragraph without changing explicit style',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        page(
          SizedBox(
            width: 180,
            height: 28,
            child: TInternalInputHint(
              controller: controller,
              multiline: true,
              hintText: 'hint Ag8',
              hintStyle: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.purple,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );
      final paragraph = tester.renderObject<RenderParagraph>(
        find.text('hint Ag8'),
      );
      expect(paragraph.size.height, greaterThan(28));
      expect(tester.getSize(find.byType(TInternalInputHint)).height, 28);
      expect(tester.widget<Text>(find.text('hint Ag8')).style!.fontSize, 16);
      expect(
        tester.widget<Text>(find.text('hint Ag8')).style!.color,
        Colors.purple,
      );
      controller.text = 'value';
      await tester.pump();
      expect(find.text('hint Ag8'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Input retains native editing state across ordinary width changes',
    (tester) async {
      final controller = TextEditingController();
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      var width = 240.0;
      late StateSetter update;
      await tester.pumpWidget(
        page(
          StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return SizedBox(
                width: width,
                child: TInput(
                  controller: controller,
                  focusNode: focus,
                  hintText: 'hint',
                  suffix: const Icon(TIcons.info_circle_filled),
                ),
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      final state = tester.state<EditableTextState>(find.byType(EditableText));
      update(() => width = 320);
      await tester.pump();
      expect(tester.getSize(find.byType(TInput)).width, 320);
      expect(
        tester.state<EditableTextState>(find.byType(EditableText)),
        same(state),
      );
      expect(focus.hasFocus, isTrue);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is SingleChildScrollView &&
              w.scrollDirection == Axis.horizontal,
        ),
        findsNothing,
      );
      await tester.enterText(find.byType(EditableText), 'Ag8');
      await tester.pump();
      expect(controller.text, 'Ag8');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'opaque Input suffix preserves typography and its own scroll behavior',
    (tester) async {
      const behavior = MaterialScrollBehavior();
      ScrollBehavior? received;
      await tester.pumpWidget(
        page(
          ScrollConfiguration(
            behavior: behavior,
            child: SizedBox(
              width: 600,
              child: TInput(
                hintText: 'hint',
                suffix: Builder(
                  builder: (context) {
                    received = ScrollConfiguration.of(context);
                    return const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 17),
                        Text(
                          '发送验证码',
                          style: TextStyle(fontSize: 16, color: Colors.purple),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(received, same(behavior));
      expect(tester.widget<Text>(find.text('发送验证码')).style!.fontSize, 16);
      expect(
        tester.widget<Text>(find.text('发送验证码')).style!.color,
        Colors.purple,
      );
      final slot = find.byWidgetPredicate(
        (w) =>
            w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
      );
      expect(slot, findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'standard PopupHeader retains its original height and explicit title style',
    (tester) async {
      await tester.pumpWidget(
        page(
          const TPopupHeader(
            title: Text(
              'custom',
              style: TextStyle(fontSize: 12, height: 1.4, color: Colors.purple),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(TPopupHeader)).height, 58);
      expect(tester.widget<Text>(find.text('custom')).style!.fontSize, 12);
      expect(
        tester.widget<Text>(find.text('custom')).style!.color,
        Colors.purple,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
