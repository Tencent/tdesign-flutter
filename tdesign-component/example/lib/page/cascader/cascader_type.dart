part of 'cascader_page.dart';

extension _CascaderTypeModule on _TCascaderPageState {
  ExampleModule get _cascaderTypeModule => ExampleModule(
    title: '类型',
    children: [
      ExampleItem(builder: _buildBase, methodName: '_cell'),
      ExampleItem(desc: '选项卡风格', builder: _buildTab, methodName: '_cell'),
    ],
  );
}
