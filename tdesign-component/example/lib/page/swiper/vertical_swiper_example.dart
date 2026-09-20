import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'swiper')
class VerticalSwiperExample extends StatefulWidget {
  const VerticalSwiperExample({super.key});

  @override
  State<VerticalSwiperExample> createState() => _VerticalSwiperExampleState();
}

class _VerticalSwiperExampleState extends State<VerticalSwiperExample> {
  Widget _buildVerticalSwiper(BuildContext context) {
    // 页面 State 持有并更新以下字段：
    // final _verticalController = TSwiperController();
    // bool _verticalAutoplay = true;
    // double _verticalInterval = 5000;
    // double _verticalAnimationDuration = 500;
    // 并在 State.dispose 中调用 _verticalController.dispose()。
    return Column(
      children: [
        SizedBox(
          height: 192,
          child: TSwiper(
            controller: _verticalController,
            loop: true,
            autoplay: _verticalAutoplay,
            autoplayInterval: Duration(milliseconds: _verticalInterval.round()),
            animationDuration: Duration(
              milliseconds: _verticalAnimationDuration.round(),
            ),
            pagination: TSwiperPaginationVariant.dotsBar,
            scrollDirection: Axis.vertical,
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
                  value: _verticalAutoplay,
                  onChanged: (value) {
                    setState(() => _verticalAutoplay = value);
                  },
                ),
                const SizedBox(width: 8),
                TText(_verticalAutoplay ? '开' : '关'),
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
          value: _verticalInterval,
          min: 1000,
          max: 5000,
          divisions: 8,
          showThumbValue: true,
          thumbFormatter: (value) => value.round().toString(),
          onChanged: (value) => setState(() => _verticalInterval = value),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: TText('动画持续时间（单位毫秒）'),
        ),
        TSlider(
          value: _verticalAnimationDuration,
          min: 200,
          max: 2000,
          divisions: 18,
          showThumbValue: true,
          thumbFormatter: (value) => value.round().toString(),
          onChanged: (value) {
            setState(() => _verticalAnimationDuration = value);
          },
        ),
      ],
    );
  }

  final _verticalController = TSwiperController();

  bool _verticalAutoplay = true;

  double _verticalInterval = 5000;

  double _verticalAnimationDuration = 500;

  @override
  void dispose() {
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = (() {
      return _buildVerticalSwiper(context);
    })();
    return content;
  }
}
