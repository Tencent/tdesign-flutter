---
title: 常见问题
description: 
spline: explain
---

## 版本节奏

1.0 当前处于预发布阶段，版本按功能完成和验证进度发布，不承诺固定的月度发布日期。已发布版本见 [Releases](https://github.com/Tencent/tdesign-flutter/releases)，后续计划以 [Issues](https://github.com/Tencent/tdesign-flutter/issues) 和对应里程碑为准。

## 自定义主题
- 自定义主题用法请参考：https://tdesign.tencent.com/flutter/getting-started#%E8%87%AA%E5%AE%9A%E4%B9%89%E4%B8%BB%E9%A2%98
- 在启动即修改主题颜色，完整示例代码请参考：https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/component_test/test_app.dart
- 在应用使用中切换主题颜色，示例代码请参考 Example App 的 `main.dart` 和 `home.dart`：https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/main.dart
- 转换完整代码：https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/shell/theme/css2_json_theme.dart

## 深色模式

可参考[深色模式](https://tdesign.tencent.com/flutter/dark-mode)

## 新增组件

如果有新增组件的想法，可以提 [issue](https://github.com/Tencent/tdesign-flutter/issues)，或者在已有 issue 补充。如果想提交代码，开发实现，可以拉负责人一起评估。

## Input相关
- 自定义高度：TInput没有自带 `height` 参数，可以通过外部嵌套 `SizedBox` 来修改高度。不过修改高度后，内部相关高度不会等比缩放，需要业务自己同步修改。
- 输入正则：`FilteringTextInputFormatter.allow` 会保留新编辑值中匹配的片段，并过滤不匹配的片段；不要使用 `^`、`$` 来校验整个输入值。需要接受或拒绝完整编辑值时，使用 `TextInputFormatter.withFunction`。

## TImage缓存问题

`TImage`基于系统 [Image](https://api.flutter.dev/flutter/widgets/Image-class.html) 组件封装，未单独处理缓存逻辑，使用的是系统组件自带的缓存。

## Toast 使用context

`TToast` 需要仍处于挂载状态、能够访问 `Overlay` 的 `BuildContext`。优先使用当前页面的 context；异步操作后先检查 `context.mounted`，再显示提示。不要长期保存页面 context。

## 内部写死的颜色或尺寸

如果发现组件内部写死了颜色或尺寸，导致无法适应业务场景，可以直接提 [issue](https://github.com/Tencent/tdesign-flutter/issues) 优化。

## Flutter SDK 版本要求

TDesign Flutter v1 的最低支持版本为 Flutter `3.32.0`。

## 文字居中

`TText` 使用 Flutter 的文本布局。水平对齐使用 `textAlign`，容器内对齐使用 `Center` 或 `Align`；行高与字体布局可通过 `style`、`strutStyle` 和 `textHeightBehavior` 配置。

示例见 [Text 文档](https://tdesign.tencent.com/flutter/components/text) 和 [文本示例源码](https://github.com/Tencent/tdesign-flutter/tree/develop/tdesign-component/example/lib/page/text)。
