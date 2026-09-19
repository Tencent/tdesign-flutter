part of 'radius_page.dart';

extension _RadiusValueModule on TRadiusPage {
  ExampleModule get _radiusValueModule => ExampleModule(
    title: '数值型',
    children: [
      ExampleItem(desc: '3px 极小组件圆角', builder: _buildRadiusSmall),
      ExampleItem(desc: '6px 组件圆角', builder: _buildRadiusDefault),
      ExampleItem(desc: '9px 卡片圆角', builder: _buildRadiusLarge),
      ExampleItem(desc: '12px 面板圆角', builder: _buildRadiusExtraLarge),
    ],
  );
}
