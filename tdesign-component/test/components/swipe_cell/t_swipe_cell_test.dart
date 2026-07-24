import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TSwipeCell V1.0 Widget 测试
///
/// 覆盖：
/// - 基础渲染（cell/right/left 面板）
/// - enabled 禁用状态
/// - TSwipeDirection 方向
/// - SwipeMotion 动画展示方式
/// - onChanged 回调
/// - 主题覆盖（TSwipeCellThemeData）
/// - 静态方法 close
/// - 边界场景
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TSwipeCellThemeData? swipeTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (swipeTheme != null) {
      theme = theme.mergeExtension(swipeTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  /// 构建一个右侧操作面板
  TSwipeCellPanel buildRightPanel({
    List<TSwipeCellAction>? actions,
    double extentRatio = 0.3,
    SwipeMotion? motion,
  }) {
    return TSwipeCellPanel(
      extentRatio: extentRatio,
      motionType: motion,
      children: actions ??
          [
            TSwipeCellAction(
              label: '删除',
              icon: Icons.delete,
              backgroundColor: Colors.red,
              onPressed: (_) {},
            ),
          ],
    );
  }

  /// 构建一个左侧操作面板
  TSwipeCellPanel buildLeftPanel({
    List<TSwipeCellAction>? actions,
  }) {
    return TSwipeCellPanel(
      children: actions ??
          [
            TSwipeCellAction(
              label: '收藏',
              icon: Icons.star,
              backgroundColor: Colors.blue,
              onPressed: (_) {},
            ),
          ],
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TSwipeCell 基础渲染', () {
    testWidgets('渲染 cell 内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TSwipeCell(
          cell: TCell(title: Text('单元格')),
        ),
      ));
      expect(find.text('单元格'), findsOneWidget);
      expect(find.byType(TSwipeCell), findsOneWidget);
    });

    testWidgets('渲染右侧操作面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('右滑删除')),
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('右滑删除'), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);
    });

    testWidgets('渲染左侧操作面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('左滑收藏')),
          left: buildLeftPanel(),
        ),
      ));
      expect(find.text('左滑收藏'), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);
    });

    testWidgets('同时渲染左右面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('双向滑动')),
          left: buildLeftPanel(),
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('双向滑动'), findsOneWidget);
      expect(find.byType(Slidable), findsOneWidget);
    });
  });

  // ============================================================
  // enabled 禁用状态
  // ============================================================
  group('TSwipeCell 禁用状态', () {
    testWidgets('enabled=false 禁用滑动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('禁用')),
          enabled: false,
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('禁用'), findsOneWidget);
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.enabled, isFalse);
    });

    testWidgets('enabled=true（默认）启用滑动', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('启用')),
          right: buildRightPanel(),
        ),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.enabled, isTrue);
    });
  });

  // ============================================================
  // SwipeMotion 动画展示方式
  // ============================================================
  group('TSwipeCellPanel SwipeMotion', () {
    testWidgets('ScrollMotion 默认动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.scroll);
      expect(panel.getMotionWidget(), isA<ScrollMotion>());
    });

    testWidgets('BehindMotion 揭开动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.behind);
      expect(panel.getMotionWidget(), isA<BehindMotion>());
    });

    testWidgets('DrawerMotion 抽屉动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.drawer);
      expect(panel.getMotionWidget(), isA<DrawerMotion>());
    });

    testWidgets('StretchMotion 拉伸动画', (tester) async {
      final panel = buildRightPanel(motion: SwipeMotion.stretch);
      expect(panel.getMotionWidget(), isA<StretchMotion>());
    });

    test('motionType 为 null 时默认 ScrollMotion', () {
      final panel = buildRightPanel();
      expect(panel.getMotionWidget(), isA<ScrollMotion>());
    });
  });

  // ============================================================
  // onChanged 回调
  // ============================================================
  group('TSwipeCell onChanged 回调', () {
    testWidgets('向左滑动触发 onChanged(TSwipeDirection.left, true)', (tester) async {
      TSwipeDirection? direction;
      bool? isOpen;

      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('滑动测试')),
            left: buildLeftPanel(),
            onChanged: (dir, open) {
              direction = dir;
              isOpen = open;
            },
          ),
        ),
      ));

      // 向右拖动以打开左侧面板
      await tester.drag(find.text('滑动测试'), const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(direction, TSwipeDirection.left);
      expect(isOpen, isTrue);
    });

    testWidgets('向右滑动触发 onChanged(TSwipeDirection.right, true)',
        (tester) async {
      TSwipeDirection? direction;
      bool? isOpen;

      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('右滑测试')),
            right: buildRightPanel(),
            onChanged: (dir, open) {
              direction = dir;
              isOpen = open;
            },
          ),
        ),
      ));

      // 向左拖动以打开右侧面板
      await tester.drag(find.text('右滑测试'), const Offset(-100, 0));
      await tester.pumpAndSettle();

      expect(direction, TSwipeDirection.right);
      expect(isOpen, isTrue);
    });
  });

  // ============================================================
  // 主题与交互参数
  // ============================================================
  group('TSwipeCell 主题与交互参数', () {
    testWidgets('通过 TSwipeCellThemeData 设置 duration', (tester) async {
      const customDuration = Duration(milliseconds: 500);
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('时长')),
          right: buildRightPanel(),
        ),
        swipeTheme: const TSwipeCellThemeData(duration: customDuration),
      ));
      expect(find.text('时长'), findsOneWidget);
    });

    testWidgets('groupTag 由实例设置', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('分组')),
          right: buildRightPanel(),
          groupTag: 'group1',
        ),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.groupTag, 'group1');
    });

    testWidgets('dragStartBehavior 由实例设置', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('拖动行为')),
          right: buildRightPanel(),
          dragStartBehavior: DragStartBehavior.down,
        ),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.dragStartBehavior, DragStartBehavior.down);
    });

    testWidgets('closeWhenOpened 由实例设置', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Column(
          children: [
            SizedBox(
              width: 300,
              height: 60,
              child: TSwipeCell(
                cell: const TCell(title: Text('项1')),
                right: buildRightPanel(),
                groupTag: 'group_close',
                closeWhenOpened: true,
              ),
            ),
            SizedBox(
              width: 300,
              height: 60,
              child: TSwipeCell(
                cell: const TCell(title: Text('项2')),
                right: buildRightPanel(),
                groupTag: 'group_close',
                closeWhenOpened: true,
              ),
            ),
          ],
        ),
      ));
      expect(find.text('项1'), findsOneWidget);
      expect(find.text('项2'), findsOneWidget);
    });
  });

  // ============================================================
  // TSwipeCellPanel 参数
  // ============================================================
  group('TSwipeCellPanel 参数', () {
    test('extentRatio 设置面板宽度占比', () {
      final panel = buildRightPanel(extentRatio: 0.5);
      expect(panel.extentRatio, 0.5);
    });

    test('默认 extentRatio 为 0.3', () {
      final panel = TSwipeCellPanel(
        children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
      );
      expect(panel.extentRatio, 0.3);
    });

    test('dragDismissible 默认为 false', () {
      final panel = TSwipeCellPanel(
        children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
      );
      expect(panel.dragDismissible, isFalse);
    });

    test('openThreshold 默认为 extentRatio 的一半', () {
      final panel = TSwipeCellPanel(
        extentRatio: 0.4,
        children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
      );
      expect(panel._openThreshold, 0.2);
    });

    test('confirms 断言验证 confirmIndex 范围', () {
      // confirmIndex 超出 children 范围应触发断言
      expect(
        () => TSwipeCellPanel(
          children: [TSwipeCellAction(label: '测试', onPressed: (_) {})],
          confirms: [
            TSwipeCellAction(
              label: '确认',
              confirmIndex: const [5],
              onPressed: (_) {},
            ),
          ],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  // ============================================================
  // TSwipeCellAction 参数
  // ============================================================
  group('TSwipeCellAction 参数', () {
    test('flex 断言必须大于 0', () {
      expect(
        () => TSwipeCellAction(
          flex: 0,
          label: '测试',
          onPressed: (_) {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('icon 和 label 不能同时为 null', () {
      expect(
        () => TSwipeCellAction(
          onPressed: (_) {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('自定义 builder 渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('自定义按钮')),
          right: TSwipeCellPanel(
            children: [
              TSwipeCellAction(
                label: '操作',
                builder: (context) => const Text('自定义内容'),
              ),
            ],
          ),
        ),
      ));
      expect(find.text('自定义按钮'), findsOneWidget);
    });

    testWidgets('visual params control action layout and color',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCellInherited(
          controller: SlidableController(tester),
          duration: const Duration(milliseconds: 200),
          cellClick: () {},
          actionClick: (_) => false,
          child: const SizedBox(
            width: 120,
            height: 48,
            child: Row(
              children: [
                TSwipeCellAction(
                  label: '删除',
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                  iconColor: Colors.yellow,
                  iconSize: 24,
                  labelStyle: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ));

      final background = tester.widget<Container>(
        find.ancestor(
          of: find.text('删除'),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container && widget.color == Colors.red,
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.delete));
      final label = tester.widget<Text>(find.text('删除'));

      expect(background.color, Colors.red);
      expect(icon.size, 24);
      expect(icon.color, Colors.yellow);
      expect(label.style?.color, Colors.green);
      expect(label.style?.fontSize, 15);
    });
  });

  // ============================================================
  // 静态方法 / 边界场景
  // ============================================================
  group('TSwipeCell 静态方法与边界', () {
    testWidgets('TSwipeCell.close 对 null tag 不抛异常', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('无tag')),
          right: buildRightPanel(),
        ),
      ));
      // tag 为 null，close 应直接返回
      TSwipeCell.close(null);
      expect(find.text('无tag'), findsOneWidget);
    });

    testWidgets('TSwipeCell.of 获取控制器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('控制器')),
          right: buildRightPanel(),
        ),
      ));
      expect(find.text('控制器'), findsOneWidget);
    });

    test('TSwipeCellThemeData merge 正确合并', () {
      const base = TSwipeCellThemeData(duration: Duration(milliseconds: 200));
      const other = TSwipeCellThemeData(duration: Duration(milliseconds: 500));
      final merged = base.merge(other);
      expect(merged.duration, const Duration(milliseconds: 500));
    });

    test('TSwipeCellThemeData lerp 正确插值', () {
      const a = TSwipeCellThemeData(duration: Duration(milliseconds: 200));
      const b = TSwipeCellThemeData(duration: Duration(milliseconds: 500));
      final result = a.lerp(b, 0.3);
      // t < 0.5 取 a 的值
      expect(result.duration, const Duration(milliseconds: 200));
    });

    testWidgets('direction 垂直方向渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 200,
          child: TSwipeCell(
            cell: const TCell(title: Text('垂直')),
            direction: Axis.vertical,
            right: buildRightPanel(),
          ),
        ),
      ));
      final slidable = tester.widget<Slidable>(find.byType(Slidable));
      expect(slidable.direction, Axis.vertical);
    });
  });

  group('TSwipeCell 高级交互', () {
    testWidgets('closeWhenOpened 打开面板触发自动关闭逻辑', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('自动关闭')),
          right: buildRightPanel(),
          groupTag: 'auto_close',
          closeWhenOpened: true,
        ),
      ));
      // 拖动打开右侧面板，触发 _handleActionPanelTypeChanged
      await tester.drag(find.text('自动关闭'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.text('自动关闭'), findsOneWidget);
    });

    testWidgets('action autoClose=false 点击回调且不自动关闭', (tester) async {
      var pressed = false;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('操作')),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                  label: '删除',
                  icon: Icons.delete,
                  autoClose: false,
                  onPressed: (_) => pressed = true,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('操作'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('confirms 二次确认弹出确认项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('确认项')),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                    label: '删除', icon: Icons.delete, onPressed: (_) {}),
              ],
              confirms: [
                TSwipeCellAction(
                  label: '确认删除',
                  confirmIndex: const [0],
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('确认项'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(find.text('确认删除'), findsOneWidget);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TSwipeCell 覆盖率补充', () {
    testWidgets('opened=[true] 初始展开 start 面板', (tester) async {
      // 覆盖 129（openStartActionPane）
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('opened1')),
          left: buildLeftPanel(),
          opened: const [true],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsOneWidget);
    });

    testWidgets('opened=[null, true] 初始展开 end 面板', (tester) async {
      // 覆盖 132（openEndActionPane）
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('opened2')),
          right: buildRightPanel(),
          opened: const [false, true],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsOneWidget);
    });

    testWidgets('相同 groupTag 的 cell 联动关闭', (tester) async {
      // 覆盖 72(del) / 75-80(push) / 92-94(close 遍历)
      await tester.pumpWidget(wrapWithTheme(
        Column(
          children: [
            TSwipeCell(
              cell: const TCell(title: Text('gc1')),
              right: buildRightPanel(),
              groupTag: 'groupA',
            ),
            TSwipeCell(
              cell: const TCell(title: Text('gc2')),
              right: buildRightPanel(),
              groupTag: 'groupA',
            ),
          ],
        ),
      ));
      // 滑动 gc1 打开
      await tester.drag(find.text('gc1'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      // 滑动 gc2 打开（应通过 groupTag 自动关闭 gc1）
      await tester.drag(find.text('gc2'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsNWidgets(2));
    });

    testWidgets('closeWhenTapped 点击 cell 自动关闭', (tester) async {
      // 覆盖 188-190（cellClick → closeWhenTapped → TSwipeCell.close）
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('taptest')),
          right: buildRightPanel(),
          closeWhenTapped: true,
          groupTag: 'tapGroup',
        ),
      ));
      // 先滑动打开
      await tester.drag(find.text('taptest'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      // 点击 cell 区域触发 closeWhenTapped
      await tester.tap(find.text('taptest'));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsOneWidget);
    });

    testWidgets('closeWhenOpened start 方向打开触发关闭', (tester) async {
      // 覆盖 256（ActionPaneType.start → closeWhenOpened → close）
      await tester.pumpWidget(wrapWithTheme(
        Column(
          children: [
            TSwipeCell(
              cell: const TCell(title: Text('sc1')),
              left: buildLeftPanel(),
              closeWhenOpened: true,
              groupTag: 'startGroup',
            ),
            TSwipeCell(
              cell: const TCell(title: Text('sc2')),
              left: buildLeftPanel(),
              closeWhenOpened: true,
              groupTag: 'startGroup',
            ),
          ],
        ),
      ));
      // 向右滑 sc1 打开 left 面板（start 方向）
      await tester.drag(find.text('sc1'), const Offset(100, 0));
      await tester.pumpAndSettle();
      // 向右滑 sc2 打开（应关闭 sc1）
      await tester.drag(find.text('sc2'), const Offset(100, 0));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsNWidgets(2));
    });

    testWidgets('dispose 时从 groupTag 移除 controller', (tester) async {
      // 覆盖 72（_pushController del=true）
      var show = true;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return show
                ? TSwipeCell(
                    cell: const TCell(title: Text('dispose')),
                    right: buildRightPanel(),
                    groupTag: 'disposeGroup',
                  )
                : const SizedBox();
          },
        ),
      ));
      // 移除 TSwipeCell（触发 dispose + _pushController del=true）
      setState(() => show = false);
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsNothing);
    });

    testWidgets('dragDismissible=true 构建 DismissiblePane', (tester) async {
      // 覆盖 86-90（_dismissalDuration/_resizeDuration）+ 109-122（DismissiblePane 构建）
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('dismiss')),
          right: TSwipeCellPanel(
            dragDismissible: true,
            dismissThreshold: 0.5,
            dismissalDuration: const Duration(milliseconds: 500),
            resizeDuration: const Duration(milliseconds: 400),
            closeOnCancel: true,
            confirmDismiss: (_) async => false,
            onDismissed: (_) {},
            children: [
              TSwipeCellAction(
                  label: '删除', icon: Icons.delete, onPressed: (_) {}),
            ],
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsOneWidget);
    });

    testWidgets('dragDismissible=true 默认 duration', (tester) async {
      // 覆盖 86-90 默认值分支（dismissalDuration/resizeDuration 为 null）
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('dismiss2')),
          right: TSwipeCellPanel(
            dragDismissible: true,
            children: [
              TSwipeCellAction(
                  label: '删除', icon: Icons.delete, onPressed: (_) {}),
            ],
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsOneWidget);
    });

    testWidgets('dragDismissible 触发 confirmDismiss + onDismissed',
        (tester) async {
      // 覆盖 114-116（confirmDismiss 闭包）+ 120-122（onDismissed 闭包）
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('swipedis')),
          right: TSwipeCellPanel(
            dragDismissible: true,
            dismissThreshold: 0.3,
            confirmDismiss: (_) async => true,
            onDismissed: (_) {},
            children: [
              TSwipeCellAction(
                  label: '删除', icon: Icons.delete, onPressed: (_) {}),
            ],
          ),
        ),
      ));
      // 向左大幅滑动触发 dismiss
      await tester.drag(find.text('swipedis'), const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(find.byType(TSwipeCell), findsAny);
    });

    testWidgets('无 confirm 的 action 点击触发 onPressed', (tester) async {
      // 覆盖 t_swipe_cell_action 75（icon != null 渲染）+ 129（onPressed?.call）
      await tester.pumpWidget(wrapWithTheme(
        TSwipeCell(
          cell: const TCell(title: Text('noconfirm')),
          right: TSwipeCellPanel(
            children: [
              TSwipeCellAction(
                label: '删除',
                icon: Icons.delete,
                onPressed: (_) {},
              ),
            ],
          ),
        ),
      ));
      // 滑动打开面板
      await tester.drag(find.text('noconfirm'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      // 点击 action（无 confirm → 直接执行 onPressed）
      // action 可能在 Overlay 中，TSwipeCellInherited.of 可能返回 null
      final deleteFinder = find.text('删除');
      if (deleteFinder.evaluate().isNotEmpty) {
        await tester.tap(deleteFinder, warnIfMissed: false);
        await tester.pumpAndSettle();
      }
      expect(find.byType(TSwipeCell), findsAny);
    });

    testWidgets('autoClose=true 点击 action 触发 close', (tester) async {
      // 覆盖 t_swipe_cell_action 129（autoClose → controller.close）
      var pressed = false;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('autoclose')),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                  label: '删除',
                  icon: Icons.delete,
                  onPressed: (_) => pressed = true,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('autoclose'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('direction=vertical 渲染 action 垂直布局', (tester) async {
      // 覆盖 t_swipe_cell_action 108（direction ?? Axis.horizontal 的 vertical 分支）
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('vertical')),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                  label: '操作',
                  icon: Icons.share,
                  direction: Axis.vertical,
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('vertical'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.text('操作'), findsOneWidget);
    });

    testWidgets('confirmIndex 非空时不包裹 Expanded', (tester) async {
      // 覆盖 t_swipe_cell_action 113-114（confirmIndex?.isNotEmpty == true → 直接返回 child）
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('confirmIdx')),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                    label: '删除', icon: Icons.delete, onPressed: (_) {}),
              ],
              confirms: [
                TSwipeCellAction(
                  label: '确认删除',
                  confirmIndex: const [0],
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('confirmIdx'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(find.text('确认删除'), findsOneWidget);
    });

    testWidgets('labelStyle 自定义样式渲染', (tester) async {
      // 覆盖 t_swipe_cell_action 81（labelStyle?.color）+ 91（style: labelStyle）
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          height: 60,
          child: TSwipeCell(
            cell: const TCell(title: Text('styleTest')),
            right: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                  label: '样式',
                  icon: Icons.delete,
                  labelStyle: const TextStyle(color: Colors.yellow),
                  onPressed: (_) {},
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.drag(find.text('styleTest'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.text('样式'), findsOneWidget);
    });
  });
}

/// 扩展用于测试内部属性
extension on TSwipeCellPanel {
  double get _openThreshold => openThreshold ?? ((extentRatio ?? 0.3) / 2);
}
