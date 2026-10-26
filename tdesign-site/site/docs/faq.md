---
title: 常见问题
description: TDesign Flutter 1.0 的接入、主题、状态管理和资源使用问题。
spline: explain
---

## 使用哪个版本和 Flutter SDK？

1.0项目使用 `tdesign_flutter: ^1.0.0`，要求 Flutter ≥3.32.0、Dart ≥3.8.0。Android/iOS最低系统版本还取决于实际解析的Flutter和平台插件，应在目标宿主构建验证。完整步骤见[快速开始](./getting-started.md)。

## 从0.2.7升级，只替换TD前缀是否足够？

不足够。构造参数、回调、受控值、主题配置和已移除能力均可能变化，尤其要区分顶部页签与底部导航。请先阅读[0.2.7 → 1.0迁移指南](./migration-0.2.7-to-1.0.md)。


## 为什么组件没有跟随Material主题变化？

TD内置外观使用全局Token、组件Theme及公开实例配置。Material的按钮主题、文字主题或IconTheme不作为TD内置视觉的隐式覆盖入口。配置方法见[自定义主题](./custom-theme.md)，明暗模式也在同一指南中。

## 为什么切换主题后仍显示默认颜色？

先检查是否通过当前子树的 `context.tTheme` 读取颜色，是否错误地固定使用 `TThemeData.defaultData()`；再检查读取context是否位于新Theme之下。局部覆盖使用 `mergeExtension`，避免重建extensions列表时丢失其他主题扩展。

## 点击、输入或选择后，为什么值不变化？

受控组件需要父级接收回调、更新状态并把新value传回。仅记录回调不会更新业务值。输入框的controller和initialValue互斥，initialValue只用于初始化。具体要求见[Input](/flutter/components/input)、[Checkbox](/flutter/components/checkbox)等组件API。

## 输入内容为什么被过滤？如何调整高度？

按所需规则配置Flutter的输入格式化器。`FilteringTextInputFormatter.allow` 保留新编辑值中匹配的片段，过滤其余内容；不要使用 `^`、`$` 校验整个输入值。需要接受或拒绝完整编辑值时，使用 `TextInputFormatter.withFunction`，并按输入法组合区和实际业务规则处理。输入框布局、内容间距和文字高度应通过当前组件API、Theme和合理的外部约束配置，不能假设给外层设置高度就会让内部全部等比缩放。参见[Input](/flutter/components/input)和[Textarea](/flutter/components/textarea)。

## Toast应该使用哪个context？加载提示如何关闭？

使用目标 Navigator 和 Theme 子树中仍处于挂载状态、能够访问 Overlay 的 context；异步操作后先检查 `context.mounted`。避免长期缓存页面 context 或用全局 context 绕过局部主题。持续加载需要显式 `Duration.zero` 并在业务结束后关闭；具体句柄和关闭方式见[Toast](/flutter/components/toast)及迁移指南。

## 图片是否有独立缓存配置？

`TImage`使用Flutter的Image/ImageProvider机制。缓存与图片来源、ImageProvider及Flutter图片缓存有关，不应假定每次重建都会重新下载。加载、失败占位和裁剪配置见[Image](/flutter/components/image)。

## 为什么组件文案没有随应用语言更新？

检查完整资源代理是否已注册，读取context是否位于Localizations之下，切换语言后是否仍缓存旧代理。对接方式与检查清单见[国际化](./internationalization.md)。

## 如何调整文字居中与行高？

使用 `textAlign`、外部Center/Align以及 `style`、`strutStyle`、`textHeightBehavior`；不再使用旧版字体padding补偿。见[Text](/flutter/components/text)。

## 如何反馈问题或申请组件能力？

先查看当前组件API和示例，确认问题后在[GitHub Issues](https://github.com/Tencent/tdesign-flutter/issues)提供组件版本、Flutter版本、运行平台、最小复现及预期结果。提交修复前阅读[贡献指南](/flutter/develop)。
