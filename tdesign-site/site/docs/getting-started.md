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


**TDesign Flutter** 是基于腾讯设计体系的跨平台 UI 组件库，使用 Flutter 框架开发，可快速构建美观、一致的移动端/Web 应用，提供丰富的预制组件和主题定制能力，支持 iOS、Android、Web 多端运行。

## 🎉 特性

- 提供遵循 TDesign 设计规范的 Flutter UI 组件库
- 支持根据 App 设计风格自定义主题
- 提供常用图标库，支持自定义替换
- 根据 TDesign 规范定义颜色组（可在 `TColors` 中查看）
- 通过颜色值声明类实时预览默认颜色效果

## 📱 预览

**Android**：扫描二维码下载预览应用

<img width="200" src="data:image/png;base64,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" />

下载链接：[tdesign-flutter-example.apk](https://tdesign.gtimg.com/flutter/tdesign_flutter_example.apk)

**iOS**：运行项目预览

[https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component](https://github.com/Tencent/tdesign-flutter/tree/main/tdesign-component)

## 🔨 安装

### SDK 版本要求

```yaml
dart: ">=3.8.0 <4.0.0"
flutter: ">=3.32.0"
```

### 添加依赖

在 `pubspec.yaml` 中添加以下内容：

```yaml
dependencies:
  tdesign_flutter: 1.0.0-alpha.1
```

### 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 📖 使用方法

### 主题配置

可通过 JSON 文件配置主题样式（颜色、字体尺寸、字体样式、圆角、阴影）。通过 `context.tTheme` 或 `TThemeData.defaultData()` 获取主题数据。

> **建议**：组件都使用 `context.tTheme`。不需要跟随局部主题的组件，才可以使用 `TThemeData.defaultData()`。

```dart
// 颜色
context.tTheme.brandColor

// 字体
TThemeData.defaultData().fontBodyLarge
```

### 图标

TDesign 图标为 TTF 格式，不跟随主题：

```dart
Icon(TIcons.activity)
```

## 🎨 自定义主题

TDesign Flutter 提供两种灵活的主题定制方式：

### 方式一：JSON 配置

直接使用 JSON 格式定义主题属性：

```dart
String themeConfig = '''
{
  "myTheme": {
    "color": {
      "brandColor": "#D7B386"
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
  theme: TThemeBuilder.light(TThemeData.fromJson('myTheme', themeConfig)!),
  // ...
)
```

> 所有可用的主题键值请参考 [t_default_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)

### 方式二：主题生成器（推荐）

如果你不想自定义太多颜色，但是想要拥有好看的自定义主题，"主题生成器"是个不错的选择。

主题生成器支持浅色和深色配置，具体可参考[深色模式](https://tdesign.tencent.com/flutter/dark-mode)。

<video controls width="100%">
  <source src="https://tdesign.gtimg.com/site/theme/demo-cn.mp4" type="video/mp4" />
</video>

1. **生成**：进入 [TDesign 主题生成器](https://tdesign.tencent.com/vue/custom-theme)，点击下方的主题生成器，在右边生成器里选择想要的颜色，点击下载。

2. **转换**：此时你得到一个 `theme.css` 文件，将该文件放到 `tdesign-component/example/shell/theme/` 文件夹下，修改该文件夹下的 `css2_json_theme.dart` 为你自己的文件名、主题名和输出路径，即可得到一个 `theme.json` 文件。

3. **应用**：通过 `TThemeData.fromJson` 加载主题 JSON，美观的自定义主题就设置完成了。

```dart
var jsonString = await rootBundle.loadString('assets/theme.json');
final _themeData = TThemeData.fromJson('green', jsonString, darkName: 'greenDark') ??
    TThemeData.defaultData();
// ...
MaterialApp(
  title: 'TDesign Flutter Example',
  theme: TThemeBuilder.light(_themeData),
  home: MyHomePage(title: 'TDesign Flutter 组件库'),
);
```

### 深色模式

通过"主题生成器"生成的主题配置文件，默认支持暗色模式相关色值。

```dart
// ...
// MaterialApp 中设置三个属性如下，如果有自定义主题属性，可以通过 copyWith() 方法修改。
// 注：主题切换需要业务自己实现，比如使用 Provider，具体可参考 tdesign-flutter/tdesign-component/example/lib/component_test/dark_test.dart
MaterialApp(
  theme: TThemeBuilder.light(_themeData),
  darkTheme: TThemeBuilder.dark(_themeData),
  themeMode: themeModeProvider.themeMode,
  // ...
)
```

## 🌍 国际化

TDesign Flutter 组件库内部不内置国际化语言，但支持与 Flutter 的国际化能力搭配使用。可以继承 `TResourceDelegate` 类，该类抽离了组件内部所有文字资源，重写获取文字的方法进行国际化处理，并通过 `setTResourceBuilder` 注入。

### 快速配置

1. **重写 `TResourceDelegate` 类：**

```dart
/// 国际化资源代理
class IntlResourceDelegate extends TResourceDelegate {
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

2. **注入 `TResourceDelegate` 类：**

```dart
var delegate = IntlResourceDelegate(context);
return MaterialApp(
  home: Builder(
    builder: (context) {
      // 设置文案代理，国际化需要在 MaterialApp 初始化完成之后才生效，而且需要每次更新 context
      setTResourceBuilder((context) => delegate..updateContext(context), needAlwaysBuild: true);
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
