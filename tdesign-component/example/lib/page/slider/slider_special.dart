part of 'slider_page.dart';

extension _SliderSpecialModule on _TSliderPageState {
  ExampleModule get _sliderSpecialModule => ExampleModule(
    title: '特殊样式',
    children: [ExampleItem(desc: '胶囊型滑块', builder: _buildCapsule)],
  );
}
