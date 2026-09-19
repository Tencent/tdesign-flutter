part of 'navbar_page.dart';

extension _NavbarStyleModule on TNavBarPage {
  ExampleModule get _navbarStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        key: const Key('navbar-demo-scene-title-center'),
        desc: '标题对齐',
        builder: _titleCenterNavbar,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-title-left'),
        builder: _titleLeftNavbar,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-title-normal'),
        desc: '标题尺寸',
        builder: _titleNormalNavbar,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-title-below'),
        builder: _titleBelowNavbar,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-custom-color'),
        desc: '自定义颜色',
        builder: _setBgColorNavbar,
      ),
    ],
  );
}
