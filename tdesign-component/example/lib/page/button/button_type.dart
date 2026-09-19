part of 'button_page.dart';

extension _ButtonTypeModule on _TButtonPageState {
  ExampleModule get _buttonTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        ignoreCode: true,
        desc: '基础按钮',
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Wrap(
              spacing: 16, // 主轴方向间距
              runSpacing: 16, // 交叉轴方向间距
              children: [
                CodeWrapper(
                  builder: _buildPrimaryFillButton,
                  methodName: '_buildPrimaryFillButton',
                ),
                CodeWrapper(
                  builder: _buildLightFillButton,
                  methodName: '_buildLightFillButton',
                ),
                CodeWrapper(builder: _buildDefaultFillButton),
                CodeWrapper(builder: _buildPrimaryStrokeButton),
                CodeWrapper(builder: _buildPrimaryTextButton),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        ignoreCode: true,
        desc: '图标按钮',
        center: false,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(left: 16),
            child: Wrap(
              spacing: 16, // 主轴方向间距
              runSpacing: 16, // 交叉轴方向间距
              children: [
                CodeWrapper(builder: _buildRectangleIconButton),
                CodeWrapper(builder: _buildSquareIconButton),
                CodeWrapper(builder: _buildLoadingIconButton),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        ignoreCode: true,
        desc: '幽灵按钮',
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            color: context.tTheme.grayColor14,
            child: Wrap(
              spacing: 16, // 主轴方向间距
              runSpacing: 16, // 交叉轴方向间距
              children: [
                CodeWrapper(builder: _buildPrimaryGhostButton),
                CodeWrapper(builder: _buildDangerGhostButton),
                CodeWrapper(builder: _buildDefaultGhostButton),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        ignoreCode: true,
        desc: '组合按钮',
        builder: (_) => CodeWrapper(builder: _buildCombinationButtons),
      ),
      ExampleItem(desc: '通栏按钮', builder: _buildBlockFillButton),
    ],
  );
}
