part of 'fab_page.dart';

extension _FabTypeModule on _TFabPageState {
  ExampleModule get _fabTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '纯图标悬浮按钮',
        builder: (context) => _buildSelectorButton(
          context,
          type: _FabDemoType.base,
          text: '纯图标悬浮按钮',
        ),
        ignoreCode: true,
      ),
      ExampleItem(
        desc: '图标加文字悬浮按钮',
        builder: (context) => _buildSelectorButton(
          context,
          type: _FabDemoType.advance,
          text: '图标加文字悬浮按钮',
        ),
        ignoreCode: true,
      ),
    ],
  );
}
