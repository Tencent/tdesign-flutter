# TText Flutter 原生契约重构

## 背景

`TText` 当前同时承担文本绘制、网络字体加载、平台字体修正、块背景和全局字体配置，
并且只暴露已废弃的线性 `textScaleFactor`。`TTextSpan` 还会为未显式配置的字段填入
Token 默认值，阻断 Flutter 富文本的父级样式继承。

## 目标

- 将 `TText` 收敛为 Flutter `Text` 的 TDesign Token 薄封装。
- 文字布局、字体 fallback、无障碍缩放和语义完全复用 Flutter 原生机制。
- 保留 TDesign 字体、颜色、删除线、富文本和组件 Theme 能力。
- 将异步字体加载与 Text 构建解耦，并保证并发请求安全。
- Demo 按普通文本与富文本两种构建模式组织，覆盖样式、段落、
  辅助能力、组件主题与 Flutter 原生 Text 组合方式。

## 非目标

- 不复制小程序 Typography 的代码样式、ul/ol 列表与 start/middle 省略自定义绘制等高级能力（复制、展开/收起已由 Spec 023 纳入契约）。
- 不实现平台 padding、强制字形垂直居中或 Web 行高修正。
- 不提供旧 API 的 deprecated 别名、转发构造器或兼容分支。

## 行为契约

- 样式优先级为 `实例 style > 实例便利参数 > TTextThemeData > DefaultTextStyle > Material TextTheme > Token`。
- `TextStyle.inherit == false` 保持 Flutter 原生语义，Paint 与 Color 不产生互斥断言。
- `TTextSpan` 只生成显式字段，其他样式继承父 Span。
- 未显式设置 `textScaler` 时继承 `MediaQuery.textScaler`。
- `TText` 不触发字体下载；字体加载完成后通过 `fontFamily` 消费已注册字体。
- `TFontLoader` 对同一字体并发去重，失败后允许重试，同名字体不能切换 URL。
- 固定容器居中与图文 baseline 由 Flutter 父布局负责。

## Breaking API

删除 `fontFamilyUrl`、`isInFontLoader`、`TFontLoaderWidget`、`textScaleFactor`、
`TTextConfiguration`、独立 `package`、块背景 `backgroundColor` 和
`TTextSpan.context`。`data` 与 `TText.rich.textSpan` 改为非空。

`TTextThemeData` 收敛为 `font`、`textStyle`、`strutStyle`、`textWidthBasis`、
`textHeightBehavior`。
