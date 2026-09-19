part of 'slider_page.dart';

extension _SliderVerticalModule on _TSliderPageState {
  ExampleModule get _sliderVerticalModule => ExampleModule(
    title: '垂直状态',
    children: [ExampleItem(builder: _buildVertical)],
  );
}
