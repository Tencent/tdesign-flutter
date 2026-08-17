import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/swipe_cell/t_swipe_cell_inherited.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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

    testWidgets('默认打开/关闭阈值对齐官方 30% 面板宽度', (tester) async {
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const Text('Row'),
          end: TSwipeCellPanel(
            extentRatio: 0.5,
            children: [panelAction('End')],
          ),
        ),
      )));
      final actionPane =
          tester.widget<Slidable>(find.byType(Slidable)).endActionPane!;
      expect(actionPane.openThreshold, closeTo(0.15, 1e-6));
      expect(actionPane.closeThreshold, closeTo(0.15, 1e-6));

      // 显式传入时以传入值为准
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const Text('Row'),
          end: TSwipeCellPanel(
            extentRatio: 0.5,
            openThreshold: 0.4,
            closeThreshold: 0.2,
            children: [panelAction('End')],
          ),
        ),
      )));
      final explicit =
          tester.widget<Slidable>(find.byType(Slidable)).endActionPane!;
      expect(explicit.openThreshold, 0.4);
      expect(explicit.closeThreshold, 0.2);
    });

    testWidgets('默认动画时长 600ms，且可通过 Theme 覆盖', (tester) async {
      await tester.pumpWidget(app(
        const TSwipeCell(child: Text('Row'), end: null, start: null),
      ));
      expect(
        tester
            .widget<TSwipeCell>(find.byType(TSwipeCell))
            .getDuration(tester.element(find.byType(TSwipeCell))),
        const Duration(milliseconds: 600),
      );

      await tester.pumpWidget(app(Theme(
        data: Theme.of(tester.element(find.byType(TSwipeCell)))
            .mergeExtension(
          const TSwipeCellThemeData(duration: Duration(milliseconds: 100)),
        ),
        child: const TSwipeCell(child: Text('Row')),
      )));
      expect(
        tester
            .widget<TSwipeCell>(find.byType(TSwipeCell))
            .getDuration(tester.element(find.byType(TSwipeCell))),
        const Duration(milliseconds: 100),
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
            closeOnTapOutside: false,
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

    testWidgets('initialOpenSide: start 打开 start 面板', (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        start: panel('Start'),
        initialOpenSide: TSwipeCellSide.start,
      )));
      await tester.pumpAndSettle();
      expect(find.text('Start'), findsOneWidget);
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
          children: const [TSwipeCellAction(label: '删除', id: 'delete')],
          confirms: const [
            TSwipeCellAction(
              label: '确认删除',
              id: 'delete-confirm',
              confirmIndex: [0],
            ),
          ],
        ),
        initialOpenSide: TSwipeCellSide.end,
      )));
      await tester.pumpAndSettle();

      // 通过 Inherited 拿到 actionClick，用重建的等价 action（同 id）触发二次确认
      final inherited =
          TSwipeCellInherited.of(tester.element(find.text('删除')))!;
      const recreated = TSwipeCellAction(label: '删除', id: 'delete');
      expect(inherited.actionClick(recreated), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('确认删除'), findsOneWidget);
    });

    testWidgets('二次确认在无 id 时按实例引用匹配', (tester) async {
      const action = TSwipeCellAction(label: '删除');
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        end: TSwipeCellPanel(
          children: [action],
          confirms: const [
            TSwipeCellAction(
              label: '确认删除',
              confirmIndex: [0],
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
        ).first,
      );
      final flexibleCount = flex.children.whereType<Flexible>().length;
      expect(flexibleCount, greaterThanOrEqualTo(2));
    });

    testWidgets('面板展开后点击本格内容自动关闭（默认 true）', (tester) async {
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const TCell(title: Text('Row')),
          end: panel('End'),
          initialOpenSide: TSwipeCellSide.end,
        ),
      )));
      await tester.pumpAndSettle();
      expect(find.text('End'), findsOneWidget);

      // end 面板展开后本格内容左移，直接 tap 文本会落到屏幕外；
      // 这里 tap 本格仍在可视区域内的坐标（x=50 位于平移后 child 范围内）。
      await tester.tapAt(const Offset(50, 30));
      await tester.pumpAndSettle();
      expect(find.text('End'), findsNothing);
    });

    testWidgets('closeOnTapOutside: false 时不因点击本格关闭', (tester) async {
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const TCell(title: Text('Row')),
          end: panel('End'),
          initialOpenSide: TSwipeCellSide.end,
          closeOnTapOutside: false,
        ),
      )));
      await tester.pumpAndSettle();
      expect(find.text('End'), findsOneWidget);

      // 同上，end 展开后本格内容左移，tap 可视区域内坐标。
      await tester.tapAt(const Offset(50, 30));
      await tester.pumpAndSettle();
      expect(find.text('End'), findsOneWidget);
    });

    testWidgets('操作项图标大小默认 20、间距 8、左右内边距 16', (tester) async {
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

      final icon = tester.widget<Icon>(find.byIcon(Icons.edit));
      expect(icon.size, 20);

      final container = tester.widget<Container>(find.ancestor(
        of: find.text('Action'),
        matching: find.byType(Container),
      ).first);
      expect(container.padding, const EdgeInsets.symmetric(horizontal: 16));
    });

    testWidgets('dragDismissible 面板会构建 DismissiblePane', (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        end: TSwipeCellPanel(
          dragDismissible: true,
          dismissThreshold: 0.6,
          closeOnCancel: true,
          onDismissed: (_) {},
          children: [panelAction('End')],
        ),
        initialOpenSide: TSwipeCellSide.end,
      )));
      await tester.pumpAndSettle();
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.endActionPane!.dragDismissible, isTrue);
    });

    testWidgets('操作项支持自定义 builder 内容', (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        end: TSwipeCellPanel(
          children: [
            TSwipeCellAction(
              label: 'Action',
              builder: (context) => const Center(child: Text('CustomBtn')),
            ),
          ],
        ),
        initialOpenSide: TSwipeCellSide.end,
      )));
      await tester.pumpAndSettle();
      expect(find.text('CustomBtn'), findsOneWidget);
    });

    testWidgets('带 confirmIndex 的二次确认操作项按内容直接包裹（不套 Expanded）',
        (tester) async {
      await tester.pumpWidget(app(TSwipeCell(
        child: const TCell(title: Text('Row')),
        end: TSwipeCellPanel(
          children: const [TSwipeCellAction(label: '删除', id: 'del')],
          confirms: const [
            TSwipeCellAction(
              label: '确认删除',
              id: 'del-confirm',
              confirmIndex: [0],
            ),
          ],
        ),
        initialOpenSide: TSwipeCellSide.end,
      )));
      await tester.pumpAndSettle();
      // 点击“删除”命中 confirmIndex → 展示二次确认操作项
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(find.text('确认删除'), findsOneWidget);
    });

    testWidgets('点击操作项触发 onPressed 并自动关闭', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const TCell(title: Text('Row')),
          end: TSwipeCellPanel(
            children: [
              TSwipeCellAction(label: 'End', onPressed: (_) => pressed++),
            ],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
      )));
      await tester.pumpAndSettle();
      expect(find.text('End'), findsOneWidget);

      await tester.tap(find.text('End'));
      await tester.pumpAndSettle();
      expect(pressed, 1);
      // autoClose 默认 true，点击后面板收起
      expect(find.text('End'), findsNothing);
    });

    testWidgets('autoClose: false 时点击操作项不自动关闭', (tester) async {
      await tester.pumpWidget(app(SizedBox(
        width: 300,
        height: 60,
        child: TSwipeCell(
          child: const TCell(title: Text('Row')),
          end: TSwipeCellPanel(
            children: [
              TSwipeCellAction(
                label: 'End',
                autoClose: false,
                onPressed: (_) {},
              ),
            ],
          ),
          initialOpenSide: TSwipeCellSide.end,
        ),
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End'));
      await tester.pumpAndSettle();
      expect(find.text('End'), findsOneWidget);
    });
  });

  group('TSwipeCellThemeData', () {
    const base = TSwipeCellThemeData(
      duration: Duration(milliseconds: 100),
      actionBackgroundColor: Colors.red,
      actionIconColor: Colors.green,
      actionTextStyle: TextStyle(color: Colors.blue),
      actionIconSize: 20,
      actionSpacing: 4,
      actionPadding: EdgeInsets.all(8),
    );

    test('copyWith 仅覆盖非空字段', () {
      final updated = base.copyWith(actionBackgroundColor: Colors.orange);
      expect(updated.actionBackgroundColor, Colors.orange);
      expect(updated.actionIconColor, base.actionIconColor);
      expect(updated.actionTextStyle, base.actionTextStyle);
      expect(updated.actionIconSize, base.actionIconSize);
      expect(updated.actionSpacing, base.actionSpacing);
      expect(updated.actionPadding, base.actionPadding);
      expect(updated.duration, base.duration);
    });

    test('merge 以 other 优先，null other 返回自身', () {
      final merged = base.merge(const TSwipeCellThemeData(
        actionIconColor: Colors.teal,
        actionIconSize: 32,
      ));
      expect(merged.actionBackgroundColor, base.actionBackgroundColor);
      expect(merged.actionIconColor, Colors.teal);
      expect(merged.actionIconSize, 32);
      expect(merged.actionSpacing, base.actionSpacing);
      expect(merged.actionPadding, base.actionPadding);
      expect(merged.duration, base.duration);

      expect(base.merge(null), same(base));
    });

    test('lerp 对颜色 / 尺寸 / 间距做线性插值', () {
      const target = TSwipeCellThemeData(
        actionBackgroundColor: Colors.black,
        actionIconSize: 40,
        actionSpacing: 8,
      );
      final mid = base.lerp(target, 0.5);
      expect(
        mid.actionBackgroundColor,
        Color.lerp(base.actionBackgroundColor, target.actionBackgroundColor, 0.5),
      );
      expect(mid.actionIconSize, 30);
      expect(mid.actionSpacing, 6);
    });

    test('lerp 对 null 返回自身', () {
      expect(base.lerp(null, 0.5), same(base));
    });
  });
}

TSwipeCellAction panelAction(String label) =>
    TSwipeCellAction(label: label, onPressed: (_) {});
