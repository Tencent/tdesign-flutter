---
title: 自定义主题
description: 按应用、组件、局部区域和单个实例选择样式配置方式。
spline: explain
flutterPreview: custom-theme
toc: false
---

切换品牌色、全局圆角和按钮图标间距，观察同一组实际 TD 按钮。局部按钮始终保持 24 圆角，大号按钮使用实例尺寸；点击按钮可看到反馈。

<div data-flutter-guide-preview></div>

## 先选择修改范围

| 你想改什么 | 使用什么 | 本页演示 |
| --- | --- | --- |
| 应用品牌色、字体、间距等 Token | `TThemeData` 与 `TThemeBuilder` | 品牌色与全局圆角 |
| 一类组件支持的样式默认值 | 对应的 `T*ThemeData` | 所有按钮的图标间距 |
| 某个页面或区域的样式 | `Theme` 与 `mergeExtension` | 局部按钮固定圆角 |
| 一个实例支持的尺寸、状态或外形 | 组件公开参数 | 大号按钮的尺寸 |

有对应实例参数时直接使用参数；需要共享默认值时再配置主题。各组件支持的字段见 [Theme API](/flutter/components/theme)及对应组件 API。

## 配置应用品牌色

示例将品牌色和 `radiusDefault` 写入 JSON，用 `TThemeData.fromJson` 解析，再传给 `TThemeBuilder.light` 和 `TThemeBuilder.dark`。将此 Token 替换快速开始的 `TThemeData.defaultData()` 即可应用到自己的应用。

所有可用 Token 键见 [t_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)。按钮等读取当前 Token 的组件会随品牌色与全局圆角变化。

## 配置一类组件的默认样式

示例将 `TButtonThemeData(iconTextSpacing: _iconSpacing)` 合并到浅色和深色主题。切换“图标间距”时，三个演示按钮一起变化。组件扩展只控制它公开支持的字段；本例的圆角来自应用 Token，图标间距来自 Button 扩展。

## 只修改一个页面或区域

局部按钮使用 `Theme` 包裹，通过 `context.tTheme.copyWith(radiusMap: {'radiusDefault': 24})` 覆盖当前 Token 的圆角，再用 `mergeExtension` 合并到当前 Flutter 主题。

因此它保留应用品牌色和 Button 图标间距，只固定自己的圆角。修改某个组件扩展时也应先读取当前扩展并 `copyWith`，避免丢失其他字段。不要用 `TThemeData.defaultData()` 替代当前 Token。

## 只修改一个实例

大号按钮使用 `size: TButtonSize.large`，无需复制或重建主题；品牌色、圆角和图标间距仍继承当前主题。

## 交互演示源码

下面是预览的完整实际源码。沿用快速开始的 Flutter 和 TDesign 导入，在已安装依赖的应用中用 `runApp(const CustomThemeExample())` 运行。

{{ flutter-example theme.CustomThemeExample }}

## 可选：从主题生成器导入配色

1. 在 [TDesign 主题生成器](https://tdesign.tencent.com/vue/custom-theme)选择颜色并下载 CSS。
2. 使用仓库中的 [css2_json_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/shell/theme/css2_json_theme.dart) 转换。它读取全局颜色 Token；将 CSS 放入 `tdesign-component/example/shell/theme/`，调整脚本中的文件名、主题名和输出路径，从 `tdesign-component/example` 目录执行 `dart run shell/theme/css2_json_theme.dart`。
3. 将生成的 JSON 放入业务应用，并在 `pubspec.yaml` 中登记资产：

```yaml
flutter:
  assets:
    - assets/theme.json
```

名称必须与 JSON 顶层键一致。下面的函数需要额外引入 `package:flutter/services.dart`：

```dart
Future<TThemeData> loadThemeAsset() async {
  final json = await rootBundle.loadString('assets/theme.json');
  return TThemeData.fromJson('green', json, darkName: 'greenDark') ??
      TThemeData.defaultData();
}
```

在应用初始化或加载状态中调用它，将解析结果保存为应用状态，再用于 `theme` 和 `darkTheme`；不要在每次 `build` 时重复加载资产。

## 配置自定义暗色配色

只改变品牌色的浅色 JSON 不会自动生成完整暗色方案；缺少暗色 Token 时，`TThemeBuilder.dark` 回退当前 Token。需要不同暗色配色时，按前面的命名规则补充暗色 JSON。

浅色、深色与跟随系统的选择及持久化见[深色模式](/flutter/dark-mode)，本页负责定义这些模式使用的配色。
