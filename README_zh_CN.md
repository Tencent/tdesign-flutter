<p align="center">
  <a href="https://tdesign.tencent.com/" target="_blank">
    <img alt="TDesign Logo" width="200" src="https://tdesign.gtimg.com/site/TDesign.png" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/Tencent/tdesign-flutter/blob/mainLICENSE">
    <img src="https://img.shields.io/github/license/tencent/tdesign-flutter" alt="License">
  </a>
  <a href="https://pub.dev/packages/tdesign_flutter/license">
    <img src="https://img.shields.io/pub/v/tdesign_flutter" alt="Version">
  </a>
  <a href="https://pub.dev/packages/tdesign_flutter/score">
    <img src="https://img.shields.io/pub/dm/tdesign_flutter" alt="Downloads">
  </a>
</p>

简体中文 | [English](README.md)

腾讯TDesign Flutter技术栈组件库，适合在移动端项目中使用。


# 🎉 特性

- 提供 TDesign 设计风格的 Flutter UI 组件库。
- 支持根据 App 设计风格定制主题。
- 提供常用 Icon 库，支持定制替换。
- 根据 TDesign 规范定义颜色组，可在 TDColors 中查看，方便适配 TDesign 规范的组件。
- 色值声明类可以添加默认颜色，实时查看色值默认显示效果。


# 🔨 使用
- SDK 版本依赖
```yaml
dart: ">=2.19.0 <4.0.0"
flutter: ">=3.7.0"
```

- 在 `pubspec.yaml` 添加依赖。

```yaml
dependencies:
  tdesign_flutter: ^0.0.6
```

- 在文件头部引入：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

- 您可以通过json文件配置主题样式，如颜色、字体大小、字体样式、角半径和阴影。使用 `TDTheme.of(context)` 或 `TDTheme.defaultData()` 获取主题数据。
  建议组件使用 `TDTheme.of(context)`，除非组件不需要遵循本地主题，在这种情况下可以使用 `TDTheme.defaultData()`。

颜色，字体，圆角等使用示例：

```dart
TDTheme.of(context).brandNormalColor
TDTheme.defaultData().fontBodyLarge
```

- TDesign的图标不遵循主题，它们都是ttf格式，使用示例：

```dart
Icon(TDIcons.activity)
```

- 有关更多使用示例，请参阅 [example/lib/page](tdesign-component/example/lib/page)


# 其他技术栈实现

- 桌面端 Vue 2.X 版本实现：[tdesign-vue](https://github.com/Tencent/tdesign-vue)
- 桌面端 Vue 3.X 版本实现：[tdesign-vue-next](https://github.com/Tencent/tdesign-vue-next)
- 桌面端 React 实现：[tdesign-react](https://github.com/Tencent/tdesign-react)
- 手机端 Vue 3.X 版本实现：[tdesign-mobile-vue](https://github.com/Tencent/tdesign-mobile-vue)
- 手机端 React 实现：[[tdesign-mobile-react](https://github.com/Tencent/tdesign-mobile-react)
- 移动端小程序实现：[tdesign-miniprogram](https://github.com/Tencent/tdesign-miniprogram)

# 致谢

TDesign Flutter 依赖以下组件库，感谢作者的开源贡献：

- [easy_refresh](https://pub-web.flutter-io.cn/packages/easy_refresh)
- [flutter_swiper](https://pub-web.flutter-io.cn/packages/flutter_swiper)
- [flutter_slidable](https://pub-web.flutter-io.cn/packages/flutter_slidable)
- [image_picker](https://pub-web.flutter-io.cn/packages/image_picker)

# Contributing

Contributing is welcome. Read [guidelines for contributing](CONTRIBUTING.md) before submitting your [Pull Request](https://github.com/Tencent/tdesign-flutter/pulls).

# 反馈

有任何问题，建议通过 [Github issues](https://github.com/Tencent/tdesign-vue-next/issues) 反馈或扫码加入用户微信群。

<img src="https://raw.githubusercontent.com/Tencent/tdesign/main/packages/components/src/images/groups/vue3-group.png" width="200" />

# 开源协议

TDesign 遵循 [MIT 协议](LICENSE)。