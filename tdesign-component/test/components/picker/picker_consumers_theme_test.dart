import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/multi_wheel_layout.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  for (final dateTime in [false, true]) {
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
