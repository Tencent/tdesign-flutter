import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// A slot must supply the same defaults to native and TD text, without taking
/// ownership of explicit child styles or losing inherited paragraph settings.
void registerTextSlotParityTests(
  String name,
  Widget Function(Widget child) build, {
  ThemeData Function(ThemeData theme)? theme,
}) {
  testWidgets('$name nearer TD text theme overrides slot defaults', (
    tester,
  ) async {
    const override = TextStyle(fontSize: 21, height: 1.3, color: Colors.orange);
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(
          body: Center(
            child: build(
              Builder(
                builder: (context) {
                  final inherited = Theme.of(
                    context,
                  ).extension<TTextThemeData>();
                  return Theme(
                    data: Theme.of(context).mergeExtension(
                      (inherited ?? const TTextThemeData()).copyWith(
                        textStyle: override,
                      ),
                    ),
                    child: const TText('Local'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final rich = tester.widget<RichText>(
      find.descendant(of: find.text('Local'), matching: find.byType(RichText)),
    );
    expect(rich.text.style!.fontSize, override.fontSize);
    expect(rich.text.style!.color, override.color);
    expect(rich.text.style!.height, override.height);
    expect(tester.takeException(), isNull);
  });

  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 2.0]) {
      for (final explicit in [false, true]) {
        testWidgets('$name $brightness scale=$scale explicit=$explicit', (
          tester,
        ) async {
          final base = brightness == Brightness.light
              ? TThemeBuilder.light(TThemeData.defaultData())
              : TThemeBuilder.dark(TThemeData.defaultData());
          const paragraph = TTextThemeData(
            textWidthBasis: TextWidthBasis.longestLine,
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
            ),
          );
          final resolvedTheme = (theme?.call(base) ?? base).mergeExtension(
            paragraph,
          );
          final style = explicit
              ? const TextStyle(
                  fontSize: 19,
                  height: 1.3,
                  color: Colors.orange,
                  fontWeight: FontWeight.w300,
                )
              : null;
          TextStyle? nativeStyle;
          Size? nativeSize;
          for (final native in [true, false]) {
            await tester.pumpWidget(
              MaterialApp(
                theme: resolvedTheme,
                home: Scaffold(
                  body: MediaQuery(
                    data: MediaQueryData(
                      size: const Size(800, 600),
                      textScaler: TextScaler.linear(scale),
                    ),
                    child: Center(
                      child: build(
                        native
                            ? Text(
                                'Slot',
                                style: style,
                                textWidthBasis: paragraph.textWidthBasis,
                                textHeightBehavior:
                                    paragraph.textHeightBehavior,
                              )
                            : TText('Slot', style: style),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final rich = find.descendant(
              of: find.text('Slot'),
              matching: find.byType(RichText),
            );
            final widget = tester.widget<RichText>(rich);
            final actual = widget.text.style!;
            if (native) {
              nativeStyle = actual;
              nativeSize = tester.getSize(rich);
            } else {
              expect(actual.fontSize, nativeStyle!.fontSize);
              expect(actual.height, nativeStyle.height);
              expect(actual.fontWeight, nativeStyle.fontWeight);
              expect(actual.color, nativeStyle.color);
              expect(actual.fontFamily, nativeStyle.fontFamily);
              expect(actual.decoration, nativeStyle.decoration);
              expect(tester.getSize(rich), nativeSize);
              expect(widget.textWidthBasis, paragraph.textWidthBasis);
              expect(widget.textHeightBehavior, paragraph.textHeightBehavior);
            }
            if (explicit) {
              expect(actual.fontSize, style!.fontSize);
              expect(actual.color, style.color);
              expect(actual.fontWeight, style.fontWeight);
            }
            expect(tester.takeException(), isNull);
          }
        });
      }
    }
  }
}
