import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'swiper')
class ControlsSwiperExample extends StatelessWidget {
  const ControlsSwiperExample({super.key});

  Widget _buildControlsSwiper(BuildContext context) {
    return TSwiper(
      loop: false,
      autoplay: true,
      animationDuration: const Duration(milliseconds: 500),
      autoplayInterval: const Duration(seconds: 5),
      pagination: TSwiperPaginationVariant.controls,
      children: List.generate(
        6,
        (index) => Image.asset(
          index.isEven ? 'assets/img/swiper1.png' : 'assets/img/swiper2.png',
          fit: BoxFit.cover,
          semanticLabel: '图片 ${index + 1}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = (() {
      return _buildControlsSwiper(context);
    })();
    return SizedBox(height: 192, child: content);
  }
}
