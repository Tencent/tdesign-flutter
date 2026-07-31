import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget app(
    Widget child, {
    TSwiperThemeData? swiperTheme,
    Size size = const Size(320, 200),
  }) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (swiperTheme != null) {
      theme = theme.mergeExtension(swiperTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: SizedBox(width: size.width, height: size.height, child: child),
      ),
    );
  }

  const pages = [Text('page-0'), Text('page-1'), Text('page-2')];

  PageController pageControllerOf(WidgetTester tester) =>
      tester.widget<PageView>(find.byType(PageView)).controller!;

  group('TSwiperController', () {
    testWidgets('initialIndex 决定首次展示页', (tester) async {
      final controller = TSwiperController(initialIndex: 1);
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        children: pages,
      )));

      expect(controller.hasClients, isTrue);
      expect(controller.index, 1);
      expect(pageControllerOf(tester).initialPage, 1);
    });

    testWidgets('jumpTo、animateTo、next 和 previous 驱动实际页', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      final changed = <int>[];
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        onChanged: changed.add,
        children: pages,
      )));

      controller.jumpTo(2);
      await tester.pump();
      expect(controller.index, 2);

      var operation = controller.previous();
      await tester.pumpAndSettle();
      await operation;
      expect(controller.index, 1);

      operation = controller.animateTo(0);
      await tester.pumpAndSettle();
      await operation;
      expect(controller.index, 0);

      operation = controller.next();
      await tester.pumpAndSettle();
      await operation;
      expect(controller.index, 1);
      expect(changed, containsAllInOrder([2, 1, 0, 1]));
    });

    testWidgets('非循环目标钳制并在边界保持不动', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        children: pages,
      )));

      controller.jumpTo(99);
      await tester.pump();
      expect(controller.index, 2);
      final operation = controller.next();
      await tester.pumpAndSettle();
      await operation;
      expect(controller.index, 2);
    });

    testWidgets('loop 的 next/previous 各移动一个虚拟页', (tester) async {
      final controller = TSwiperController(initialIndex: 2);
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        loop: true,
        children: pages,
      )));
      final pageController = pageControllerOf(tester);
      final initial = pageController.initialPage;

      var operation = controller.next();
      await tester.pumpAndSettle();
      await operation;
      expect(controller.index, 0);
      expect(pageController.page, initial + 1);

      operation = controller.previous();
      await tester.pumpAndSettle();
      await operation;
      expect(controller.index, 2);
      expect(pageController.page, initial);
    });

    testWidgets('loop animateTo 始终向前到达目标', (tester) async {
      final controller = TSwiperController(initialIndex: 2);
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        loop: true,
        children: pages,
      )));
      final pageController = pageControllerOf(tester);
      final initial = pageController.initialPage;

      final operation = controller.animateTo(0);
      await tester.pumpAndSettle();
      await operation;
      expect(pageController.page, initial + 1);
      expect(controller.index, 0);
    });

    testWidgets('外部 Controller 由调用方持有且卸载后可复用', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        children: pages,
      )));
      expect(controller.hasClients, isTrue);

      await tester.pumpWidget(app(const SizedBox()));
      expect(controller.hasClients, isFalse);

      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        children: pages,
      )));
      expect(controller.hasClients, isTrue);
    });

    testWidgets('替换 Controller 使用新的 initialIndex 并通知实际页', (tester) async {
      final first = TSwiperController();
      final second = TSwiperController(initialIndex: 2);
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      final changed = <int>[];
      var controller = first;
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TSwiper(
            controller: controller,
            onChanged: changed.add,
            children: pages,
          );
        },
      )));

      update(() => controller = second);
      await tester.pump();
      await tester.pump();
      expect(first.hasClients, isFalse);
      expect(second.index, 2);
      expect(pageControllerOf(tester).initialPage, 2);
      expect(changed, [2]);
    });

    testWidgets('同一个 Controller 不能同时控制两个 Swiper', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(Column(
        children: [
          Expanded(child: TSwiper(controller: controller, children: pages)),
          Expanded(child: TSwiper(controller: controller, children: pages)),
        ],
      )));
      expect(tester.takeException(), isStateError);
    });

    testWidgets('数据减少时钳制当前页并通知', (tester) async {
      final controller = TSwiperController(initialIndex: 2);
      addTearDown(controller.dispose);
      var children = pages;
      final changed = <int>[];
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TSwiper(
            controller: controller,
            onChanged: changed.add,
            children: children,
          );
        },
      )));

      update(() => children = const [Text('only')]);
      await tester.pump();
      await tester.pump();
      expect(controller.index, 0);
      expect(changed, [0]);
    });

    testWidgets('同一 children 列表原地减少时仍钳制当前页', (tester) async {
      final controller = TSwiperController(initialIndex: 2);
      addTearDown(controller.dispose);
      final children = <Widget>[
        const Text('one'),
        const Text('two'),
        const Text('three'),
      ];
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TSwiper(controller: controller, children: children);
        },
      )));

      update(() => children.removeRange(1, children.length));
      await tester.pump();
      await tester.pump();
      expect(controller.index, 0);
      expect(pageControllerOf(tester).initialPage, 0);
    });
  });

  group('autoplay lifecycle', () {
    testWidgets('定时切换并在非循环末页停止', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        autoplay: true,
        autoplayInterval: const Duration(milliseconds: 50),
        pagination: TSwiperPaginationVariant.none,
        children: pages,
      )));

      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();
      expect(controller.index, 1);
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();
      expect(controller.index, 2);
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.index, 2);
    });

    testWidgets('由单页更新为多页后启动 autoplay', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      var children = const <Widget>[Text('only')];
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TSwiper(
            controller: controller,
            autoplay: true,
            autoplayInterval: const Duration(milliseconds: 50),
            pagination: TSwiperPaginationVariant.none,
            children: children,
          );
        },
      )));

      update(() => children = pages);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();
      expect(controller.index, 1);
    });

    testWidgets('TickerMode 关闭和应用非 resumed 时暂停', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      var tickerEnabled = false;
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TickerMode(
            enabled: tickerEnabled,
            child: TSwiper(
              controller: controller,
              autoplay: true,
              autoplayInterval: const Duration(milliseconds: 30),
              pagination: TSwiperPaginationVariant.none,
              children: pages,
            ),
          );
        },
      )));
      await tester.pump(const Duration(milliseconds: 40));
      expect(controller.index, 0);

      update(() => tickerEnabled = true);
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(milliseconds: 40));
      expect(controller.index, 0);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pumpAndSettle();
      expect(controller.index, 1);
    });

    testWidgets('在应用已暂停时首次挂载不会启动 autoplay', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        autoplay: true,
        autoplayInterval: const Duration(milliseconds: 30),
        pagination: TSwiperPaginationVariant.none,
        children: pages,
      )));
      await tester.pump(const Duration(milliseconds: 40));
      expect(controller.index, 0);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pumpAndSettle();
      expect(controller.index, 1);
    });

    testWidgets('Controller jump 后重新等待完整 interval', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        autoplay: true,
        loop: true,
        autoplayInterval: const Duration(milliseconds: 100),
        pagination: TSwiperPaginationVariant.none,
        children: pages,
      )));

      await tester.pump(const Duration(milliseconds: 80));
      controller.jumpTo(1);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 30));
      expect(controller.index, 1);
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pumpAndSettle();
      expect(controller.index, 2);
    });

    testWidgets('用户拖拽期间暂停并在稳定后重新等待完整 interval', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        autoplay: true,
        autoplayInterval: const Duration(milliseconds: 100),
        pagination: TSwiperPaginationVariant.none,
        children: pages,
      )));

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(PageView)),
      );
      await gesture.moveBy(const Offset(-1, 0));
      await tester.pump(const Duration(milliseconds: 120));
      expect(controller.index, 0);

      await gesture.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(controller.index, 0);
      await tester.pump(const Duration(milliseconds: 30));
      await tester.pumpAndSettle();
      expect(controller.index, 1);
    });
  });

  group('pagination and effects', () {
    testWidgets('页面滚动后 dots 选中态和 fraction 实际下标同步更新', (tester) async {
      await tester.pumpWidget(app(const TSwiper(children: pages)));

      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();
      final selectedDot = tester.widget<Semantics>(
        find.bySemanticsLabel('2 / 3'),
      );
      expect(selectedDot.properties.selected, isTrue);

      final fractionController = TSwiperController();
      addTearDown(fractionController.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: fractionController,
        pagination: TSwiperPaginationVariant.fraction,
        children: pages,
      )));
      fractionController.jumpTo(2);
      await tester.pump();
      expect(find.text('3/3'), findsOneWidget);
    });

    testWidgets('横竖 dotsBar 使用对应主轴长度', (tester) async {
      const theme = TSwiperThemeData(
        dotSize: 8,
        activeDotExtent: 24,
      );
      await tester.pumpWidget(app(
        const TSwiper(
          pagination: TSwiperPaginationVariant.dotsBar,
          children: pages,
        ),
        swiperTheme: theme,
      ));
      expect(
        tester.getSize(find.byKey(const ValueKey('swiper-dot-0'))),
        const Size(32, 8),
      );

      await tester.pumpWidget(app(
        const TSwiper(
          scrollDirection: Axis.vertical,
          pagination: TSwiperPaginationVariant.dotsBar,
          children: pages,
        ),
        swiperTheme: theme,
      ));
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(const ValueKey('swiper-dot-0'))),
        const Size(8, 32),
      );
    });

    testWidgets('默认 alignment 随滚动轴变化', (tester) async {
      await tester.pumpWidget(app(const TSwiper(children: pages)));
      expect(tester.widget<Align>(find.byType(Align)).alignment,
          Alignment.bottomCenter);

      await tester.pumpWidget(app(const TSwiper(
        scrollDirection: Axis.vertical,
        children: pages,
      )));
      expect(tester.widget<Align>(find.byType(Align)).alignment,
          Alignment.centerRight);
    });

    testWidgets('outside 横向放在下方且竖向放在右侧', (tester) async {
      await tester.pumpWidget(app(const TSwiper(
        paginationPlacement: TSwiperPaginationPlacement.outside,
        children: pages,
      )));
      final horizontalPage = tester.getRect(find.byType(PageView));
      final horizontalPagination =
          tester.getRect(find.bySemanticsLabel('1 / 3'));
      expect(horizontalPage.height, lessThan(200));
      expect(horizontalPagination.top,
          greaterThanOrEqualTo(horizontalPage.bottom));

      await tester.pumpWidget(app(const TSwiper(
        scrollDirection: Axis.vertical,
        paginationPlacement: TSwiperPaginationPlacement.outside,
        children: pages,
      )));
      await tester.pumpAndSettle();
      final verticalPage = tester.getRect(find.byType(PageView));
      final verticalPagination = tester.getRect(find.bySemanticsLabel('1 / 3'));
      expect(verticalPage.width, lessThan(320));
      expect(verticalPagination.left, greaterThanOrEqualTo(verticalPage.right));
    });

    testWidgets('实例 placement 覆盖主题默认值', (tester) async {
      const theme = TSwiperThemeData(
        paginationPlacement: TSwiperPaginationPlacement.outside,
      );
      await tester.pumpWidget(app(
        const TSwiper(children: pages),
        swiperTheme: theme,
      ));
      expect(find.byType(Flex), findsWidgets);
      expect(tester.getSize(find.byType(PageView)).height, lessThan(200));

      await tester.pumpWidget(app(
        const TSwiper(
          paginationPlacement: TSwiperPaginationPlacement.overlay,
          children: pages,
        ),
        swiperTheme: theme,
      ));
      expect(tester.getSize(find.byType(PageView)), const Size(320, 200));
    });

    testWidgets('自定义标记获得业务下标并随实际页更新', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        paginationItemBuilder: (context, details) {
          return SizedBox(
            key: ValueKey(
              'custom-marker-${details.index}-${details.isActive}',
            ),
            width: details.isActive ? 18 : 6,
            height: 6,
            child: Text('${details.currentIndex}:${details.itemCount}'),
          );
        },
        children: pages,
      )));

      expect(
        find.byKey(const ValueKey('custom-marker-0-true')),
        findsOneWidget,
      );
      expect(find.text('0:3'), findsNWidgets(3));

      controller.jumpTo(2);
      await tester.pump();
      expect(
        find.byKey(const ValueKey('custom-marker-2-true')),
        findsOneWidget,
      );
      final selectedSemantics = tester
          .widgetList<Semantics>(find.byType(Semantics))
          .singleWhere((widget) => widget.properties.label == '3 / 3');
      expect(
        selectedSemantics.properties.selected,
        isTrue,
      );
      expect(find.text('2:3'), findsNWidgets(3));
    });

    testWidgets('窄空间下自定义标记不会被默认 fraction 回退替换', (tester) async {
      await tester.pumpWidget(app(
        TSwiper(
          itemCount: 40,
          itemBuilder: (_, index) => Text('$index'),
          paginationItemBuilder: (_, details) => SizedBox.square(
            key: ValueKey('compact-marker-${details.index}'),
            dimension: 2,
          ),
        ),
        size: const Size(160, 100),
      ));

      expect(find.byKey(const ValueKey('compact-marker-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('compact-marker-39')), findsOneWidget);
      expect(find.text('1/40'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('竖向 cardMargin 使用 vertical padding', (tester) async {
      await tester.pumpWidget(app(const TSwiper(
        scrollDirection: Axis.vertical,
        pageEffect: TSwiperPageEffect.cardMargin,
        children: pages,
      )));
      final paddings = tester.widgetList<Padding>(find.byType(Padding));
      expect(
        paddings.any((padding) =>
            padding.padding == const EdgeInsets.symmetric(vertical: 6)),
        isTrue,
      );
    });

    testWidgets('竖向 controls 使用上下箭头', (tester) async {
      await tester.pumpWidget(app(const TSwiper(
        scrollDirection: Axis.vertical,
        loop: true,
        pagination: TSwiperPaginationVariant.controls,
        children: pages,
      )));
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('自定义 controls 图标保留按钮行为和边界禁用状态', (tester) async {
      final controller = TSwiperController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(app(TSwiper(
        controller: controller,
        pagination: TSwiperPaginationVariant.controls,
        previousIcon: const Icon(Icons.first_page, key: ValueKey('previous')),
        nextIcon: const Icon(Icons.last_page, key: ValueKey('next')),
        children: pages,
      )));

      expect(find.byKey(const ValueKey('previous')), findsOneWidget);
      expect(find.byKey(const ValueKey('next')), findsOneWidget);
      final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
      expect(buttons.first.onPressed, isNull);
      expect(buttons.last.onPressed, isNotNull);
      expect(
        buttons.first.style?.minimumSize?.resolve({}),
        const Size.square(32),
      );
      expect(
        tester.getSize(find.byType(IconButton).first),
        const Size.square(48),
      );

      await tester.tap(find.byKey(const ValueKey('next')));
      await tester.pumpAndSettle();
      expect(controller.index, 1);
    });

    testWidgets('横竖四种 pagination 组成无溢出的视觉矩阵', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const variants = [
        TSwiperPaginationVariant.dots,
        TSwiperPaginationVariant.dotsBar,
        TSwiperPaginationVariant.fraction,
        TSwiperPaginationVariant.controls,
      ];
      await tester.pumpWidget(MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(
          body: Column(
            children: [
              for (final axis in Axis.values)
                for (final variant in variants)
                  Expanded(
                    child: TSwiper(
                      scrollDirection: axis,
                      pagination: variant,
                      children: pages,
                    ),
                  ),
            ],
          ),
        ),
      ));

      expect(find.byType(PageView), findsNWidgets(8));
      expect(tester.takeException(), isNull);
    });

    testWidgets('横向 controls 根据 RTL 与 reverse 选择箭头方向', (tester) async {
      await tester.pumpWidget(app(const Directionality(
        textDirection: TextDirection.rtl,
        child: TSwiper(
          loop: true,
          pagination: TSwiperPaginationVariant.controls,
          children: pages,
        ),
      )));
      expect(
        tester.widgetList<Icon>(find.byType(Icon)).map((icon) => icon.icon),
        containsAllInOrder([Icons.chevron_right, Icons.chevron_left]),
      );

      await tester.pumpWidget(app(const Directionality(
        textDirection: TextDirection.rtl,
        child: TSwiper(
          loop: true,
          reverse: true,
          pagination: TSwiperPaginationVariant.controls,
          children: pages,
        ),
      )));
      expect(
        tester.widgetList<Icon>(find.byType(Icon)).map((icon) => icon.icon),
        containsAllInOrder([Icons.chevron_left, Icons.chevron_right]),
      );
    });

    testWidgets('多 dots 超出空间时回退 fraction', (tester) async {
      await tester.pumpWidget(app(
        TSwiper(
          itemCount: 40,
          itemBuilder: (_, index) => Text('$index'),
        ),
        size: const Size(160, 100),
      ));
      expect(find.text('1/40'), findsOneWidget);
    });

    testWidgets('viewportFraction 透传并显示页面效果', (tester) async {
      await tester.pumpWidget(app(const TSwiper(
        viewportFraction: 0.8,
        pageEffect: TSwiperPageEffect.scaleAndFade,
        children: pages,
      )));
      expect(pageControllerOf(tester).viewportFraction, 0.8);
      expect(find.byType(Opacity), findsWidgets);
    });
  });

  group('TSwiperThemeData', () {
    const a = TSwiperThemeData(
      pagination: TSwiperPaginationVariant.dots,
      pageEffect: TSwiperPageEffect.none,
      paginationPlacement: TSwiperPaginationPlacement.overlay,
      paginationAlignment: Alignment.bottomLeft,
      paginationMargin: EdgeInsets.all(2),
      activeColor: Colors.red,
      inactiveColor: Colors.black,
      dotSize: 4,
      activeDotExtent: 10,
      dotSpacing: 2,
      fractionStyle: TextStyle(fontSize: 10),
      fractionBackgroundColor: Colors.white,
      controlStyle: ButtonStyle(),
      controlIconSize: 12,
    );
    const b = TSwiperThemeData(
      pagination: TSwiperPaginationVariant.fraction,
      pageEffect: TSwiperPageEffect.scaleAndFade,
      paginationPlacement: TSwiperPaginationPlacement.outside,
      paginationAlignment: Alignment.topRight,
      paginationMargin: EdgeInsets.all(6),
      activeColor: Colors.blue,
      inactiveColor: Colors.white,
      dotSize: 8,
      activeDotExtent: 20,
      dotSpacing: 6,
      fractionStyle: TextStyle(fontSize: 14),
      fractionBackgroundColor: Colors.black,
      controlStyle: ButtonStyle(),
      controlIconSize: 20,
    );

    test('copyWith 和 lerp 覆盖新增视觉字段', () {
      final copied = a.copyWith(
        activeDotExtent: 18,
        controlIconSize: 16,
        paginationAlignment: Alignment.center,
        paginationPlacement: TSwiperPaginationPlacement.outside,
      );
      expect(copied.activeDotExtent, 18);
      expect(copied.controlIconSize, 16);
      expect(copied.paginationAlignment, Alignment.center);
      expect(
        copied.paginationPlacement,
        TSwiperPaginationPlacement.outside,
      );

      final value = a.lerp(b, 0.5);
      expect(value.activeDotExtent, 15);
      expect(value.controlIconSize, 16);
      expect(value.paginationAlignment, Alignment.center);
      expect(value.fractionStyle?.fontSize, 12);
      expect(value.paginationPlacement, TSwiperPaginationPlacement.outside);
    });
  });

  group('constructor contracts', () {
    test('拒绝无效内容、初始索引、视口和 autoplay 间隔', () {
      expect(TSwiper.new, throwsAssertionError);
      expect(
        () => const TSwiper(children: []).createState(),
        throwsArgumentError,
      );
      expect(
        () => TSwiper(itemCount: 0, itemBuilder: (_, __) => const Text('x')),
        throwsAssertionError,
      );
      expect(
        () => TSwiperController(initialIndex: -1),
        throwsArgumentError,
      );
      final outOfRange = TSwiperController(initialIndex: pages.length);
      addTearDown(outOfRange.dispose);
      expect(
        () => TSwiper(
          controller: outOfRange,
          children: pages,
        ).createState(),
        throwsRangeError,
      );
      expect(
        () => TSwiper(viewportFraction: 0, children: pages),
        throwsAssertionError,
      );
    });

    test('创建状态时拒绝非正 autoplay 间隔', () {
      expect(
        () => const TSwiper(
          autoplayInterval: Duration.zero,
          children: pages,
        ).createState(),
        throwsArgumentError,
      );
    });
  });
}
