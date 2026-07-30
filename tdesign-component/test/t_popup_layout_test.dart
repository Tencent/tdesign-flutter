import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup.dart';

import 'helpers/popup_test_helpers.dart';

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

    testWidgets('bottom 无 height 时使用默认高度并贴底', (tester) async {
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
      expect(positioned.height, PopupLayout.defaultEdgeHeight);
    });

    testWidgets('top 无 height 时使用默认高度', (tester) async {
      final layout = PopupLayout(placement: TPopupPlacement.top);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(children: [layout.wrapPositioned(child: const SizedBox())]),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, 0);
      expect(positioned.height, PopupLayout.defaultEdgeHeight);
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

    test('safePaddingFor 按 placement 提取 MediaQuery.padding', () {
      expect(
        PopupLayout.safePaddingFor(
          TPopupPlacement.top,
          kPopupTestMediaPadding,
          true,
        ),
        const EdgeInsets.only(top: 22),
      );
      expect(
        PopupLayout.safePaddingFor(
          TPopupPlacement.bottom,
          kPopupTestMediaPadding,
          true,
        ),
        const EdgeInsets.only(bottom: 44),
      );
      expect(
        PopupLayout.safePaddingFor(
          TPopupPlacement.left,
          kPopupTestMediaPadding,
          true,
        ),
        const EdgeInsets.only(left: 11, top: 22, bottom: 44),
      );
      expect(
        PopupLayout.safePaddingFor(
          TPopupPlacement.right,
          kPopupTestMediaPadding,
          true,
        ),
        const EdgeInsets.only(right: 33, top: 22, bottom: 44),
      );
      expect(
        PopupLayout.safePaddingFor(
          TPopupPlacement.center,
          kPopupTestMediaPadding,
          true,
        ),
        kPopupTestMediaPadding,
      );
      expect(
        PopupLayout.safePaddingFor(
          TPopupPlacement.bottom,
          kPopupTestMediaPadding,
          false,
        ),
        EdgeInsets.zero,
      );
    });

    group('safePadding 边界', () {
      test('safePaddingFor 在 useSafeArea=false 时五向均为零', () {
        for (final placement in TPopupPlacement.values) {
          expect(
            PopupLayout.safePaddingFor(
              placement,
              kPopupTestMediaPadding,
              false,
            ),
            EdgeInsets.zero,
            reason: '$placement',
          );
        }
      });

      test('safePaddingFor 在 MediaQuery.padding 全零时五向均为零', () {
        for (final placement in TPopupPlacement.values) {
          expect(
            PopupLayout.safePaddingFor(placement, EdgeInsets.zero, true),
            EdgeInsets.zero,
            reason: '$placement',
          );
        }
      });

      testWidgets('wrapPositioned 默认 safePadding 为零时不偏移', (tester) async {
        final layout = PopupLayout(
          placement: TPopupPlacement.bottom,
          height: 100,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [layout.wrapPositioned(child: const SizedBox())],
              ),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.bottom, 0);
        expect(positioned.left, 0);
        expect(positioned.right, 0);
      });

      testWidgets('center 应用完整 safePadding，在安全区内居中',
          (tester) async {
        final layout = PopupLayout(placement: TPopupPlacement.center);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  layout.wrapPositioned(
                    child: const SizedBox(key: ValueKey('panel')),
                    safePadding: kPopupTestMediaPadding,
                  ),
                ],
              ),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.left, kPopupTestMediaPadding.left);
        expect(positioned.top, kPopupTestMediaPadding.top);
        expect(positioned.right, kPopupTestMediaPadding.right);
        expect(positioned.bottom, kPopupTestMediaPadding.bottom);
        expect(find.byKey(const ValueKey('panel')), findsOneWidget);
      });

      testWidgets('inset 类型与 placement 不匹配时仅应用 safePadding',
          (tester) async {
        final layout = PopupLayout(
          placement: TPopupPlacement.top,
          inset: const TPopupBottomInset(left: 99, right: 88),
          height: 60,
        );
        final safePadding = PopupLayout.safePaddingFor(
          TPopupPlacement.top,
          kPopupTestMediaPadding,
          true,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  layout.wrapPositioned(
                    child: const SizedBox(),
                    safePadding: safePadding,
                  ),
                ],
              ),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.top, 22);
        expect(positioned.left, 0);
        expect(positioned.right, 0);
      });

      testWidgets('left 无 inset 时默认宽度 280 且仅避让安全区', (tester) async {
        final layout = PopupLayout(placement: TPopupPlacement.left);
        final safePadding = PopupLayout.safePaddingFor(
          TPopupPlacement.left,
          kPopupTestMediaPadding,
          true,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  layout.wrapPositioned(
                    child: const SizedBox(),
                    safePadding: safePadding,
                  ),
                ],
              ),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.width, PopupLayout.defaultDrawerWidth);
        expect(positioned.left, 11);
        expect(positioned.top, 22);
        expect(positioned.bottom, 44);
      });

      testWidgets('right 无 inset 时默认宽度 280 且仅避让安全区', (tester) async {
        final layout = PopupLayout(placement: TPopupPlacement.right);
        final safePadding = PopupLayout.safePaddingFor(
          TPopupPlacement.right,
          kPopupTestMediaPadding,
          true,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  layout.wrapPositioned(
                    child: const SizedBox(),
                    safePadding: safePadding,
                  ),
                ],
              ),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.width, PopupLayout.defaultDrawerWidth);
        expect(positioned.right, 33);
        expect(positioned.top, 22);
        expect(positioned.bottom, 44);
      });

      testWidgets('仅单侧安全区：bottom 不受 top padding 影响', (tester) async {
        const onlyTop = EdgeInsets.only(top: 59);
        final layout = PopupLayout(
          placement: TPopupPlacement.bottom,
          height: 120,
        );
        final safePadding = PopupLayout.safePaddingFor(
          TPopupPlacement.bottom,
          onlyTop,
          true,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  layout.wrapPositioned(
                    child: const SizedBox(),
                    safePadding: safePadding,
                  ),
                ],
              ),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.bottom, 0);
        expect(positioned.height, 120);
      });

      testWidgets('仅单侧安全区：top 不受 bottom padding 影响', (tester) async {
        const onlyBottom = EdgeInsets.only(bottom: 59);
        final layout = PopupLayout(
          placement: TPopupPlacement.top,
          height: 80,
        );
        final safePadding = PopupLayout.safePaddingFor(
          TPopupPlacement.top,
          onlyBottom,
          true,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  layout.wrapPositioned(
                    child: const SizedBox(),
                    safePadding: safePadding,
                  ),
                ],
              ),
            ),
          ),
        );
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.top, 0);
        expect(positioned.height, 80);
      });
    });

    testWidgets('bottom 应用 safePadding 时贴安全区上沿', (tester) async {
      const safeBottom = 34.0;
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
        height: 200,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(
                  child: const SizedBox(),
                  safePadding: const EdgeInsets.only(bottom: safeBottom),
                ),
              ],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.bottom, safeBottom);
      expect(positioned.height, 200);
    });

    testWidgets('top 应用 safePadding 时 left/right 与 inset 叠加', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.top,
        inset: const TPopupTopInset(left: 8, right: 12),
        height: 100,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(
                  child: const SizedBox(),
                  safePadding: const EdgeInsets.only(
                    top: 20,
                    left: 4,
                    right: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, 20);
      expect(positioned.left, 12);
      expect(positioned.right, 18);
    });

    testWidgets('top 仅应用垂直 safePadding', (tester) async {
      const safeTop = 47.0;
      final layout = PopupLayout(
        placement: TPopupPlacement.top,
        height: 80,
      );
      final safePadding = PopupLayout.safePaddingFor(
        TPopupPlacement.top,
        const EdgeInsets.fromLTRB(11, safeTop, 33, 44),
        true,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(
                  child: const SizedBox(),
                  safePadding: safePadding,
                ),
              ],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.top, safeTop);
      expect(positioned.left, 0);
      expect(positioned.right, 0);
    });

    testWidgets('bottom inset 与 safePadding 叠加', (tester) async {
      const safeBottom = 34.0;
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
        inset: const TPopupBottomInset(left: 10, right: 16),
        height: 180,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(
                  child: const SizedBox(),
                  safePadding: const EdgeInsets.only(bottom: safeBottom),
                ),
              ],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.bottom, safeBottom);
      expect(positioned.left, 10);
      expect(positioned.right, 16);
      expect(positioned.height, 180);
    });

    testWidgets('bottom 无 height 时使用默认高度并贴安全区上沿', (tester) async {
      const safeBottom = 21.0;
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(
                  child: const SizedBox(height: 60),
                  safePadding: const EdgeInsets.only(bottom: safeBottom),
                ),
              ],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.bottom, safeBottom);
      expect(positioned.height, PopupLayout.defaultEdgeHeight);
    });

    testWidgets('left/right 应用 safePadding 时避让侧栏与上下安全区', (tester) async {
      const media = EdgeInsets.fromLTRB(11, 22, 33, 44);
      final leftSafePadding = PopupLayout.safePaddingFor(
        TPopupPlacement.left,
        media,
        true,
      );
      final leftLayout = PopupLayout(
        placement: TPopupPlacement.left,
        inset: const TPopupLeftInset(top: 8, bottom: 12),
        width: 280,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                leftLayout.wrapPositioned(
                  child: const SizedBox(),
                  safePadding: leftSafePadding,
                ),
              ],
            ),
          ),
        ),
      );
      var positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.left, 11);
      expect(positioned.top, 30);
      expect(positioned.bottom, 56);
      expect(positioned.width, 280);

      final rightSafePadding = PopupLayout.safePaddingFor(
        TPopupPlacement.right,
        media,
        true,
      );
      final rightLayout = PopupLayout(
        placement: TPopupPlacement.right,
        inset: const TPopupRightInset(top: 5, bottom: 7),
        width: 260,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                rightLayout.wrapPositioned(
                  child: const SizedBox(),
                  safePadding: rightSafePadding,
                ),
              ],
            ),
          ),
        ),
      );
      positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.right, 33);
      expect(positioned.top, 27);
      expect(positioned.bottom, 51);
      expect(positioned.width, 260);
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
