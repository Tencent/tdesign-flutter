part of 'slider_page.dart';

extension _SliderStatusModule on _TSliderPageState {
  ExampleModule get _sliderStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(desc: '滑块禁用状态', builder: _buildDisabled)],
  );
}
