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

<p align="center">
<a href="https://github.com/Tencent/tdesign-flutter/blob/develop/README.md">English</a> | 简体中文
</p>

**TDesign Flutter** 是基于腾讯设计体系的跨平台 UI 组件库，使用 Flutter 框架开发，可快速构建美观、一致的移动端/Web 应用，提供丰富的预制组件和主题定制能力，支持 iOS、Android、Web 多端运行。

## 🎉 特性

- 提供遵循 TDesign 设计规范的 Flutter UI 组件库
- 支持根据 App 设计风格自定义主题
- 提供常用图标库，支持自定义替换
- 根据 TDesign 规范定义颜色组（可在 `TDColors` 中查看）
- 通过颜色值声明类实时预览默认颜色效果

## 📱 预览

**Android**：扫描二维码下载预览应用

<img width="200" src="https://tdesign.tencent.com/flutter/assets/qrcode/td_apk_qrcode.png" />

**iOS**：运行项目预览

[https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component](https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component)

## 🔨 安装

### SDK 版本要求

```yaml
dart: ">=3.2.6 <4.0.0"
flutter: ">=3.16.0"
```

### 添加依赖

在 `pubspec.yaml` 中添加以下内容：

```yaml
dependencies:
  tdesign_flutter: ^0.2.6
```

### 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 📖 使用方法

### 主题配置

可通过 JSON 文件配置主题样式（颜色、字体尺寸、字体样式、圆角、阴影）。通过 `TDTheme.of(context)` 或 `TDTheme.defaultData()` 获取主题数据。

> **建议**：组件都使用 `TDTheme.of(context)`。不需要跟随局部主题的组件，才可以使用 `TDTheme.defaultData()`。

```dart
// 颜色
TDTheme.of(context).brandNormalColor

// 字体
TDTheme.defaultData().fontBodyLarge
```

### 图标

TDesign 图标为 TTF 格式，不跟随主题：

```dart
Icon(TDIcons.activity)
```

## 🎨 自定义主题

TDesign Flutter 提供三种灵活的主题定制方式：

### 方式一：JSON 配置

直接使用 JSON 格式定义主题属性：

```dart
String themeConfig = '''
{
  "myTheme": {
    "color": {
      "brandNormalColor": "#D7B386"
    },
    "font": {
      "fontBodyMedium": {
        "size": 40,
        "lineHeight": 55
      }
    }
  }
}
''';

MaterialApp(
  theme: ThemeData(
    extensions: [TDThemeData.fromJson('myTheme', themeConfig)!],
  ),
  // ...
)
```

> 所有可用的主题键值请参考 [td_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/td_default_theme.dart)

### 方式二：主题生成器（推荐）

如果你不想自定义太多颜色，但是想要拥有好看的自定义主题，"主题生成器"是个不错的选择。

