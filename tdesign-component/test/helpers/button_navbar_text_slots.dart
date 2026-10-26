import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'text_slot_regression.dart';

// Exercise the public slots using their existing registered component suites.
void registerButtonTextSlotTests() {
  for (final gradient in [false, true]) {
    for (final disabled in [false, true]) {
      registerTextSlotParityTests(
        'button text slot gradient=$gradient disabled=$disabled',
        (child) => TButton(
          colorPreset: TButtonColorPreset.primary,
          onPressed: disabled ? null : () {},
          child: child,
        ),
        theme: (theme) => gradient
            ? theme.mergeExtension(
                const TButtonThemeData(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                ),
              )
            : theme,
      );
    }
  }

  for (final gradient in [false, true]) {
    testWidgets('button text slot states and overrides gradient=$gradient', (
      tester,
    ) async {
      for (final size in TButtonSize.values) {
        for (final variant in TButtonVariant.values) {
          for (final preset in TButtonColorPreset.values) {
            TextStyle? nativeStyle;
            Size? nativeSize;
            for (final native in [true, false]) {
              var theme = TThemeBuilder.light(TThemeData.defaultData());
              if (gradient) {
                theme = theme.mergeExtension(
                  const TButtonThemeData(
                    gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                  ),
                );
              }
              await tester.pumpWidget(
                MaterialApp(
                  theme: theme,
                  home: Scaffold(
                    body: Center(
                      child: TButton(
                        size: size,
                        variant: variant,
                        colorPreset: preset,
                        onPressed: () {},
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.pressed)
                                ? Colors.pink
                                : Colors.blue,
                          ),
                          textStyle: WidgetStateProperty.resolveWith(
                            (states) => TextStyle(
                              letterSpacing:
                                  states.contains(WidgetState.pressed) ? 2 : 1,
                            ),
                          ),
                        ),
                        child: native
                            ? const Text('State')
                            : const TText('State'),
                      ),
                    ),
                  ),
                ),
              );
              await tester.pumpAndSettle();
              final richFinder = find.descendant(
                of: find.text('State'),
                matching: find.byType(RichText),
              );
              final idle = tester.widget<RichText>(richFinder).text.style!;
              expect(idle.color, Colors.blue);
              expect(idle.letterSpacing, 1);
              if (native) {
                nativeStyle = idle;
                nativeSize = tester.getSize(richFinder);
              } else {
                expect(idle, nativeStyle);
                expect(tester.getSize(richFinder), nativeSize);
              }
              final gesture = await tester.startGesture(
                tester.getCenter(find.byType(TButton)),
              );
              await tester.pumpAndSettle();
              final pressed = tester.widget<RichText>(richFinder).text.style!;
              expect(pressed.color, Colors.pink);
              expect(pressed.letterSpacing, 2);
              await gesture.up();
              await tester.pumpAndSettle();
              expect(tester.widget<RichText>(richFinder).text.style, idle);
              expect(tester.takeException(), isNull);
            }
          }
        }
      }
    });
  }
  _registerContentOverrides(
    'button text slot',
    (child) => TButton(
      colorPreset: TButtonColorPreset.primary,
      onPressed: () {},
      child: child,
    ),
  );
}

void registerNavBarTextSlotTests() {
  registerTextSlotParityTests(
    'navbar title slot',
    (child) => TNavBar(title: child),
    theme: (theme) =>
        theme.mergeExtension(const TNavBarThemeData(titleColor: Colors.purple)),
  );
  _registerContentOverrides(
    'navbar title slot',
    (child) => TNavBar(title: child),
  );
  testWidgets('navbar title scope does not reach action content', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(
          TThemeData.defaultData(),
        ).mergeExtension(const TNavBarThemeData(titleColor: Colors.purple)),
        home: const Scaffold(
          body: TNavBar(
            title: TText('Title'),
            actions: [TNavBarItem(customWidget: TText('Action'))],
          ),
        ),
      ),
    );
    TextStyle actual(String text) => tester
        .widget<RichText>(
          find.descendant(of: find.text(text), matching: find.byType(RichText)),
        )
        .text
        .style!;
    expect(actual('Title').color, Colors.purple);
    expect(actual('Action').color, TThemeData.defaultData().textColorPrimary);
    expect(
      actual('Action').fontSize,
      TThemeData.defaultData().fontBodyMedium!.size,
    );
  });
}

void _registerContentOverrides(String name, Widget Function(Widget) build) {
  testWidgets('$name partial, rich, outer theme and global isolation', (
    tester,
  ) async {
    final token = TThemeData.defaultData();
    final theme = TThemeBuilder.light(token).mergeExtension(
      const TTextThemeData(
        textStyle: TextStyle(
          fontSize: 27,
          color: Colors.green,
          letterSpacing: 3,
        ),
        textWidthBasis: TextWidthBasis.longestLine,
      ),
    );
    Future<TextStyle> render(Widget text) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(body: Center(child: build(text))),
        ),
      );
      await tester.pumpAndSettle();
      final rich = tester.widget<RichText>(find.byType(RichText).last);
      expect(rich.textWidthBasis, TextWidthBasis.longestLine);
      expect(tester.takeException(), isNull);
      return rich.text.style!;
    }

    final defaults = await render(const TText('Slot'));
    expect(defaults.fontSize, isNot(27));
    expect(defaults.color, isNot(Colors.green));
    expect(defaults.letterSpacing, 3);
    final empty = await render(const TText('Slot', style: TextStyle()));
    expect(empty, defaults);
    final partial = await render(
      const TText('Slot', style: TextStyle(color: Colors.red)),
    );
    expect(partial, defaults.copyWith(color: Colors.red));
    final font = await render(
      TText('Slot', font: Font(size: 19, lineHeight: 25)),
    );
    expect(font.fontSize, 19);
    expect(font.height, 25 / 19);
    final rich = await render(
      const TText.rich(
        TextSpan(
          text: 'Base',
          children: [
            TextSpan(
              text: 'Red',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
    expect(rich, defaults);
    final span =
        tester.widget<RichText>(find.byType(RichText).last).text as TextSpan;
    expect(
      (span.children!.single as TextSpan).children!.single.style!.color,
      Colors.red,
    );
    final isolated = await render(
      const TText(
        'Slot',
        style: TextStyle(inherit: false, fontSize: 17, color: Colors.orange),
      ),
    );
    expect(isolated.fontSize, 17);
    expect(isolated.color, Colors.orange);
    expect(isolated.fontWeight, isNull);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: DefaultTextStyle(
            style: TextStyle(fontSize: 50, color: Colors.pink),
            child: TText('Outside'),
          ),
        ),
      ),
    );
    final outside = tester
        .widget<RichText>(find.byType(RichText).last)
        .text
        .style!;
    expect(outside.fontSize, 27);
    expect(outside.color, Colors.green);
  });
}
