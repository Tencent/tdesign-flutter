part of 'fab_page.dart';

extension _FabStyleModule on _TFabPageState {
  ExampleModule get _fabStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '可移动悬浮按钮',
        builder: (context) => _buildSelectorButton(
          context,
          type: _FabDemoType.draggable,
          text: '可移动悬浮按钮',
        ),
        ignoreCode: true,
      ),
      ExampleItem(
        desc: '带自动收缩功能',
        builder: (context) => _buildSelectorButton(
          context,
          type: _FabDemoType.collapsible,
          text: '带自动收缩功能',
        ),
        ignoreCode: true,
      ),
      ExampleItem(
        builder: _buildSkeletonContent,
        center: false,
        ignoreCode: true,
      ),
    ],
  );
}
