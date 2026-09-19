part of 'cell_page.dart';

extension _CellTypeModule on TCellPage {
  ExampleModule get _cellTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        key: const Key('cell-demo-single-line'),
        desc: '单行单元格',
        builder: _buildSingleLine,
        center: false,
      ),
      ExampleItem(
        key: const Key('cell-demo-multiple-line'),
        desc: '多行单元格',
        builder: _buildMultipleLine,
        center: false,
      ),
    ],
  );
}
