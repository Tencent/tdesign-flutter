---
title: 国际化
description: 接入业务语言资源，并让 TDesign 组件文案跟随语言切换。
spline: explain
---

## 什么时候需要配置

TDesign 默认资源为中文，业务可通过 `TResourceDelegate` 和 `setTResourceBuilder` 接入 Flutter 国际化。

## 接入步骤

1. 配置 Flutter 的 `localizationsDelegates`、`supportedLocales` 和业务语言资源。
2. 继承 `TResourceDelegate` 并实现其**全部抽象成员**，包括开关、弹层、日期、无障碍标签等资源。只重写 `cancel` 和 `confirm` 不能构成可实例化的完整代理。可参考示例应用的[完整 IntlResourceDelegate](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/base/intl_resource_delegate.dart)，并替换为业务生成的 `AppLocalizations`。具有中文默认实现的资源（如上传文案）也需按业务支持的语言覆盖。
3. 使用 `setTResourceBuilder` 注入代理，传入的上下文应能访问 `MaterialApp` 提供的本地化资源。需要跟随语言切换重新解析资源时使用 `needAlwaysBuild: true`，并使用每次传入的上下文。完整接入位置见示例应用 [main.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/main.dart)。

资源代理由全局管理器保存，不是某个页面的局部语言配置。Flutter 语言资源生成与配置方法见[应用国际化文档](https://docs.flutter.cn/ui/accessibility-and-internationalization/internationalization)。

## 注入业务资源代理

下面示例假设已经按上面的完整代理实现了业务 `IntlResourceDelegate`，并将它放在当前文件旁的 `intl_resource_delegate.dart`。在应用入口调用 `configureTDesignResources()` 后，再运行你的应用：

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

注册构建器时不需要提前缓存页面 context。组件读取资源时才调用构建器，回调的 `context` 应能访问当前 `MaterialApp` 的本地化资源。这样代理可以使用当前语言，而不必长期持有一个页面的上下文。

## 切换语言与验收

业务通过状态管理更新 `MaterialApp.locale`，使依赖本地化资源的组件重新构建。`needAlwaysBuild: true` 表示每次读取资源重新调用构建器，本身不会触发界面重建。

配置完成后，分别检查业务文本、组件的默认按钮文案、日期和无障碍标签，以及具有中文默认实现的上传文案。完整代理示例用于说明实现范围，业务新增能力或升级版本时还需核对当前 `TResourceDelegate`。

应用初次接入见[快速开始](/flutter/getting-started)，资源接口见 [Theme API](/flutter/components/theme)。
