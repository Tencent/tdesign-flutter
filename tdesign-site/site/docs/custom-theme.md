---
title: 自定义主题
description: 按应用、组件、局部区域和单个实例选择样式配置方式。
spline: explain
flutterPreview: custom-theme
toc: false
---

在预览中切换品牌色和全局圆角：全局标签随之变化，局部标签保持 24 圆角，大号标签只改变实例尺寸。

## 先选择修改范围

| 你想改什么 | 使用什么 | 影响范围 |
| --- | --- | --- |
| 整个应用的品牌色、字体、间距 | `TThemeData` 与 `TThemeBuilder` | 使用该主题的应用子树 |
| 某一类组件的样式默认值 | 对应的 `T*ThemeData` | 该主题下的同类组件 |
| 某个页面或区域的组件样式 | `Theme` 与 `mergeExtension` | 被包裹的子树 |
| 一个实例支持的尺寸、状态或外形 | 组件的公开参数 | 当前实例 |

实例有对应参数时优先使用参数；没有时可用 `Theme` 只包裹该实例，例如修改单个 Tag 的圆角。

以下示例沿用快速开始的 `material.dart` 和 `tdesign_flutter.dart` 导入。

## 配置应用品牌色

添加下面函数，再把快速开始中的 `final token = TThemeData.defaultData();` 改为 `final token = loadBrandTheme();`：

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

所有可用 Token 键见 [t_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)。如果需要自定义暗色 Token，在 JSON 中增加 `myThemeDark` 配置；`fromJson` 默认查找 `${name}Dark`，也可以通过 `darkName` 指定名称。

## 配置一类组件的默认样式

例如让方形 Tag 默认使用 6 逻辑像素圆角。添加下面函数，将快速开始的 `theme: TThemeBuilder.light(token)` 改为 `theme: buildLightTheme(token)`。暗色模式也需要在 `TThemeBuilder.dark(token)` 的结果上合并同样的组件扩展。

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

在已配置主题的 `MaterialApp` 内调用 `buildLocalTag(context)`。`mergeExtension` 保留其他类型的扩展；先调用已有扩展的 `copyWith`，可同时保留该组件的其他字段。读取当前 Token 使用 `context.tTheme`，不要用返回默认 Token 的 `TThemeData.defaultData()`。

## 只修改一个实例

优先使用该组件公开支持的参数，例如标签的尺寸：

```dart
Widget buildLargeTag() => const TTag('TDesign', size: TTagSize.large);
```

组件的具体字段、生效条件和覆盖关系见 [Theme API](/flutter/components/theme)及对应组件 API。

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

## 交互演示源码

下面是预览的实际源码；在已安装依赖的应用中用 `runApp(const CustomThemeExample())` 运行。

{{ flutter-example theme.CustomThemeExample }}
