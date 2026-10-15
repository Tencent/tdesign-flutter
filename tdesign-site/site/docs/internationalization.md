---
title: 国际化
description: 通过 TResourceDelegate 对接应用的 Flutter 国际化资源。
spline: explain
---


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
