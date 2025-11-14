---
title: 深色模式
description: 组件库提供了深色模式支持，可以点击官网右上角开关切换整体浅色与深色模式体验。
spline: explain
---

<div style="background: #ecf2fe; display: flex; align-items: center; line-height: 20px; padding: 14px 24px; border-radius: 3px; color: #555a65">
  <svg fill="none" viewBox="0 0 16 16" width="16px" height="16px" style="margin-right: 5px">
    <path fill="#0052d9" d="M8 15A7 7 0 108 1a7 7 0 000 14zM7.4 4h1.2v1.2H7.4V4zm.1 2.5h1V12h-1V6.5z" fillopacity="0.9"></path>
  </svg>
 该特性于 0.2.6 上线，请留意版本。
</div>

## 使用之前

使用之前，请先阅读 flutter 官方文档：[使用 Themes 统一颜色和字体风格](https://docs.flutter.cn/cookbook/design/themes)。

TDFlutter 的深色模式是基于上述 flutter 官方文档对 [ThemeData](https://api.flutter-io.cn/flutter/material/ThemeData-class.html) 进行自定义配置和重载主题实现的。

具体代码请参考 [深色模式切换](https://github.com/Tencent/tdesign-flutter/pull/768/commits/c5bf979a4b54c119e196ced2f6006deb69339fde)。
 
## 主题配置

本示例中我们要配置两套主题，浅色和深色。（你也可以根据自己的业务需求，配置更多主题）

具体请参考 [自定义主题](https://tdesign.tencent.com/flutter/getting-started#%E8%87%AA%E5%AE%9A%E4%B9%89%E4%B8%BB%E9%A2%98)。

### 深色主题配置

```json
{
  "defaultDark": {
        "ref": {
            "brandNormalColor": "brandColor8",
            "warningNormalColor": "warningColor5",
            "errorNormalColor": "errorColor6",
            "successNormalColor": "successColor5",
            "brandFocusColor": "brandColor1",
            "brandActiveColor": "brandColor9",
            "brandDisabledColor": "brandColor3",
            "brandLightColor": "brandColor1",
            "brandColorLightActive": "brandColor2",
            "warningFocusColor": "warningColor2",
            "warningActiveColor": "warningColor4",
            "warningDisabledColor": "warningColor3",
            "warningLightColor": "warningColor1",
            "warningColorLightActive": "warningColor2",
            "errorFocusColor": "errorColor2",
            "errorActiveColor": "errorColor5",
            "errorDisabledColor": "errorColor3",
            "errorLightColor": "errorColor1",
            "errorColorLightActive": "errorColor2",
            "successFocusColor": "successColor2",
            "successActiveColor": "successColor4",
            "successDisabledColor": "successColor3",
            "successLightColor": "successColor1",
            "successColorLightActive": "successColor2",
            "bgColorPage": "grayColor14",
            "bgColorContainer": "grayColor13",
            "bgColorSecondaryContainer": "grayColor12",
            "bgColorComponent": "grayColor11",
            "bgColorContainerActive": "grayColor12",
            "bgColorSecondaryContainerActive": "grayColor11",
            "bgColorComponentActive": "grayColor10",
            "bgColorComponentDisabled": "grayColor12",
            "textColorPrimary": "fontWhColor1",
            "textColorSecondary": "fontWhColor2",
            "textColorPlaceholder": "fontWhColor3",
            "textDisabledColor": "fontWhColor4",
            "textColorAnti": "fontWhColor1",
            "textColorBrand": "brandColor8",
            "textColorLink": "brandColor8",
            "componentStrokeColor": "grayColor11",
            "componentBorderColor": "grayColor9"
        },
        "color": {
            "brandColor1": "#1b2f51",
            "brandColor2": "#173463",
            "brandColor3": "#143975",
            "brandColor4": "#103d88",
            "brandColor5": "#0d429a",
            "brandColor6": "#054bbe",
            "brandColor7": "#2667d4",
            "brandColor8": "#4582e6",
            "brandColor9": "#699ef5",
            "brandColor10": "#96bbf8"
    }
  }
}
```

## 主题应用和重载

### 加载主题配置

```dart
late TDThemeData themeData;
late TDThemeData darkThemeData;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var themeJsonString = await rootBundle.loadString('assets/theme.json');
  /// 开启多套主题功能
  TDTheme.needMultiTheme(true);
  /// 默认浅色主题,xxxDark为深色主题
  themeData = TDThemeData.fromJson('red', themeJsonString, darkName: 'redDark') ??
      TDTheme.defaultData();

  runApp(const App());
}
```

### 应用主题

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
          // MaterialApp中设置theme,darkTheme,themeMode三个属性如下，如果有自定义主题属性，可以通过copyWith()方法修改。
          // 注：主题切换需要业务自己实现，比如使用Provider,具体可参考tdesign-flutter/tdesign-component/example/lib/component_test/dark_test.dart
          return MaterialApp(
            title: '深色模式切换测试',

            /// 默认浅色模式
            theme: themeData.systemThemeDataLight!.copyWith(
              /// 根据自己的需求用 TD 颜色覆盖 Material/Cupertino 的颜色
              cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
                barBackgroundColor: themeData.bgColorContainer.withOpacity(0.5),
              ),
              /// ... 更多重载主题
            ),

            /// 深色模式
            darkTheme: themeData.systemThemeDataDark?.copyWith(
              cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
                barBackgroundColor: themeData.dark?.grayColor13.withOpacity(0.5),
              ),

              /// ... 更多重载主题
            ),
            themeMode: themeModeProvider.themeMode,
    );
  }
}
```

## 主题切换设置

### 跟随系统

完成上述主题配置后，你就可以在 `MaterialApp` 中设置主题模式了。

```dart
return MaterialApp(
  title: '深色模式切换测试',
  // 默认浅色模式（已忽略细节）
  theme: _themeData.systemThemeDataLight,
  // 深色模式（已忽略细节）
  darkTheme: _themeData.systemThemeDataDark,
  // MaterialApp 主题模式默认跟随系统
  themeMode: themeMode: ThemeMode.system,
);
```

### 状态管理与持久化

除了跟随系统外，有时我们还可以让用户手动选择主题模式，并持久化该状态。

下面我们将通过 [shared_preferences](https://pub.dev/packages/shared_preferences) 持久化主题模式，并使用 [provider](https://pub.dev/packages/provider) 状态管理，实现跟随系统/手动切换主题模式。

```yaml
  provider: ^6.1.5+1
  shared_preferences: ^2.2.3
