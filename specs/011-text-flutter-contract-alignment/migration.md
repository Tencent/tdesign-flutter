# Breaking 迁移指南

本次重构不保留 deprecated 别名或旧行为分支。旧调用会产生编译错误，请按以下方式迁移。

## 文字缩放

```dart
// before
TText('文本', textScaleFactor: 1.2)

// after
TText('文本', textScaler: TextScaler.linear(1.2))
```

不传 `textScaler` 时，组件继承 `MediaQuery` 的系统缩放策略，包括非线性缩放。

## 在线字体

```dart
final loaded = await TFontLoader.load(
  name: 'BrandFont',
  fontFamilyUrl: fontUrl,
);

if (loaded) {
  const TText(
    '文本',
    fontFamily: FontFamily(fontFamily: 'BrandFont'),
  );
}
```

原 `fontFamilyUrl`、`isInFontLoader` 和 `TFontLoaderWidget` 均删除。字体加载状态由业务层持有，
`TText` 不在 build 期间发起网络请求。

## 全局与局部默认样式

原 `TTextConfiguration` 改为 Flutter 原生 Theme 组合：

- 应用级字体使用 Material `ThemeData`。
- 子树文字默认值使用 `DefaultTextStyle`。
- 仅控制 `TText` 时使用 `TTextThemeData`。

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: const [
      TTextThemeData(textStyle: TextStyle(fontFamily: 'BrandFont')),
    ],
  ),
  child: const TText('文本'),
)
```

## 字体 package

```dart
TText(
  '文本',
  fontFamily: const FontFamily(
    fontFamily: 'BrandFont',
    package: 'brand_assets',
  ),
)
```

不再提供独立 `package` 参数。

## 背景与垂直布局

- 字形背景使用 `TextStyle.backgroundColor`。
- 行盒背景使用 `ColoredBox` 或 `Container`。
- 垂直居中使用 `Center` 或 `Align`。
- 图文对齐使用父级 baseline 布局。

原 `backgroundColor`、`forceVerticalCenter` 和 padding 配置均删除。

## 非空内容

`TText(data)` 与 `TText.rich(textSpan)` 的构造参数改为非空。可空业务值应在调用处明确处理：

```dart
TText(value ?? '')
```
