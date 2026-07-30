import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TSwiperPage extends StatelessWidget {
  const TSwiperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'swiper',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            _item('点状', _buildDotsSwiper),
            _item('点条状', _buildDotsBarSwiper),
            _item('分式', _buildFractionSwiper),
            _item('切换按钮', _buildControlsSwiper),
            _item('外置分页', _buildOutsidePaginationSwiper),
            _item('自定义标记', _buildCustomMarkersSwiper),
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
        ExampleModule(
          title: '交互能力',
          children: [
            _item('自动播放', _buildAutoplaySwiper),
            _item('外部控制', _buildControllerSwiper),
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

  Widget _buildSwiper(
    BuildContext context, {
    TSwiperPaginationVariant pagination = TSwiperPaginationVariant.dots,
    TSwiperPageEffect pageEffect = TSwiperPageEffect.none,
    Axis scrollDirection = Axis.horizontal,
    bool autoplay = false,
    double viewportFraction = 1,
    TSwiperPaginationPlacement paginationPlacement =
        TSwiperPaginationPlacement.overlay,
    TSwiperPaginationItemBuilder? paginationItemBuilder,
    Widget? previousIcon,
    Widget? nextIcon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
      child: TSwiper(
        loop: true,
        autoplay: autoplay,
        pagination: pagination,
        paginationPlacement: paginationPlacement,
        paginationItemBuilder: paginationItemBuilder,
        previousIcon: previousIcon,
        nextIcon: nextIcon,
        pageEffect: pageEffect,
        viewportFraction: viewportFraction,
        scrollDirection: scrollDirection,
        children: const [
          _SwiperImage(0, 'assets/img/image.png'),
          _SwiperImage(1, 'assets/img/t_avatar_1.png'),
          _SwiperImage(2, 'assets/img/t_avatar_2.png'),
        ],
      ),
    );
  }

  @ExampleCode(group: 'swiper')
  Widget _buildDotsSwiper(BuildContext context) => _buildSwiper(context);

  @ExampleCode(group: 'swiper')
  Widget _buildDotsBarSwiper(BuildContext context) => _buildSwiper(
        context,
        pagination: TSwiperPaginationVariant.dotsBar,
      );

  @ExampleCode(group: 'swiper')
  Widget _buildFractionSwiper(BuildContext context) => _buildSwiper(
        context,
        pagination: TSwiperPaginationVariant.fraction,
      );

  @ExampleCode(group: 'swiper')
  Widget _buildControlsSwiper(BuildContext context) => _buildSwiper(
        context,
        pagination: TSwiperPaginationVariant.controls,
        previousIcon: const Icon(Icons.arrow_back_rounded),
        nextIcon: const Icon(Icons.arrow_forward_rounded),
      );

  @ExampleCode(group: 'swiper')
  Widget _buildOutsidePaginationSwiper(BuildContext context) => _buildSwiper(
        context,
        paginationPlacement: TSwiperPaginationPlacement.outside,
      );

  @ExampleCode(group: 'swiper')
  Widget _buildCustomMarkersSwiper(BuildContext context) => _buildSwiper(
        context,
        pagination: TSwiperPaginationVariant.dots,
        paginationItemBuilder: (context, details) => AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: details.isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: details.isActive
                ? context.tTheme.brandNormalColor
                : context.tTheme.bgColorComponentHover,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );

  @ExampleCode(group: 'swiper')
  Widget _buildCardsSwiper(BuildContext context) => _buildSwiper(
        context,
        pageEffect: TSwiperPageEffect.cardMargin,
        viewportFraction: 0.86,
      );

  @ExampleCode(group: 'swiper')
  Widget _buildScaleCardsSwiper(BuildContext context) => _buildSwiper(
        context,
        pageEffect: TSwiperPageEffect.scaleAndFade,
        viewportFraction: 0.86,
      );

  @ExampleCode(group: 'swiper')
  Widget _buildVerticalSwiper(BuildContext context) => _buildSwiper(
        context,
        pagination: TSwiperPaginationVariant.controls,
        scrollDirection: Axis.vertical,
      );

  @ExampleCode(group: 'swiper')
  Widget _buildAutoplaySwiper(BuildContext context) => _buildSwiper(
        context,
        autoplay: true,
      );

  @ExampleCode(group: 'swiper')
  Widget _buildControllerSwiper(BuildContext context) =>
      const _ControlledSwiperExample();
}

class _SwiperImage extends StatelessWidget {
  const _SwiperImage(this.index, this.asset);

  final int index;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(asset, fit: BoxFit.cover),
        Positioned(
          top: 12,
          left: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.tTheme.textColorPrimary.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                'index: $index',
                style: TextStyle(color: context.tTheme.textColorAnti),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlledSwiperExample extends StatefulWidget {
  const _ControlledSwiperExample();

  @override
  State<_ControlledSwiperExample> createState() =>
      _ControlledSwiperExampleState();
}

class _ControlledSwiperExampleState extends State<_ControlledSwiperExample> {
  final _controller = TSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
            child: TSwiper(
              controller: _controller,
              loop: true,
              children: const [
                _SwiperImage(0, 'assets/img/image.png'),
                _SwiperImage(1, 'assets/img/t_avatar_1.png'),
                _SwiperImage(2, 'assets/img/t_avatar_2.png'),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: _controller.next,
          child: const Text('下一页'),
        ),
      ],
    );
  }
}
