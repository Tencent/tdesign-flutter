part of 'rate_page.dart';

extension _RateTypeModule on TRatePage {
  ExampleModule get _rateTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '实心评分', builder: _buildBasic, center: false),
      ExampleItem(desc: '自定义评分', builder: _buildCustom, center: false),
      ExampleItem(
        desc: '第三方图标评分',
        builder: _buildThirdPartyIcon,
        center: false,
      ),
      ExampleItem(desc: '自定义评分数量', builder: _buildCount, center: false),
      ExampleItem(desc: '带描述评分', builder: _buildShowText, center: false),
    ],
  );
}
