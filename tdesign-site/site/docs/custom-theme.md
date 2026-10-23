---
title: 自定义主题
description: 配置全局主题、组件样式和明暗模式。
spline: explain
flutterExample: custom-theme
---

## 主题的作用范围

全局颜色、字体和间距等 Token 通过 `TThemeData` 配置；`TThemeBuilder` 把 Token 转为 Flutter `ThemeData`。组件局部外观使用对应 `T*ThemeData`，单个组件可用的实例配置以组件 API 为准。

| 想修改什么 | 配置入口 | 注意事项 |
| --- | --- | --- |
| 整个应用的颜色、字体、间距等 | `TThemeData` + `TThemeBuilder` | 为浅色和深色准备对应 Token |
| 一类组件支持的默认样式 | `TButtonThemeData`、`TTagThemeData` 等 | 只配置该组件公开支持的字段 |
| 某个页面或区域 | 子树 `Theme` + `mergeExtension` | 从当前主题合并，保留其他扩展 |
| 某个实例的尺寸、状态或内容 | 该组件的构造参数 | 具体能力以当前依赖版本的 API 为准 |

使用 `context.tTheme` 读取当前子树主题。`TThemeData.defaultData()` 返回默认配置，不能代替当前上下文的主题。TD 内置视觉不隐式继承 Material 组件主题；自定义内容仍可使用 Flutter 的主题机制。

右侧预览展示 JSON 配色、局部标签样式和明暗切换。点击“默认主题 / 业务主题”可比较配色，点击模式按钮可切换整页外观。资源文件加载按下方步骤接入。[查看预览源码](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/documentation_theme_demo.dart)。

示例使用以下导入：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## JSON 配置

以下绿色业务主题同时配置品牌状态色、背景、文字和边框；未列出的 Token 保留对应模式的默认值。将配置传入下方的主题构建函数，即可应用到页面和组件：

<!-- documentation-example:theme-json:start -->
```dart
const themeJson = '''
{
  "green": {"color": {
    "brandColor": "#16875D", "brandColorLight": "#E5F5ED",
    "brandColorFocus": "#C5E8D6", "brandColorActive": "#106B49",
    "brandColorDisabled": "#A6D6BF", "bgColorPage": "#EFF7F2",
    "bgColorContainer": "#FFFFFF", "textColorPrimary": "#183C2C",
    "textColorSecondary": "#526E60", "componentBorder": "#A8CDBA",
    "componentStroke": "#D4E8DD"
  }},
  "greenDark": {"color": {
    "brandColor": "#56C08D", "brandColorLight": "#183D2D",
    "brandColorFocus": "#24543D", "brandColorActive": "#78D4A6",
    "brandColorDisabled": "#315B45", "bgColorPage": "#101F18",
    "bgColorContainer": "#192E23", "textColorPrimary": "#E2F3E9",
    "textColorSecondary": "#A5C6B3", "componentBorder": "#537A64",
    "componentStroke": "#304C3D", "textColorAnti": "#102B1B"
  }}
}
''';

TThemeData createTheme() =>
    TThemeData.fromJson('green', themeJson, darkName: 'greenDark')!;
```
<!-- documentation-example:theme-json:end -->

运行效果：切换“默认主题 / 业务主题”，观察同一个业务卡片中的按钮、标签、输入框、背景、文字和边框一起变化；明暗模式与主题选择相互独立，整页同步。下方色值表展示当前主题的浅深色配置。

