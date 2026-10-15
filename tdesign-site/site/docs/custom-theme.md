---
title: 自定义主题
description: 全局 Token、主题 JSON 和组件 ThemeExtension 的配置方式。
spline: explain
---


TDesign Flutter 提供两种灵活的主题定制方式：

## 方式一：JSON 配置

直接使用 JSON 格式定义主题属性：

```dart
String themeConfig = '''
{
  "myTheme": {
    "color": {
      "brandColor": "#D7B386"
    },
    "font": {
      "fontBodyMedium": {
        "size": 40,
        "lineHeight": 55
      }
    }
  }
}
''';

MaterialApp(
  theme: TThemeBuilder.light(TThemeData.fromJson('myTheme', themeConfig)!),
  // ...
)
```

> 所有可用的主题键值请参考 [t_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)

## 方式二：主题生成器（推荐）

如果你不想自定义太多颜色，但是想要拥有好看的自定义主题，"主题生成器"是个不错的选择。

主题生成器支持浅色和深色配置，具体可参考[深色模式](https://tdesign.tencent.com/flutter/dark-mode)。

<video controls width="100%">
  <source src="https://tdesign.gtimg.com/site/theme/demo-cn.mp4" type="video/mp4" />
</video>

1. **生成**：进入 [TDesign 主题生成器](https://tdesign.tencent.com/vue/custom-theme)，点击下方的主题生成器，在右边生成器里选择想要的颜色，点击下载。

2. **转换**：此时你得到一个 `theme.css` 文件，将该文件放到 `tdesign-component/example/shell/theme/` 文件夹下，修改该文件夹下的 `css2_json_theme.dart` 为你自己的文件名、主题名和输出路径，即可得到一个 `theme.json` 文件。

3. **应用**：通过 `TThemeData.fromJson` 加载主题 JSON，美观的自定义主题就设置完成了。

```dart
var jsonString = await rootBundle.loadString('assets/theme.json');
final _themeData = TThemeData.fromJson('green', jsonString, darkName: 'greenDark') ??
    TThemeData.defaultData();
// ...
MaterialApp(
  title: 'TDesign Flutter Example',
  theme: TThemeBuilder.light(_themeData),
  home: MyHomePage(title: 'TDesign Flutter 组件库'),
);
```

## 读取当前主题

组件通过 `context.tTheme` 读取当前子树 Token；`TThemeData.defaultData()` 仅用于不需要继承局部主题的场景。实例规格、状态与具体视觉配置分别遵循组件公开 API。

## 组件局部样式

通过组件的 `T*ThemeData` 覆盖局部样式。`mergeExtension` 保留其他主题扩展，仅替换指定类型的扩展。

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TTagThemeData(squareBorderRadius: 6),
  ),
  child: const TTag('局部圆角'),
);
```

全局 Token 与组件 ThemeExtension 分别负责全局配色和组件样式；组件可用配置见各组件文档末尾的 Theme 表。

## 明暗模式

主题的 `theme`、`darkTheme`、`themeMode` 和运行时切换见[深色模式](./dark-mode.md)。
