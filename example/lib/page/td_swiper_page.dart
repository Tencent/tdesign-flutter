import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';

class TDSwiperPage extends StatelessWidget {
  const TDSwiperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: '轮播图 Swiper',
      children: [
      ExampleModule(title: '默认',
      children: [
        ExampleItem(
            desc: '圆点指示器',
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
                      builder: TDSwiperPagination.dots),
                  itemBuilder: (BuildContext context, int index) {
                    return FlutterLogo(
                      size: MediaQuery.of(context).size.width,
                    );
                  },
                ),
              );
            }),
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
                      builder: TDSwiperPagination.roundedRectangle),
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
                      builder: TDSwiperPagination.arrow),
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
                      builder: TDSwiperPagination.arrow),
                  itemBuilder: (BuildContext context, int index) {
                    return FlutterLogo(
                      size: MediaQuery.of(context).size.width,
                    );
                  },
                ),
              );
            }),
      ],
    )]);
  }
}
