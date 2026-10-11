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

[English](./README.md) | 简体中文

**TDesign Flutter** 是基于腾讯设计体系的跨平台 UI 组件库，使用 Flutter 框架开发，可快速构建美观、一致的移动端/Web 应用，提供丰富的预制组件和主题定制能力，支持 iOS、Android、Web 多端运行。

## 🎉 特性

- 提供遵循 TDesign 设计规范的 Flutter UI 组件库
- 支持根据 App 设计风格自定义主题
- 提供常用图标库，支持自定义替换
- 根据 TDesign 规范定义颜色组（可在 `TColors` 中查看）
- 通过颜色值声明类实时预览默认颜色效果

## 📱 预览

**Android**：扫描二维码下载预览应用

<img width="200" src="https://raw.githubusercontent.com/Tencent/tdesign-flutter/develop/tdesign-site/site/public/assets/qrcode/t_apk_qrcode.png" />

下载链接：[tdesign-flutter-example.apk](https://tdesign.gtimg.com/flutter/tdesign_flutter_example.apk)

**iOS**：运行项目预览

[https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component](https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component)

<!-- getting-started:start -->

## 🔨 安装

### SDK 版本要求

Flutter `>=3.32.0`，Dart `>=3.8.0 <4.0.0`。下面示例对应 v1 预发布版本；预发布期间 API 和视觉细节仍可能调整，建议锁定依赖版本。旧版项目升级前请核对对应版本的变更说明。

### 添加依赖

在应用的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  flutter:
    sdk: flutter
  tdesign_flutter: 1.0.0-alpha.1
```

然后在应用目录执行 `flutter pub get`。

## 📖 第一个应用

将下面完整示例放入 `lib/main.dart`，连接设备后执行 `flutter run`：

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
        appBar: AppBar(title: const Text('TDesign Flutter')),
        body: Center(
          child: TButton(
            onPressed: () {},
            child: const TText('Hello TDesign'),
          ),
        ),
      ),
    );
  }
}
```

默认主题已配置，`ThemeMode.system` 会跟随系统明暗设置。运行后应能看到一个“Hello TDesign”按钮。

<a id="自定义主题"></a>
<a id="🎨-自定义主题"></a>

## 接下来你想做什么？

| 需求 | 阅读入口 |
| --- | --- |
| 找到并使用组件 | [组件概览](https://tdesign.tencent.com/flutter/overview) |
| 改整个应用的品牌色 | [自定义主题](https://tdesign.tencent.com/flutter/custom-theme#%E9%85%8D%E7%BD%AE%E5%BA%94%E7%94%A8%E5%93%81%E7%89%8C%E8%89%B2) |
| 改一类组件、某个页面或单个实例的样式 | [自定义主题](https://tdesign.tencent.com/flutter/custom-theme#%E5%85%88%E9%80%89%E6%8B%A9%E4%BF%AE%E6%94%B9%E8%8C%83%E5%9B%B4) |
| 手动切换明暗模式，或保存用户选择 | [深色模式](https://tdesign.tencent.com/flutter/dark-mode) |
| 使用其他语言 | [国际化](https://tdesign.tencent.com/flutter/internationalization) |
| 从旧版本升级 | [发布记录](https://github.com/Tencent/tdesign-flutter/releases) |

<!-- getting-started:end -->

## 🌐 TDesign 组件库

TDesign 还提供其他平台和框架的组件库：

| 平台 | 仓库 |
|------|------|
| Vue 2.x | [tdesign-vue](https://github.com/Tencent/tdesign-vue) |
| Vue 3.x | [tdesign-vue-next](https://github.com/Tencent/tdesign-vue-next) |
| React | [tdesign-react](https://github.com/Tencent/tdesign-react) |
| Vue 3.x 移动端 | [tdesign-mobile-vue](https://github.com/Tencent/tdesign-mobile-vue) |
| React 移动端 | [tdesign-mobile-react](https://github.com/Tencent/tdesign-mobile-react) |
| 微信小程序 | [tdesign-miniprogram](https://github.com/Tencent/tdesign-miniprogram) |

## 🤝 参与贡献

欢迎贡献代码！请在提交 [Pull Request](https://github.com/Tencent/tdesign-flutter/pulls) 前阅读[贡献指南](https://github.com/Tencent/tdesign-flutter/blob/develop/CONTRIBUTING.md)。

<a href="https://github.com/Tencent/tdesign-flutter/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Tencent/tdesign-flutter" />
</a>

## 💬 交流反馈

创建 [GitHub Issues](https://github.com/Tencent/tdesign-flutter/issues) 或扫描二维码加入用户群：

<img src="https://raw.githubusercontent.com/Tencent/tdesign/main/packages/site-components/src/images/groups/flutter-group.png" width="200" />

## 🙏 致谢

TDesign Flutter 依赖以下组件库，感谢作者的开源贡献：

- [easy_refresh](https://pub.dev/packages/easy_refresh)
- [flutter_slidable](https://pub.dev/packages/flutter_slidable)
- [image_picker](https://pub.dev/packages/image_picker)

## 📄 开源协议

TDesign Flutter 遵循 [MIT 协议](https://github.com/Tencent/tdesign-flutter/blob/develop/LICENSE)。
