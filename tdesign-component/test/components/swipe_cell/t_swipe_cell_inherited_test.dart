import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/swipe_cell/t_swipe_cell_action.dart';
import 'package:tdesign_flutter/src/components/swipe_cell/t_swipe_cell_inherited.dart';

// TSwipeCellInherited 覆盖率补充测试
//
// 覆盖：updateShouldNotify 重写方法体（t_swipe_cell_inherited.dart 未覆盖行），
// 以及 of(context) 从子树解析最近实例。
void main() {
  TSwipeCellInherited makeInherited(SlidableController controller) {
    return TSwipeCellInherited(
      child: const SizedBox(),
      cellClick: () {},
      actionClick: (_) => false,
      duration: const Duration(milliseconds: 200),
      controller: controller,
    );
  }

  group('TSwipeCellInherited', () {
    testWidgets('updateShouldNotify 重写方法体始终返回 true', (tester) async {
      final controller = SlidableController(tester);
      final a = makeInherited(controller);
      final b = makeInherited(controller);
      // 直接调用覆盖 @override updateShouldNotify 方法体
      expect(a.updateShouldNotify(b), isTrue);
    });

    testWidgets('of 从子树 context 解析最近实例', (tester) async {
      final controller = SlidableController(tester);
      TSwipeCellInherited? resolved;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TSwipeCellInherited(
              child: Builder(
                builder: (context) {
                  resolved = TSwipeCellInherited.of(context);
                  return const SizedBox();
                },
              ),
              cellClick: () {},
              actionClick: (_) => false,
              duration: const Duration(milliseconds: 200),
              controller: controller,
            ),
          ),
        ),
      );
      expect(resolved, isNotNull);
      expect(resolved, isA<TSwipeCellInherited>());
    });
  });
}
