---
title: 自定义主题
description: 按应用、组件、局部区域和单个实例选择样式配置方式。
spline: explain
---

## 先选择修改范围

| 你想改什么 | 使用什么 | 影响范围 |
| --- | --- | --- |
| 整个应用的品牌色、字体、间距 | `TThemeData` 与 `TThemeBuilder` | 使用该主题的应用子树 |
| 某一类组件的样式默认值 | 对应的 `T*ThemeData` | 该主题下的同类组件 |
| 某个页面或区域的组件样式 | `Theme` 与 `mergeExtension` | 被包裹的子树 |
| 一个实例支持的尺寸、状态或外形 | 组件的公开参数 | 当前实例 |

先确定影响范围，再选择配置方式。不同组件支持的实例参数不同；例如 Tag 的 `shape` 选择外形，具体圆角值由 Theme 决定。只改一个 Tag 的圆角，也可以用 `Theme` 仅包裹这个实例。

## 配置应用品牌色

将下面的 JSON 解析为 Token。在快速开始的完整应用中用 `loadBrandTheme()` 替换 `TThemeData.defaultData()`，再交给 `TThemeBuilder.light`：

```dart
TThemeData loadBrandTheme() {
  const config = '''
  {
    "myTheme": {
      "color": { "brandColor": "#D7B386" }
    }
  }
  ''';
  return TThemeData.fromJson('myTheme', config) ?? TThemeData.defaultData();
}
```

将返回的 Token 用于 `TThemeBuilder.light`。所有可用 Token 键见 [t_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)。如果需要自定义暗色 Token，在 JSON 中增加 `myThemeDark` 配置；`fromJson` 默认查找 `${name}Dark`，也可以通过 `darkName` 指定名称。

## 配置一类组件的默认样式

- 应用级颜色、字体、间距、圆角等 Token 通过 `TThemeData` 配置，再交给 `TThemeBuilder` 构建 Material 主题。
- 组件的样式默认值通过对应的 `ThemeExtension` 配置，例如 `TTagThemeData`；组件支持的显式参数用于单个实例。
- 子树通过 Flutter `Theme` 覆盖主题。`mergeExtension` 替换同类型扩展并保留其他扩展；若还要保留同类型扩展的已有字段，应先对原扩展调用 `copyWith`。

例如让应用中的方形 Tag 默认使用 6 逻辑像素圆角。以下函数返回亮色主题，用作 `MaterialApp.theme`；暗色主题需要在 `TThemeBuilder.dark(token)` 的结果上配置同样的组件扩展。

```dart
ThemeData buildLightTheme(TThemeData token) => TThemeBuilder.light(token)
    .mergeExtension(const TTagThemeData(squareBorderRadius: 6));
```

## 只修改一个页面或区域

用 `Theme` 包裹目标子树。这里将局部方形 Tag 的圆角改为 12，同时保留应用级 Tag Theme 的其他字段：

```dart
Widget buildLocalTag(BuildContext context) {
  final theme = Theme.of(context);
  final tagTheme = theme.extension<TTagThemeData>() ?? const TTagThemeData();
  return Theme(
    data: theme.mergeExtension(tagTheme.copyWith(squareBorderRadius: 12)),
    child: const TTag('TDesign'),
  );
}
```

这些示例需要引入 `package:flutter/material.dart` 和 `package:tdesign_flutter/tdesign_flutter.dart`。`context` 应位于已配置主题的 `MaterialApp` 内部。业务读取当前 Token 使用 `context.tTheme`；`TThemeData.defaultData()` 返回默认 Token，不读取当前上下文，不能用于读取局部覆盖后的值。

## 只修改一个实例

优先使用该组件公开支持的参数，例如标签的尺寸：

```dart
Widget buildLargeTag() => const TTag('TDesign', size: TTagSize.large);
```

组件的具体字段、生效条件和覆盖关系见 [Theme API](/flutter/components/theme)及对应组件 API。

## 使用主题生成器

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

JSON 中增加对应暗色配置，例如 `greenDark`，解析时传入 `darkName: 'greenDark'`。只改变品牌色的浅色 JSON 不会自动生成完整暗色方案；缺少暗色 Token 时，`TThemeBuilder.dark` 回退当前 Token。

浅色、深色与跟随系统的选择及持久化见[深色模式](/flutter/dark-mode)，本页负责定义这些模式使用的配色。
