part of 'radius_page.dart';

extension _RadiusSpecialModule on TRadiusPage {
  ExampleModule get _radiusSpecialModule => ExampleModule(
    title: '特殊',
    children: [
      ExampleItem(desc: '胶囊型', builder: _buildRadiusRound),
      ExampleItem(desc: '圆型', builder: _buildRadiusCircle),
    ],
  );
}
