import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TBackTop widget 级用例', () {
    testWidgets('默认圆形可构建', (tester) async {
      await tester.pumpWidget(wrap(const TBackTop(onPressed: _noop)));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('圆形展示文字时保持 48px 且不溢出', (tester) async {
      await tester.pumpWidget(
        wrap(const TBackTop(showText: true, onPressed: _noop)),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TBackTop)), const Size(48, 48));
    });

    testWidgets('halfCircle / tooltip 可构建', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TBackTop(
            shape: TBackTopShape.halfCircle,
            tooltip: '回到顶部',
            onPressed: _noop,
          ),
        ),
      );
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('绑定 ScrollController 且阈值未达时隐藏内容', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(
          TBackTop(
            controller: controller,
            visibilityOffset: 100,
            onPressed: _noop,
          ),
        ),
      );
      expect(find.byType(TBackTop), findsOneWidget);
      await tester.pump();
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('主题更新后可重建', (tester) async {
      await tester.pumpWidget(wrap(const TBackTop(onPressed: _noop)));
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          ),
          home: const Scaffold(body: TBackTop(onPressed: _noop)),
        ),
      );
      expect(find.byType(TBackTop), findsOneWidget);
    });
  });
}

void _noop() {}
