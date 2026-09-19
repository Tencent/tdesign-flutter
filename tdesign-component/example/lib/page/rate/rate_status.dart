part of 'rate_page.dart';

extension _RateStatusModule on TRatePage {
  ExampleModule get _rateStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(builder: _buildAction, center: false)],
  );
}
