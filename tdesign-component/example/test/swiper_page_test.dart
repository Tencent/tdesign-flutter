import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_swiper_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'demo_page_test_utils.dart';
import 'swiper_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(swiperDemoPageTestSpec);

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TSwiperPage(),
      ),
    );
  }

  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    for (
      var attempt = 0;
      attempt < 20 && target.evaluate().isEmpty;
      attempt++
    ) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pump();
    }
    expect(target, findsWidgets);
    await tester.ensureVisible(target.first);
    await tester.pump();
  }

  Finder swiperWhere(bool Function(TSwiper) predicate) {
    return find.byWidgetPredicate(
      (widget) => widget is TSwiper && predicate(widget),
    );
  }

  testWidgets('公开 Demo 使用六个目标条目、同源图片和准确初始配置', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    await tester.pump();

    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('点状（dots）'), findsOneWidget);
    var swiper = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) =>
            candidate.pagination == TSwiperPaginationVariant.dots &&
            !candidate.autoplay,
      ),
    );
    expect(swiper.children, hasLength(6));
    expect(swiper.autoplay, isFalse);
    expect(swiper.loop, isTrue);
    expect(swiper.animationDuration, const Duration(milliseconds: 500));
    expect(
      tester
          .widgetList<Image>(find.byType(Image))
          .every(
            (image) =>
                image.image is AssetImage &&
                (image.image as AssetImage).assetName.startsWith(
                  'assets/img/swiper',
                ),
          ),
      isTrue,
    );

    await scrollTo(tester, find.text('点条状（dots-bar）'));
    swiper = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) =>
            candidate.pagination == TSwiperPaginationVariant.dotsBar &&
            candidate.scrollDirection == Axis.horizontal,
      ),
    );
    expect(swiper.autoplay, isTrue);
    expect(swiper.controller, isNull);
    expect(swiper.children, hasLength(6));

    await scrollTo(tester, find.text('分式（fraction）'));
    swiper = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) =>
            candidate.pagination == TSwiperPaginationVariant.fraction,
      ),
    );
    expect(swiper.controller, isNull);
    expect(swiper.children, hasLength(6));
    expect(swiper.paginationAlignment, Alignment.bottomRight);

    await scrollTo(tester, find.text('切换按钮（controls）'));
    swiper = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) =>
            candidate.pagination == TSwiperPaginationVariant.controls,
      ),
    );
    expect(swiper.children, hasLength(6));
    expect(swiper.loop, isFalse);
    expect(swiper.controller, isNull);

    await scrollTo(tester, find.text('卡片式（cards）'));
    await scrollTo(tester, find.text('02 组件样式'));
    expect(find.text('垂直模式'), findsOneWidget);
    expect(find.text('外置分页'), findsNothing);
    expect(find.text('自定义标记'), findsNothing);
    expect(find.text('外部控制'), findsNothing);
  });

  testWidgets('横向拖拽和 controls 点击驱动真实页面状态', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    final dots = swiperWhere(
      (candidate) =>
          candidate.pagination == TSwiperPaginationVariant.dots &&
          !candidate.autoplay,
    );
    await tester.fling(
      find.descendant(of: dots, matching: find.byType(PageView)),
      const Offset(-400, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<Semantics>(
            find.descendant(of: dots, matching: find.bySemanticsLabel('2 / 6')),
          )
          .properties
          .selected,
      isTrue,
    );

    await scrollTo(tester, find.text('切换按钮（controls）'));
    final controls = swiperWhere(
      (candidate) => candidate.pagination == TSwiperPaginationVariant.controls,
    );
    final pageView = tester.widget<PageView>(
      find.descendant(of: controls, matching: find.byType(PageView)),
    );
    expect(pageView.controller?.page, 0);
    final buttons = tester.widgetList<IconButton>(
      find.descendant(of: controls, matching: find.byType(IconButton)),
    );
    expect(buttons.first.onPressed, isNull);
    expect(buttons.last.onPressed, isNotNull);
    await tester.tap(
      find.descendant(of: controls, matching: find.byType(IconButton)).last,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(pageView.controller?.page, 1);
  });

  testWidgets('卡片双模式和垂直参数面板使用受控交互', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await scrollTo(tester, find.text('卡片式（cards）'));
    final cardSwipers = tester
        .widgetList<TSwiper>(find.byType(TSwiper))
        .where((swiper) => swiper.viewportFraction == 0.82);
    expect(cardSwipers, hasLength(2));
    expect(
      cardSwipers.map((swiper) => swiper.pageEffect),
      containsAll([TSwiperPageEffect.cardMargin, TSwiperPageEffect.scale]),
    );

    await scrollTo(tester, find.text('自动播放间隔时间（单位毫秒）'));
    var vertical = tester.widget<TSwiper>(
      swiperWhere((candidate) => candidate.scrollDirection == Axis.vertical),
    );
    expect(vertical.autoplay, isTrue);
    expect(vertical.autoplayInterval, const Duration(seconds: 5));
    expect(vertical.animationDuration, const Duration(milliseconds: 500));

    await tester.tap(find.byType(TSwitch));
    await tester.pump();
    vertical = tester.widget<TSwiper>(
      swiperWhere((candidate) => candidate.scrollDirection == Axis.vertical),
    );
    expect(vertical.autoplay, isFalse);
    expect(find.text('关'), findsOneWidget);

    final sliders = tester.widgetList<TSlider>(find.byType(TSlider)).toList();
    sliders.first.onChanged!(1000);
    sliders.last.onChanged!(1200);
    await tester.pump();
    vertical = tester.widget<TSwiper>(
      swiperWhere((candidate) => candidate.scrollDirection == Axis.vertical),
    );
    expect(vertical.autoplayInterval, const Duration(seconds: 1));
    expect(vertical.animationDuration, const Duration(milliseconds: 1200));
  });
}
