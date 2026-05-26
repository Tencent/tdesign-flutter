import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('PopupLayout', () {
    testWidgets('top placement 使用 height 与左右 inset', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.top,
        inset: const TPopupTopInset(left: 4, right: 6),
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
      expect(positioned.top, 0);
      expect(positioned.left, 4);
      expect(positioned.right, 6);
      expect(positioned.height, 100);
    });

    testWidgets('bottom placement 使用左右 inset 与固定 height', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
        inset: const TPopupBottomInset(left: 12, right: 20),
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
      expect(positioned.left, 12);
      expect(positioned.right, 20);
      expect(positioned.bottom, 0);
      expect(positioned.height, 200);
    });

    testWidgets('bottom 无 height 时贴底', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
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
      expect(positioned.bottom, 0);
      expect(positioned.top, isNull);
      expect(positioned.height, isNull);
    });

    testWidgets('left / right 使用默认或自定义 width 与上下 inset', (tester) async {
      final left = PopupLayout(
        placement: TPopupPlacement.left,
        inset: const TPopupLeftInset(top: 56, bottom: 12),
        width: 300,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body:
                Stack(children: [left.wrapPositioned(child: const SizedBox())]),
          ),
        ),
      );
      var positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.width, 300);
      expect(positioned.top, 56);
      expect(positioned.bottom, 12);

      final right = PopupLayout(
        placement: TPopupPlacement.right,
        inset: const TPopupRightInset(top: 8, bottom: 10),
        width: 260,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [right.wrapPositioned(child: const SizedBox())],
            ),
          ),
        ),
      );
      positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.width, 260);
      expect(positioned.top, 8);
      expect(positioned.bottom, 10);
    });

    testWidgets('center placement 仅 Center 包裹（尺寸由 PopupShell 控制）',
        (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.center,
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
      final box =
          tester.widget<SizedBox>(find.byKey(const ValueKey('content')));
      expect(box.width, 200);
      expect(box.height, 150);
    });

    test('slideOffset 五向偏移', () {
      final layout = PopupLayout(
        placement: TPopupPlacement.top,
      );
      expect(layout.slideOffset(0), const Offset(0, -1));
      expect(layout.slideOffset(1), const Offset(0, 0));

      final bottom = PopupLayout(
        placement: TPopupPlacement.bottom,
      );
      expect(bottom.slideOffset(0), const Offset(0, 1));

      final left = PopupLayout(
        placement: TPopupPlacement.left,
      );
      expect(left.slideOffset(0.5), const Offset(-0.5, 0));

      final right = PopupLayout(
        placement: TPopupPlacement.right,
      );
      expect(right.slideOffset(0.5), const Offset(0.5, 0));

      final center = PopupLayout(
        placement: TPopupPlacement.center,
      );
      expect(center.slideOffset(0.5), Offset.zero);
    });

    testWidgets('center 仅 Positioned.fill + Center，由 PopupShell 控制尺寸',
        (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.center,
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

    test('alignment 各方向', () {
      expect(
        PopupLayout(
          placement: TPopupPlacement.top,
        ).alignment,
        Alignment.topCenter,
      );
      expect(
        PopupLayout(
          placement: TPopupPlacement.right,
        ).alignment,
        Alignment.centerRight,
      );
    });
  });
}
