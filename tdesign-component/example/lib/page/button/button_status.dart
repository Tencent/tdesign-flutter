part of 'button_page.dart';

extension _ButtonStatusModule on _TButtonPageState {
  ExampleModule get _buttonStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        ignoreCode: true,
        desc: '按钮禁用状态',
        builder: (context) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 16, // 主轴方向间距
            runSpacing: 16, // 交叉轴方向间距
            children: [
              CodeWrapper(builder: _buildDisablePrimaryFillButton),
              CodeWrapper(builder: _buildDisableLightFillButton),
              CodeWrapper(builder: _buildDisableDefaultFillButton),
              CodeWrapper(builder: _buildDisablePrimaryStrokeButton),
              CodeWrapper(builder: _buildDisablePrimaryTextButton),
            ],
          );
        },
      ),
    ],
  );
}
