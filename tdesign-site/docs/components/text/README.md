---
title: Text 文本
description: 使用 TDesign Token 渲染 Flutter 原生文本。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

`TText` 是 Flutter `Text` 的 TDesign Token 薄封装。文字排版、字体 fallback、
无障碍缩放、语义和选区行为均由 Flutter 原生实现；容器居中和图文 baseline 由父布局负责。

## 基础用法

```dart
TText(
  '文本 Text',
  font: context.tTheme.fontHeadlineLarge,
  textColor: context.tTheme.brandNormalColor,
)
```

`style` 具有最高优先级，适合使用 Flutter `TextStyle` 的完整能力：

```dart
TText(
  '文本 Text',
  font: context.tTheme.fontBodyLarge,
  textColor: context.tTheme.brandNormalColor,
  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
)
```

## 富文本

`TTextSpan` 只生成显式设置的样式，未设置字段从根 Span 继承。

```dart
TText.rich(
  TextSpan(
    children: [
      TTextSpan(text: '警告', textColor: context.tTheme.warningNormalColor),
      const TextSpan(text: '普通内容'),
    ],
  ),
  font: context.tTheme.fontBodyLarge,
)
```

## Theme 默认值

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      ...Theme.of(context).extensions.values,
      const TTextThemeData(
        textStyle: TextStyle(color: Colors.blue),
      ),
    ],
  ),
  child: const TText('继承组件 Theme'),
)
```

最终样式优先级为：实例 `style` > 实例便利参数 > `TTextThemeData` >
`DefaultTextStyle` > Material `TextTheme` > TDesign Token。

## 字体加载

`TText` 不在构建或绘制期间下载字体。先异步加载，再通过 `fontFamily` 使用：

```dart
final loaded = await TFontLoader.load(
  name: 'BrandFont',
  fontFamilyUrl: fontUrl,
);

if (loaded) {
  const TText(
    '品牌字体',
    fontFamily: FontFamily(fontFamily: 'BrandFont'),
  );
}
```

同名字体的并发加载共享一个 Future；加载失败后可以重试，同名字体不能切换 URL。

## Flutter 原生组合

- 线性缩放：`textScaler: TextScaler.linear(1.2)`。
- 系统缩放：不设置 `textScaler`，自动继承 `MediaQuery.textScalerOf(context)`。
- 字形背景：`style: TextStyle(backgroundColor: color)`。
- 行盒背景：用 `ColoredBox` 或 `Container` 包裹。
- 垂直居中：用 `Center` 或 `Align` 包裹。
- package 字体：`FontFamily(fontFamily: 'Name', package: 'package_name')`。

## Breaking 迁移

- `textScaleFactor` 改为 `textScaler: TextScaler.linear(value)`。
- `fontFamilyUrl`、`isInFontLoader` 和 `TFontLoaderWidget` 改为先调用
  `TFontLoader.load`，加载成功后设置 `fontFamily`。
- `TTextConfiguration` 改为 Material `Theme`、`DefaultTextStyle` 或
  `TTextThemeData`。
- 独立 `package` 合并到 `FontFamily.package`。
- `backgroundColor` 根据语义改为 `TextStyle.backgroundColor` 或父级
  `ColoredBox`。
- `forceVerticalCenter` 和 padding 配置改为父级 `Center`、`Align` 或 baseline 布局。
- `TText` 的 `data` 与 `TText.rich` 的 `textSpan` 现在必须非空。

## API

### TText / TText.rich

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| data / textSpan | String / InlineSpan | 普通文本或富文本内容，必填且非空类型 |
| font | Font? | TDesign 字体 Token |
| fontWeight | FontWeight? | 字重 |
| fontFamily | FontFamily? | 字体族及可选 package |
| textColor | Color? | 文字颜色 |
| isTextThrough | bool? | 是否使用删除线，null 表示继承 |
| lineThroughColor | Color? | 删除线颜色 |
| style | TextStyle? | 最高优先级的 Flutter 原生样式 |
| strutStyle | StrutStyle? | 原生段落 Strut |
| textAlign | TextAlign? | 原生对齐方式 |
| textDirection | TextDirection? | 原生文字方向 |
| locale | Locale? | 原生 Locale |
| softWrap | bool? | 是否软换行 |
| overflow | TextOverflow? | 溢出行为 |
| textScaler | TextScaler? | 文字缩放；null 时继承 MediaQuery |
| maxLines | int? | 最大行数 |
| semanticsLabel | String? | 语义标签 |
| semanticsIdentifier | String? | 语义标识 |
| textWidthBasis | TextWidthBasis? | 宽度计算方式 |
| textHeightBehavior | TextHeightBehavior? | 高度行为 |
| selectionColor | Color? | 选区颜色 |

### TTextSpan

除 Flutter `TextSpan` 的文本、子节点、手势和语义参数外，支持 `font`、
`fontWeight`、`fontFamily`、`textColor`、`isTextThrough`、
`lineThroughColor` 和 `style`。

### TTextThemeData

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| font | Font? | 默认 TDesign 字体 Token |
| textStyle | TextStyle? | 默认 Flutter 文字样式，覆盖 font 同名字段 |
| strutStyle | StrutStyle? | 默认 Strut |
| textWidthBasis | TextWidthBasis? | 默认宽度计算方式 |
| textHeightBehavior | TextHeightBehavior? | 默认高度行为 |

### TFontLoader.load

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| name | String | 注册后的字体族名称 |
| fontFamilyUrl | String | 字体资源 URL |

返回 `Future<bool>` 表示字体是否加载并注册成功。
