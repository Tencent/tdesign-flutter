---
title: 国际化
description: 通过当前资源代理与 Flutter Localizations 对接应用语言。
spline: explain
---

## 资源代理与应用语言

TDesign Flutter 通过 `TResourceDelegate` 提供组件内部文案，通过 `setTResourceBuilder` 注册资源代理。应用自身的翻译文件、支持语言及 Locale 切换由 Flutter `Localizations` 管理。未提供翻译的默认文案不会自动变成目标语言。

## 实现完整代理

以示例工程的[完整 IntlResourceDelegate](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/base/intl_resource_delegate.dart)为参考，将组件资源字段映射到应用生成的 `AppLocalizations`。

`TResourceDelegate` 有多个必须实现的抽象字段；只覆盖 `cancel` 和 `confirm` 不能构成可实例化的完整代理。请按[当前资源 API](/flutter/components/theme?tab=api)实现全部必填字段，并按业务需要覆盖带默认实现的字段，包括上传状态和无障碍文案。新增组件资源后也要检查对应翻译。

## 注册与配置

下面代码来自示例工程的 `lib/documentation_examples.dart`，使用已有的完整代理和生成的本地化类。在业务项目中，将两个相对导入替换成自己的对应文件：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'base/intl_resource_delegate.dart';
import 'l10n/app_localizations.dart';
```

<!-- documentation-example:intl:start -->
```dart
void configureDocumentationResources() {
  setTResourceBuilder(
    IntlResourceDelegate.new,
    needAlwaysBuild: true,
  );
}

Widget documentationLocalizedApp(Locale locale, Widget home) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}
```
<!-- documentation-example:intl:end -->

在应用启动时调用一次 `configureDocumentationResources()`，再使用 `documentationLocalizedApp` 构建应用。更新语言时，重建应用并传入新的 `Locale`。

构建器收到的是读取组件资源时的 context，必须位于配置了 `Localizations` 的应用子树中。`needAlwaysBuild: true` 让每次读取资源时都按当前 context 创建代理，避免持续复用首次语言的缓存；不需要保存全局 context 或反复修改同一个代理的 context。

示例包含中文和英文。业务的 `supportedLocales`、生成的翻译资源和代理字段映射需保持一致。框架的 Material/Widgets/Cupertino 本地化代理由示例的 `AppLocalizations.localizationsDelegates` 提供。

Flutter 翻译资源的生成与配置见[Flutter 国际化文档](https://docs.flutter.dev/ui/internationalization)。

## 检查语言切换

- 首次进入页面、运行中切换语言后，确认/取消、刷新、日期、上传及无障碍文案都应更新。
- 只有默认实现、尚未覆盖的字段需要补翻译，不能仅凭按钮文字变化认定全部组件已国际化。
- 资源构建器是全局注册；需要多个语言子树时，仍应根据传入 context 选择当前资源。
