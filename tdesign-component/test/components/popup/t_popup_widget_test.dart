import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPopup widget 级用例', () {
    testWidgets('TPopupOptions 各方向工厂可构造', (tester) async {
      final bottom = TPopupOptions.bottom(
        child: const Text('body'),
        titleWidget: const Text('标题'),
      );
      final top = TPopupOptions.top(child: const Text('top'));
      final left = TPopupOptions.left(child: const Text('left'));
      final right = TPopupOptions.right(child: const Text('right'));
      final center = TPopupOptions.center(child: const Text('center'));
      expect(bottom.placement, TPopupPlacement.bottom);
      expect(top.placement, TPopupPlacement.top);
      expect(left.placement, TPopupPlacement.left);
      expect(right.placement, TPopupPlacement.right);
      expect(center.placement, TPopupPlacement.center);
    });

    testWidgets('TPopup.show 打开浮层并渲染内容', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => TPopup.show(
                context,
                options: TPopupOptions.bottom(child: const Text('浮层内容')),
              ),
              child: const Text('打开'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.text('浮层内容'), findsWidgets);
    });

    testWidgets('center 浮层可打开', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => TPopup.show(
                context,
                options: TPopupOptions.center(child: const Text('居中浮层')),
              ),
              child: const Text('打开居中'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('打开居中'));
      await tester.pumpAndSettle();
      expect(find.text('居中浮层'), findsWidgets);
    });
  });
}
