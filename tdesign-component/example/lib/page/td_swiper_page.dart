import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDSwiperPage extends StatelessWidget {
  const TDSwiperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      exampleCodeGroup: 'swiper',
      children: [
      ExampleModule(title: '组件类型',
      children: [
        ExampleItem(
            desc: '点状(dots)',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildDotsSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '点条状(dots-bar)',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildDotsBarSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '分式(fraction)',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildFractionSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '切换按钮(controls)',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildControlsSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '卡片式(cards)',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildCardsSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '卡片式(cards)-scale:0.8',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildScaleCardsSwiper,
                ),
              );
            }),
      ],
    ),
      ExampleModule(title: '组件样式', children: [
        ExampleItem(
            desc: '内部',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildDotsSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '外部',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildOuterDotsSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '右边(竖向)',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildRightDotsSwiper,
                ),
              );
            }),
      ])
      ],

      test: [

        ExampleItem(
            desc: '卡片式(cards),只有两张不轮播',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildNotLoopCardsSwiper,
                ),
              );
            }),
        ExampleItem(
          // outer样式不支持竖向布局
            desc: '点条状outer样式',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildOuterDotsBarSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '分式符位置',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildFractionBarSwiper,
                ),
              );
            }),
        ExampleItem(
            desc: '竖向点条状',
            ignoreCode: true,
            builder: (_) {
              return Container(
                height: 193,
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: CodeWrapper(
                  builder: _buildVerticalDotsBarSwiper,
                ),
              );
            }),
      ],
    );
  }

  @Demo(group: 'swiper')
  Widget _buildDotsSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: TDSwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildDotsBarSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: TDSwiperPagination.dotsBar),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildFractionSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: TDSwiperPagination.fraction),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildControlsSwiper(BuildContext context) {
    return Swiper(
      // autoplay: true,
      itemCount: 6,
      loop: true,
      pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: TDSwiperPagination.controls),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildCardsSwiper(BuildContext context) {
    return Swiper(
      viewportFraction: 0.75,
      outer: true,
      autoplay: true,
      itemCount: 6,
      loop: true,
      transformer: TDPageTransformer.margin(),
      pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: TDSwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildScaleCardsSwiper(BuildContext context) {
    return Swiper(
      viewportFraction: 0.75,
      outer: true,
      autoplay: true,
      itemCount: 6,
      loop: true,
      transformer: TDPageTransformer.scaleAndFade(),
      pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: TDSwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildOuterDotsSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      outer: true,
      pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: TDSwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildRightDotsSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      scrollDirection: Axis.vertical,
      pagination: const SwiperPagination(
          alignment: Alignment.centerRight,
          builder: TDSwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildNotLoopCardsSwiper(BuildContext context) {
    return Swiper(
      viewportFraction: 0.75,
      scale: 0.8,
      outer: true,
      autoplay: true,
      itemCount: 2,
      loop: false,
      pagination: const SwiperPagination(
          alignment: Alignment.center,
          builder: TDSwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildOuterDotsBarSwiper(BuildContext context) {
    return Swiper(
      outer: true,
      autoplay: true,
      itemCount: 6,
      loop: true,
      pagination: const SwiperPagination(
          alignment: Alignment.topLeft,
          builder: TDSwiperPagination.dotsBar),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildFractionBarSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      pagination: const SwiperPagination(
          alignment: Alignment.bottomRight,
          builder: TDSwiperPagination.fraction),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }

  @Demo(group: 'swiper')
  Widget _buildVerticalDotsBarSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      scrollDirection:Axis.vertical,
      pagination: const SwiperPagination(
          alignment: Alignment.bottomRight,
          builder: TDSwiperPagination.dotsBar),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }
}

