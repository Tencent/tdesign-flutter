# Text 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

自定义测量、文字便捷参数和隐式主题继承形成重复逻辑。

`TText` 当前同时承担文本绘制、网络字体加载、平台字体修正、块背景和全局字体配置，
并且只暴露已废弃的线性 `textScaleFactor`。`TTextSpan` 还会为未显式配置的字段填入
Token 默认值，阻断 Flutter 富文本的父级样式继承。

## 范围与非目标

### 目标

- 将 `TText` 收敛为 Flutter `Text` 的 TDesign Token 薄封装。
- 文字布局、字体 fallback、无障碍缩放和语义完全复用 Flutter 原生机制。
- 保留 TDesign 字体、颜色、删除线、富文本和组件 Theme 能力。
- 将异步字体加载与 Text 构建解耦，并保证并发请求安全。
- Demo 按普通文本与富文本两种构建模式组织，覆盖样式、段落、
  辅助能力、组件主题与 Flutter 原生 Text 组合方式。

### 不涉及

- 不复制小程序 Typography 的复制、展开、省略和代码样式等高级能力。
- 不实现平台 padding、强制字形垂直居中或 Web 行高修正。
- 不提供旧 API 的 deprecated 别名、转发构造器或兼容分支。

## 最终方案与行为契约

- 样式优先级为实例 style > 实例 font 预设 > TTextThemeData.textStyle > TDesign 字体 Token；DefaultTextStyle 和 Material TextTheme 不自动覆盖内置文字。
- `TextStyle.inherit == false` 保持 Flutter 原生语义，Paint 与 Color 不产生互斥断言。
- `TTextSpan` 只生成显式字段，其他样式继承父 Span。
- 未显式设置 `textScaler` 时继承 `MediaQuery.textScaler`。
- TText 不触发字体下载；字体加载完成后通过实例 TextStyle.fontFamily 或组件文字主题消费已注册字体。
- `TFontLoader` 对同一字体并发去重，失败后允许重试，同名字体不能切换 URL。
- 固定容器居中与图文 baseline 由 Flutter 父布局负责。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 保留 Flutter 原生 Text/TextSpan 行为，使用完整 style 和明确的 TDesign 字体预设。 |
| 保留的边界与代价 | 移除与完整样式同义的公开字段；组合组件显式提供其内容默认样式，不猜测外部 Material 配置。 |

## 兼容性与迁移

删除 `fontFamilyUrl`、`isInFontLoader`、`TFontLoaderWidget`、`textScaleFactor`、
`TTextConfiguration`、独立 `package`、块背景 `backgroundColor` 和
`TTextSpan.context`。`data` 与 `TText.rich.textSpan` 改为非空。

TTextThemeData 只保留 textStyle、strutStyle、textWidthBasis、textHeightBehavior；旧 font 与同义便捷样式迁移到 textStyle，实例 font 仍是字体 Token 预设。

迁移时将 `textScaleFactor` 改为 `textScaler: TextScaler.linear(...)`；未传值继续响应系统非线性缩放。在线字体先在业务层调用 `TFontLoader.load`，加载成功后通过 `style.fontFamily` 消费；字体 package 同样由 `TextStyle` 表达，不恢复旧 `FontFamily` 便捷入口。块背景使用父级 `ColoredBox`/`Container`，行内字形背景使用 `TextStyle.backgroundColor`；可空文本由调用方明确兜底。正式版本迁移见 [用户指南](../../../tdesign-site/site/docs/migration-0.2.7-to-1.0.md)。

## 验收标准

- 默认、显式配置、关键状态与边界行为符合最终方案；功能、视觉和人工路径按适用范围分别验收。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
