import 'dart:async';
import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(
    Widget child, {
    TDropdownThemeData? dropdownTheme,
    Alignment alignment = Alignment.topCenter,
  }) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (dropdownTheme != null) {
      theme = theme.mergeExtension(dropdownTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Align(alignment: alignment, child: child),
      ),
    );
  }

  TDropdownMenuItem item(
    String label, {
    String? panelLabel,
    bool enabled = true,
  }) {
    return TDropdownMenuItem(
      label: label,
      enabled: enabled,
      panelBuilder: (context, controller) => SizedBox(
        height: 80,
        child: Center(child: Text(panelLabel ?? '$label panel')),
      ),
    );
  }

  group('public models', () {
    test('item and trigger state expose immutable configuration', () {
      final menuItem = item('排序');
      expect(menuItem.label, '排序');
      expect(menuItem.enabled, isTrue);
      expect(menuItem.flex, 1);
      expect(menuItem.triggerBuilder, isNull);

      var toggled = false;
      final state = TDropdownMenuTriggerState(
        index: 2,
        isOpen: true,
        enabled: true,
        toggle: () => toggled = true,
      );
      state.toggle();
      expect(toggled, isTrue);
      expect(state.index, 2);
    });

    test('controller is safe before attachment', () async {
      final controller = TDropdownMenuController();
      await controller.open(0);
      await controller.toggle(0);
      await controller.close();
      expect(controller.isOpen, isFalse);
      expect(controller.openIndex, isNull);
      controller.dispose();
    });

    test('invalid item flex asserts', () {
      expect(
        () => TDropdownMenuItem(
          label: 'invalid',
          flex: 0,
          panelBuilder: (_, __) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    test('theme data merge, copy and lerp preserve the visual contract', () {
      const base = TDropdownThemeData(
        barHeight: 40,
        barBackgroundColor: Colors.white,
        dividerColor: Colors.black,
        textStyle: TextStyle(color: Colors.black),
        activeTextStyle: TextStyle(color: Colors.blue),
        disabledTextStyle: TextStyle(color: Colors.grey),
        iconColor: Colors.black,
        activeIconColor: Colors.blue,
        disabledIconColor: Colors.grey,
        iconSize: 20,
        panelBackgroundColor: Colors.white,
        overlayColor: Colors.black54,
        optionHeight: 56,
        optionPadding: EdgeInsets.all(8),
        optionTextStyle: TextStyle(fontSize: 14),
        selectedOptionTextStyle: TextStyle(color: Colors.blue),
        disabledOptionTextStyle: TextStyle(color: Colors.grey),
        optionColor: Colors.white,
        selectedOptionColor: Colors.lightBlue,
        disabledOptionColor: Colors.black12,
        optionBorderRadius: BorderRadius.all(Radius.circular(4)),
        actionAreaPadding: EdgeInsets.all(16),
        actionGap: 16,
        animationDuration: Duration(milliseconds: 200),
      );
      const override = TDropdownThemeData(
        barHeight: 60,
        iconSize: 24,
        optionColor: Colors.yellow,
        animationDuration: Duration(milliseconds: 300),
      );

      expect(identical(base.merge(null), base), isTrue);
      final merged = base.merge(override);
      expect(merged.barHeight, 60);
      expect(merged.barBackgroundColor, Colors.white);
      expect(merged.optionColor, Colors.yellow);
      expect(merged.animationDuration, const Duration(milliseconds: 300));

      final copied = base.copyWith(
        barHeight: 48,
        activeIconColor: Colors.orange,
        actionGap: 20,
      );
      expect(copied.barHeight, 48);
      expect(copied.activeIconColor, Colors.orange);
      expect(copied.actionGap, 20);
      expect(copied.optionHeight, 56);
      expect(base.copyWith().barHeight, 40);

      expect(identical(base.lerp(null, 0.5), base), isTrue);
      final lerped = base.lerp(override, 0.5);
      expect(lerped.barHeight, 50);
      expect(lerped.iconSize, 22);
      expect(
        lerped.optionColor,
        Color.lerp(Colors.white, Colors.yellow, 0.5),
      );
      expect(
        lerped.animationDuration,
        const Duration(milliseconds: 300),
      );
    });
  });

  group('rendering and theme', () {
    testWidgets('renders expanded, scrollable, custom and disabled triggers',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TDropdownMenu(
                animationDuration: Duration.zero,
                items: [
                  item('排序'),
                  item('禁用', enabled: false),
                ],
              ),
              TDropdownMenu(
                scrollable: true,
                animationDuration: Duration.zero,
                items: [
                  TDropdownMenuItem.custom(
                    width: 140,
                    triggerBuilder: (context, state) => GestureDetector(
                      onTap: state.toggle,
                      child: Text(state.isOpen ? '自定义已打开' : '自定义'),
                    ),
                    panelBuilder: (_, __) => const Text('custom panel'),
                  ),
                  TDropdownMenuItem.custom(
                    width: 140,
                    enabled: false,
                    triggerBuilder: (context, state) => GestureDetector(
                      onTap: state.toggle,
                      child: Text(
                        state.enabled ? '可用自定义' : '禁用自定义',
                      ),
                    ),
                    panelBuilder: (_, __) =>
                        const Text('disabled custom panel'),
                  ),
                  item('更多'),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('排序'), findsOneWidget);
      expect(find.text('禁用'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.tap(find.text('禁用'));
      await tester.pump();
      expect(find.text('禁用 panel'), findsNothing);

      await tester.tap(find.text('自定义'));
      await tester.pumpAndSettle();
      expect(find.text('自定义已打开'), findsOneWidget);
      expect(find.text('custom panel'), findsOneWidget);
      expect(find.text('禁用自定义'), findsOneWidget);
      await tester.tap(find.text('禁用自定义'));
      await tester.pump();
      expect(find.text('disabled custom panel'), findsNothing);
    });

    testWidgets('theme controls bar and active visual values', (tester) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            items: [item('主题')],
          ),
          dropdownTheme: const TDropdownThemeData(
            barHeight: 60,
            barBackgroundColor: Colors.yellow,
            dividerColor: Colors.green,
            textStyle: TextStyle(color: Colors.purple),
            activeTextStyle: TextStyle(color: Colors.red),
            iconColor: Colors.blue,
            activeIconColor: Colors.orange,
            iconSize: 28,
            panelBackgroundColor: Colors.white,
            overlayColor: Colors.pink,
          ),
        ),
      );

      expect(tester.getSize(find.byType(TDropdownMenu)).height, 60);
      expect(
        tester.widget<Text>(find.text('主题')).style?.color,
        Colors.purple,
      );
      await tester.tap(find.text('主题'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('主题')).style?.color,
        Colors.red,
      );
      expect(find.text('主题 panel'), findsOneWidget);
    });

    testWidgets('local DefaultTextStyle and IconTheme precede token fallback',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          DefaultTextStyle(
            style: const TextStyle(color: Colors.brown, fontSize: 18),
            child: IconTheme(
              data: const IconThemeData(color: Colors.teal),
              child: TDropdownMenu(
                animationDuration: Duration.zero,
                items: [item('继承主题')],
              ),
            ),
          ),
        ),
      );
      expect(
        tester.widget<Text>(find.text('继承主题')).style?.color,
        Colors.brown,
      );
      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(TDropdownMenu),
          matching: find.byType(Icon),
        ),
      );
      expect(icon.color, Colors.teal);
    });

    testWidgets('empty menu is safe', (tester) async {
      await tester.pumpWidget(
        wrap(const TDropdownMenu(items: [])),
      );
      expect(find.byType(TDropdownMenu), findsOneWidget);
    });
  });

  group('overlay lifecycle', () {
    testWidgets('tap and controller open/close report exact callbacks',
        (tester) async {
      final controller = TDropdownMenuController();
      final opened = <int>[];
      final closed = <(int, TDropdownMenuCloseReason)>[];
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            controller: controller,
            animationDuration: Duration.zero,
            onOpened: opened.add,
            onClosed: (index, reason) => closed.add((index, reason)),
            items: [item('A'), item('B')],
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      expect(controller.openIndex, 0);
      expect(opened, [0]);

      unawaited(controller.close());
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);
      expect(closed.last, (0, TDropdownMenuCloseReason.controller));

      unawaited(controller.open(1));
      await tester.pumpAndSettle();
      expect(find.text('B panel'), findsOneWidget);

      unawaited(controller.toggle(1));
      await tester.pumpAndSettle();
      expect(closed.last, (1, TDropdownMenuCloseReason.trigger));
      controller.dispose();
    });

    testWidgets('switches directly between triggers', (tester) async {
      final closed = <TDropdownMenuCloseReason>[];
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            onClosed: (_, reason) => closed.add(reason),
            items: [item('A'), item('B')],
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      expect(find.text('A panel'), findsNothing);
      expect(find.text('B panel'), findsOneWidget);
      expect(closed, contains(TDropdownMenuCloseReason.switchItem));
    });

    testWidgets('overlay closes with overlay reason', (tester) async {
      TDropdownMenuCloseReason? reason;
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            onClosed: (_, value) => reason = value,
            items: [item('筛选')],
          ),
        ),
      );
      await tester.tap(find.text('筛选'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 500));
      await tester.pumpAndSettle();
      expect(reason, TDropdownMenuCloseReason.overlay);
      expect(find.text('筛选 panel'), findsNothing);
    });

    testWidgets('non-dismissible transparent overlay remains open',
        (tester) async {
      final controller = TDropdownMenuController();
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            controller: controller,
            showOverlay: false,
            closeOnOverlayTap: false,
            animationDuration: Duration.zero,
            items: [item('筛选')],
          ),
        ),
      );
      await tester.tap(find.text('筛选'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 500));
      await tester.pump();
      expect(controller.isOpen, isTrue);
      controller.dispose();
    });

    testWidgets('open overlay reads updated items and dismissal configuration',
        (tester) async {
      var panelLabel = '旧面板';
      var dismissible = false;
      late StateSetter rebuild;
      TDropdownMenuCloseReason? reason;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return TDropdownMenu(
                closeOnOverlayTap: dismissible,
                animationDuration: Duration.zero,
                onClosed: (_, value) => reason = value,
                items: [item('筛选', panelLabel: panelLabel)],
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('筛选'));
      await tester.pumpAndSettle();
      expect(find.text('旧面板'), findsOneWidget);

      rebuild(() {
        panelLabel = '新面板';
        dismissible = true;
      });
      await tester.pump();
      await tester.pump();
      expect(find.text('新面板'), findsOneWidget);
      await tester.tapAt(const Offset(10, 500));
      await tester.pumpAndSettle();
      expect(reason, TDropdownMenuCloseReason.overlay);
    });

    testWidgets('open overlay receives local theme updates', (tester) async {
      var panelColor = Colors.blue;
      late StateSetter rebuild;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return Theme(
                data: Theme.of(context).mergeExtension(
                  TDropdownThemeData(panelBackgroundColor: panelColor),
                ),
                child: TDropdownMenu(
                  animationDuration: Duration.zero,
                  items: [item('主题刷新')],
                ),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('主题刷新'));
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Material && widget.color == Colors.blue,
        ),
        findsWidgets,
      );

      rebuild(() => panelColor = Colors.red);
      await tester.pump();
      await tester.pump();
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Material && widget.color == Colors.red,
        ),
        findsWidgets,
      );
    });

    testWidgets('trigger semantics and focus update and restore',
        (tester) async {
      final semantics = tester.ensureSemantics();
      final controller = TDropdownMenuController();
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            controller: controller,
            animationDuration: Duration.zero,
            items: [item('无障碍筛选')],
          ),
        ),
      );
      final triggerSemantics = find.ancestor(
        of: find.text('无障碍筛选'),
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.expanded != null,
        ),
      );
      var node = tester.getSemantics(triggerSemantics);
      expect(node.hasFlag(SemanticsFlag.hasExpandedState), isTrue);
      expect(node.hasFlag(SemanticsFlag.isExpanded), isFalse);
      expect(node.hasFlag(SemanticsFlag.isButton), isTrue);

      await tester.tap(find.text('无障碍筛选'));
      await tester.pumpAndSettle();
      node = tester.getSemantics(triggerSemantics);
      expect(node.hasFlag(SemanticsFlag.isExpanded), isTrue);
      expect(
        FocusManager.instance.primaryFocus?.debugLabel,
        'TDropdownMenu panel',
      );

      await controller.close();
      await tester.pumpAndSettle();
      expect(
        FocusManager.instance.primaryFocus?.debugLabel,
        'TDropdownMenu trigger 0',
      );
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      controller.dispose();
      semantics.dispose();
    });

    testWidgets('escape and system back close without popping page',
        (tester) async {
      final reasons = <TDropdownMenuCloseReason>[];
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            onClosed: (_, reason) => reasons.add(reason),
            items: [item('筛选')],
          ),
        ),
      );
      await tester.tap(find.text('筛选'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(reasons.last, TDropdownMenuCloseReason.cancel);

      await tester.tap(find.text('筛选'));
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(reasons.last, TDropdownMenuCloseReason.back);
      expect(find.byType(TDropdownMenu), findsOneWidget);
    });

    testWidgets('disposing while open removes overlay without callback',
        (tester) async {
      var closed = 0;
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            onClosed: (_, __) => closed++,
            items: [item('筛选')],
          ),
        ),
      );
      await tester.tap(find.text('筛选'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      await tester.pump();
      expect(closed, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('external controller can be replaced while mounted',
        (tester) async {
      final first = TDropdownMenuController();
      final second = TDropdownMenuController();
      late StateSetter rebuild;
      var controller = first;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return TDropdownMenu(
                controller: controller,
                animationDuration: Duration.zero,
                items: [item('筛选')],
              );
            },
          ),
        ),
      );
      rebuild(() => controller = second);
      await tester.pump();
      await first.open(0);
      expect(first.isOpen, isFalse);
      unawaited(second.open(0));
      await tester.pumpAndSettle();
      expect(second.isOpen, isTrue);
      first.dispose();
      second.dispose();
    });

    testWidgets('replacing controller while open removes the old overlay',
        (tester) async {
      final first = TDropdownMenuController();
      final second = TDropdownMenuController();
      late StateSetter rebuild;
      var controller = first;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return TDropdownMenu(
                controller: controller,
                animationDuration: Duration.zero,
                items: [item('筛选')],
              );
            },
          ),
        ),
      );
      await first.open(0);
      await tester.pumpAndSettle();
      expect(find.text('筛选 panel'), findsOneWidget);

      rebuild(() => controller = second);
      await tester.pump();
      await tester.pump();
      expect(first.isOpen, isFalse);
      expect(second.isOpen, isFalse);
      expect(find.text('筛选 panel'), findsNothing);

      await second.open(0);
      await tester.pumpAndSettle();
      expect(find.text('筛选 panel'), findsOneWidget);
      first.dispose();
      second.dispose();
    });

    testWidgets('dynamic item shrink closes an invalid open item',
        (tester) async {
      var items = [item('A'), item('B')];
      late StateSetter rebuild;
      TDropdownMenuCloseReason? reason;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return TDropdownMenu(
                animationDuration: Duration.zero,
                items: items,
                onClosed: (_, value) => reason = value,
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      rebuild(() => items = [item('A')]);
      await tester.pumpAndSettle();
      expect(find.text('B panel'), findsNothing);
      expect(reason, TDropdownMenuCloseReason.cancel);
    });

    testWidgets('dynamically disabling the open item closes it',
        (tester) async {
      var enabled = true;
      late StateSetter rebuild;
      TDropdownMenuCloseReason? reason;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return TDropdownMenu(
                animationDuration: Duration.zero,
                items: [item('A', enabled: enabled)],
                onClosed: (_, value) => reason = value,
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      rebuild(() => enabled = false);
      await tester.pumpAndSettle();
      expect(find.text('A panel'), findsNothing);
      expect(reason, TDropdownMenuCloseReason.cancel);
    });

    testWidgets('switching from owned to external controller remains usable',
        (tester) async {
      TDropdownMenuController? external;
      late StateSetter rebuild;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return TDropdownMenu(
                controller: external,
                animationDuration: Duration.zero,
                items: [item('A')],
              );
            },
          ),
        ),
      );
      final next = TDropdownMenuController();
      rebuild(() => external = next);
      await tester.pump();
      unawaited(next.open(0));
      await tester.pumpAndSettle();
      expect(next.isOpen, isTrue);
      next.dispose();
    });

    testWidgets('metrics and ancestor scroll refresh the anchored overlay',
        (tester) async {
      final scrollController = ScrollController();
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 100),
                TDropdownMenu(
                  animationDuration: Duration.zero,
                  items: [item('跟随滚动')],
                ),
                const SizedBox(height: 900),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('跟随滚动'));
      await tester.pumpAndSettle();
      final before = tester.getTopLeft(find.text('跟随滚动 panel')).dy;
      scrollController.jumpTo(40);
      tester.binding.handleMetricsChanged();
      await tester.pump();
      await tester.pump();
      final after = tester.getTopLeft(find.text('跟随滚动 panel')).dy;
      expect(after, lessThan(before));
      scrollController.dispose();
    });

    testWidgets('nested and root overlays both support anchored panels',
        (tester) async {
      Future<void> pumpNested({required bool useRootOverlay}) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: TThemeBuilder.light(TThemeData.defaultData()),
            home: Scaffold(
              body: Overlay(
                key: ValueKey(useRootOverlay),
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => Align(
                      alignment: Alignment.topCenter,
                      child: TDropdownMenu(
                        useRootOverlay: useRootOverlay,
                        animationDuration: Duration.zero,
                        items: [item(useRootOverlay ? '根层' : '嵌套层')],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      await pumpNested(useRootOverlay: false);
      await tester.tap(find.text('嵌套层'));
      await tester.pumpAndSettle();
      expect(find.text('嵌套层 panel'), findsOneWidget);

      await pumpNested(useRootOverlay: true);
      await tester.tap(find.text('根层'));
      await tester.pumpAndSettle();
      expect(find.text('根层 panel'), findsOneWidget);
    });

    testWidgets('changing root overlay migrates an open panel', (tester) async {
      final nestedOverlayKey = GlobalKey<OverlayState>();
      late StateSetter rebuild;
      OverlayState? rootOverlay;
      var useRootOverlay = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: Overlay(
              key: nestedOverlayKey,
              initialEntries: [
                OverlayEntry(
                  builder: (context) {
                    rootOverlay = Overlay.of(context, rootOverlay: true);
                    return StatefulBuilder(
                      builder: (context, setState) {
                        rebuild = setState;
                        return Align(
                          alignment: Alignment.topCenter,
                          child: TDropdownMenu(
                            useRootOverlay: useRootOverlay,
                            animationDuration: Duration.zero,
                            items: [item('迁移弹层')],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('迁移弹层'));
      await tester.pumpAndSettle();
      expect(
        Overlay.of(tester.element(find.text('迁移弹层 panel'))),
        same(nestedOverlayKey.currentState),
      );

      rebuild(() => useRootOverlay = true);
      await tester.pump();
      await tester.pump();
      expect(find.text('迁移弹层 panel'), findsOneWidget);
      expect(
        Overlay.of(tester.element(find.text('迁移弹层 panel'))),
        same(rootOverlay),
      );
    });
  });

  group('geometry', () {
    testWidgets('non-scrollable menu is safe in an unbounded horizontal parent',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TDropdownMenu(
              animationDuration: Duration.zero,
              items: [item('A'), item('B')],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(TDropdownMenu)).width, 224);
    });

    testWidgets('below and above placement touch the bar', (tester) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.below,
            animationDuration: Duration.zero,
            items: [item('向下')],
          ),
        ),
      );
      await tester.tap(find.text('向下'));
      await tester.pumpAndSettle();
      final barBottom = tester.getBottomLeft(find.byType(TDropdownMenu)).dy;
      final panelTop = tester.getTopLeft(find.text('向下 panel')).dy;
      expect(panelTop, greaterThanOrEqualTo(barBottom));

      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      await tester.pump();
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.above,
            animationDuration: Duration.zero,
            items: [item('向上')],
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
      await tester.tap(find.text('向上'));
      await tester.pumpAndSettle();
      final barTop = tester.getTopLeft(find.byType(TDropdownMenu)).dy;
      final panelBottom = tester.getBottomLeft(find.text('向上 panel')).dy;
      expect(panelBottom, lessThanOrEqualTo(barTop));
    });

    testWidgets('auto opens above when lower space is small', (tester) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            items: [item('自动')],
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
      await tester.tap(find.text('自动'));
      await tester.pumpAndSettle();
      expect(
        tester.getBottomLeft(find.text('自动 panel')).dy,
        lessThanOrEqualTo(tester.getTopLeft(find.byType(TDropdownMenu)).dy),
      );
    });

    testWidgets('auto keeps a short panel below when it fits', (tester) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            items: [item('短面板')],
          ),
          alignment: const Alignment(0, 0.5),
        ),
      );
      await tester.tap(find.text('短面板'));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('短面板 panel')).dy,
        greaterThanOrEqualTo(
          tester.getBottomLeft(find.byType(TDropdownMenu)).dy,
        ),
      );
    });

    testWidgets('keyboard and safe area constrain a long panel',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(800, 600),
              padding: EdgeInsets.only(top: 20, bottom: 20),
              viewInsets: EdgeInsets.only(bottom: 200),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Align(
                alignment: Alignment.topCenter,
                child: TDropdownMenu(
                  placement: TDropdownMenuPlacement.below,
                  animationDuration: Duration.zero,
                  items: [
                    TDropdownMenuItem(
                      label: '长列表',
                      panelBuilder: (context, controller) =>
                          TDropdownSingleSelectPanel<int>(
                        controller: controller,
                        value: null,
                        options: List.generate(
                          30,
                          (index) => TDropdownMenuOption(
                            value: index,
                            label: '选项 $index',
                          ),
                        ),
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('长列表'));
      await tester.pumpAndSettle();
      final listRect = tester.getRect(find.byType(ListView));
      expect(listRect.top, greaterThanOrEqualTo(48));
      expect(listRect.bottom, lessThanOrEqualTo(400));
      expect(tester.takeException(), isNull);
    });
  });
}
