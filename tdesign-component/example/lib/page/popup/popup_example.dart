part of 'popup_page.dart';

extension _PopupExampleModule on TPopupPage {
  ExampleModule get _popupExampleModule => ExampleModule(
    title: '组件示例',
    children: [
      ExampleItem(
        key: const ValueKey('popup-application-examples'),
        desc: '应用示例',
        builder: _buildApplicationPopups,
      ),
    ],
  );
}