> **注意**：[v0.2.6](https://tdesign.tencent.com/flutter/changelog) 版本开始，主题生成器已支持"深色模式"，具体可参考[深色模式](https://tdesign.tencent.com/flutter/dark-mode)。

<video controls width="100%">
  <source src="https://tdesign.gtimg.com/site/theme/demo-cn.mp4" type="video/mp4" />
</video>

1. **生成**：进入 [TDesign 主题生成器](https://tdesign.tencent.com/vue/custom-theme)，点击下方的主题生成器，在右边生成器里选择想要的颜色，点击下载。

2. **转换**：此时你得到一个 `theme.css` 文件，将该文件放到 `tdesign-component/example/shell/theme/` 文件夹下，修改该文件夹下的 `css2JsonTheme.dart` 为你自己的文件名、主题名和输出路径，即可得到一个 `theme.json` 文件。

![img.png](https://tdesign.tencent.com/flutter/assets/dart_modify.png)

3. **应用**：将主题 JSON 加载进 `TDTheme`，美观的自定义主题就设置完成了。

```dart
// 开启多套主题功能
TDTheme.needMultiTheme();

var jsonString = await rootBundle.loadString('assets/theme.json');
var _themeData = TDThemeData.fromJson('green', jsonString);
// ...
MaterialApp(
  title: 'TDesign Flutter Example',
  theme: ThemeData(
    extensions: [_themeData]
  ),
  home: MyHomePage(title: 'TDesign Flutter 组件库'),
);
```

### 深色模式

通过"主题生成器"生成的主题配置文件，默认支持暗色模式相关色值。

```dart
// 开启多套主题功能
TDTheme.needMultiTheme();
// ...
// MaterialApp 中设置三个属性如下，如果有自定义主题属性，可以通过 copyWith() 方法修改。
// 注：主题切换需要业务自己实现，比如使用 Provider，具体可参考 tdesign-flutter/tdesign-component/example/lib/component_test/dark_test.dart
MaterialApp(
  theme: _themeData.systemThemeDataLight,
  darkTheme: _themeData.systemThemeDataDark,
  themeMode: themeModeProvider.themeMode,
  // ...
)
```

## 🌍 国际化

TDesign Flutter 组件库内部不内置国际化语言，但支持与 Flutter 的国际化能力搭配使用。可以继承 `TDResourceDelegate` 类，该类抽离了组件内部所有文字资源，重写获取文字的方法进行国际化处理，并通过 `TDTheme.setResourceBuilder` 注入。

### 快速配置

1. **重写 `TDResourceDelegate` 类：**

```dart
/// 国际化资源代理
class IntlResourceDelegate extends TDResourceDelegate {
  IntlResourceDelegate(this.context);

  BuildContext context;

  /// 国际化需要每次更新 context
  updateContext(BuildContext context) {
    this.context = context;
  }

  @override
  String get cancel => AppLocalizations.of(context)!.cancel;

  @override
  String get confirm => AppLocalizations.of(context)!.confirm;
}
```

2. **注入 `TDResourceDelegate` 类：**

```dart
var delegate = IntlResourceDelegate(context);
return MaterialApp(
  home: Builder(
    builder: (context) {
      // 设置文案代理，国际化需要在 MaterialApp 初始化完成之后才生效，而且需要每次更新 context
      TDTheme.setResourceBuilder((context) => delegate..updateContext(context), needAlwaysBuild: true);
      return MyHomePage(
        title: AppLocalizations.of(context)?.components ?? '',
      );
    },
  ),
  // 设置国际化处理
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
);
```

3. Flutter 国际化配置方法，请参阅官方文档：[Flutter 应用里的国际化](https://docs.flutter.cn/ui/accessibility-and-internationalization/internationalization)

## ❓ 常见问题

### 文本居中

- **v0.1.4 版本**：Flutter 3.16 之后，修改了渲染引擎，导致启用 `forceVerticalCenter` 参数的组件字体偏移更多，不再居中。可以通过设置 `kTextForceVerticalCenterEnable=false` 来禁用字体居中功能，让组件显示与官方 Text 一致。

- **v0.1.5 版本**：适配了 Android 和 iOS 双端基础系统字体的中文居中，其他语言的字体，可以通过重写 `TDTextPaddingConfig` 的 `paddingRate` 和 `paddingExtraRate` 进行自定义适配，`TDTextPaddingConfig` 使用方法可参考 `TDTextPage`。

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

欢迎贡献代码！请在提交 [Pull Request](https://github.com/Tencent/tdesign-flutter/pulls) 前阅读[贡献指南](CONTRIBUTING.md)。

<a href="https://github.com/Tencent/tdesign-flutter/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Tencent/tdesign-flutter" />
</a>

## 💬 交流反馈

创建 [GitHub Issues](https://github.com/Tencent/tdesign-flutter/issues) 或扫描二维码加入用户群：

<img src="https://tdesign.tencent.com/flutter/assets/qrcode/feedback.png" width="200" />

## 🙏 致谢

TDesign Flutter 依赖以下组件库，感谢作者的开源贡献：

- [easy_refresh](https://pub-web.flutter-io.cn/packages/easy_refresh)
- [flutter_swiper](https://pub-web.flutter-io.cn/packages/flutter_swiper)
- [flutter_slidable](https://pub-web.flutter-io.cn/packages/flutter_slidable)
- [image_picker](https://pub-web.flutter-io.cn/packages/image_picker)

## 📄 开源协议

TDesign Flutter 遵循 [MIT 协议](LICENSE)。
