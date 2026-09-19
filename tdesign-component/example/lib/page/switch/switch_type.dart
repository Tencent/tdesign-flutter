part of 'switch_page.dart';

extension _SwitchTypeModule on TSwitchPage {
  ExampleModule get _switchTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        key: const Key('switch-demo-basic'),
        desc: '基础开关',
        builder: _buildBasic,
        center: false,
      ),
      ExampleItem(
        key: const Key('switch-demo-label'),
        desc: '带描述开关',
        builder: _buildLabel,
        center: false,
      ),
      ExampleItem(
        key: const Key('switch-demo-color'),
        desc: '自定义颜色开关',
        builder: _buildColor,
        center: false,
      ),
    ],
  );
}
