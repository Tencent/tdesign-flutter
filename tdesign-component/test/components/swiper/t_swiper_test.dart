import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget app(Widget child, {TSwiperThemeData? swiperTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (swiperTheme != null) {
      theme = theme.mergeExtension(swiperTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: SizedBox(width: 320, height: 200, child: child)),
    );
  }

  const pages = [Text('page-0'), Text('page-1'), Text('page-2')];

  group('TSwiper controlled', () {
    testWidgets('默认渲染 value 对应页面与圆点', (tester) async {
      await tester.pumpWidget(app(const TSwiper(children: pages, value: 1)));

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byKey(const ValueKey('swiper-dot-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('swiper-dot-2')), findsOneWidget);
      final controller =
          tester.widget<PageView>(find.byType(PageView)).controller!;
      expect(controller.initialPage, 1);
    });

    testWidgets('onChanged 为空时禁止手势滚动', (tester) async {
      await tester.pumpWidget(app(const TSwiper(children: pages)));
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.physics, isA<NeverScrollableScrollPhysics>());
    });

    testWidgets('滑动只请求新值，父级回写后切换', (tester) async {
      var value = 0;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) => TSwiper(
          value: value,
          onChanged: (next) => setState(() => value = next),
          children: pages,
        ),
      )));

      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(value, 1);
    });

    testWidgets('外部 value 更新会驱动 PageController', (tester) async {
      var value = 0;
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TSwiper(
            value: value,
            onChanged: (_) {},
            children: pages,
          );
        },
      )));

      update(() => value = 2);
      await tester.pumpAndSettle();
      final controller =
          tester.widget<PageView>(find.byType(PageView)).controller!;
      expect(controller.page, 2);
    });

    testWidgets('builder 模式按索引构建', (tester) async {
      await tester.pumpWidget(app(TSwiper(
        itemCount: 2,
        itemBuilder: (context, index) => Text('builder-$index'),
      )));
      expect(find.text('builder-0'), findsOneWidget);
    });

    testWidgets('loop 模式规范化虚拟页索引', (tester) async {
      var value = 2;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) => TSwiper(
          loop: true,
          value: value,
          onChanged: (next) => setState(() => value = next),
          children: pages,
        ),
      )));
      final controller =
          tester.widget<PageView>(find.byType(PageView)).controller!;
      expect(controller.initialPage, greaterThan(1000));
      expect(controller.initialPage % 3, 2);
    });

    testWidgets('切换 loop 会重建控制器', (tester) async {
      var loop = false;
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TSwiper(
            loop: loop,
            onChanged: (_) {},
            children: pages,
          );
        },
      )));
      final oldController =
          tester.widget<PageView>(find.byType(PageView)).controller;
      update(() => loop = true);
      await tester.pump();
      final newController =
          tester.widget<PageView>(find.byType(PageView)).controller;
      expect(newController, isNot(same(oldController)));
    });
  });

  group('TSwiper autoplay', () {
    testWidgets('定时请求下一页', (tester) async {
      var value = 0;
      await tester.pumpWidget(app(TSwiper(
        value: value,
        onChanged: (next) => value = next,
        autoplay: true,
        autoplayInterval: const Duration(milliseconds: 100),
        children: pages,
      )));

      await tester.pump(const Duration(milliseconds: 110));
      expect(value, 1);
    });

    testWidgets('末页非 loop 不发出越界值', (tester) async {
      var calls = 0;
      await tester.pumpWidget(app(TSwiper(
        value: 2,
        onChanged: (_) => calls++,
        autoplay: true,
        autoplayInterval: const Duration(milliseconds: 100),
        children: pages,
      )));
      await tester.pump(const Duration(milliseconds: 110));
      expect(calls, 0);
    });

    testWidgets('末页 loop 请求第 0 页', (tester) async {
      int? next;
      await tester.pumpWidget(app(TSwiper(
        value: 2,
        loop: true,
        onChanged: (value) => next = value,
        autoplay: true,
        autoplayInterval: const Duration(milliseconds: 100),
        children: pages,
      )));
      await tester.pump(const Duration(milliseconds: 110));
      expect(next, 0);
    });

    testWidgets('更新 autoplay 配置会重建定时器', (tester) async {
      var autoplay = false;
      var calls = 0;
      late StateSetter update;
      await tester.pumpWidget(app(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TSwiper(
            autoplay: autoplay,
            autoplayInterval: const Duration(milliseconds: 50),
            onChanged: (_) => calls++,
            children: pages,
          );
        },
      )));
      update(() => autoplay = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      expect(calls, 1);
    });
  });

  group('pagination and effects', () {
    testWidgets('none 不创建 Stack', (tester) async {
      await tester.pumpWidget(app(const TSwiper(
        pagination: TSwiperPaginationVariant.none,
        children: pages,
      )));
      expect(find.byKey(const ValueKey('swiper-dot-0')), findsNothing);
      expect(find.text('1/3'), findsNothing);
    });

    testWidgets('单页不显示分页器', (tester) async {
      await tester.pumpWidget(app(const TSwiper(children: [Text('only')])));
      expect(find.byKey(const ValueKey('swiper-dot-0')), findsNothing);
    });

    testWidgets('dotsBar 激活项使用长条宽度', (tester) async {
      await tester.pumpWidget(app(
        const TSwiper(
          pagination: TSwiperPaginationVariant.dotsBar,
          children: pages,
        ),
        swiperTheme: const TSwiperThemeData(
          dotSize: 8,
          activeDotWidth: 24,
          dotSpacing: 3,
          activeColor: Colors.red,
          inactiveColor: Colors.green,
        ),
      ));
      final active = find.byKey(const ValueKey('swiper-dot-0'));
      final inactive = find.byKey(const ValueKey('swiper-dot-1'));
      expect(tester.getSize(active).width,
          greaterThan(tester.getSize(inactive).width));
      expect(tester.getSize(active).height, 8);
    });

    testWidgets('fraction 显示受控页码', (tester) async {
      await tester.pumpWidget(app(
        const TSwiper(
          value: 1,
          pagination: TSwiperPaginationVariant.fraction,
          children: pages,
        ),
        swiperTheme: const TSwiperThemeData(
          fractionStyle: TextStyle(color: Colors.red),
          fractionBackgroundColor: Colors.black,
        ),
      ));
      expect(find.text('2/3'), findsOneWidget);
    });

    testWidgets('fraction 默认样式来自全局 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(app(const TSwiper(
        pagination: TSwiperPaginationVariant.fraction,
        children: pages,
      )));

      final text = tester.widget<Text>(find.text('1/3'));
      expect(text.style?.color, token.textColorAnti);
      expect(text.style?.fontSize, token.fontBodySmall?.size);
    });

    testWidgets('controls 请求前后页并尊重边界', (tester) async {
      final values = <int>[];
      await tester.pumpWidget(app(TSwiper(
        value: 1,
        pagination: TSwiperPaginationVariant.controls,
        onChanged: values.add,
        children: pages,
      )));
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.tap(find.byIcon(Icons.chevron_right));
      expect(values, [0, 2]);
    });

    testWidgets('controls 在非循环边界禁用按钮', (tester) async {
      await tester.pumpWidget(app(TSwiper(
        pagination: TSwiperPaginationVariant.controls,
        onChanged: (_) {},
        children: pages,
      )));
      final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
      expect(buttons.first.onPressed, isNull);
      expect(buttons.last.onPressed, isNotNull);
    });

    testWidgets('cardMargin 创建 Padding 效果', (tester) async {
      await tester.pumpWidget(app(TSwiper(
        pageEffect: TSwiperPageEffect.cardMargin,
        onChanged: (_) {},
        children: pages,
      )));
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('scaleAndFade 创建透明缩放效果', (tester) async {
      await tester.pumpWidget(app(TSwiper(
        pageEffect: TSwiperPageEffect.scaleAndFade,
        onChanged: (_) {},
        children: pages,
      )));
      expect(find.byType(Opacity), findsWidgets);
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('Theme 提供默认 pagination 与 effect', (tester) async {
      await tester.pumpWidget(app(
        TSwiper(onChanged: (_) {}, children: pages),
        swiperTheme: const TSwiperThemeData(
          pagination: TSwiperPaginationVariant.fraction,
          pageEffect: TSwiperPageEffect.cardMargin,
          paginationMargin: EdgeInsets.all(4),
        ),
      ));
      expect(find.text('1/3'), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });
  });

  group('TSwiperThemeData', () {
    const a = TSwiperThemeData(
      pagination: TSwiperPaginationVariant.dots,
      pageEffect: TSwiperPageEffect.none,
      paginationMargin: EdgeInsets.all(2),
      activeColor: Colors.red,
      inactiveColor: Colors.black,
      dotSize: 4,
      activeDotWidth: 10,
      dotSpacing: 2,
      fractionStyle: TextStyle(fontSize: 10),
      fractionBackgroundColor: Colors.white,
    );
    const b = TSwiperThemeData(
      pagination: TSwiperPaginationVariant.fraction,
      pageEffect: TSwiperPageEffect.scaleAndFade,
      paginationMargin: EdgeInsets.all(6),
      activeColor: Colors.blue,
      inactiveColor: Colors.white,
      dotSize: 8,
      activeDotWidth: 20,
      dotSpacing: 6,
      fractionStyle: TextStyle(fontSize: 14),
      fractionBackgroundColor: Colors.black,
    );

    test('copyWith 覆盖并保留字段', () {
      final value = a.copyWith(dotSize: 7, activeColor: Colors.green);
      expect(value.pagination, a.pagination);
      expect(value.pageEffect, a.pageEffect);
      expect(value.paginationMargin, a.paginationMargin);
      expect(value.activeColor, Colors.green);
      expect(value.inactiveColor, a.inactiveColor);
      expect(value.dotSize, 7);
      expect(value.activeDotWidth, a.activeDotWidth);
      expect(value.dotSpacing, a.dotSpacing);
      expect(value.fractionStyle, a.fractionStyle);
      expect(value.fractionBackgroundColor, a.fractionBackgroundColor);
      final all = a.copyWith(
        pagination: TSwiperPaginationVariant.controls,
        pageEffect: TSwiperPageEffect.cardMargin,
        paginationMargin: const EdgeInsets.all(9),
        inactiveColor: Colors.yellow,
        activeDotWidth: 18,
        dotSpacing: 5,
        fractionStyle: const TextStyle(fontSize: 18),
        fractionBackgroundColor: Colors.green,
      );
      expect(all.pagination, TSwiperPaginationVariant.controls);
      expect(all.pageEffect, TSwiperPageEffect.cardMargin);
      expect(all.paginationMargin, const EdgeInsets.all(9));
      expect(all.inactiveColor, Colors.yellow);
      expect(all.activeDotWidth, 18);
      expect(all.dotSpacing, 5);
      expect(all.fractionStyle?.fontSize, 18);
      expect(all.fractionBackgroundColor, Colors.green);
    });

    test('lerp 插值全部视觉字段', () {
      final value = a.lerp(b, 0.5);
      expect(value.pagination, b.pagination);
      expect(value.pageEffect, b.pageEffect);
      expect(value.paginationMargin, const EdgeInsets.all(4));
      expect(value.activeColor, isNotNull);
      expect(value.inactiveColor, isNotNull);
      expect(value.dotSize, 6);
      expect(value.activeDotWidth, 15);
      expect(value.dotSpacing, 4);
      expect(value.fractionStyle?.fontSize, 12);
      expect(value.fractionBackgroundColor, isNotNull);
      expect(a.lerp(null, 0.5), same(a));
      expect(
          const TSwiperThemeData().lerp(const TSwiperThemeData(), 0.5).dotSize,
          isNull);
    });
  });

  group('constructor contracts', () {
    test('必须且只能提供一种内容来源', () {
      expect(
          () => TSwiper(
              children: const [], itemBuilder: (_, __) => const Text('x')),
          throwsAssertionError);
      expect(TSwiper.new, throwsAssertionError);
      expect(() => TSwiper(itemBuilder: (_, __) => const Text('x')),
          throwsAssertionError);
    });

    test('拒绝无效数量、索引和无回调自动播放', () {
      expect(
        () => TSwiper(itemCount: 0, itemBuilder: (_, __) => const Text('x')),
        throwsAssertionError,
      );
      expect(() => TSwiper(value: -1, children: pages), throwsAssertionError);
      expect(
          () => TSwiper(autoplay: true, children: pages), throwsAssertionError);
    });
  });
}