```

你也可以根据自己的业务需求，使用其他状态管理方式。

1. 新建 `ThemeModeProvider` 类，并继承 `ChangeNotifier`，添加主题模式属性和切换主题模式的方法。并使用 `SharedPreferencesAsync` 持久化主题模式。

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  /// 当前主题模式
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
      asyncPrefs.setInt('setting:theme_mode', _themeMode.index);
    }
  }

  /// 初始化主题模式
  Future<void> initThemeMode() async {
    final themeModeIndex = await asyncPrefs.getInt('setting:theme_mode');
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (themeMode) => themeMode.index == themeModeIndex,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }
}
```

2. 初始化状态管理，并在 `MaterialApp` 中使用状态管理提供的主题模式。

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) {
            // 初始化主题模式
            final provider = ThemeModeProvider();
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (provider.themeMode == ThemeMode.system) {
                await provider.initThemeMode();
              }
            });
            return provider;
          },
        ),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (context, themeModeProvider, child) {
          return MaterialApp(
            title: '深色模式切换测试',
            // 默认浅色模式（已忽略细节）
            theme: _themeData.systemThemeDataLight,
            // 深色模式（已忽略细节）
            darkTheme: _themeData.systemThemeDataDark,
            // 使用状态管理提供的主题模式
            themeMode: themeModeProvider.themeMode,
            // 主题设置页面
            home: const ThemeModeSettingsPage(),
          );
        },
      ),
    );
  }
}
```

3. 创建主题设置页面，并添加主题模式切换按钮。以下示例供参考，请根据自身业务需求进行修改。

```dart
class ThemeModeSettingsPage extends StatefulWidget {
  const ThemeModeSettingsPage({super.key});

  @override
  State<ThemeModeSettingsPage> createState() => _ThemeModeSettingsPageState();
}

class _ThemeModeSettingsPageState extends State<ThemeModeSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeModeProvider = Provider.of<ThemeModeProvider>(context);

    // 获取系统主题
    Brightness systemBrightness = MediaQuery.platformBrightnessOf(context);

    enabledModeCheckIcon(ThemeMode mode) {
      return themeModeProvider.themeMode == mode ||
              (themeModeProvider.themeMode == ThemeMode.system &&
                  systemBrightness ==
                      (mode == ThemeMode.light
                          ? Brightness.light
                          : Brightness.dark))
          ? TDIcons.check
          : null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('深色主题切换'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            TDCellGroup(
              theme: TDCellGroupTheme.cardTheme,
              cells: [
                TDCell(
                  title: '跟随系统',
                  description: '开启后，将跟随系统打开或关闭深色模式。',
                  rightIconWidget: TDSwitch(
                    isOn: themeModeProvider.themeMode == ThemeMode.system,
                    onChanged: (isOn) {
                      if (isOn) {
                        themeModeProvider.themeMode = ThemeMode.system;
                      } else if (systemBrightness == Brightness.dark) {
                        themeModeProvider.themeMode = ThemeMode.dark;
                      } else {
                        themeModeProvider.themeMode = ThemeMode.light;
                      }
                      return isOn;
                    },
                  ),
                  disabled: true,
                ),
              ],
            ),
            TDCellGroup(
              theme: TDCellGroupTheme.cardTheme,
              title: '手动选择',
              cells: [
                TDCell(
                  title: '浅色模式',
                  leftIcon: TDIcons.mode_light,
                  rightIcon: enabledModeCheckIcon(ThemeMode.light),
                  onClick: (cell) {
                    themeModeProvider.themeMode = ThemeMode.light;
                  },
                ),
                TDCell(
                  title: '深色模式',
                  leftIcon: TDIcons.mode_dark,
                  rightIcon: enabledModeCheckIcon(ThemeMode.dark),
                  onClick: (cell) {
                    themeModeProvider.themeMode = ThemeMode.dark;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

