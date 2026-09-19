part of 'tag_page.dart';

extension _TagSelectableModule on _TTagPageState {
  ExampleModule get _tagSelectableModule => ExampleModule(
    title: '可选标签',
    children: [
      ExampleItem(desc: '默认形态', builder: _buildSelectDefault),
      ExampleItem(
        desc: '描边形态',
        methodName: 'TagSelectOutlineExample',
        builder: (_) => const TagSelectOutlineExample(),
      ),
      ExampleItem(desc: '不同语义色', builder: _buildSelectColorSchemes),
      ExampleItem(desc: '禁用状态', builder: _buildSelectDisabled),
    ],
  );
}
