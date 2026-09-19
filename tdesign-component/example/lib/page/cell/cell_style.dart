part of 'cell_page.dart';

extension _CellStyleModule on TCellPage {
  ExampleModule get _cellStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        key: const Key('cell-demo-card'),
        desc: '卡片单元格',
        builder: _buildCardGroup,
        center: false,
      ),
    ],
  );
}
