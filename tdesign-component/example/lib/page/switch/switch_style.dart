part of 'switch_page.dart';

extension _SwitchStyleModule on TSwitchPage {
  ExampleModule get _switchStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        key: const Key('switch-demo-sizes'),
        desc: '开关尺寸',
        builder: _buildSizes,
        center: false,
      ),
    ],
  );
}
