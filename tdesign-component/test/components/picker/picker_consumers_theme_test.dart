import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/multi_wheel_layout.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  for (final date in [false, true]) {
    testWidgets('explicit component text theme date=$date', (tester) async {
      final changes = <Object>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const [
              TTextThemeData(
                textStyle: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w800,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          home: Scaffold(
            body: date
                ? TDateTimePicker(
                    value: const TDateTimePickerValue(
                      year: 2024,
                      month: 6,
                      day: 15,
                    ),
                    onChanged: changes.add,
                  )
                : TPicker(
                    items: TPickerColumns([
                      List.generate(
                        12,
                        (i) => TPickerOption(label: 'Item $i', value: i),
                      ),
                    ]),
                    value: const [0],
                    onChanged: changes.add,
                  ),
          ),
        ),
      );
      final wheelFinder = find.byType(ListWheelScrollView).first;
      final textFinder = find.descendant(
        of: wheelFinder,
        matching: find.byType(Text),
      );
      final text = tester.widget<Text>(textFinder.first);
      expect(text.style!.fontSize, 31);
      expect(text.style!.fontWeight, FontWeight.w800);
      expect(text.style!.color, Colors.pink);
    });
  }
  for (final dateTime in [false, true]) {
    for (final fallback in [false, true]) {
      testWidgets(
        'semantic font tokens dateTime=$dateTime fallback=$fallback',
        (tester) async {
          final tokens = TThemeData.defaultData().copyWithTThemeData(
            'semantic-font',
            fontMap: {
              'fontBodyLarge': Font(
                size: 18,
                lineHeight: 26,
                fontWeight: FontWeight.w300,
              ),
              'fontMarkLarge': Font(
                size: 20,
                lineHeight: 28,
                fontWeight: FontWeight.w700,
              ),
            },
          );
          final projected = TThemeBuilder.light(tokens);
          final material = fallback
              ? projected.copyWith(
                  textTheme: projected.textTheme.apply(
                    fontFamilyFallback: ['custom'],
                  ),
                )
              : ThemeData(extensions: [tokens]);
          await tester.pumpWidget(
            MaterialApp(
              theme: material,
              home: Scaffold(
                body: dateTime
                    ? TDateTimePicker(
                        value: const TDateTimePickerValue(
                          year: 2024,
                          month: 6,
                          day: 15,
                        ),
                        onChanged: (_) {},
                      )
                    : TPicker(
                        items: const TPickerColumns([
                          [
                            TPickerOption(label: 'A', value: 0),
                            TPickerOption(label: 'B', value: 1),
                          ],
                        ]),
                        value: const [0],
                        onChanged: (_) {},
                      ),
              ),
            ),
          );
          final styles = tester
              .widgetList<Text>(
                find.descendant(
                  of: find.byType(ListWheelScrollView).first,
                  matching: find.byType(Text),
                ),
              )
              .map((text) => text.style!)
              .toList();
          expect(
            styles.any(
              (style) =>
                  style.fontSize == 20 &&
                  style.height == 1.4 &&
                  style.fontWeight == FontWeight.w700,
            ),
            isTrue,
          );
          expect(
            styles.any(
              (style) =>
                  style.fontSize == 18 &&
                  style.height == 26 / 18 &&
                  style.fontWeight == FontWeight.w300,
            ),
            isTrue,
          );
        },
      );
    }
  }
  for (final dateTime in [false, true]) {
    for (final explicit in [false, true]) {
      testWidgets(
        '${dateTime ? 'DateTimePicker' : 'Picker'} typography respects tokens and explicit TextTheme $explicit',
        (tester) async {
          final tokens = TThemeData.defaultData().copyWithTThemeData(
            'font-test',
            fontMap: {
              'fontBodyLarge': Font(size: 19, lineHeight: 27),
              'fontMarkLarge': Font(
                size: 19,
                lineHeight: 27,
                fontWeight: FontWeight.w600,
              ),
            },
          );
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(extensions: [tokens]),
              home: Builder(
                builder: (context) => Theme(
                  data: explicit
                      ? Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.copyWith(
                            bodyLarge: const TextStyle(
                              fontSize: 21,
                              height: 1.6,
                              fontFamily: 'custom',
                            ),
                          ),
                        )
                      : Theme.of(context),
                  child: Scaffold(
                    body: SizedBox(
                      width: 360,
                      child: dateTime
                          ? TDateTimePicker(
                              value: const TDateTimePickerValue(
                                year: 2024,
                                month: 6,
                                day: 15,
                              ),
                              onChanged: (_) {},
                            )
                          : TPicker(
                              items: const TPickerColumns([
                                [TPickerOption(label: 'A', value: 'a')],
                              ]),
                              value: const ['a'],
                              onChanged: (_) {},
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
          final texts = tester.widgetList<TText>(
            find.descendant(
              of: find.byType(MultiWheelLayout),
              matching: find.byType(TText),
            ),
          );
          expect(texts, isNotEmpty);
          for (final text in texts) {
            expect(text.style?.fontSize, explicit ? 21 : 19);
            expect(text.style?.height, explicit ? 1.6 : 27 / 19);
            if (explicit) {
              expect(text.style?.fontFamily, 'custom');
            }
          }
        },
      );
    }
    for (final custom in [false, true]) {
      testWidgets(
        '${dateTime ? 'DateTimePicker' : 'Picker'} shell follows ${custom ? 'custom' : 'default'} tokens',
        (tester) async {
          final tokens = custom
              ? TThemeData.defaultData().copyWithTThemeData(
                  'wheel-test',
                  colorMap: {
                    'bgColorContainer': const Color(0xFF123456),
                    'bgColorSecondaryContainer': const Color(0xFF456789),
                  },
                  marginMap: {'spacer48': 24},
                )
              : TThemeData.defaultData();
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(extensions: [tokens]),
              home: Scaffold(
                body: ColoredBox(
                  color: Colors.pink,
                  child: SizedBox(
                    width: 360,
                    child: dateTime
                        ? TDateTimePicker(
                            value: const TDateTimePickerValue(
                              year: 2024,
                              month: 6,
                              day: 15,
                            ),
                            onChanged: (_) {},
                          )
                        : TPicker(
                            items: const TPickerColumns([
                              [
                                TPickerOption(label: 'A', value: 'a'),
                                TPickerOption(label: 'B', value: 'b'),
                              ],
                            ]),
                            value: const ['a'],
                            onChanged: (_) {},
                          ),
                  ),
                ),
              ),
            ),
          );

          final shell = find.byType(MultiWheelLayout);
          expect(shell, findsOneWidget);
          final background = find.descendant(
            of: shell,
            matching: find.byType(ColoredBox),
          );
          expect(
            tester.widget<ColoredBox>(background).color,
            tokens.bgColorContainer,
          );
          final fades = find.descendant(
            of: shell,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is DecoratedBox &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).gradient
                      is LinearGradient,
            ),
          );
          expect(fades, findsNWidgets(2));
          for (var index = 0; index < 2; index++) {
            final fade = fades.at(index);
            final gradient =
                (tester.widget<DecoratedBox>(fade).decoration as BoxDecoration)
                        .gradient!
                    as LinearGradient;
            expect(gradient.colors, [
              tokens.bgColorContainer,
              tokens.bgColorContainer.withValues(alpha: 0),
            ]);
            expect(
              gradient.begin,
              index == 0 ? Alignment.topCenter : Alignment.bottomCenter,
            );
            expect(
              gradient.end,
              index == 0 ? Alignment.bottomCenter : Alignment.topCenter,
            );
            expect(tester.getSize(fade).height, custom ? 24 : 48);
            final ignore = find.ancestor(
              of: fade,
              matching: find.byType(IgnorePointer),
            );
            expect(tester.widget<IgnorePointer>(ignore.first).ignoring, isTrue);
          }
          final highlight = find.descendant(
            of: shell,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Container &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).color ==
                      tokens.bgColorSecondaryContainer,
            ),
          );
          expect(highlight, findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
