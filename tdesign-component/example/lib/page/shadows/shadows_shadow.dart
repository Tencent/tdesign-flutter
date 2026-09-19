part of 'shadows_page.dart';

extension _ShadowsShadowModule on TShadowsPage {
  ExampleModule get _shadowsShadowModule => ExampleModule(
    title: '投影',
    children: [
      ExampleItem(desc: '基础投影', builder: _buildShadowsBase),
      ExampleItem(desc: '中层投影', builder: _buildShadowsMiddle),
      ExampleItem(desc: '上层投影', builder: _buildShadowsTop),
    ],
  );
}
