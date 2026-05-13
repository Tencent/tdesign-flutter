import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget _buildTestApp(Widget child) {
  return TTheme(
    data: TThemeData.defaultData(),
    child: MaterialApp(
      home: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('TFab — onLongPress (issue #924)', () {
    testWidgets('TC-01: 长按时应触发 onLongPress', (tester) async {
      var longPressed = false;
      await tester.pumpWidget(
        _buildTestApp(
          TFab(
            onLongPress: () {
              longPressed = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(TFab));
      await tester.pumpAndSettle();

      expect(longPressed, isTrue);
    });
  });
}
