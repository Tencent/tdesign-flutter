part of 'icon_page.dart';

extension _IconListModule on _TIconPageState {
  ExampleModule get _iconListModule => ExampleModule(
    title: 'icon示例',
    children: [
      ExampleItem(
        desc: 'icon数量: ${TIcons.allIconsMap.length}',
        builder: _showAllIcons,
      ),
    ],
  );
}
