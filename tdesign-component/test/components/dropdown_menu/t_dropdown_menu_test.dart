import 'dart:async';

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
    double panelHeight = 80,
  }) {
    return TDropdownMenuItem(
      label: label,
      enabled: enabled,
      panelBuilder: (context, controller) => SizedBox(
        height: panelHeight,
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
      expect(lerped.optionColor, Color.lerp(Colors.white, Colors.yellow, 0.5));
      expect(lerped.animationDuration, const Duration(milliseconds: 300));
    });
  });

  group('rendering and theme', () {
    testWidgets('renders expanded, scrollable, custom and disabled triggers', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TDropdownMenu(
                animationDuration: Duration.zero,
                items: [item('排序'), item('禁用', enabled: false)],
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
                      child: Text(state.enabled ? '可用自定义' : '禁用自定义'),
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
          TDropdownMenu(animationDuration: Duration.zero, items: [item('主题')]),
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
      expect(tester.widget<Text>(find.text('主题')).style?.color, Colors.purple);
      await tester.tap(find.text('主题'));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.text('主题')).style?.color, Colors.red);
      expect(find.text('主题 panel'), findsOneWidget);
    });

    testWidgets('local DefaultTextStyle and IconTheme precede token fallback', (
      tester,
    ) async {
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
      expect(tester.widget<Text>(find.text('继承主题')).style?.color, Colors.brown);
      final icon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(TDropdownMenu),
          matching: find.byType(Icon),
        ),
      );
      expect(icon.color, Colors.teal);
    });

    testWidgets('empty menu is safe', (tester) async {
      await tester.pumpWidget(wrap(const TDropdownMenu(items: [])));
      expect(find.byType(TDropdownMenu), findsOneWidget);
    });
  });

  group('overlay lifecycle', () {
    testWidgets('tap and controller open/close report exact callbacks', (
      tester,
    ) async {
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

    testWidgets(
      'same-menu switch keeps overlay stable with a subtle panel shift',
      (tester) async {
        final controller = TDropdownMenuController();
        final opened = <int>[];
        final closed = <(int, TDropdownMenuCloseReason)>[];
        addTearDown(controller.dispose);
        await tester.pumpWidget(
          wrap(
            TDropdownMenu(
              controller: controller,
              animationDuration: const Duration(milliseconds: 200),
              onOpened: opened.add,
              onClosed: (index, reason) => closed.add((index, reason)),
              items: [item('A'), item('B')],
            ),
          ),
        );

        await tester.tap(find.text('A'));
        await tester.pumpAndSettle();
        final overlayFinder = find.byKey(
          const ValueKey<String>('t-dropdown-menu-overlay'),
        );
        final beforeColor = tester.widget<ColoredBox>(overlayFinder).color;
        expect(opened, [0]);

        await tester.tap(find.text('B'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(controller.openIndex, 1);
        expect(overlayFinder, findsOneWidget);
        expect(tester.widget<ColoredBox>(overlayFinder).color, beforeColor);
        expect(find.text('A panel'), findsOneWidget);
        expect(find.text('B panel'), findsOneWidget);
        final panelSurface = find.byKey(
          const ValueKey<String>('t-dropdown-menu-panel-surface'),
        );
        expect(panelSurface, findsOneWidget);
        expect(tester.widget<ColoredBox>(panelSurface).color, Colors.white);
        final incomingOffset = tester
            .widget<SlideTransition>(
              find.byKey(
                const ValueKey<String>('t-dropdown-menu-incoming-slide'),
              ),
            )
            .position
            .value
            .dy
            .abs();
        expect(incomingOffset, greaterThan(0));
        expect(incomingOffset, lessThanOrEqualTo(0.04));
        expect(closed, isEmpty);

        await tester.pumpAndSettle();
        expect(find.text('A panel'), findsNothing);
        expect(find.text('B panel'), findsOneWidget);
        expect(opened, [0, 1]);
        expect(closed, [(0, TDropdownMenuCloseReason.switchItem)]);
      },
    );

    testWidgets('opening and closing reveal the panel from the menu edge', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.below,
            animationDuration: const Duration(milliseconds: 200),
            items: [item('位移展开')],
          ),
        ),
      );

      const revealKey = ValueKey<String>('t-dropdown-menu-open-close-reveal');
      await tester.tap(find.text('位移展开'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      var align = tester.widget<Align>(
        find.descendant(of: find.byKey(revealKey), matching: find.byType(Align)),
      );
      expect(align.alignment, AlignmentDirectional.topStart);
      expect(align.heightFactor, greaterThan(0));
      expect(align.heightFactor, lessThan(1));

      await tester.pumpAndSettle();
      align = tester.widget<Align>(
        find.descendant(of: find.byKey(revealKey), matching: find.byType(Align)),
      );
      expect(align.heightFactor, 1);

      await tester.tap(find.text('位移展开'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      align = tester.widget<Align>(
        find.descendant(of: find.byKey(revealKey), matching: find.byType(Align)),
      );
      expect(align.heightFactor, greaterThan(0));
      expect(align.heightFactor, lessThan(1));
      await tester.pumpAndSettle();
      expect(find.byKey(revealKey), findsNothing);

      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.above,
            animationDuration: const Duration(milliseconds: 200),
            items: [item('向上位移展开')],
          ),
          alignment: Alignment.center,
        ),
      );
      await tester.tap(find.text('向上位移展开'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      align = tester.widget<Align>(
        find.descendant(of: find.byKey(revealKey), matching: find.byType(Align)),
      );
      expect(align.alignment, AlignmentDirectional.bottomStart);
      expect(align.heightFactor, greaterThan(0));
      expect(align.heightFactor, lessThan(1));
    });

    testWidgets('platform reduced motion disables menu animations', (
      tester,
    ) async {
      final opened = <int>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: TDropdownMenu(
                animationDuration: const Duration(milliseconds: 200),
                onOpened: opened.add,
                items: [item('减少动态')],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('减少动态'));
      await tester.pump();
      await tester.pump();
      expect(opened, [0]);
      final revealKey = find.byKey(
        const ValueKey<String>('t-dropdown-menu-open-close-reveal'),
      );
      final align = tester.widget<Align>(
        find.descendant(of: revealKey, matching: find.byType(Align)),
      );
      expect(align.heightFactor, 1);
    });

    testWidgets('same-menu switch keeps one stable surface for panel heights', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: const Duration(milliseconds: 200),
            placement: TDropdownMenuPlacement.below,
            items: [
              item('短面板', panelHeight: 80),
              item('长面板', panelHeight: 160),
            ],
          ),
        ),
      );

      await tester.tap(find.text('短面板'));
      await tester.pumpAndSettle();
      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );
      expect(tester.getSize(panelSurface).height, 80);

      await tester.tap(find.text('长面板'));
      await tester.pump();
      expect(tester.getSize(panelSurface).height, 160);

      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(panelSurface).height, 160);

      await tester.pumpAndSettle();
      expect(tester.getSize(panelSurface).height, 160);

      await tester.tap(find.text('短面板'));
      await tester.pump();
      expect(tester.getSize(panelSurface).height, 160);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(panelSurface).height, 160);

      await tester.pumpAndSettle();
      expect(tester.getSize(panelSurface).height, 80);
    });

    testWidgets('rapid same-menu switches keep only the final panel active', (
      tester,
    ) async {
      final opened = <int>[];
      final closed = <(int, TDropdownMenuCloseReason)>[];
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: const Duration(milliseconds: 200),
            onOpened: opened.add,
            onClosed: (index, reason) => closed.add((index, reason)),
            items: [item('A'), item('B'), item('C')],
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('C'));
      await tester.pumpAndSettle();

      expect(find.text('A panel'), findsNothing);
      expect(find.text('B panel'), findsNothing);
      expect(find.text('C panel'), findsOneWidget);
      expect(opened, [0, 2]);
      expect(closed, [
        (0, TDropdownMenuCloseReason.switchItem),
        (1, TDropdownMenuCloseReason.switchItem),
      ]);
    });

    testWidgets('switching back does not close the active item index', (
      tester,
    ) async {
      final opened = <int>[];
      final closed = <(int, TDropdownMenuCloseReason)>[];
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: const Duration(milliseconds: 200),
            onOpened: opened.add,
            onClosed: (index, reason) => closed.add((index, reason)),
            items: [item('A'), item('B')],
          ),
        ),
      );

      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      expect(find.text('A panel'), findsOneWidget);
      expect(find.text('B panel'), findsNothing);
      expect(opened, [0, 0]);
      expect(closed, [(1, TDropdownMenuCloseReason.switchItem)]);
    });

    testWidgets('interrupted open and close futures both complete', (
      tester,
    ) async {
      final controller = TDropdownMenuController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            controller: controller,
            placement: TDropdownMenuPlacement.below,
            animationDuration: const Duration(milliseconds: 200),
            items: [item('动画中断')],
          ),
        ),
      );

      var openCompleted = false;
      var closeCompleted = false;
      unawaited(controller.open(0).whenComplete(() => openCompleted = true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      unawaited(controller.close().whenComplete(() => closeCompleted = true));
      await tester.pumpAndSettle();

      expect(openCompleted, isTrue);
      expect(closeCompleted, isTrue);
      expect(controller.isOpen, isFalse);
      expect(find.text('动画中断 panel'), findsNothing);
    });

    testWidgets('switching items during close restores the revealed panel', (
      tester,
    ) async {
      final controller = TDropdownMenuController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            controller: controller,
            placement: TDropdownMenuPlacement.below,
            animationDuration: const Duration(milliseconds: 200),
            items: [item('关闭中 A'), item('关闭中 B')],
          ),
        ),
      );

      unawaited(controller.open(0));
      await tester.pumpAndSettle();
      unawaited(controller.close());
      await tester.pump(const Duration(milliseconds: 50));
      unawaited(controller.open(1));
      await tester.pumpAndSettle();

      expect(controller.openIndex, 1);
      expect(find.text('关闭中 A panel'), findsNothing);
      expect(find.text('关闭中 B panel'), findsOneWidget);
      final revealKey = find.byKey(
        const ValueKey<String>('t-dropdown-menu-open-close-reveal'),
      );
      final align = tester.widget<Align>(
        find.descendant(of: revealKey, matching: find.byType(Align)),
      );
      expect(align.heightFactor, 1);
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

    testWidgets('non-dismissible transparent overlay remains open', (
      tester,
    ) async {
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

    testWidgets(
      'open overlay reads updated items and dismissal configuration',
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
      },
    );

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

    testWidgets('trigger semantics and focus update and restore', (
      tester,
    ) async {
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
      var semanticsWidget = tester.widget<Semantics>(triggerSemantics);
      expect(semanticsWidget.properties.expanded, isFalse);
      expect(semanticsWidget.properties.button, isTrue);

      await tester.tap(find.text('无障碍筛选'));
      await tester.pumpAndSettle();
      semanticsWidget = tester.widget<Semantics>(triggerSemantics);
      expect(semanticsWidget.properties.expanded, isTrue);
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

    testWidgets('escape and system back close without popping page', (
      tester,
    ) async {
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

    testWidgets('disposing while open removes overlay without callback', (
      tester,
    ) async {
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

    testWidgets('external controller can be replaced while mounted', (
      tester,
    ) async {
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

    testWidgets('replacing controller while open removes the old overlay', (
      tester,
    ) async {
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

    testWidgets('dynamic item shrink closes an invalid open item', (
      tester,
    ) async {
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

    testWidgets('dynamically disabling the open item closes it', (
      tester,
    ) async {
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

    testWidgets('switching from owned to external controller remains usable', (
      tester,
    ) async {
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

    testWidgets('bar, panel and overlay follow ancestor scroll as one unit', (
      tester,
    ) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 100),
                TDropdownMenu(
                  placement: TDropdownMenuPlacement.below,
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

      final menuFinder = find.byType(TDropdownMenu);
      final panelFinder = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel'),
      );
      final overlayFinder = find.byKey(
        const ValueKey<String>('t-dropdown-menu-overlay'),
      );
      final beforeBar = tester.getRect(menuFinder);
      final beforePanel = tester.getRect(panelFinder);
      final beforeOverlay = tester.getRect(overlayFinder);

      scrollController.jumpTo(40);
      await tester.pump();
      await tester.pump();

      final afterBar = tester.getRect(menuFinder);
      final afterPanel = tester.getRect(panelFinder);
      final afterOverlay = tester.getRect(overlayFinder);
      expect(afterBar.top - beforeBar.top, closeTo(-40, 0.001));
      expect(afterPanel.top - beforePanel.top, closeTo(-40, 0.001));
      expect(afterOverlay.top - beforeOverlay.top, closeTo(-40, 0.001));
      expect(afterPanel.top, closeTo(afterBar.bottom, 0.001));
      expect(afterOverlay.top, closeTo(afterBar.bottom, 0.001));
      expect(afterOverlay.bottom, closeTo(600, 0.001));
      expect(afterOverlay.height, greaterThan(beforeOverlay.height));
    });

    testWidgets('panel and overlay leave the viewport with an offscreen bar', (
      tester,
    ) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 300),
                TDropdownMenu(
                  placement: TDropdownMenuPlacement.below,
                  animationDuration: Duration.zero,
                  items: [item('滚出视口')],
                ),
                const SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('滚出视口'));
      await tester.pumpAndSettle();

      scrollController.jumpTo(700);
      await tester.pump();

      expect(
        tester.getRect(find.byType(TDropdownMenu)).bottom,
        lessThanOrEqualTo(0),
      );
      expect(
        tester
            .getRect(
              find.byKey(const ValueKey<String>('t-dropdown-menu-panel')),
            )
            .bottom,
        lessThanOrEqualTo(0),
      );
      expect(
        tester
            .getRect(
              find.byKey(const ValueKey<String>('t-dropdown-menu-overlay')),
            )
            .bottom,
        lessThanOrEqualTo(0),
      );
    });

    testWidgets('nested and root overlays both support anchored panels', (
      tester,
    ) async {
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
    testWidgets(
      'non-scrollable menu is safe in an unbounded horizontal parent',
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
      },
    );

    testWidgets('anchor seam guard straddles the bar by one physical pixel', (
      tester,
    ) async {
      const devicePixelRatio = 3.25;
      const logicalSize = Size(800, 600);
      tester.view.devicePixelRatio = devicePixelRatio;
      tester.view.physicalSize = logicalSize * devicePixelRatio;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      const seamKey = ValueKey<String>('t-dropdown-menu-anchor-seam');
      const physicalPixel = 1 / devicePixelRatio;

      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.below,
            animationDuration: Duration.zero,
            items: [item('向下保护区')],
          ),
          alignment: Alignment.center,
        ),
      );
      await tester.tap(find.text('向下保护区'));
      await tester.pumpAndSettle();

      var barRect = tester.getRect(find.byType(TDropdownMenu));
      var seamRect = tester.getRect(find.byKey(seamKey));
      expect(seamRect.top, closeTo(barRect.bottom - physicalPixel, 0.001));
      expect(seamRect.bottom, closeTo(barRect.bottom + physicalPixel, 0.001));

      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      await tester.pump();
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.above,
            animationDuration: Duration.zero,
            items: [item('向上保护区')],
          ),
          alignment: Alignment.center,
        ),
      );
      await tester.tap(find.text('向上保护区'));
      await tester.pumpAndSettle();

      barRect = tester.getRect(find.byType(TDropdownMenu));
      seamRect = tester.getRect(find.byKey(seamKey));
      expect(seamRect.top, closeTo(barRect.top - physicalPixel, 0.001));
      expect(seamRect.bottom, closeTo(barRect.top + physicalPixel, 0.001));
    });

    testWidgets('panel and overlay touch only the configured side of the bar', (
      tester,
    ) async {
      const panelKey = ValueKey<String>('t-dropdown-menu-panel');
      const overlayKey = ValueKey<String>('t-dropdown-menu-overlay');
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.below,
            animationDuration: Duration.zero,
            items: [item('向下')],
          ),
          alignment: Alignment.center,
        ),
      );
      await tester.tap(find.text('向下'));
      await tester.pumpAndSettle();
      var barRect = tester.getRect(find.byType(TDropdownMenu));
      var panelRect = tester.getRect(find.byKey(panelKey));
      var overlayRect = tester.getRect(find.byKey(overlayKey));
      expect(panelRect.top, closeTo(barRect.bottom, 0.001));
      expect(panelRect.left, closeTo(barRect.left, 0.001));
      expect(panelRect.right, closeTo(barRect.right, 0.001));
      expect(overlayRect.top, closeTo(barRect.bottom, 0.001));
      expect(overlayRect.left, closeTo(0, 0.001));
      expect(overlayRect.right, closeTo(800, 0.001));

      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      await tester.pump();
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.above,
            animationDuration: Duration.zero,
            items: [item('向上')],
          ),
          alignment: Alignment.center,
        ),
      );
      await tester.tap(find.text('向上'));
      await tester.pumpAndSettle();
      barRect = tester.getRect(find.byType(TDropdownMenu));
      panelRect = tester.getRect(find.byKey(panelKey));
      overlayRect = tester.getRect(find.byKey(overlayKey));
      expect(panelRect.bottom, closeTo(barRect.top, 0.001));
      expect(panelRect.left, closeTo(barRect.left, 0.001));
      expect(panelRect.right, closeTo(barRect.right, 0.001));
      expect(overlayRect.bottom, closeTo(barRect.top, 0.001));
      expect(overlayRect.left, closeTo(0, 0.001));
      expect(overlayRect.right, closeTo(800, 0.001));
    });

    testWidgets('content opposite the expansion side remains interactive', (
      tester,
    ) async {
      final controller = TDropdownMenuController();
      addTearDown(controller.dispose);
      var pageTapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => pageTapCount++,
                  child: const ColoredBox(color: Colors.white),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TDropdownMenu(
                    controller: controller,
                    placement: TDropdownMenuPlacement.below,
                    animationDuration: Duration.zero,
                    items: [item('单侧遮罩')],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('单侧遮罩'));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(20, 100));
      await tester.pumpAndSettle();
      expect(pageTapCount, 1);
      expect(controller.isOpen, isFalse);

      await controller.open(0);
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(const Offset(20, 100));
      await gesture.moveBy(const Offset(0, -80));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(controller.isOpen, isTrue);

      await tester.tapAt(const Offset(20, 500));
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);
    });

    testWidgets('dragging the opposite side scrolls without closing', (
      tester,
    ) async {
      final controller = TDropdownMenuController();
      final scrollController = ScrollController();
      addTearDown(controller.dispose);
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 240),
                TDropdownMenu(
                  controller: controller,
                  placement: TDropdownMenuPlacement.below,
                  animationDuration: Duration.zero,
                  items: [item('拖拽页面')],
                ),
                const SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('拖拽页面'));
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(20, 100));
      await gesture.moveBy(const Offset(0, -80));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(scrollController.offset, greaterThan(0));
      expect(controller.isOpen, isTrue);
      final barRect = tester.getRect(find.byType(TDropdownMenu));
      final overlayRect = tester.getRect(
        find.byKey(const ValueKey<String>('t-dropdown-menu-overlay')),
      );
      expect(overlayRect.top, closeTo(barRect.bottom, 0.001));
      expect(overlayRect.bottom, closeTo(600, 0.001));
    });

    testWidgets('opening another menu closes the previous menu', (
      tester,
    ) async {
      final firstController = TDropdownMenuController();
      final secondController = TDropdownMenuController();
      addTearDown(firstController.dispose);
      addTearDown(secondController.dispose);
      await tester.pumpWidget(
        wrap(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TDropdownMenu(
                controller: secondController,
                placement: TDropdownMenuPlacement.below,
                animationDuration: Duration.zero,
                items: [item('第二个菜单')],
              ),
              TDropdownMenu(
                controller: firstController,
                placement: TDropdownMenuPlacement.below,
                animationDuration: Duration.zero,
                items: [item('第一个菜单')],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('第一个菜单'));
      await tester.pumpAndSettle();
      expect(firstController.isOpen, isTrue);
      expect(secondController.isOpen, isFalse);

      await tester.tap(find.text('第二个菜单'));
      await tester.pumpAndSettle();
      expect(firstController.isOpen, isFalse);
      expect(secondController.isOpen, isTrue);
      expect(find.text('第一个菜单 panel'), findsNothing);
      expect(find.text('第二个菜单 panel'), findsOneWidget);
    });

    testWidgets('scroll refreshes overlay coverage to the viewport edge', (
      tester,
    ) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 200),
                TDropdownMenu(
                  placement: TDropdownMenuPlacement.below,
                  animationDuration: Duration.zero,
                  items: [item('滚动遮罩')],
                ),
                const SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('滚动遮罩'));
      await tester.pumpAndSettle();

      scrollController.jumpTo(100);
      await tester.pump();
      await tester.pump();

      final barRect = tester.getRect(find.byType(TDropdownMenu));
      final overlayRect = tester.getRect(
        find.byKey(const ValueKey<String>('t-dropdown-menu-overlay')),
      );
      expect(overlayRect.top, closeTo(barRect.bottom, 0.001));
      expect(overlayRect.bottom, closeTo(600, 0.001));
    });

    testWidgets('auto opens above when lower space is small', (tester) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(animationDuration: Duration.zero, items: [item('自动')]),
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
          TDropdownMenu(animationDuration: Duration.zero, items: [item('短面板')]),
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

    testWidgets('arrow direction follows explicit and resolved placement', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            placement: TDropdownMenuPlacement.above,
            animationDuration: Duration.zero,
            items: [item('向上箭头')],
          ),
        ),
      );
      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
        0.5,
      );
      await tester.tap(find.text('向上箭头'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
        0,
      );

      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: Duration.zero,
            items: [item('自动箭头')],
          ),
          alignment: Alignment.bottomCenter,
        ),
      );
      await tester.tap(find.text('自动箭头'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<AnimatedRotation>(find.byType(AnimatedRotation)).turns,
        0,
      );
    });

    testWidgets('auto placement re-evaluates when the anchor scrolls', (
      tester,
    ) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 400),
                TDropdownMenu(
                  animationDuration: Duration.zero,
                  items: [item('滚动翻转', panelHeight: 180)],
                ),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('滚动翻转'));
      await tester.pumpAndSettle();
      var barRect = tester.getRect(find.byType(TDropdownMenu));
      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 0.001));

      scrollController.jumpTo(250);
      await tester.pump();
      await tester.pump();
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.5));
    });

    testWidgets('auto placement is stable around the flip boundary', (
      tester,
    ) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 400),
                TDropdownMenu(
                  animationDuration: Duration.zero,
                  items: [item('临界翻转', panelHeight: 180)],
                ),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('临界翻转'));
      await tester.pumpAndSettle();
      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );

      Future<void> setSpaceBelow(double target) async {
        final barRect = tester.getRect(find.byType(TDropdownMenu));
        final current = 600 - barRect.bottom;
        scrollController.jumpTo(scrollController.offset + target - current);
        await tester.pump();
        await tester.pump();
      }

      await setSpaceBelow(190);
      var barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.001));

      await setSpaceBelow(179);
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 0.001));

      await setSpaceBelow(181);
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 0.001));

      await setSpaceBelow(189);
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.001));
    });

    testWidgets('auto placement is stable when available spaces are equal', (
      tester,
    ) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 400),
                TDropdownMenu(
                  animationDuration: Duration.zero,
                  items: [item('空间临界', panelHeight: 500)],
                ),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ),
      );
      scrollController.jumpTo(140);
      await tester.pump();
      await tester.tap(find.text('空间临界'));
      await tester.pumpAndSettle();

      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );

      Future<void> setSpaceDifference(double target) async {
        final barRect = tester.getRect(find.byType(TDropdownMenu));
        final current = barRect.top - (600 - barRect.bottom);
        scrollController.jumpTo(
          scrollController.offset + (current - target) / 2,
        );
        await tester.pump();
        await tester.pump();
      }

      await setSpaceDifference(2);
      var barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.001));

      await setSpaceDifference(10);
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 0.001));

      await setSpaceDifference(-2);
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 0.001));

      await setSpaceDifference(-10);
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.001));
    });

    testWidgets('auto placement can return during the same active drag', (
      tester,
    ) async {
      final scrollController = ScrollController();
      addTearDown(scrollController.dispose);
      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 400),
                TDropdownMenu(
                  animationDuration: Duration.zero,
                  items: [item('拖动临界', panelHeight: 180)],
                ),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ),
      );
      scrollController.jumpTo(250);
      await tester.pump();
      await tester.tap(find.text('拖动临界'));
      await tester.pumpAndSettle();

      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );
      var barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.001));

      final gesture = await tester.startGesture(const Offset(20, 80));
      for (var step = 0; step < 5; step++) {
        await gesture.moveBy(const Offset(0, 52));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(scrollController.offset, lessThan(250));
      barRect = tester.getRect(find.byType(TDropdownMenu));
      // Flutter engines can round the actively dragged anchor by one logical
      // pixel while preserving the exact above/below placement relationship.
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 1));
      final seam = find.byKey(
        const ValueKey<String>('t-dropdown-menu-anchor-seam'),
      );
      expect(tester.getRect(seam).bottom, greaterThan(barRect.top - 1));

      for (var step = 0; step < 4; step++) {
        await gesture.moveBy(const Offset(0, -52));
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
      }
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 1));

      await gesture.up();
      scrollController.jumpTo(250);
      await tester.pump();
      await tester.pump();
      barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 1));
    });

    testWidgets('auto placement re-evaluates the target panel height', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TDropdownMenu(
            animationDuration: const Duration(milliseconds: 200),
            items: [
              item('短筛选', panelHeight: 80),
              item('长筛选', panelHeight: 260),
            ],
          ),
          alignment: const Alignment(0, 0.55),
        ),
      );

      await tester.tap(find.text('短筛选'));
      await tester.pumpAndSettle();
      final barRect = tester.getRect(find.byType(TDropdownMenu));
      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.001));

      await tester.tap(find.text('长筛选'));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 0.001));
      expect(tester.getRect(panelSurface).top, greaterThanOrEqualTo(0));
    });

    testWidgets('auto placement remeasures rebuilt active panel content', (
      tester,
    ) async {
      var panelHeight = 80.0;
      late StateSetter rebuild;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return TDropdownMenu(
                animationDuration: Duration.zero,
                items: [item('动态面板', panelHeight: panelHeight)],
              );
            },
          ),
          alignment: const Alignment(0, 0.55),
        ),
      );

      await tester.tap(find.text('动态面板'));
      await tester.pumpAndSettle();
      final panelSurface = find.byKey(
        const ValueKey<String>('t-dropdown-menu-panel-surface'),
      );
      final barRect = tester.getRect(find.byType(TDropdownMenu));
      expect(tester.getRect(panelSurface).top, closeTo(barRect.bottom, 0.001));

      rebuild(() => panelHeight = 260);
      await tester.pump();
      await tester.pumpAndSettle();
      expect(tester.getRect(panelSurface).bottom, closeTo(barRect.top, 0.001));
    });

    testWidgets('keyboard and safe area constrain a long panel', (
      tester,
    ) async {
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
      final overlayRect = tester.getRect(
        find.byKey(const ValueKey<String>('t-dropdown-menu-overlay')),
      );
      expect(listRect.top, greaterThanOrEqualTo(48));
      expect(listRect.bottom, lessThanOrEqualTo(400));
      expect(overlayRect.bottom, closeTo(600, 0.001));
      expect(tester.takeException(), isNull);
    });
  });
}
