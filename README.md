<p align="center">
  <a href="https://tdesign.tencent.com/" target="_blank">
    <img alt="TDesign Logo" width="200" src="https://tdesign.gtimg.com/site/TDesign.png" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/Tencent/tdesign-flutter/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/tencent/tdesign-flutter" alt="License">
  </a>
  <a href="https://pub.dev/packages/tdesign_flutter">
    <img src="https://img.shields.io/pub/v/tdesign_flutter" alt="Version">
  </a>
  <a href="https://pub.dev/packages/tdesign_flutter/score">
    <img src="https://img.shields.io/pub/dm/tdesign_flutter" alt="Downloads">
  </a>
  <a href="https://deepwiki.com/Tencent/tdesign-flutter">
    <img src="https://deepwiki.com/badge.svg" alt="Ask DeepWiki">
  </a>
</p>

English | [简体中文](README_zh_CN.md)

Tencent TDesign UI component library of Flutter, suitable for use in mobile projects.

# 🎉 Features

- Provides Flutter UI component library in TDesign design style
- Support customizing themes according to App design style
- Provides commonly used Icon library and supports customized replacement
- Define color groups according to the TDesign specification, which can be viewed in TDColors to facilitate the adaptation of components to the TDesign specification.
- The color value declaration class can add default colors and view the default display effect of color values in real time.

# 🔨 Usage

- SDK dependency version

```yaml
dart: ">=2.19.0 <4.0.0"
flutter: ">=3.7.0"
```

- Add the dependency in `pubspec.yaml`

```yaml
dependencies:
  tdesign_flutter: ^0.0.6
```

- Import at the top of your file:

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

- You can configure theme styles such as colors, font sizes, font styles, corner radius, and shadows through a json file. 
Retrieve theme data using `TDTheme.of(context)` or `TDTheme.defaultData()`. It is recommended 
that components use `TDTheme.of(context)` unless the component does not need to follow local themes, 
in which case `TDTheme.defaultData()` can be used.

Examples of using colors, fonts, and corner radius:

```dart
TDTheme.of(context).brandNormalColor
TDTheme.defaultData().fontBodyLarge
```

- TDesign's icons do not follow the theme, they are all in ttf format, usage examples:

```dart
Icon(TDIcons.activity)
```

- For more use examples, please refer to [example/lib/page](tdesign-component/example/lib/page)


# TDesign component libraries

TDesign also provides component libraries for other platforms and frameworks.

- component library for Vue 2.x : [tdesign-vue](https://github.com/Tencent/tdesign-vue)
- component library for Vue 3.x : [tdesign-vue-next](https://github.com/Tencent/tdesign-vue-next)
- component library for React : [tdesign-react](https://github.com/Tencent/tdesign-react)
- component library for Vue 3.x Mobile : [tdesign-mobile-vue](https://github.com/Tencent/tdesign-mobile-vue)
- component library for React Mobile : [tdesign-mobile-react](https://github.com/Tencent/tdesign-mobile-react)
- component library for Wechat miniprogram : [tdesign-miniprogram](https://github.com/Tencent/tdesign-miniprogram)

# Acknowledgements

TDesign Flutter depends on the following component libraries. We appreciate the authors for their open-source contributions:

- [easy_refresh](https://pub-web.flutter-io.cn/packages/easy_refresh)
- [flutter_swiper](https://pub-web.flutter-io.cn/packages/flutter_swiper)
- [flutter_slidable](https://pub-web.flutter-io.cn/packages/flutter_slidable)
- [image_picker](https://pub-web.flutter-io.cn/packages/image_picker)

# Contributing

Contributing is welcome. Read [guidelines for contributing](CONTRIBUTING.md) before submitting your [Pull Request](https://github.com/Tencent/tdesign-flutter/pulls).

# Feedback

Create your [Github issues](https://github.com/Tencent/tdesign-flutter/issues) or scan the QR code below to join our user groups.

<img src="https://tdesign.tencent.com/flutter/assets/qrcode/feedback.png" width="200" />

# License

The MIT License. Please see [the license file](LICENSE) for more information.
