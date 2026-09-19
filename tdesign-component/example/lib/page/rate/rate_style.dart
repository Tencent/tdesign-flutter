part of 'rate_page.dart';

extension _RateStyleModule on TRatePage {
  ExampleModule get _rateStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(desc: '评分大小', builder: _buildSize, center: false),
      ExampleItem(desc: '评分风格', builder: _buildColor, center: false),
    ],
  );
}