[单独打开运行示例](/flutter/example/#custom-theme-json)

JSON 中未覆盖的 Token 按所属模式继承默认浅色或深色配置，背景和文字也会随模式切换。JSON 使用命名主题对象；`green`、`greenDark` 必须与调用中的名称一致。`fromJson` 返回可空结果，加载失败时可回退默认主题。完整字段见 [主题 API](/flutter/components/theme?tab=api)，默认 Token 定义见[默认主题源码](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/lib/src/theme/t_default_theme.dart)。

配置来自资源文件时，先在应用 `pubspec.yaml` 的 `flutter.assets` 注册文件，再通过 `rootBundle.loadString` 读取；这需要导入 `package:flutter/services.dart`。读取完成后再构建或更新应用主题，不在 Widget 的每次 build 中重复加载。

## 从业务资源加载主题

将上面的 JSON 保存为 `assets/custom_theme.json`（不包含 Dart 的变量声明和三引号）。`green` / `greenDark` 是这份配置的浅色和深色主题名称，加载时使用相同名称。

在应用 `pubspec.yaml` 登记资源，然后执行 `flutter pub get`：

```yaml
flutter:
  assets:
    - assets/custom_theme.json
```

在 `lib/main.dart` 导入以下两个入口，并加入资源加载与启动函数：

```dart
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

<!-- documentation-example:theme-asset:start -->
```dart
Future<TThemeData> loadTheme() async {
  final json = await rootBundle.loadString('assets/custom_theme.json');
  final tokens = TThemeData.fromJson('green', json, darkName: 'greenDark');
  if (tokens == null) {
    throw const FormatException('主题 JSON 缺少 green 配置或格式错误');
  }
  return tokens;
}

Future<void> runThemeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tokens = await loadTheme();
  runApp(
    MaterialApp(
      theme: TThemeBuilder.light(tokens),
      darkTheme: TThemeBuilder.dark(tokens),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: const TNavBar(title: Text('资源主题')),
        body: Center(
          child: TButton(
            colorPreset: TButtonColorPreset.primary,
            onPressed: () {},
            child: const Text('主题按钮'),
          ),
        ),
      ),
    ),
  );
}
```
<!-- documentation-example:theme-asset:end -->

最后使用 `Future<void> main() => runThemeApp();` 作为应用入口。资源只在启动时加载一次，不放进 Widget 的 `build`。文件不存在、JSON 格式错误或缺少 `green` 配置时，加载函数会抛出异常。缺少 `greenDark` 不会使 `fromJson` 返回 `null`；使用自定义深色主题时，请同时提供该配置。

`rootBundle.loadString` 的文件路径须与资源注册路径一致；`fromJson` 的 `green`、`greenDark` 对应 JSON 内的主题键名，与文件名无关。加载成功后，同一对象分别传给 `TThemeBuilder.light` 与 `dark`，由 `themeMode` 决定当前外观。

## 组件局部样式

通过 `mergeExtension` 合并指定类型的主题扩展，保留子树中的其他扩展：

<!-- documentation-example:theme-local:start -->
```dart
Widget wrapLocalTheme(BuildContext context, Widget child) {
  return Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TTagThemeData(squareBorderRadius: 6)),
    child: child,
  );
}
```
<!-- documentation-example:theme-local:end -->

运行效果：对比默认标签与圆角为 6 的局部主题标签。

[单独打开运行示例](/flutter/example/#custom-theme-local)

传入组件必须处于这个 `Theme` 子树内；需要读取更新后主题时，在子树的 `Builder` 或独立 Widget 中取得 context。

## 文字默认值与组件文字槽

**普通位置用正文默认值，组件文字槽用组件默认值，自己明确设置的样式优先。**

| 使用位置 | 默认样式来源 | 如何定制 |
| --- | --- | --- |
| 普通位置的 `TText('说明')` | 最近的 `TTextThemeData`，未配置字段回退 TD 正文 Token | 子树文字主题或实例 `style` / `font` |
| `TButton` 的 `child` 文字 | 按钮尺寸、配色和当前状态的文案样式 | 按钮已有样式入口，或内容实例的显式文字样式 |
| `TNavBar` 的 `title` 文字 | 导航标题字体和标题色，默认单行省略 | `TNavBarThemeData`，或标题实例的显式文字样式 |

全局 `TTextThemeData` 仍可配置，但它表达通用默认，不强制所有场景使用相同字体。组件文字槽覆盖外层默认中的同名字段，其余字段继续保留；内容内部更近的 TD 文字主题可重新提供局部默认。文字实例的显式字段优先，`style` 同名字段又优先于 `font`。

未传 `style`、空 `TextStyle()`、只设置颜色，遵循同一规则：未设置字段继续采用所在位置默认。`TextStyle(inherit: false)` 是已有的整体替换行为。富文本的基础样式遵循相同规则，span 保留自己的显式样式。

全站字体族和各类字体规格通过 TD Token 配置；正文、按钮文案和导航标题分别使用各自的语义规格。调整正文默认字号，不等于强制修改所有按钮和标题。TText 的字体与颜色仍不自动读取外部 Material `TextTheme` 或 `DefaultTextStyle.style`；缩放、方向和已有段落环境行为不因此取消。

### Button / NavBar 旧用法迁移

Button、NavBar 的文字槽现在同时向原生 `Text` 和 `TText` 提供组件默认。这是默认行为变化：旧无样式或部分样式 TText 的字号、字重、颜色、自然宽度和省略位置可能改变，不会通过新增兼容配置切换。

希望使用组件默认时，直接传入 `TText('提交')` 或 `TText('首页')`。希望保留旧正文外观时，通过现有 `TText.style` / `font` 明确原来依赖的字段，或者在内容内部提供局部 `TTextThemeData`；不要再依赖组件外层通用文字主题强制统一外观。只显式指定红色时，红色会保留，其余字体字段仍采用组件默认；该红色也优先于按钮禁用前景色。

复合标题的主副文案都会接受标题默认；需要较小副标题时，在副标题上明确字号、行高或颜色。此规则仅描述已适配的文字槽，不代表所有自定义 Widget 区域都由组件接管。Button 图标、NavBar 操作项与整块自定义布局仍保持各自职责。

## 明暗模式

浅色、深色和跟随系统由 `MaterialApp.themeMode` 决定：

<!-- documentation-example:theme-mode:start -->
```dart
Widget buildThemeApp(ThemeMode mode, Widget home, {TThemeData? tokens}) {
  tokens ??= createTheme();
  return MaterialApp(
    theme: TThemeBuilder.light(tokens),
    darkTheme: TThemeBuilder.dark(tokens),
    themeMode: mode,
    home: home,
  );
}
```
<!-- documentation-example:theme-mode:end -->

运行效果：点击浅色、深色或跟随系统，观察品牌色、组件与背景变化。

[单独打开运行示例](/flutter/example/#custom-theme-mode)

`tokens` 同时包含浅色配置 `green` 与深色配置 `greenDark`。`TThemeBuilder.light(tokens)` 使用浅色配置，`TThemeBuilder.dark(tokens)` 使用深色配置；两者传入同一个对象，并不表示使用同一套配色。

- `ThemeMode.light`：固定浅色。
- `ThemeMode.dark`：固定深色。
- `ThemeMode.system`：跟随系统外观。

业务保存用户的外观选择，在切换时重建 `MaterialApp` 并传入新的 `mode`。自定义深色配色必须提供相应的深色主题配置，不能只把浅色颜色整体变暗。

## 主题工具与色板预览

[Theme 主题](/flutter/components/theme) 展示功能色、文字与图标颜色、中性色板，并提供主题 API 查询。页面中的色板会根据当前上下文重新读取主题。

从主题工具下载完整的 `theme.css` 后，可以在仓库中离线转换为组件包支持的 JSON。无需手动拆分明暗规则，也无需删除字体配置或将小数字号取整：

```sh
git clone https://github.com/Tencent/tdesign-flutter.git
cd tdesign-flutter/tdesign-component/example
flutter pub get
dart run tool/convert_theme.dart /path/to/theme.css /path/to/theme.json --name ocean
```

工具从完整 CSS 读取浅色、深色和共享结构变量，复用 `css2token` 映射，保留字体小数精度；缺失的复合字体字段按对应明暗默认主题补齐（含字重）。模式专属规则优先于共享 `:root`，相同类型规则按源码顺序覆盖。输出主题名称为 `ocean` 和 `oceanDark`，可用 `--dark-name night` 指定深色名称；加载时须传相同的 `darkName`。

将输出文件加入业务应用的 `assets/theme.json`，在业务 `pubspec.yaml` 注册：

```yaml
flutter:
  assets:
    - assets/theme.json
