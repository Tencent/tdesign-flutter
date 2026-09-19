part of 'indexes_page.dart';

extension _IndexesStyleModule on TIndexesPage {
  ExampleModule get _indexesStyleModule => const ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '其他索引列表样式',
        padding: EdgeInsets.symmetric(horizontal: 16),
        builder: _buildCapsuleIndexes,
      ),
    ],
  );
}
