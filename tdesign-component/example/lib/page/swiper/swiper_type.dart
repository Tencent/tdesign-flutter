part of 'swiper_page.dart';

extension _SwiperTypeModule on _TSwiperPageState {
  ExampleModule get _swiperTypeModule => ExampleModule(
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
  );
}
