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

## 🔨 Installation

### SDK Requirements

Flutter `>=3.32.0` and Dart `>=3.8.0 <4.0.0` are required. These examples target the v1 prerelease; APIs and visual details may still change. Pin the dependency version and review the changes for your version before upgrading an older project.

### Add Dependency

Add this to your application's `pubspec.yaml` and run `flutter pub get`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  tdesign_flutter: 1.0.0-alpha.1
```

## 📖 First Application

Put this complete example in `lib/main.dart`, connect a device, and run `flutter run`:

```dart
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    return MaterialApp(
      theme: TThemeBuilder.light(token),
      darkTheme: TThemeBuilder.dark(token),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: const TNavBar(title: Text('TDesign Flutter')),
        body: Center(
          child: TButton(
            onPressed: () {},
            child: const Text('Hello TDesign'),
          ),
        ),
      ),
    );
  }
}
```

The default themes are configured, and `ThemeMode.system` follows the system appearance. You should see a “Hello TDesign” button after running the application.

## What Do You Want to Do Next?

| Goal | Guide |
| --- | --- |
| Find and use components | [Component Overview](https://tdesign.tencent.com/flutter/overview) |
| Change application brand colors | [Custom Theme](https://tdesign.tencent.com/flutter/custom-theme#%E9%85%8D%E7%BD%AE%E5%BA%94%E7%94%A8%E5%93%81%E7%89%8C%E8%89%B2) |
| Style a component type, subtree, or instance | [Custom Theme](https://tdesign.tencent.com/flutter/custom-theme#%E5%85%88%E9%80%89%E6%8B%A9%E4%BF%AE%E6%94%B9%E8%8C%83%E5%9B%B4) |
| Switch appearance or save the selected mode | [Dark Mode](https://tdesign.tencent.com/flutter/dark-mode) |
| Support another language | [Internationalization](https://tdesign.tencent.com/flutter/internationalization) |
| Upgrade from an older version | [Releases](https://github.com/Tencent/tdesign-flutter/releases) |

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

Contributions are welcome! Please read the [contributing guidelines](CONTRIBUTING.md) before submitting your [Pull Request](https://github.com/Tencent/tdesign-flutter/pulls).

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
