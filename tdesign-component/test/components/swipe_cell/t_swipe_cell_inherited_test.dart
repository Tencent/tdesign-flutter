import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/swipe_cell/t_swipe_cell_inherited.dart';

void main() {
  group('TSwipeCellInherited', () {
    Future<void> close() async {}

    test('仅关闭回调变化时通知子树', () {
      final first = TSwipeCellInherited(close: close, child: const SizedBox());
      final same = TSwipeCellInherited(close: close, child: const SizedBox());
      final different = TSwipeCellInherited(
        close: () async {},
        child: const SizedBox(),
      );
      expect(first.updateShouldNotify(same), isFalse);
      expect(first.updateShouldNotify(different), isTrue);
    });

    testWidgets('of 从子树解析最近实例', (tester) async {
      TSwipeCellInherited? resolved;
      await tester.pumpWidget(
        MaterialApp(
          home: TSwipeCellInherited(
            close: close,
            child: Builder(
              builder: (context) {
                resolved = TSwipeCellInherited.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(resolved, isNotNull);
    });
  });
}
