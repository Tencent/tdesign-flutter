part of 'navbar_page.dart';

extension _NavbarTypeModule on TNavBarPage {
  ExampleModule get _navbarTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        key: const Key('navbar-demo-scene-base'),
        desc: '基础H5导航栏',
        builder: _baseH5Navbar,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-left-multi'),
        builder: _leftMultiAction,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-right-multi'),
        builder: _rightMultiAction,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-search'),
        desc: '带搜索导航栏',
        builder: _searchNavbar,
      ),
      ExampleItem(
        key: const Key('navbar-demo-scene-image'),
        desc: '带图片导航栏',
        builder: _logoNavbar,
      ),
    ],
  );
}
