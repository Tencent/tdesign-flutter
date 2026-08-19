import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget app(Widget child, {TextDirection direction = TextDirection.ltr}) {
    return MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Directionality(
        textDirection: direction,
        child: Scaffold(body: child),
      ),
    );
  }

  TSwipeCellPanel panel(String label, {VoidCallback? onPressed}) {
    return TSwipeCellPanel(
      children: [
        TSwipeCellAction(
          label: label,
          onPressed: onPressed == null ? null : (_) => onPressed(),
        ),
      ],
    );
  }

  Widget cell({
    Key? childKey,
    TSwipeCellController? controller,
    TSwipeCellPanel? start,
    TSwipeCellPanel? end,
    TSwipeCellSide? initialOpenSide,
    TSwipeCellChanged? onOpenChanged,
    bool enabled = true,
    bool closeOnScroll = true,
    Widget? child,
  }) {
    return SizedBox(
      width: 300,
      height: 64,
      child: TSwipeCell(
        controller: controller,
        start: start,
        end: end,
        initialOpenSide: initialOpenSide,
        onOpenChanged: onOpenChanged,
        enabled: enabled,
        closeOnScroll: closeOnScroll,
        child:
            child ??
            ColoredBox(
              key: childKey,
              color: Colors.white,
              child: const SizedBox.expand(child: Text('内容')),
            ),
      ),
    );
  }

  group('API', () {
    test('面板与操作项校验无效配置', () {
      expect(() => TSwipeCellPanel(children: const []), throwsAssertionError);
      expect(TSwipeCellAction.new, throwsAssertionError);
    });

    testWidgets('未绑定控制器时命令安全完成', (tester) async {
      final controller = TSwipeCellController();
      await controller.open(TSwipeCellSide.end);
      await controller.close();
    });

    testWidgets('更新外部控制器后由新控制器接管', (tester) async {
      final childKey = GlobalKey();
      final first = TSwipeCellController();
      final second = TSwipeCellController();
      await tester.pumpWidget(
        app(cell(childKey: childKey, controller: first, end: panel('删除'))),
      );
      await tester.pump();
      await tester.pumpWidget(
        app(cell(childKey: childKey, controller: second, end: panel('删除'))),
      );
      unawaited(first.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, 0);
      unawaited(second.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, lessThan(0));
    });
  });

  group('尺寸与布局', () {
    testWidgets('标准操作项按真实内容宽度展开且文字完整', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(
        app(
          cell(
            childKey: childKey,
            end: panel('非常长的操作'),
            initialOpenSide: TSwipeCellSide.end,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final actionWidth = tester.getSize(find.byType(TSwipeCellAction)).width;
      expect(
        tester.getTopLeft(find.byKey(childKey)).dx,
        closeTo(-actionWidth, 0.1),
      );
      expect(
        tester
            .renderObject<RenderParagraph>(find.text('非常长的操作'))
            .didExceedMaxLines,
        isFalse,
      );
    });

    testWidgets('不同文案保留各自真实宽度', (tester) async {
      await tester.pumpWidget(
        app(
          cell(
            end: TSwipeCellPanel(
              children: [
                const TSwipeCellAction(label: '编辑'),
                const TSwipeCellAction(label: '非常长的操作'),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      final sizes = tester
          .widgetList<TSwipeCellAction>(find.byType(TSwipeCellAction))
          .map((action) => tester.getSize(find.byWidget(action)).width)
          .toList();
      expect(sizes[1], greaterThan(sizes[0]));
    });

    testWidgets('自定义 builder 直接决定宽度', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(
        app(
          cell(
            childKey: childKey,
            end: TSwipeCellPanel(
              children: [
                TSwipeCellAction(
                  builder: (_) => const SizedBox(width: 90, child: Text('自定义')),
                ),
              ],
            ),
            initialOpenSide: TSwipeCellSide.end,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TSwipeCellAction)).width, 90);
      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(-90, 0.1));
    });

    testWidgets('图标、文字与主题尺寸共同参与真实布局', (tester) async {
      await tester.pumpWidget(
        app(
          Theme(
            data: TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(
              const TSwipeCellThemeData(
                actionIconSize: 24,
                actionSpacing: 12,
                actionPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            child: cell(
              end: TSwipeCellPanel(
                children: [
                  const TSwipeCellAction(icon: Icons.edit, label: '编辑'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.getSize(find.byType(Icon)).width, 24);
      expect(
        tester.getSize(find.byType(TSwipeCellAction)).width,
        greaterThan(76),
      );
    });

    testWidgets('展开后操作项宽度变化会校正当前偏移', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      await tester.pumpWidget(
        app(cell(childKey: childKey, controller: controller, end: panel('删除'))),
      );
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        app(
          cell(
            childKey: childKey,
            controller: controller,
            end: panel('非常长的操作'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      final newWidth = tester.getSize(find.byType(TSwipeCellAction)).width;
      expect(
        tester.getTopLeft(find.byKey(childKey)).dx,
        closeTo(-newWidth, 0.1),
      );
    });

    testWidgets('展开侧面板被移除时立即恢复关闭状态', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      final changes = <bool>[];
      await tester.pumpWidget(
        app(
          cell(
            childKey: childKey,
            controller: controller,
            end: panel('删除'),
            onOpenChanged: (_, open) => changes.add(open),
          ),
        ),
      );
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        app(
          cell(
            childKey: childKey,
            controller: controller,
            onOpenChanged: (_, open) => changes.add(open),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, 0);
      expect(changes, [true, false]);
    });

    testWidgets('展开后切换 RTL 会校正逻辑方向', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      final swipeCell = cell(
        childKey: childKey,
        controller: controller,
        end: panel('删除'),
      );
      await tester.pumpWidget(app(swipeCell));
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, lessThan(0));

      await tester.pumpWidget(app(swipeCell, direction: TextDirection.rtl));
      await tester.pump();
      await tester.pump();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, greaterThan(0));
    });
  });

  group('主题继承', () {
    testWidgets('DefaultTextStyle 和 IconTheme 可控制默认 action', (tester) async {
      await tester.pumpWidget(
        app(
          DefaultTextStyle(
            style: const TextStyle(fontSize: 19, color: Colors.purple),
            child: IconTheme(
              data: const IconThemeData(size: 31, color: Colors.green),
              child: cell(
                end: TSwipeCellPanel(
                  children: [
                    const TSwipeCellAction(icon: Icons.edit, label: '操作'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final text = tester.widget<Text>(find.text('操作'));
      final icon = tester.widget<Icon>(find.byIcon(Icons.edit));
      expect(text.style?.fontSize, 19);
      expect(text.style?.color, Colors.purple);
      expect(icon.size, 31);
      expect(icon.color, Colors.green);
    });
  });

  group('交互', () {
    testWidgets('超过面板 30% 才展开', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(app(cell(childKey: childKey, end: panel('删除'))));
      await tester.pump();
      final actionWidth = tester.getSize(find.byType(TSwipeCellAction)).width;

      await tester.drag(find.byKey(childKey), Offset(-actionWidth * 0.2, 0));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(0, 0.1));

      await tester.drag(find.byKey(childKey), Offset(-actionWidth * 0.5, 0));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.byKey(childKey)).dx,
        closeTo(-actionWidth, 0.1),
      );
    });

    testWidgets('从完全展开态反向拖动会关闭', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(
        app(
          cell(
            childKey: childKey,
            end: panel('删除'),
            initialOpenSide: TSwipeCellSide.end,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.dragFrom(
        tester.getCenter(find.byKey(childKey)),
        const Offset(10, 0),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(0, 0.1));
    });

    testWidgets('指针移动离开 item 不会被误判为外部点击', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      await tester.pumpWidget(
        app(cell(childKey: childKey, controller: controller, end: panel('删除'))),
      );
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      final openOffset = tester.getTopLeft(find.byKey(childKey)).dx;

      tester.binding.handlePointerEvent(
        const PointerMoveEvent(pointer: 42, position: Offset(700, 500)),
      );
      await tester.pump(const Duration(milliseconds: 700));

      expect(
        tester.getTopLeft(find.byKey(childKey)).dx,
        closeTo(openOffset, 0.1),
      );
    });

    testWidgets('拖拽被取消时恢复到稳定状态', (tester) async {
      final childKey = GlobalKey();
      await tester.pumpWidget(app(cell(childKey: childKey, end: panel('删除'))));
      await tester.pump();

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(childKey)),
      );
      await gesture.moveBy(const Offset(-40, 0));
      await tester.pump();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, lessThan(0));
      await gesture.cancel();
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(0, 0.1));
    });

    testWidgets('关闭动画期间阻止 action 重复执行和 child 穿透', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      var actionPressed = 0;
      var childPressed = 0;
      await tester.pumpWidget(
        app(
          cell(
            controller: controller,
            end: panel('删除', onPressed: () => actionPressed++),
            child: GestureDetector(
              key: childKey,
              behavior: HitTestBehavior.opaque,
              onTap: () => childPressed++,
              child: const SizedBox.expand(child: Text('业务内容')),
            ),
          ),
        ),
      );
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();

      await tester.tap(find.text('删除'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('删除'), warnIfMissed: false);
      await tester.tap(find.byKey(childKey), warnIfMissed: false);
      expect(actionPressed, 1);
      expect(childPressed, 0);

      await tester.pumpAndSettle();
      await tester.tapAt(tester.getCenter(find.byKey(childKey)));
      expect(childPressed, 1);
    });

    testWidgets('点击内容、外部与操作项均自动关闭', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      var pressed = 0;
      await tester.pumpWidget(
        app(
          Column(
            children: [
              cell(
                childKey: childKey,
                controller: controller,
                end: panel('删除', onPressed: () => pressed++),
              ),
              const TextButton(onPressed: null, child: Text('外部')),
            ],
          ),
        ),
      );
      await tester.pump();

      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      await tester.tapAt(tester.getCenter(find.byKey(childKey)));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(0, 0.1));

      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('外部'));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(0, 0.1));

      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('删除'));
      await tester.pumpAndSettle();
      expect(pressed, 1);
      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(0, 0.1));
    });

    testWidgets('展开一格会自动关闭其他格', (tester) async {
      final firstKey = GlobalKey();
      final secondKey = GlobalKey();
      final first = TSwipeCellController();
      final second = TSwipeCellController();
      await tester.pumpWidget(
        app(
          Column(
            children: [
              cell(childKey: firstKey, controller: first, end: panel('删除')),
              cell(childKey: secondKey, controller: second, end: panel('删除')),
            ],
          ),
        ),
      );
      await tester.pump();
      unawaited(first.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      unawaited(second.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(firstKey)).dx, closeTo(0, 0.1));
      expect(tester.getTopLeft(find.byKey(secondKey)).dx, lessThan(0));
    });

    testWidgets('禁用时不响应拖动但控制器仍可展开', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      await tester.pumpWidget(
        app(
          cell(
            childKey: childKey,
            controller: controller,
            end: panel('删除'),
            enabled: false,
          ),
        ),
      );
      await tester.pump();
      await tester.drag(find.byKey(childKey), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(0, 0.1));
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, lessThan(0));
    });

    testWidgets('状态回调按关闭旧侧再打开新侧触发', (tester) async {
      final controller = TSwipeCellController();
      final changes = <String>[];
      await tester.pumpWidget(
        app(
          cell(
            controller: controller,
            start: panel('选择'),
            end: panel('删除'),
            onOpenChanged: (side, open) => changes.add('$side:$open'),
          ),
        ),
      );
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.start));
      await tester.pumpAndSettle();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      unawaited(controller.close());
      await tester.pumpAndSettle();
      expect(changes, [
        'TSwipeCellSide.start:true',
        'TSwipeCellSide.start:false',
        'TSwipeCellSide.end:true',
        'TSwipeCellSide.end:false',
      ]);
    });

    testWidgets('RTL 中逻辑起始侧在右侧', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      await tester.pumpWidget(
        app(
          cell(childKey: childKey, controller: controller, start: panel('选择')),
          direction: TextDirection.rtl,
        ),
      );
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.start));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byKey(childKey)).dx, lessThan(0));
    });

    testWidgets('滚动祖先列表时默认关闭', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      final changes = <bool>[];
      await tester.pumpWidget(
        app(
          ListView(
            children: [
              cell(
                childKey: childKey,
                controller: controller,
                end: panel('删除'),
                onOpenChanged: (_, open) => changes.add(open),
              ),
              const SizedBox(height: 1000),
            ],
          ),
        ),
      );
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -30));
      await tester.pumpAndSettle();
      expect(changes, [true, false]);
    });

    testWidgets('祖先 ScrollPosition 更换后仍监听新位置', (tester) async {
      final childKey = GlobalKey();
      final controller = TSwipeCellController();
      final changes = <bool>[];

      Widget scrollApp(ScrollPhysics physics) {
        return app(
          ListView(
            physics: physics,
            children: [
              cell(
                childKey: childKey,
                controller: controller,
                end: panel('删除'),
                onOpenChanged: (_, open) => changes.add(open),
              ),
              const SizedBox(height: 1000),
            ],
          ),
        );
      }

      await tester.pumpWidget(scrollApp(const ClampingScrollPhysics()));
      await tester.pump();
      unawaited(controller.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      await tester.pumpWidget(scrollApp(const BouncingScrollPhysics()));
      await tester.pump();
      await tester.drag(find.byType(ListView), const Offset(0, -30));
      await tester.pumpAndSettle();

      expect(changes, [true, false]);
    });

    testWidgets('不同路由中的 SwipeCell 不会互相关闭', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      final firstKey = GlobalKey();
      final secondKey = GlobalKey();
      final first = TSwipeCellController();
      final second = TSwipeCellController();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: cell(
              childKey: firstKey,
              controller: first,
              end: panel('第一个删除'),
            ),
          ),
        ),
      );
      await tester.pump();
      unawaited(first.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();

      unawaited(
        navigatorKey.currentState!.push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              body: cell(
                childKey: secondKey,
                controller: second,
                end: panel('第二个删除'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(second.open(TSwipeCellSide.end));
      await tester.pumpAndSettle();
      navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(find.byKey(firstKey)).dx, lessThan(0));
    });
  });
}
