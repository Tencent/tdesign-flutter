part of 'icon_page.dart';

extension _IconThemeModule on _TIconPageState {
  ExampleModule get _iconThemeModule => ExampleModule(
    title: '主题与图标',
    children: [
      ExampleItem(desc: 'TIcon 基础用法:', builder: _buildBasicTIcon),
      ExampleItem(desc: '指定 size 和 color:', builder: _buildSizedTIcon),
      ExampleItem(desc: 'TIcon.fromName 通过名称:', builder: _buildFromName),
      ExampleItem(desc: 'Theme 默认 size/color:', builder: _buildThemeDemo),
      ExampleItem(desc: '构造器优先级覆盖 Theme:', builder: _buildPriorityDemo),
    ],
  );
}
