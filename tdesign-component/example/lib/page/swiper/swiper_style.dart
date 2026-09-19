part of 'swiper_page.dart';

extension _SwiperStyleModule on _TSwiperPageState {
  ExampleModule get _swiperStyleModule => ExampleModule(
    title: '组件样式',
    children: [_item('垂直模式', _buildVerticalSwiper, height: null)],
  );
}
