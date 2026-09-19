part of 'tree_select_page.dart';

extension _TreeSelectTypeModule on TTreeSelectPage {
  ExampleModule get _treeSelectTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '基础树形选择器',
        methodName: 'TreeSelectSingleExample',
        builder: (_) => const TreeSelectSingleExample(),
      ),
      ExampleItem(
        desc: '多选树形选择器',
        methodName: 'TreeSelectMultipleExample',
        builder: (_) => const TreeSelectMultipleExample(),
      ),
    ],
  );
}
