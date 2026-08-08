---
title: 常见问题
description: 
spline: explain
---

## 版本节奏

TDesign Flutter 从 `0.2.0` 版本开始，正常情况下，每月初发一个版本，若有节假日等特殊情况再特殊处理。

新版本携带的功能，可以通过 issue 的标签查看，带`pre_x.x.x`标签的issue，则表示已开发完成，预计在x.x.x发布。

## 自定义主题
- 自定义主题用法请参考：https://tdesign.tencent.com/flutter/getting-started#%E8%87%AA%E5%AE%9A%E4%B9%89%E4%B8%BB%E9%A2%98
- 如果自定义主题未生效，请检查是否设置：`TTheme.needMultiTheme(true);`
- 在启动即修改主题颜色，完整示例代码请参考：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/component_test/test_app.dart
- 在应用使用中切换主题颜色，示例代码请参考 example 的 `main.dart` 和 `home.dart`：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/main.dart
- 转换完整代码：https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/shell/theme/css2JsonTheme.dart

## 深色模式

可参考[深色模式](https://tdesign.tencent.com/flutter/dark-mode)

## 新增组件

如果有新增组件的想法，可以提 [issue](https://github.com/Tencent/tdesign-flutter/issues)，或者在已有 issue 补充。如果想提交代码，开发实现，可以拉负责人一起评估。

## Input相关
- 自定义高度：TInput没有自带 `height` 参数，可以通过外部嵌套 `SizeBox` 来修改高度。不过修改高度后，内部相关高度不会等比缩放，需要业务自己同步修改。
- 输入正则：Input的`FilteringTextInputFormatter.allow(RegExp(r''))`的正则是匹配即将输入的单个字符串的，不是匹配已输入的整个字符串的，按字符串匹配写的正则可能导致无法输入。

## TImage缓存问题

`TImage`基于系统 [Image](https://api.flutter.dev/flutter/widgets/Image-class.html) 组件封装，未单独处理缓存逻辑，使用的是系统组件自带的缓存。

## Toast 使用context

目前 `TToast` 显示需要`context`，如果使用的是`GetX`，可以考虑是否要方法记录一个全局context，再给 TToast 使用。如果后续实现方案优化了context，将更新本文档。

## 内部写死的颜色或尺寸

如果发现组件内部写死了颜色或尺寸，导致无法适应业务场景，可以直接提 [issue](https://github.com/Tencent/tdesign-flutter/issues) 优化。

## Flutter SDK 版本要求

TDesign Flutter v1 的最低支持版本为 Flutter `3.32.0`，不再支持 Flutter 3.32 以下版本，也不再需要配置 `tdesign_flutter_adaptation` 依赖覆盖。
