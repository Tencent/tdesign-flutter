import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'cards_swiper_example.dart';
import 'controls_swiper_example.dart';
import 'dots_bar_swiper_example.dart';
import 'dots_swiper_example.dart';
import 'fraction_swiper_example.dart';
import 'vertical_swiper_example.dart';

@ExampleCodeManifest()
class TSwiperPage extends StatefulWidget {
  const TSwiperPage({super.key});

  @override
  State<TSwiperPage> createState() => _TSwiperPageState();
}

class _TSwiperPageState extends State<TSwiperPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于循环轮播一组图片或内容，也可以滑动进行切换，轮播动效时间可以设置。',
      exampleCodeGroup: 'swiper',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '点状（dots）',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'DotsSwiperExample',
              builder: (_) => const DotsSwiperExample(),
            ),
            ExampleItem(
              desc: '点条状（dots-bar）',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'DotsBarSwiperExample',
              builder: (_) => const DotsBarSwiperExample(),
            ),
            ExampleItem(
              desc: '分式（fraction）',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'FractionSwiperExample',
              builder: (_) => const FractionSwiperExample(),
            ),
            ExampleItem(
              desc: '切换按钮（controls）',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'ControlsSwiperExample',
              builder: (_) => const ControlsSwiperExample(),
            ),
            ExampleItem(
              desc: '卡片式（cards）',
              padding: EdgeInsets.zero,
              methodName: 'CardsSwiperExample',
              builder: (_) => const CardsSwiperExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '垂直模式',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'VerticalSwiperExample',
              builder: (_) => const VerticalSwiperExample(),
            ),
          ],
        ),
      ],
    );
  }
}
