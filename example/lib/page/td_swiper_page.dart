import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDSwiperPage extends StatelessWidget {
  const TDSwiperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: '轮播图 Swiper',
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
                margin: const EdgeInsets.only(left: 16,right: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge)),
                child: const Center(
                  child: TDText("TODO"),
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
            desc: '右边',
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
          desc: '圆角矩形指示器（默认100ms动画）',
          builder: (_) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Swiper(
                autoplay: true,
                itemCount: 6,
                loop: true,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: TDSwiperPagination.dotsBar),
                itemBuilder: (BuildContext context, int index) {
                  return FlutterLogo(
                    size: MediaQuery.of(context).size.width,
                  );
                },
              ),
            );
          }),
      ExampleItem(
          desc: '数字指示器',
          builder: (_) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Swiper(
                autoplay: true,
                itemCount: 6,
                loop: true,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: TDSwiperPagination.fraction),
                itemBuilder: (BuildContext context, int index) {
                  return FlutterLogo(
                    size: MediaQuery.of(context).size.width,
                  );
                },
              ),
            );
          }),
      ExampleItem(
          desc: '数字指示器指定位置',
          builder: (_) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Swiper(
                autoplay: true,
                itemCount: 6,
                loop: true,
                pagination: const SwiperPagination(
                    alignment: Alignment.topRight,
                    builder: TDSwiperPagination.fraction),
                itemBuilder: (BuildContext context, int index) {
                  return FlutterLogo(
                    size: MediaQuery.of(context).size.width,
                  );
                },
              ),
            );
          }),
      ExampleItem(
          desc: '箭头指示器',
          builder: (_) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Swiper(
                autoplay: true,
                itemCount: 6,
                loop: true,
                pagination: const SwiperPagination(
                    alignment: Alignment.center,
                    builder: TDSwiperPagination.controls),
                itemBuilder: (BuildContext context, int index) {
                  return FlutterLogo(
                    size: MediaQuery.of(context).size.width,
                  );
                },
              ),
            );
          }),
      ExampleItem(
          desc: '箭头指示器非循环，边界箭头隐藏',
          builder: (_) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10)),
              child: Swiper(
                autoplay: true,
                itemCount: 6,
                loop: false,
                pagination: const SwiperPagination(
                    alignment: Alignment.center,
                    builder: TDSwiperPagination.controls),
                itemBuilder: (BuildContext context, int index) {
                  return FlutterLogo(
                    size: MediaQuery.of(context).size.width,
                  );
                },
              ),
            );
          }),],);
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
      autoplay: true,
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
  Widget _buildOuterDotsSwiper(BuildContext context) {
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
  Widget _buildRightDotsSwiper(BuildContext context) {
    return Swiper(
      autoplay: true,
      itemCount: 6,
      loop: true,
      pagination: const SwiperPagination(
          alignment: Alignment.centerRight,
          builder: TDSwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return const TDImage(assetUrl: 'assets/img/image.png',);
      },
    );
  }
}
