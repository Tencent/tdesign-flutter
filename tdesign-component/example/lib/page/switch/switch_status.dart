part of 'switch_page.dart';

extension _SwitchStatusModule on TSwitchPage {
  ExampleModule get _switchStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        key: const Key('switch-demo-status'),
        builder: _buildStatus,
        center: false,
      ),
    ],
  );
}
