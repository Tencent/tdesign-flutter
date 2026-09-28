# 小程序与 Flutter Token 对齐

## 背景

Flutter 当前主题包含全局 Token 和组件 ThemeExtension；小程序同时包含全局 CSS 变量及组件 CSS 变量。两端存在命名、默认值、组件消费路径和单位差异，不能通过字符串替换证明一致。

## 目标

- 以 `tdesign-miniprogram/develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5` 为本轮冻结基线，逐项核对全局与组件 Token。
- 全局 Token 的集合和名称以小程序为唯一基准（Dart 仅做 camelCase 转写）；默认值除 `radiusCircle` 的 Flutter 几何例外外均与小程序对齐。尺寸以 375 逻辑像素宽的 `2rpx = 1 Flutter 逻辑像素` 为比较基准。
- 明确报告同名但值不同、Flutter 独有、小程序独有、同名异义、平台不可直接等价的项目。
- 记录尚待设计稿裁定的差异，不通过猜测掩盖它们。

## 非目标

- 本轮不进行设计稿像素比对，也不假定 375 宽基准换算在所有屏宽上严格等价。
- 不把小程序 `theme` 等组件参数、CSS 语法和布局机制机械复制为 Flutter API。
- 不修改无关 Demo 布局或已有未跟踪文件。

## 范围

### 涉及

- 全局颜色、字体、间距、圆角、阴影等 Token 的明暗主题定义及公开访问方式。
- 组件 CSS 变量与 Flutter 对应组件的默认样式、ThemeExtension 覆盖入口和 Token 消费路径。
- 差异清单、映射回归测试与必要的组件视觉回归。

### 不涉及

- 与设计稿不一致但小程序源码无法裁定的视觉值；此类差异只记录。
- 平台专属交互能力的跨端 API 复制。

## 行为契约

- 全局 Token 以小程序的语义和值为基准，唯一已确认的默认值例外是 `radiusCircle`；组件可配置项显式值优先，未配置时使用相应全局 Token 或组件内置默认值。
- 全局颜色 Token 的 `var(--td-...)` 引用关系也是契约：自定义被引用的上游 Token 后，下游默认值随之变化；直接自定义下游 Token 时，直接值优先。Flutter 的明暗主题均需保持小程序各自的引用链，而不仅是出厂色值相同。
- 每个全局颜色键均有同名的类型化 Flutter getter；底层 `colorMap` 中存在键不等于公开读取入口齐备。
- Flutter 独有的全局 Token 默认退出全局公开契约。若组件仍需对应视觉值，应改用小程序组件变量、Flutter 组件 Theme 字段或局部实现值；不能为保留旧名称而伪造小程序全局 Token。
- 小程序全局 Token 全量转写；组件 CSS 变量先逐项建立来源、默认引用及 Flutter 去向映射，只对实际需要子树配置的视觉字段开放组件 Theme，不机械制造约千个字段。
- 小程序自身的跨层命名歧义保持原样，例如 Tag `danger` 默认引用全局 `errorColor`；把歧义与覆盖链列入报告，留待设计稿与使用场景评判。
- 组件配色选择器（如 Tag `primary`）不是全局 Token；其具体颜色映射参照小程序组件变量。
- Tag 浅色 `warning` / `danger` / `success` 的组件默认来源分别是全局 `warningColor1` / `errorColor1` / `successColor1`；即使同名 `*ColorLight` 的出厂值相同，也不得用别名替代该引用链。用户自定义两者为不同值时，Tag 应跟随色阶 1。
- Tag 的普通 `outline` 变体在小程序中被统一覆盖为 `tagOutlineBgColor → bgColorContainer` 背景；其 `default` 描边是 `tagDefaultColor → bgColorComponent`，不是透明背景与 `componentBorder`。Flutter 的 `lightOutline` 是另一变体，不套用这条背景覆盖。
- Tag 的 `square` 外圆角固定来自组件变量 `8rpx → 4dp`，不随全局 `radiusSmall`（3dp）变化；关闭图标默认色来自 `tagCloseIconColor → textColorPlaceholder`，不跟随标签文字色。两项都不因默认值修正而新增同义 Theme 入口。
- `rpx` 转换后的固定逻辑像素与小程序屏宽自适应行为分别记录，不混称完全等价。
- 同名异义的 Token（例如小程序 `spacer-4` 与当前 Flutter `spacer4`）先迁移消费端语义，再由小程序定义占据该名称；旧 Flutter 语义不得继续以同名全局 Token 存在。
- `radiusCircle` 是有记录的 Flutter 几何例外：小程序值为 CSS `50%`，Flutter 保留固定 `9999` 逻辑像素圆角。Flutter 的 `double` getter 和自定义值均解释为逻辑像素；BackTop 正圆的背景、边框使用同一个 `RoundedRectangleBorder`。半圆 BackTop 与 TabBar 胶囊使用 `radiusRound`，不得把 `radiusCircle` 当作通用胶囊半径，也不再额外公开仅供一个组件使用的 `radiusCircleBorder` 辅助 API。该例外不计为其他全局 Token 已对齐的证据。

## 验收标准

- [ ] 全局与组件 Token 均有可追溯的小程序来源、Flutter 去向和分类。
- [ ] 同名不同值、Flutter 独有及未能等价转化的清单可复现。
- [ ] 已实施的映射有聚焦测试；视觉变化有无更新 Golden 比对结果。
- [ ] Flutter 3.32.0 与 latest 的分析和非视觉回归结果已记录。
