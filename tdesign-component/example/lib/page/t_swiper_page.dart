import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TSwiperPage extends StatefulWidget {
  const TSwiperPage({super.key});

  @override
  State<TSwiperPage> createState() => _TSwiperPageState();
}

class _TSwiperPageState extends State<TSwiperPage> {
  final _dotsBarController = TSwiperController(initialIndex: 1);
  final _fractionController = TSwiperController(initialIndex: 2);
  final _controlsController = TSwiperController(initialIndex: 3);
  final _verticalController = TSwiperController(initialIndex: 1);

  bool _verticalAutoplay = true;
  double _verticalInterval = 5000;
  double _verticalAnimationDuration = 500;

  @override
  void dispose() {
    _dotsBarController.dispose();
    _fractionController.dispose();
    _controlsController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

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
            _item('点状（dots）', _buildDotsSwiper),
            _item('点条状（dots-bar）', _buildDotsBarSwiper),
            _item('分式（fraction）', _buildFractionSwiper),
            _item('切换按钮（controls）', _buildControlsSwiper),
            _item(
              '卡片式（cards）',
              _buildCardsSwiper,
              height: 462,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [_item('垂直模式', _buildVerticalSwiper, height: null)],
        ),
      ],
    );
  }

  ExampleItem _item(
    String description,
    WidgetBuilder builder, {
    double? height = 192,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
  }) {
    return ExampleItem(
      desc: description,
      padding: padding,
      builder: (context) {
        final content = CodeWrapper(builder: builder);
        return height == null
            ? content
            : SizedBox(height: height, child: content);
      },
    );
  }

  @ExampleCode(group: 'swiper')
  Widget _buildDotsSwiper(BuildContext context) {
    return TSwiper(
      loop: true,
      autoplay: false,
      animationDuration: const Duration(milliseconds: 500),
      autoplayInterval: const Duration(seconds: 5),
      pagination: TSwiperPaginationVariant.dots,
      children: List.generate(
        5,
        (index) => Image.asset(
          index.isEven ? 'assets/img/swiper1.png' : 'assets/img/swiper2.png',
          fit: BoxFit.cover,
          semanticLabel: '图片 ${index + 1}',
        ),
      ),
    );
  }

  @ExampleCode(group: 'swiper')
  Widget _buildDotsBarSwiper(BuildContext context) {
    // 页面 State 持有：
    // final _dotsBarController = TSwiperController(initialIndex: 1);
    // 并在 State.dispose 中调用 _dotsBarController.dispose()。
    return TSwiper(
      controller: _dotsBarController,
      loop: true,
      autoplay: true,
      animationDuration: const Duration(milliseconds: 500),
      autoplayInterval: const Duration(seconds: 5),
      pagination: TSwiperPaginationVariant.dotsBar,
      children: List.generate(
        4,
        (index) => Image.asset(
          index.isEven ? 'assets/img/swiper1.png' : 'assets/img/swiper2.png',
          fit: BoxFit.cover,
          semanticLabel: '图片 ${index + 1}',
        ),
      ),
    );
  }

  @ExampleCode(group: 'swiper')
  Widget _buildFractionSwiper(BuildContext context) {
    // 页面 State 持有：
    // final _fractionController = TSwiperController(initialIndex: 2);
    // 并在 State.dispose 中调用 _fractionController.dispose()。
    return TSwiper(
      controller: _fractionController,
      loop: true,
      autoplay: true,
      animationDuration: const Duration(milliseconds: 500),
      autoplayInterval: const Duration(seconds: 5),
      pagination: TSwiperPaginationVariant.fraction,
      paginationAlignment: Alignment.bottomRight,
      children: List.generate(
        5,
        (index) => Image.asset(
          index.isEven ? 'assets/img/swiper1.png' : 'assets/img/swiper2.png',
          fit: BoxFit.cover,
          semanticLabel: '图片 ${index + 1}',
        ),
      ),
    );
  }

  @ExampleCode(group: 'swiper')
  Widget _buildControlsSwiper(BuildContext context) {
    // 页面 State 持有：
    // final _controlsController = TSwiperController(initialIndex: 3);
    // 并在 State.dispose 中调用 _controlsController.dispose()。
    return TSwiper(
      controller: _controlsController,
      loop: false,
      autoplay: true,
      animationDuration: const Duration(milliseconds: 500),
      autoplayInterval: const Duration(seconds: 5),
      pagination: TSwiperPaginationVariant.controls,
      children: List.generate(
        4,
        (index) => Image.asset(
          index.isEven ? 'assets/img/swiper1.png' : 'assets/img/swiper2.png',
          fit: BoxFit.cover,
          semanticLabel: '图片 ${index + 1}',
        ),
      ),
    );
  }

  @ExampleCode(group: 'swiper')
  Widget _buildCardsSwiper(BuildContext context) {
    final cardTheme = TSwiperThemeData(
      borderRadius: BorderRadius.zero,
      paginationMargin: const EdgeInsets.only(top: 12),
      activeColor: context.tTheme.brandNormalColor,
      inactiveColor: context.tTheme.bgColorComponent,
    );
    List<Widget> buildImages() => List.generate(5, (index) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
        child: Image.asset(
          index.isEven ? 'assets/img/swiper1.png' : 'assets/img/swiper2.png',
          fit: BoxFit.cover,
          semanticLabel: '图片 ${index + 1}',
        ),
      );
    });
    Widget buildCard(TSwiperPageEffect effect) {
      return SizedBox(
        height: 210,
        child: Theme(
          data: Theme.of(context).mergeExtension(cardTheme),
          child: TSwiper(
            loop: true,
            autoplay: false,
            pagination: TSwiperPaginationVariant.dots,
            paginationPlacement: TSwiperPaginationPlacement.outside,
            pageEffect: effect,
            viewportFraction: 0.82,
            children: buildImages(),
          ),
        ),
      );
    }

    return Column(
      children: [
        buildCard(TSwiperPageEffect.cardMargin),
        const SizedBox(height: 42),
        buildCard(TSwiperPageEffect.scale),
      ],
    );
  }

  @ExampleCode(group: 'swiper')
  Widget _buildVerticalSwiper(BuildContext context) {
    // 页面 State 持有并更新以下字段：
    // final _verticalController = TSwiperController(initialIndex: 1);
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
              4,
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
}
