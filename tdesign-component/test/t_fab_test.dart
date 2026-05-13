import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget _buildTestApp(Widget child) {
  return TTheme(
    data: TThemeData.defaultData(),
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('TFab 长按事件测试', () {
    testWidgets('TC-01: onLongPress 回调应被触发', (tester) async {
      var longPressTriggered = false;

      await tester.pumpWidget(
        _buildTestApp(
          TFab(
            text: 'LongPress',
            onLongPress: () {
              longPressTriggered = true;
            },
          ),
        ),
      );

      await tester.longPress(find.byType(TFab));
      await tester.pumpAndSettle();

      expect(longPressTriggered, isTrue);
    });

    testWidgets('TC-02: 点击不应误触发 onLongPress', (tester) async {
      var longPressCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TFab(
            text: 'LongPress',
            onLongPress: () {
              longPressCount += 1;
            },
          ),
        ),
      );

      await tester.tap(find.byType(TFab));
      await tester.pumpAndSettle();

      expect(longPressCount, 0);
    });

    testWidgets('TC-03: onClick 与 onLongPress 可独立工作', (tester) async {
      var tapCount = 0;
      var longPressCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TFab(
            text: 'LongPress',
            onClick: () {
              tapCount += 1;
            },
            onLongPress: () {
              longPressCount += 1;
            },
          ),
        ),
      );

      await tester.tap(find.byType(TFab));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
      expect(longPressCount, 0);

      await tester.longPress(find.byType(TFab));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
      expect(longPressCount, 1);
    });
  });
}
