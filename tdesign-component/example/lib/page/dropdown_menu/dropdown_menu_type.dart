part of 'dropdown_menu_page.dart';

extension _DropdownMenuTypeModule on TDropdownMenuPage {
  ExampleModule get _dropdownMenuTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '单选下拉菜单', builder: _sorting),
      ExampleItem(desc: '分栏下拉菜单', builder: _multiple),
    ],
  );
}
