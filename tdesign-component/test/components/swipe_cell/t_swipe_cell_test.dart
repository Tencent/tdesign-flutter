import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/components/swipe_cell/t_swipe_cell_inherited.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(body: child),
      );

  TSwipeCellPanel panel(String label) => TSwipeCellPanel(
        children: [
          TSwipeCellAction(label: label, onPressed: (_) {}),
        ],
      );

  group('TSwipeCell', () {
    test('面板与操作项的默认值为非空、可预测的 v1 值', () {
      final panel = TSwipeCellPanel(children: [panelAction('Action')]);
      final action = panel.children.single;

      expect(panel.extentRatio, 0.3);
      expect(panel.dragDismissible, isFalse);
      expect(panel.dismissThreshold, 0.75);
      expect(panel.dismissalDuration, const Duration(milliseconds: 300));
      expect(action.flex, 1);
      expect(action.autoClose, isTrue);
      expect(action.direction, Axis.horizontal);
    });

    test('面板拒绝无效的 extentRatio', () {
      expect(
        () =>
            TSwipeCellPanel(extentRatio: 0, children: [panelAction('Action')]),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('接受任意 child，而不依赖 TCell', (tester) async {
      await tester.pumpWidget(app(const TSwipeCell(child: Text('Custom row'))));
      expect(find.text('Custom row'), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);
    });

    testWidgets('start 和 end 面板分别接入 Slidable', (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        start: panel('Start'),
        end: panel('End'),
      )));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.startActionPane, isNotNull);
      expect(slidable.endActionPane, isNotNull);
    });

    testWidgets('默认在祖先滚动时关闭，并允许实例关闭该行为', (tester) async {
      await tester.pumpWidget(app(
        TSwipeCell(
          child: const TCell(title: Text('Default')),
          end: panel('End'),
        ),
      ));
      expect(
        tester.widget<Slidable>(find.byType(Slidable)).closeOnScroll,
        isTrue,
      );

      await tester.pumpWidget(app(
        TSwipeCell(
          child: const TCell(title: Text('Explicit')),
          end: panel('End'),
          closeOnScroll: false,
        ),
      ));
      expect(
        tester.widget<Slidable>(find.byType(Slidable)).closeOnScroll,
        isFalse,
      );
    });

    testWidgets('onOpenChanged 使用 start/end 语义', (tester) async {
      TSwipeCellSide? side;
      bool? isOpen;
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const TCell(title: Text('Row')),
          start: panel('Start'),
          onOpenChanged: (value, open) {
            side = value;
            isOpen = open;
          },
        ),
      )));
      await tester.drag(find.text('Row'), const Offset(120, 0));
      await tester.pumpAndSettle();
      expect(side, TSwipeCellSide.start);
      expect(isOpen, isTrue);
    });

    testWidgets('closeWhenOpened 只关闭同一 groupTag 的已展开项', (tester) async {
      final events = <String>[];
      TSwipeCell item(String id) => TSwipeCell(
            child: SizedBox(
              key: ValueKey(id),
              width: 300,
              height: 60,
              child: Text(id),
            ),
            start: panel('Start $id'),
            groupTag: 'inbox',
            closeWhenOpened: true,
            onOpenChanged: (side, isOpen) {
              events.add('$id:${side.name}:$isOpen');
            },
          );

      await tester
          .pumpWidget(app(Column(children: [item('one'), item('two')])));
      await tester.drag(
          find.byKey(const ValueKey('one')), const Offset(120, 0));
      await tester.pumpAndSettle();
      await tester.drag(
          find.byKey(const ValueKey('two')), const Offset(120, 0));
      await tester.pumpAndSettle();

      expect(
          events,
          containsAllInOrder(
              ['one:start:true', 'two:start:true', 'one:start:false']));
    });

    testWidgets('initialOpenSide 打开指定面板', (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        end: panel('End'),
        initialOpenSide: TSwipeCellSide.end,
      )));
      await tester.pumpAndSettle();
      expect(find.text('End'), findsOneWidget);
    });

    testWidgets('重建不会因内部 UniqueKey 丢失 Slidable 状态', (tester) async {
      final child = TSwipeCell(child: const Text('Stable'), end: panel('End'));
      await tester.pumpWidget(app(child));
      final before = tester.element(find.byType(Slidable));
      await tester.pumpWidget(app(child));
      final after = tester.element(find.byType(Slidable));
      expect(after, same(before));
    });

    testWidgets('移除最后一个分组控制器后仍可安全关闭分组', (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const Text('Grouped'),
        end: panel('End'),
        groupTag: 'group',
      )));
      await tester.pumpWidget(app(const SizedBox.shrink()));
      expect(() => TSwipeCell.close('group'), returnsNormally);
    });

    testWidgets('二次确认支持按 id 匹配重建的等价 action', (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        end: TSwipeCellPanel(
          children: [TSwipeCellAction(label: '删除', id: 'delete')],
          confirms: [
            TSwipeCellAction(
              label: '确认删除',
              id: 'delete-confirm',
              confirmIndex: const [0],
            ),
          ],
        ),
        initialOpenSide: TSwipeCellSide.end,
      )));
      await tester.pumpAndSettle();

      // 通过 Inherited 拿到 actionClick，用重建的等价 action（同 id）触发二次确认
      final inherited =
          TSwipeCellInherited.of(tester.element(find.text('删除')))!;
      final recreated =
          TSwipeCellAction(label: '删除', id: 'delete');
      expect(inherited.actionClick(recreated), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('确认删除'), findsOneWidget);
    });

    testWidgets('二次确认在无 id 时按实例引用匹配', (tester) async {
      final action = TSwipeCellAction(label: '删除');
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        end: TSwipeCellPanel(
          children: [action],
          confirms: [
            TSwipeCellAction(
              label: '确认删除',
              confirmIndex: const [0],
            ),
          ],
        ),
        initialOpenSide: TSwipeCellSide.end,
      )));
      await tester.pumpAndSettle();

      final inherited =
          TSwipeCellInherited.of(tester.element(find.text('删除')))!;
      expect(inherited.actionClick(action), isTrue);
    });

    testWidgets('操作项图标与文字均以 Flexible 包裹，布局对称', (tester) async {
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const TCell(title: Text('Row')),
          end: TSwipeCellPanel(
            children: [
              TSwipeCellAction(
                icon: Icons.edit,
                label: 'Action',
                onPressed: (_) {},
              ),
            ],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
      )));
      await tester.pumpAndSettle();
      final flex = tester.widget<Flex>(
        find.ancestor(
          of: find.text('Action'),
          matching: find.byType(Flex),
        ),
      );
      final flexibleCount = flex.children
          .where((child) => child is Flexible)
          .length;
      expect(flexibleCount, greaterThanOrEqualTo(2));
    });
  });
}

TSwipeCellAction panelAction(String label) =>
    TSwipeCellAction(label: label, onPressed: (_) {});
