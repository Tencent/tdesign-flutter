<!-- Generated from README_zh_CN.md; do not edit this copy. -->

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

## 🚀 快速开始

从 0.2.7 升级时，请先阅读 [1.0 迁移指南](./MIGRATION.md)。1.0 包含不兼容的接口与默认行为变化，不能只替换组件前缀。

要求 Flutter ≥ 3.32.0、Dart ≥ 3.8.0。

在 `pubspec.yaml` 中添加 `tdesign_flutter: ^1.0.0`，运行 `flutter pub get`。完整接入步骤见[快速开始](https://tdesign.tencent.com/flutter/getting-started)。

### 最小导入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

TD 入口导出 Flutter Material 组件，可通过同一个入口使用 `MaterialApp`、`Scaffold`、`Text` 和 TDesign 组件。

### 最小使用

将按钮放入已有页面的 Widget 树中：

```dart
const TButton(child: Text('按钮'))
```

无需额外初始化或主题配置。不传 `onPressed` 时，按钮处于禁用状态。

## 📚 文档

- [快速开始](https://tdesign.tencent.com/flutter/getting-started)
- [自定义主题](https://tdesign.tencent.com/flutter/custom-theme)
- [深色模式](https://tdesign.tencent.com/flutter/custom-theme#明暗模式)
- [国际化](https://tdesign.tencent.com/flutter/internationalization)
- [常见问题](https://tdesign.tencent.com/flutter/faq)
- [在线组件文档](https://tdesign.tencent.com/flutter/overview)

## 🔗 更多示例

更多使用示例请参考 [example/lib/page/](https://github.com/Tencent/tdesign-flutter/tree/develop/tdesign-component/example/lib/page)

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
