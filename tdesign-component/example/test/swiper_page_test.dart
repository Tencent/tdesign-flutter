import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_swiper_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
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
    for (var attempt = 0;
        attempt < 12 && target.evaluate().isEmpty;
        attempt++) {
      await tester.drag(
        find.byType(CustomScrollView),
        const Offset(0, -500),
      );
      await tester.pump();
    }
    expect(target, findsWidgets);
    await tester.ensureVisible(target.first);
    await tester.pump();
  }

  testWidgets('示例覆盖分页扩展、autoplay、真实卡片视口和竖向 controls', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await scrollTo(tester, find.text('外置分页'));
    expect(
      tester.widgetList<TSwiper>(find.byType(TSwiper)).any(
            (swiper) =>
                swiper.paginationPlacement ==
                TSwiperPaginationPlacement.outside,
          ),
      isTrue,
    );

    await scrollTo(tester, find.text('自定义标记'));
    expect(
      tester
          .widgetList<TSwiper>(find.byType(TSwiper))
          .any((swiper) => swiper.paginationItemBuilder != null),
      isTrue,
    );

    await scrollTo(tester, find.text('卡片间距'));
    expect(
      tester
          .widgetList<TSwiper>(find.byType(TSwiper))
          .any((swiper) => swiper.viewportFraction == 0.86),
      isTrue,
    );

    await scrollTo(tester, find.text('竖向轮播'));
    expect(
      tester.widgetList<TSwiper>(find.byType(TSwiper)).any(
            (swiper) =>
                swiper.scrollDirection == Axis.vertical &&
                swiper.pagination == TSwiperPaginationVariant.controls,
          ),
      isTrue,
    );

    await scrollTo(tester, find.text('自动播放'));
    expect(
      tester
          .widgetList<TSwiper>(find.byType(TSwiper))
          .any((swiper) => swiper.autoplay),
      isTrue,
    );
  });

  testWidgets('外部 Controller 示例真实切页且各 Swiper 状态独立', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();

    await scrollTo(tester, find.text('下一页'));

    final pageViews =
        tester.widgetList<PageView>(find.byType(PageView)).toList();
    final controllers = pageViews.map((view) => view.controller).toSet();
    expect(controllers, hasLength(pageViews.length));

    final controlledSwiper = tester
        .widgetList<TSwiper>(find.byType(TSwiper))
        .singleWhere((swiper) => swiper.controller != null);
    final controlledPageView = tester.widget<PageView>(
      find.descendant(
        of: find.byWidget(controlledSwiper),
        matching: find.byType(PageView),
      ),
    );
    final initialPage = controlledPageView.controller!.page!;

    await tester.tap(find.text('下一页'));
    await tester.pump();
    await tester.pump(kThemeAnimationDuration);
    expect(controlledPageView.controller!.page, initialPage + 1);
  });
}
