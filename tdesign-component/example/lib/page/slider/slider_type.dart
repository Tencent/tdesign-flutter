part of 'slider_page.dart';

extension _SliderTypeModule on _TSliderPageState {
  ExampleModule get _sliderTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '单游标滑块', builder: _buildSingle),
      ExampleItem(desc: '双游标滑块', builder: _buildRange),
      ExampleItem(desc: '带数值滑动选择器', builder: _buildLabeled),
      ExampleItem(desc: '起始非零滑动选择器', builder: _buildNonZero),
      ExampleItem(desc: '带刻度滑动选择器', builder: _buildScale),
    ],
  );
}
