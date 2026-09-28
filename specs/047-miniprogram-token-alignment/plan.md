# 实施方案

## 技术方案

1. 固定小程序源码提交，抽取全局主题变量、组件 CSS 变量与默认引用，抽取 Flutter 默认主题及组件 ThemeExtension/消费代码。
2. 先按名称列集合差异，再解析别名、颜色表达、`rpx`、字体组合与组件映射，区分真实差异和表示方式差异。
3. 先迁移 Flutter 独有全局键和同名异义键的消费端，再全量导入小程序全局集合与默认值；组件变量建立完整映射，按真实子树定制需求开放 Theme 字段。小程序自身的命名歧义不擅自修正，只在报告列明。
4. 以最终实现的组件/主题回归和设计稿后续比对校验可见效果。
5. 对同名同默认值的全局颜色另比对 `ref` 链与类型化 getter：浅色 `bgColorContainer → fontWhite1`，明暗 `textColorAnti → fontWhite1`，浅色 `textColorBrand/textColorLink → brandColor`，暗色后两者 `→ primaryColor8`。移除会遮住引用的同键字面值，并用自定义上游与直接覆盖下游的测试验证优先级。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 全局主题 | `tdesign-component/lib/src/theme/` | 默认值、getter、主题投影 |
| 组件 | `tdesign-component/lib/src/components/` | 默认样式、ThemeExtension 覆盖 |
| 测试 | `tdesign-component/test/`、`tool/` | 映射、主题切换与视觉回归 |
| 文档 | 本 Spec、公开 dartdoc | 转换与歧义记录 |

## API 变化

- 全局语义色的公开 getter 与 `colorMap` 键改用小程序对应名称，例如 `brandNormalColor → brandColor`、`brandClickColor`/`brandActiveColor → brandColorActive`、`textDisabledColor → textColorDisabled`。这是 breaking change，需同步迁移所有仓库内消费端和 dartdoc。
- Flutter 独有全局 Token 默认删除；平台专属的必要样式改由 Flutter 组件层持有，并在差异报告中记录例外、消费位置和迁移方式。
- `radiusCircle` 保留 Flutter 原有固定逻辑像素语义，默认 `9999`，作为小程序 CSS `50%` 的明确例外；这撤销了本轮把公开 `double` getter 解释为比例的 breaking 变更。BackTop 正圆与圆角 Demo 使用固定半径，半圆 BackTop 与 TabBar 胶囊使用 `radiusRound`；Indexes 索引项/提示气泡按各自尺寸取圆角，Flutter 专有的胶囊锚点使用 `radiusRound`。
- 组件 CSS 变量是否全部暴露为独立的公开 Flutter Theme 字段仍待确认；审计范围不依赖该选择。

## 风险与取舍

- 小程序 `spacer-4` 为 `64rpx`，Flutter `spacer4` 为 4 逻辑像素；同名异义。
- Flutter 显式 Material 主题与组件 ThemeExtension 的覆盖优先级必须保持可解释，不能把 Token 默认值预填到高优先级覆盖层。
- `radiusCircle` 的 CSS `50%` 与 Flutter 固定 `9999dp` 不是同值；审计必须明列该唯一例外。CSS 阴影和响应式 `rpx` 与 Flutter 的几何对象不能只做数值比较。
- 共享 Token 改动会影响多个组件；需按消费范围扩大验证。

## 验证策略

- 单元测试：Token 名称、值、明暗模式及覆盖回退。
- Widget 测试：受影响组件的实际样式解析。
- 静态检查：双版本 `flutter analyze --fatal-infos`。
- 视觉：稳定后先运行无更新 Golden，再人工核对设计稿歧义。
