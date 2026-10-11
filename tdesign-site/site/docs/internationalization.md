---
title: 国际化
description: 接入业务语言资源，并让 TDesign 组件文案跟随语言切换。
spline: explain
---

TDesign 默认文案为中文。需要其他语言时，按下面三步接入。

## 1. 配置 Flutter 语言资源

在 `MaterialApp` 中配置 `localizationsDelegates`、`supportedLocales` 和业务生成的 `AppLocalizations`。已有 Flutter 国际化配置的应用可以直接进入下一步；配置方法见[Flutter 国际化文档](https://docs.flutter.cn/ui/accessibility-and-internationalization/internationalization)。

## 2. 实现组件资源代理

参考[完整 IntlResourceDelegate](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/base/intl_resource_delegate.dart)，将其语言资源替换为业务的 `AppLocalizations`，保存到 `intl_resource_delegate.dart`。

代理须实现 `TResourceDelegate` 的全部抽象成员；具有中文默认实现的上传文案等资源也应覆盖，避免切换语言后仍显示中文。

## 3. 注册代理并切换语言

将下面代码放在代理文件旁，在应用入口调用 `configureTDesignResources()`，再执行 `runApp`：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'intl_resource_delegate.dart';

void configureTDesignResources() {
  setTResourceBuilder(
    (context) => IntlResourceDelegate(context),
    needAlwaysBuild: true,
  );
}
```

组件读取资源时使用回调传入的当前 `context`，它应能访问 `MaterialApp` 的语言资源。无需提前缓存页面 context；注册一次即可，代理配置在应用中全局生效。

切换语言时更新 `MaterialApp.locale` 并让相关组件重新构建。`needAlwaysBuild: true` 保证每次读取使用当前语言，本身不会触发界面重建。

最后检查组件按钮、日期、无障碍标签和上传文案是否随业务语言一起切换。完整注册示例见 [main.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/main.dart)，资源接口见 [Theme API](/flutter/components/theme)。
