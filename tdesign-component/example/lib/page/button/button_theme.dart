part of 'button_page.dart';

extension _ButtonThemeModule on _TButtonPageState {
  ExampleModule get _buttonThemeModule => ExampleModule(
    title: '组件主题',
    children: [
      ExampleItem(
        ignoreCode: true,
        desc: '按钮尺寸',
        builder: (context) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 16, // 主轴方向间距
            runSpacing: 16, // 交叉轴方向间距
            children: [
              CodeWrapper(builder: _buildLargeButton),
              CodeWrapper(builder: _buildMediumButton),
              CodeWrapper(builder: _buildSmallButton),
              CodeWrapper(builder: _buildExtraSmallButton),
            ],
          );
        },
      ),
      ExampleItem(
        ignoreCode: true,
        desc: '按钮形状',
        center: false,
        builder: (context) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CodeWrapper(builder: _buildRectangleShapeButton),
                CodeWrapper(builder: _buildSquareIconButton),
                CodeWrapper(builder: _buildRoundButton),
                CodeWrapper(builder: _buildCircleButton),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        ignoreCode: true,
        desc: '按钮主题',
        builder: (context) {
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 16, // 主轴方向间距
            runSpacing: 16, // 交叉轴方向间距
            children: [
              /// 默认主题
              CodeWrapper(builder: _buildDefaultFillButton),
              CodeWrapper(builder: _buildDefaultStrokeButton),
              CodeWrapper(builder: _buildDefaultTextButton),

              /// primary主题
              CodeWrapper(builder: _buildPrimaryFillButton),
              CodeWrapper(builder: _buildPrimaryStrokeButton),
              CodeWrapper(builder: _buildPrimaryTextButton),

              /// danger主题
              CodeWrapper(builder: _buildDangerFillButton),
              CodeWrapper(builder: _buildDangerStrokeButton),
              CodeWrapper(builder: _buildDangerTextButton),

              /// light主题
              CodeWrapper(builder: _buildLightFillButton),
              CodeWrapper(builder: _buildLightStrokeButton),
              CodeWrapper(builder: _buildLightTextButton),
            ],
          );
        },
      ),
    ],
  );
}
