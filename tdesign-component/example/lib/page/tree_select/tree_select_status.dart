part of 'tree_select_page.dart';

extension _TreeSelectStatusModule on TTreeSelectPage {
  ExampleModule get _treeSelectStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        desc: '树形选择器-三列',
        methodName: 'TreeSelectThreeColumnsExample',
        builder: (_) => const TreeSelectThreeColumnsExample(),
      ),
    ],
  );
}
