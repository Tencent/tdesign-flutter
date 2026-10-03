# 小程序与 Flutter Token 对齐

## 背景

Flutter 当前主题包含全局 Token 和组件 ThemeExtension；小程序同时包含全局 CSS 变量及组件 CSS 变量。两端存在命名、默认值、组件消费路径和单位差异，不能通过字符串替换证明一致。

## 目标

- 以 `tdesign-miniprogram/develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5` 为本轮冻结基线，逐项核对全局与组件 Token。
- 全局 Token 的集合和名称以小程序为基准（Dart 仅做 camelCase 转写）；圆角严格采用 `radiusSmall/Default/Large/ExtraLarge = 3/6/9/12dp`、`radiusRound = 999dp`，不再参考另一套 Figma 圆角变量，也不添加全局 `radiusMedium`。已裁定的其余例外为浅色 `grayColor3 = #E8E8E8`，以及 `radiusCircle` 保留 Flutter 固定半径的几何表达。其他小程序尺寸以 375 逻辑像素宽的 `2rpx = 1 Flutter 逻辑像素` 为比较基准。
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

- 全局 Token 以小程序的语义和值为基准；圆角全局键仅有 `radiusSmall/Default/Large/ExtraLarge/Round/Circle` 六项。已确认例外仅为 `radiusCircle` 的 Flutter 几何表达，以及 Figma 裁定的浅色 `grayColor3 = #E8E8E8`。组件可配置项显式值优先，未配置时使用相应全局 Token 或组件内置默认值。
- 全局颜色 Token 的 `var(--td-...)` 引用关系也是契约：自定义被引用的上游 Token 后，下游默认值随之变化；直接自定义下游 Token 时，直接值优先。Flutter 的明暗主题均需保持小程序各自的引用链，而不仅是出厂色值相同。
- 每个全局颜色键均有同名的类型化 Flutter getter；底层 `colorMap` 中存在键不等于公开读取入口齐备。
- Flutter 独有的全局 Token 退出全局公开契约，包括此前为另一套 Figma 档位新增的 `radiusMedium`。若组件仍需其他视觉值，应改用小程序组件变量、Flutter 组件 Theme 字段或局部实现值；不能为保留旧名称而伪造小程序全局 Token。
- 小程序全局 Token 全量转写；组件 CSS 变量先逐项建立来源、默认引用及 Flutter 去向映射，只对实际需要子树配置的视觉字段开放组件 Theme，不机械制造约千个字段。
- 小程序自身的跨层命名歧义保持原样，例如 Tag `danger` 默认引用全局 `errorColor`；把歧义与覆盖链列入报告，留待设计稿与使用场景评判。
- 组件配色选择器（如 Tag `primary`）不是全局 Token；其具体颜色映射参照小程序组件变量。
- Tag 浅色 `warning` / `danger` / `success` 的组件默认来源分别是全局 `warningColor1` / `errorColor1` / `successColor1`；即使同名 `*ColorLight` 的出厂值相同，也不得用别名替代该引用链。用户自定义两者为不同值时，Tag 应跟随色阶 1。
- Tag 的普通 `outline` 变体在小程序中被统一覆盖为 `tagOutlineBgColor → bgColorContainer` 背景；其 `default` 描边是 `tagDefaultColor → bgColorComponent`，不是透明背景与 `componentBorder`。Flutter 的 `lightOutline` 是另一变体，不套用这条背景覆盖。
- Tag 的 `square` 圆角由组件 `TTagThemeData.squareBorderRadius` 显式值优先，否则读取全局 `radiusSmall = 3dp`，四档共用同一个语义值，不按尺寸分档或写死组件默认数值。此项是用户对小程序 Tag 组件变量 `tagSquareBorderRadius = 8rpx` 的重新裁定；组件回退到全局 `@radius-small = 6rpx ≈ 3dp`。关闭图标默认色来自 `tagCloseIconColor → textColorPlaceholder`，不跟随标签文字色。
- Slider 正常态未选中轨道及其刻度的内置默认颜色读取全局 `componentBorder`；显式 `SliderThemeData` 与适用的 Material `ColorScheme` 仍按现有优先级覆盖。禁用态内轨仍用 `bgColorComponentDisabled`，胶囊外轨保留原有 `bgColorComponent`，不随正常态一并替换。此项按设计稿裁定，区别于小程序 `slider-default-color → bgColorComponent` 的回退。
- Avatar 默认背景读取 `brandColorLightActive`，方形头像默认圆角读取 `radiusDefault`（6dp）；组件 Theme 的背景与方形圆角显式值仍优先。圆形头像继续使用 `radiusCircle`，不受方形修正影响。
- Cell 组件默认样式不因页面底色而改变；公开 Cell Demo 的页面底色按设计稿改读 `bgColorSecondaryContainer`，组件容器仍使用各自的背景 Token。
- Tag 默认宽度由实际排版后的文字宽度、左右内边距和边框共同决定；有图标或关闭按钮时再计入其宽度与间距。设计稿中“Tag”实例的 38px 外宽是该文案和设计字体下的结果，不能作为所有文案的固定宽度，也不能通过增加内边距补偿字体度量差异。普通 medium Tag 的水平内边距为左右各 8dp；1dp 描边态的内容内边距左右各减 1dp，使边框与内边距合计的水平预算仍为每侧 8dp。显式 `TTagThemeData.fixedWidth` 和父布局约束不属于默认自然宽度规则。
- Tag 公开 Demo 的垂直边框盒按小程序字体行高、padding 和 1dp 边框计算：small 20dp、medium 24dp、large 28dp、extraLarge 40dp；上下内边距分别为 2/2/3/9dp。无描边变体把透明边框的 1dp 合并进内容 padding；描边变体保留实际边框并相应减少内容 padding，因此总高度不因 variant 改变。文字本身应用相应 `Font.height` 行盒；显式组件 Theme 字体优先，并决定单行 Tag 的对应高度。另一张 Figma“Style 组件样式”页的 16/20/24/36px 是不同尺寸规范，不能未经裁定直接替代公开 Demo 契约；字体字形与 Figma 栅格差异单独记录，不通过 Demo 外层位移修正。
- `rpx` 转换后的固定逻辑像素与小程序屏宽自适应行为分别记录，不混称完全等价。
- 同名异义的 Token（例如小程序 `spacer-4` 与当前 Flutter `spacer4`）先迁移消费端语义，再由小程序定义占据该名称；旧 Flutter 语义不得继续以同名全局 Token 存在。
- `radiusCircle` 是有记录的 Flutter 几何例外：小程序值为 CSS `50%`，Flutter 保留固定 `9999` 逻辑像素圆角。Flutter 的 `double` getter 和自定义值均解释为逻辑像素；BackTop 正圆的背景、边框使用同一个 `RoundedRectangleBorder`。半圆 BackTop 与 TabBar 胶囊使用 `radiusRound`，不得把 `radiusCircle` 当作通用胶囊半径，也不再额外公开仅供一个组件使用的 `radiusCircleBorder` 辅助 API。该例外不计为其他全局 Token 已对齐的证据。

## 验收标准

- [ ] 全局与组件 Token 均有可追溯的小程序来源、Flutter 去向和分类。
- [ ] 同名不同值、Flutter 独有及未能等价转化的清单可复现。
- [ ] 已实施的映射有聚焦测试；视觉变化有无更新 Golden 比对结果。
- [ ] Flutter 3.32.0 与 latest 的分析和非视觉回归结果已记录。
