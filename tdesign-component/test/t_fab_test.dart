import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget _wrap(Widget child) {
  return TTheme(
    data: TThemeData.defaultData(),
    child: MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

void main() {
  group('TFab — onLongPress (issue #924)', () {
    testWidgets('长按时应触发 onLongPress', (tester) async {
      var longPressed = false;
      await tester.pumpWidget(_wrap(
        TFab(
          theme: TFabTheme.primary,
          onLongPress: () {
            longPressed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(TFab));
      await tester.pumpAndSettle();

      expect(longPressed, isTrue);
    });

    testWidgets('单击时应触发 onClick，且可与 onLongPress 共存', (tester) async {
      var tapped = false;
      var longPressed = false;
      await tester.pumpWidget(_wrap(
        TFab(
          theme: TFabTheme.primary,
          onClick: () {
            tapped = true;
          },
          onLongPress: () {
            longPressed = true;
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TFab));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
      expect(longPressed, isFalse);

      await tester.longPress(find.byType(TFab));
      await tester.pumpAndSettle();
      expect(longPressed, isTrue);
    });
  });
}
