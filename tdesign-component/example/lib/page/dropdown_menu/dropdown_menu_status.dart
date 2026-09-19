part of 'dropdown_menu_page.dart';

extension _DropdownMenuStatusModule on TDropdownMenuPage {
  ExampleModule get _dropdownMenuStatusModule => ExampleModule(
    title: '组件状态',
    children: [ExampleItem(desc: '禁用状态', builder: _disabled)],
  );
}
