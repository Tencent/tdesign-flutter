part of 'action_sheet_page.dart';

extension _ActionSheetStatusModule on TActionSheetPage {
  ExampleModule get _actionSheetStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        desc: '列表型选项状态',
        builder: _statusIconList,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ],
  );
}