```

然后加载并传给明暗构建器（需导入 `package:flutter/material.dart`、`package:flutter/services.dart` 和 `package:tdesign_flutter/tdesign_flutter.dart`）：

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final json = await rootBundle.loadString('assets/theme.json');
  final tokens = TThemeData.fromJson('ocean', json, darkName: 'oceanDark');
  if (tokens == null) throw const FormatException('Invalid theme.json');
  runApp(MaterialApp(
    theme: TThemeBuilder.light(tokens),
    darkTheme: TThemeBuilder.dark(tokens),
    themeMode: ThemeMode.system,
    home: const Scaffold(body: Center(child: TText('主题已加载'))),
  ));
}
```

业务运行时只依赖组件包和生成后的 JSON，不需要复制转换器、依赖 `css2token` 或站点 Web 消息接收适配。已有整数 JSON 配置继续可用。该字体小数修复需要使用包含 #1173 修复的组件版本；旧 1.0.0 不具备该能力，仅更新转换工具不能修复旧版解析器。

转换工具位于[Example/tool/convert_theme.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/tool/convert_theme.dart)，映射复用仓库内[css2token](https://github.com/Tencent/tdesign-flutter/tree/develop/packages/css2token)。这是构建时的生成器导出接入工具，不是组件包中的运行时 CSS 导入 API。当前支持生成器的根选择器规则；嵌套规则、媒体查询或其他选择器会报错。仅转换已有映射支持的 Token，未知或不支持的 CSS 值沿用转换器的忽略规则；未提供的非字体 Token 继续继承业务组件版本默认值，不承诺浏览器 CSS 与 Flutter 逐像素一致。
