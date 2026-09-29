# 实施方案

## 技术方案

1. 固定小程序源码提交，抽取全局主题变量、组件 CSS 变量与默认引用，抽取 Flutter 默认主题及组件 ThemeExtension/消费代码。
2. 先按名称列集合差异，再解析别名、颜色表达、`rpx`、字体组合与组件映射，区分真实差异和表示方式差异。
3. 先迁移 Flutter 独有全局键和同名异义键的消费端，再全量导入小程序全局集合与默认值；组件变量建立完整映射，按真实子树定制需求开放 Theme 字段。小程序自身的命名歧义不擅自修正，只在报告列明。
4. 以最终实现的组件/主题回归和设计稿后续比对校验可见效果。
5. 对同名同默认值的全局颜色另比对 `ref` 链与类型化 getter：浅色 `bgColorContainer → fontWhite1`，明暗 `textColorAnti → fontWhite1`，浅色 `textColorBrand/textColorLink → brandColor`，暗色后两者 `→ primaryColor8`。移除会遮住引用的同键字面值，并用自定义上游与直接覆盖下游的测试验证优先级。
6. 按用户提供的全局 Radius 规范与小程序源码统一明暗默认配置：`radiusSmall/Default/Large/ExtraLarge = 3/6/9/12dp`、`radiusRound = 999dp`；移除此前按另一套 Figma 档位新增的全局 `radiusMedium`。头像原来借用 medium 取得 6dp，改为引用语义对应的 `radiusDefault`。`radiusCircle` 保持已裁定的 Flutter 固定半径平台表达，并在审计中明列 CSS 50% 的差异。
7. Tag 方形圆角按用户裁定：组件 Theme 显式值优先，否则读取全局 `radiusSmall = 3dp`，不再固定为小程序组件变量原有的 `8rpx ≈ 4dp`。验证默认路径和局部覆盖路径；只在确认差异来源后更新 Tag Golden。

## Tag 内容宽度与 Padding

- 默认不写死设计稿单个实例的 38px 外宽。让文字按最终使用的字体、字号、字重和字距自然排版，再由组件加左右内边距；图标、关闭按钮存在时计入各自宽度和间距。不同文字、平台字体或字体缩放下，外宽可以不同。
- medium 普通态每侧保留 8dp 水平内边距。描边宽度为 1dp 时，每侧内容内边距减为 7dp，由「1dp 边框 + 7dp 内边距」保持相同的 8dp 外侧预算。不要把描边另外叠加到目标宽度，也不要为弥补字体差异把 8dp 改成 8.75dp。
- 核对字体族是否真正传到 Tag 内部 `Text`；仅从全局 `fontBodySmall` 取得 12dp 字号，不等于使用了设计稿的 PingFang SC 字形。固定文案、视口、DPR、缩放和字体后，分别量文字排版宽度、组件外宽与左右内边距，再决定是否需要组件字体解析修复。当前 Figma 的 38px 减去两侧 8px 得到约 22px，是间接推算，不是已直接测得的字形宽度。

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
- `radiusSmall`、`radiusDefault` 回归小程序全局默认的 3/6dp；移除尚未合并、仅为另一套 Figma 档位新增的 `radiusMedium` getter 与 Theme JSON 键。`radiusLarge/ExtraLarge/Round` 保持 9/12/999dp；`radiusCircle` 的百分比与固定半径差异继续明列。
- `TTagThemeData.squareBorderRadius` 是方形 Tag 独立覆盖入口；未覆盖时从全局 `radiusSmall = 3dp` 读取。小程序独立组件变量原默认 8rpx，已按用户裁定改走全局 small 回退，是可见的默认行为变化。
- 组件 CSS 变量是否全部暴露为独立的公开 Flutter Theme 字段仍待确认；审计范围不依赖该选择。

## 风险与取舍

- 小程序 `spacer-4` 为 `64rpx`，Flutter `spacer4` 为 4 逻辑像素；同名异义。
- Flutter 显式 Material 主题与组件 ThemeExtension 的覆盖优先级必须保持可解释，不能把 Token 默认值预填到高优先级覆盖层。
- `radiusCircle` 的 CSS `50%` 与 Flutter 固定 `9999dp` 不是同值；浅色 `grayColor3` 也按设计稿保留与小程序的色值例外，及其 4 个引用项。审计必须明列两项根因，不能把引用项误算为独立决策。CSS 阴影和响应式 `rpx` 与 Flutter 的几何对象不能只做数值比较。
- 共享 Token 改动会影响多个组件；需按消费范围扩大验证。

## 验证策略

- 单元测试：Token 名称、值、明暗模式及覆盖回退。
- Widget 测试：受影响组件的实际样式解析。
- 静态检查：双版本 `flutter analyze --fatal-infos`。
- 视觉：稳定后先运行无更新 Golden，再人工核对设计稿歧义。
