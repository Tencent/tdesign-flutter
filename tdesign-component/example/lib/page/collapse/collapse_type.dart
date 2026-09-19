part of 'collapse_page.dart';

extension _CollapseTypeModule on TCollapsePageState {
  ExampleModule get _collapseTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础折叠面板', builder: _buildBasicCollapse),
      ExampleItem(desc: '带操作说明', builder: _buildCollapseWithOperationText),
      ExampleItem(
        desc: '手风琴式',
        builder: _buildAccordionCollapse,
        center: false,
      ),
    ],
  );
}
