part of 'cascader_page.dart';

extension _CascaderAdvancedModule on _TCascaderPageState {
  ExampleModule get _cascaderAdvancedModule => ExampleModule(
    title: '进阶',
    children: [
      ExampleItem(desc: '带初始值', builder: _buildInitial, methodName: '_cell'),
      ExampleItem(desc: '自定义 keys', builder: _buildKeys, methodName: '_cell'),
      ExampleItem(desc: '使用次级标题', builder: _buildSubtitle, methodName: '_cell'),
      ExampleItem(desc: '选择任意一项', builder: _buildAny, methodName: '_cell'),
      ExampleItem(desc: '支持搜索', builder: _buildSearch, methodName: '_cell'),
    ],
  );
}
