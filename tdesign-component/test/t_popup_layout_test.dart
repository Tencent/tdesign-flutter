import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('PopupLayout', () {
    const screen = Size(400, 800);

    testWidgets('top placement 使用 height 与 margin', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.top,
        screenSize: screen,
        margin: const EdgeInsets.only(top: 8, left: 4, right: 4),
        height: 100,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(children: [
              layout.wrapPositioned(child: const SizedBox(height: 50))
            ]),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, 8);
      expect(positioned.height, 100);
    });

    testWidgets('bottom placement 含 margin.top 与固定 height', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
        screenSize: screen,
        margin: const EdgeInsets.only(top: 100),
        height: 200,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(children: [
              layout.wrapPositioned(child: const SizedBox(height: 50))
            ]),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, 100);
      expect(positioned.height, 200);
    });

    testWidgets('bottom 无 height 有 margin.top 计算高度', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
        screenSize: screen,
        margin: const EdgeInsets.only(top: 50, bottom: 10),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(child: const SizedBox(height: 1))
              ],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, 50);
      expect(positioned.height, screen.height - 50 - 10);
    });

    testWidgets('left / right 使用默认或自定义 width', (tester) async {
      for (final p in [TPopupPlacement.left, TPopupPlacement.right]) {
        final layout = PopupLayout(
          placement: p,
          screenSize: screen,
          margin: const EdgeInsets.only(top: 56),
          width: 300,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                  children: [layout.wrapPositioned(child: const SizedBox())]),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.width, 300);
        expect(positioned.top, 56);
      }
    });

    testWidgets('center placement 仅 Center 包裹（尺寸由 PopupShell 控制）',
        (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.center,
        screenSize: screen,
        margin: EdgeInsets.zero,
        width: 200,
        height: 150,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(
                  child: const SizedBox(
                    key: ValueKey('content'),
                    width: 200,
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(Center), findsOneWidget);
      final box = tester.widget<SizedBox>(find.byKey(const ValueKey('content')));
      expect(box.width, 200);
      expect(box.height, 150);
    });

    test('slideOffset 五向偏移', () {
      final layout = PopupLayout(
        placement: TPopupPlacement.top,
        screenSize: screen,
        margin: EdgeInsets.zero,
      );
      expect(layout.slideOffset(0), const Offset(0, -1));
      expect(layout.slideOffset(1), const Offset(0, 0));

      final bottom = PopupLayout(
        placement: TPopupPlacement.bottom,
        screenSize: screen,
        margin: EdgeInsets.zero,
      );
      expect(bottom.slideOffset(0), const Offset(0, 1));

      final left = PopupLayout(
        placement: TPopupPlacement.left,
        screenSize: screen,
        margin: EdgeInsets.zero,
      );
      expect(left.slideOffset(0.5), const Offset(-0.5, 0));

      final right = PopupLayout(
        placement: TPopupPlacement.right,
        screenSize: screen,
        margin: EdgeInsets.zero,
      );
      expect(right.slideOffset(0.5), const Offset(0.5, 0));

      final center = PopupLayout(
        placement: TPopupPlacement.center,
        screenSize: screen,
        margin: EdgeInsets.zero,
      );
      expect(center.slideOffset(0.5), Offset.zero);
    });

    testWidgets('center 仅 Positioned.fill + Center，由 PopupShell 控制尺寸',
        (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.center,
        screenSize: screen,
        margin: EdgeInsets.zero,
        width: 100,
        height: 80,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(child: const SizedBox(height: 200)),
              ],
            ),
          ),
        ),
      );
      final center = tester.widget<Center>(find.byType(Center));
      expect(center.child, isA<SizedBox>());
    });

    test('resolvedMargin center 为零', () {
      final layout = PopupLayout(
        placement: TPopupPlacement.center,
        screenSize: screen,
        margin: const EdgeInsets.all(20),
      );
      expect(layout.resolvedMargin(), EdgeInsets.zero);
    });

    test('alignment 各方向', () {
      expect(
        PopupLayout(
          placement: TPopupPlacement.top,
          screenSize: screen,
          margin: EdgeInsets.zero,
        ).alignment,
        Alignment.topCenter,
      );
      expect(
        PopupLayout(
          placement: TPopupPlacement.right,
          screenSize: screen,
          margin: EdgeInsets.zero,
        ).alignment,
        Alignment.centerRight,
      );
    });
  });
}
