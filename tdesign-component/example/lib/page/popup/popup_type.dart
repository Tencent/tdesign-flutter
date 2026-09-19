part of 'popup_page.dart';

extension _PopupTypeModule on TPopupPage {
  ExampleModule get _popupTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        key: const ValueKey('popup-base-examples'),
        desc: '基础弹出层',
        builder: _buildBasePopups,
      ),
    ],
  );
}
