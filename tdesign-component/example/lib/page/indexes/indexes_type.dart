part of 'indexes_page.dart';

extension _IndexesTypeModule on TIndexesPage {
  ExampleModule get _indexesTypeModule => const ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '索引类型',
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildLetterIndexes,
      ),
      ExampleItem(
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildNumberIndexes,
      ),
    ],
  );
}
