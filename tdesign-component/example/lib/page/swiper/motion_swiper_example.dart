import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'swiper')
class MotionSwiperExample extends StatefulWidget {
  const MotionSwiperExample({super.key});

  @override
  State<MotionSwiperExample> createState() => _MotionSwiperExampleState();
}

class _MotionSwiperExampleState extends State<MotionSwiperExample> {
  bool _autoplay = true;
  double _interval = 4000;
  double _duration = 500;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 192,
          child: TSwiper(
            loop: true,
            autoplay: _autoplay,
            autoplayInterval: Duration(milliseconds: _interval.round()),
            animationDuration: Duration(milliseconds: _duration.round()),
            pagination: TSwiperPaginationVariant.dots,
            children: List.generate(
              6,
              (index) => Image.asset(
                index.isEven
                    ? 'assets/img/swiper1.png'
                    : 'assets/img/swiper2.png',
                fit: BoxFit.cover,
                semanticLabel: '图片 ${index + 1}',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TText('自动播放'),
            Row(
              children: [
                TSwitch(
                  value: _autoplay,
                  onChanged: (value) => setState(() => _autoplay = value),
                ),
                const SizedBox(width: 8),
                TText(_autoplay ? '开' : '关'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: TText('自动播放间隔时间（单位毫秒）'),
        ),
        TSlider(
          value: _interval,
          min: 1000,
          max: 5000,
          divisions: 8,
          showThumbValue: true,
          thumbFormatter: (value) => value.round().toString(),
          onChanged: (value) => setState(() => _interval = value),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: TText('动画持续时间（单位毫秒）'),
        ),
        TSlider(
          value: _duration,
          min: 200,
          max: 2000,
          divisions: 18,
          showThumbValue: true,
          thumbFormatter: (value) => value.round().toString(),
          onChanged: (value) => setState(() => _duration = value),
        ),
      ],
    );
  }
}
