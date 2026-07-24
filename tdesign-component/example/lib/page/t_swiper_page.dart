import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TSwiperPage extends StatefulWidget {
  const TSwiperPage({super.key});

  @override
  State<TSwiperPage> createState() => _TSwiperPageState();
}

class _TSwiperPageState extends State<TSwiperPage> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'swiper',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            _item('点状', _buildDotsSwiper),
            _item('点条状', _buildDotsBarSwiper),
            _item('分式', _buildFractionSwiper),
            _item('切换按钮', _buildControlsSwiper),
          ],
        ),
        ExampleModule(
          title: '页面效果',
          children: [
            _item('卡片间距', _buildCardsSwiper),
            _item('缩放与淡化', _buildScaleCardsSwiper),
            _item('竖向轮播', _buildVerticalSwiper),
          ],
        ),
      ],
    );
  }

  ExampleItem _item(String description, WidgetBuilder builder) {
    return ExampleItem(
      desc: description,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      builder: (context) => SizedBox(
        height: 200,
        child: CodeWrapper(builder: builder),
      ),
    );
  }

  Widget _buildSwiper({
    TSwiperPaginationVariant pagination = TSwiperPaginationVariant.dots,
    TSwiperPageEffect pageEffect = TSwiperPageEffect.none,
    Axis scrollDirection = Axis.horizontal,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
      child: TSwiper(
        value: _value,
        onChanged: (value) => setState(() => _value = value),
        loop: true,
        pagination: pagination,
        pageEffect: pageEffect,
        scrollDirection: scrollDirection,
        paginationAlignment: scrollDirection == Axis.horizontal
            ? Alignment.bottomCenter
            : Alignment.centerRight,
        children: const [
          _SwiperImage('assets/img/image.png'),
          _SwiperImage('assets/img/t_avatar_1.png'),
          _SwiperImage('assets/img/t_avatar_2.png'),
        ],
      ),
    );
  }

  @Demo(group: 'swiper')
  Widget _buildDotsSwiper(BuildContext context) => _buildSwiper();

  @Demo(group: 'swiper')
  Widget _buildDotsBarSwiper(BuildContext context) => _buildSwiper(
        pagination: TSwiperPaginationVariant.dotsBar,
      );

  @Demo(group: 'swiper')
  Widget _buildFractionSwiper(BuildContext context) => _buildSwiper(
        pagination: TSwiperPaginationVariant.fraction,
      );

  @Demo(group: 'swiper')
  Widget _buildControlsSwiper(BuildContext context) => _buildSwiper(
        pagination: TSwiperPaginationVariant.controls,
      );

  @Demo(group: 'swiper')
  Widget _buildCardsSwiper(BuildContext context) => _buildSwiper(
        pageEffect: TSwiperPageEffect.cardMargin,
      );

  @Demo(group: 'swiper')
  Widget _buildScaleCardsSwiper(BuildContext context) => _buildSwiper(
        pageEffect: TSwiperPageEffect.scaleAndFade,
      );

  @Demo(group: 'swiper')
  Widget _buildVerticalSwiper(BuildContext context) => _buildSwiper(
        pagination: TSwiperPaginationVariant.dotsBar,
        scrollDirection: Axis.vertical,
      );
}

class _SwiperImage extends StatelessWidget {
  const _SwiperImage(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(asset, fit: BoxFit.cover);
  }
}
