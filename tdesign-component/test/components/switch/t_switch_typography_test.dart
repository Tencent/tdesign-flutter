import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    await (FontLoader('Roboto')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
  });
  testWidgets('different explicit state fonts retain their rendered sizes', (
    tester,
  ) async {
    for (final value in [true, false]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [
              TThemeData.defaultData(),
              const TTextThemeData(textStyle: TextStyle(fontFamily: 'Roboto')),
              const TSwitchThemeData(
                thumbContentOnFont: TextStyle(fontSize: 28, height: 1),
                thumbContentOffFont: TextStyle(fontSize: 12, height: 1),
              ),
            ],
          ),
          home: Scaffold(
            body: Center(
              child: TSwitch(
                value: value,
                onChanged: (_) {},
                variant: TSwitchVariant.text,
                openText: 'I',
                closeText: 'l',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final label = value ? 'I' : 'l';
      final paragraph = tester.renderObject<RenderParagraph>(find.text(label));
      final text = tester.widget<Text>(find.text(label));
      expect(text.style!.fontSize, value ? 28 : 12);
      expect(paragraph.getTransformTo(null).storage[5], closeTo(1, .001));
      expect(tester.takeException(), isNull);
    }
  });
  for (final scale in [1.0, 2.0, 3.0]) {
    testWidgets(
      'default multi-character switch preserves rendered typography at $scale',
      (tester) async {
        for (final value in [true, false]) {
          bool? changed;
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                extensions: [
                  TThemeData.defaultData(),
                  const TTextThemeData(
                    textStyle: TextStyle(fontFamily: 'Roboto'),
                  ),
                ],
              ),
              home: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Scaffold(
                  body: Center(
                    child: TSwitch(
                      value: value,
                      onChanged: (next) => changed = next,
                      variant: TSwitchVariant.text,
                      openText: 'ON',
                      closeText: 'OFF',
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final label = value ? 'ON' : 'OFF';
          final paragraph = tester.renderObject<RenderParagraph>(
            find.text(label),
          );
          final actualScale = paragraph.getTransformTo(null).storage[5];
          expect(
            actualScale,
            closeTo(1, .001),
            reason:
                'Default content must not shrink the configured text scaler.',
          );
          expect(tester.widget<Text>(find.text(label)).style!.fontSize, 14);
          expect(
            paragraph.getBoxesForSelection(
              const TextSelection(baseOffset: 0, extentOffset: 1),
            ),
            isNotEmpty,
            reason:
                'The first character must remain visible beside the ellipsis.',
          );
          if (scale == 1) {
            expect(
              tester.getSize(find.byType(TSwitch)).height,
              greaterThanOrEqualTo(28),
            );
          }
          await tester.tap(find.byType(TSwitch));
          await tester.pumpAndSettle();
          expect(changed, !value);
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
}
