import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/swiper/swiper_page.dart';
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

  testWidgets('公开 Demo 使用设计稿分组、同源图片和准确初始配置', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    await tester.pump();

    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('点状（dots）'), findsOneWidget);
    var swiper = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) =>
            candidate.pagination == TSwiperPaginationVariant.dots &&
            !candidate.autoplay &&
            candidate.paginationPlacement == null,
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
    expect(find.text('指示器位置'), findsOneWidget);
    await scrollTo(tester, find.text('03 组件动效'));
    expect(find.text('03 组件动效'), findsOneWidget);
    expect(find.text('调整动效参数'), findsOneWidget);
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
          !candidate.autoplay &&
          candidate.paginationPlacement == null,
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

  testWidgets('卡片三模式、指示器位置和动效参数使用受控交互', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await scrollTo(tester, find.text('卡片式（cards）'));
    final cardSwipers = tester
        .widgetList<TSwiper>(find.byType(TSwiper))
        .where((swiper) => (swiper.viewportFraction - 295 / 375).abs() < 0.001);
    expect(cardSwipers, hasLength(3));
    expect(cardSwipers.every((swiper) => swiper.children?.length == 6), isTrue);
    expect(
      cardSwipers.map((swiper) => swiper.pageEffect),
      containsAll([
        TSwiperPageEffect.cardMargin,
        TSwiperPageEffect.scale,
        TSwiperPageEffect.scaleAndFade,
      ]),
    );

    await scrollTo(tester, find.text('指示器位置'));
    final placementSwipers = tester
        .widgetList<TSwiper>(find.byType(TSwiper))
        .where((swiper) => swiper.paginationPlacement != null)
        .toList();
    expect(placementSwipers, hasLength(3));
    expect(
      placementSwipers.map((swiper) => swiper.paginationPlacement),
      orderedEquals([
        TSwiperPaginationPlacement.overlay,
        TSwiperPaginationPlacement.overlay,
        TSwiperPaginationPlacement.outside,
      ]),
    );

    await scrollTo(tester, find.text('自动播放间隔时间（单位毫秒）'));
    var motion = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) =>
            candidate.autoplay &&
            candidate.pagination == TSwiperPaginationVariant.dots,
      ),
    );
    expect(motion.autoplay, isTrue);
    expect(motion.autoplayInterval, const Duration(seconds: 4));
    expect(motion.animationDuration, const Duration(milliseconds: 500));

    await tester.tap(find.byType(TSwitch));
    await tester.pump();
    motion = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) =>
            !candidate.autoplay &&
            candidate.animationDuration == const Duration(milliseconds: 500),
      ).last,
    );
    expect(motion.autoplay, isFalse);
    expect(find.text('关'), findsOneWidget);

    final sliders = tester.widgetList<TSlider>(find.byType(TSlider)).toList();
    sliders.first.onChanged!(1000);
    sliders.last.onChanged!(1200);
    await tester.pump();
    motion = tester.widget<TSwiper>(
      swiperWhere(
        (candidate) => candidate.autoplayInterval == const Duration(seconds: 1),
      ),
    );
    expect(motion.autoplayInterval, const Duration(seconds: 1));
    expect(motion.animationDuration, const Duration(milliseconds: 1200));
  });
}
