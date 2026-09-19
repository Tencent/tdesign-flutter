part of 'theme_page.dart';

extension _ThemeColorModule on _TThemeColorsPageState {
  ExampleModule get _themeColorModule => ExampleModule(
    title: '颜色示例',
    children: [
      ExampleItem(desc: '功能色', builder: _buildFunctionColor, ignoreCode: true),
      ExampleItem(desc: '文字&图标颜色', builder: _buildTextColor, ignoreCode: true),
      ExampleItem(desc: '中性色板', builder: _buildOtherColor, ignoreCode: true),
    ],
  );
}
