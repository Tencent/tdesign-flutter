part of 'rate_page.dart';

extension _RateSpecialModule on TRatePage {
  ExampleModule get _rateSpecialModule => ExampleModule(
    title: '特殊样式',
    children: [
      ExampleItem(desc: '竖向带描述评分', builder: _buildVertical, center: false),
    ],
  );
}
