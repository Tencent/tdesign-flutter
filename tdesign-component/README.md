<!-- Generated from README.md; do not edit this copy. -->

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

English | [简体中文](./README_zh_CN.md)

**TDesign Flutter** is a cross-platform UI component library based on Tencent's design system. Built with the Flutter framework, it enables rapid development of beautiful, consistent mobile/web applications with rich pre-built components and theme customization capabilities, supporting iOS, Android, and Web platforms.

## 🎉 Features

- Provides Flutter UI component library following TDesign design specifications
- Supports theme customization to match your App's design style
- Includes a comprehensive Icon library with custom replacement support
- Defines color groups according to TDesign specifications (viewable in `TColors`)
- Real-time preview of default color values through the color declaration class

## 📱 Preview

**Android**: Scan the QR code to download the preview app

<img width="200" src="https://raw.githubusercontent.com/Tencent/tdesign-flutter/develop/tdesign-site/site/public/assets/qrcode/t_apk_qrcode.png" />

Download link: [tdesign-flutter-example.apk](https://tdesign.gtimg.com/flutter/tdesign_flutter_example.apk)

**iOS**: Run the project to preview

[https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component](https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component)

## 🚀 Quick Start

Upgrading from 0.2.7? Read the [1.0 migration guide (Chinese)](./MIGRATION.md) before changing the dependency. Version 1.0 contains breaking API and behavior changes.

Requires Flutter ≥ 3.32.0 and Dart ≥ 3.8.0.

Add `tdesign_flutter: ^1.0.0` to `pubspec.yaml` and run `flutter pub get`. See [Getting started](https://tdesign.tencent.com/flutter/getting-started) for the complete setup.

### Minimal Import

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

The TDesign entry point re-exports Flutter Material widgets, so the same import provides `MaterialApp`, `Scaffold`, `Text`, and TDesign components.

### Minimal Usage

Add the button to the widget tree of an existing page:

```dart
const TButton(child: Text('Button'))
```

No additional initialization or theme configuration is required. Omitting `onPressed` leaves the button disabled.

## 📚 Documentation

The detailed guides below are currently in Chinese.

- [Getting started](https://tdesign.tencent.com/flutter/getting-started)
- [Custom themes](https://tdesign.tencent.com/flutter/custom-theme)
- [Dark mode](https://tdesign.tencent.com/flutter/custom-theme#明暗模式)
- [Internationalization](https://tdesign.tencent.com/flutter/internationalization)
- [FAQ](https://tdesign.tencent.com/flutter/faq)
- [Component documentation](https://tdesign.tencent.com/flutter/overview)

## 🔗 More Examples

For more usage examples, refer to [example/lib/page/](https://github.com/Tencent/tdesign-flutter/tree/develop/tdesign-component/example/lib/page)

## 🌐 TDesign Component Libraries

TDesign provides component libraries for other platforms and frameworks:

| Platform           | Repository                                                              |
| ------------------ | ----------------------------------------------------------------------- |
| Vue 2.x            | [tdesign-vue](https://github.com/Tencent/tdesign-vue)                   |
| Vue 3.x            | [tdesign-vue-next](https://github.com/Tencent/tdesign-vue-next)         |
| React              | [tdesign-react](https://github.com/Tencent/tdesign-react)               |
| Vue 3.x Mobile     | [tdesign-mobile-vue](https://github.com/Tencent/tdesign-mobile-vue)     |
| React Mobile       | [tdesign-mobile-react](https://github.com/Tencent/tdesign-mobile-react) |
| WeChat Miniprogram | [tdesign-miniprogram](https://github.com/Tencent/tdesign-miniprogram)   |

## 🤝 Contributing

Contributions are welcome! Please read the [contributing guidelines](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md) before submitting your [Pull Request](https://github.com/Tencent/tdesign-flutter/pulls).

<a href="https://github.com/Tencent/tdesign-flutter/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Tencent/tdesign-flutter" />
</a>

## 💬 Feedback

Create [GitHub Issues](https://github.com/Tencent/tdesign-flutter/issues) or scan the QR code to join our user groups:

<img src="https://raw.githubusercontent.com/Tencent/tdesign/main/packages/site-components/src/images/groups/flutter-group.png" width="200" />

## 🙏 Acknowledgements

TDesign Flutter depends on the following component libraries. We appreciate the authors for their open-source contributions:

- [easy_refresh](https://pub.dev/packages/easy_refresh)
- [flutter_slidable](https://pub.dev/packages/flutter_slidable)
- [image_picker](https://pub.dev/packages/image_picker)

## 📄 License

TDesign Flutter is licensed under the [MIT License](https://github.com/Tencent/tdesign-flutter/blob/develop/LICENSE).
