part of 'action_sheet_page.dart';

extension _ActionSheetStyleModule on TActionSheetPage {
  ExampleModule get _actionSheetStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '列表型对齐方式',
        builder: _centerList,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      ExampleItem(
        builder: _leftList,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      ),
    ],
  );
}
