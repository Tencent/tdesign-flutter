# ActionSheet 设计说明

前文“仅 showList/showGrid”及“不保留分组”为早期设计记录；当前源码还包含 showGridSections。本轮只核对末节的当前生命周期契约，不删除已有入口或分组能力。


## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

列表、分页与滚动宫格的参数组合、回调索引和默认几何存在歧义。

ActionSheet 当前 Demo 以自定义业务场景取代了官方小程序的公开示例矩阵，且列表描述项高度、描述色与宫格分页点颜色存在可见差异。

## 范围与非目标

### 目标

- 以 `tdesign-miniprogram` ActionSheet 当前 Demo 为唯一基线，提供一对一的公开 Demo 矩阵。
- 对齐列表描述项高度、描述文本 token 和宫格分页点 token。
- 统一默认宫格、分页宫格和多行滚动宫格的可视容量与密度语义。
- 将公开入口收敛为 `showList` 与 `showGrid`，不保留缺少公开设计证据的二次分组能力。
- 使用互斥的强类型宫格布局配置表达普通、分页与滚动模式，不允许无效参数组合。

### 涉及

- ActionSheet 列表与宫格的可见样式。
- ActionSheet 公开入口、Item、回调、宫格布局与 ThemeExtension 契约。
- ActionSheet 组件 Widget 测试。
- Example 页与自动生成的代码片段。

### 不涉及

- 不新增字符串联合 item、`suffixIcon` 或 `popupProps` 等非 Flutter-native API。
- 不以 Mobile Vue Demo 代替小程序基线。
- 不新增 Section 或其他分组数据模型。

- Popup 底层路由与动画协议。

## 最终方案与行为契约

- 无描述列表项高 56；带描述列表项高 84。
- 面板描述和 item 描述均使用 `textColorPlaceholder`。
- 面板与 Item 的 `subtitle` 为 null 或空字符串时均视为无描述，不渲染空白描述栏，
  也不计入弹层高度。
- 分页当前点使用 `brandNormalColor`，非当前点使用 `textDisabledColor`。
- `count` 表示一个可视面板期望容纳的项目数量，`rows` 表示行数，
  `items.length` 表示全部数据数量；每行列数统一由 `count ~/ rows` 推导。
- `TActionSheetGridLayout.fixed/paged/scroll` 是互斥布局；`itemMinWidth` 仅由
  `scroll` 布局持有，不存在分页与滚动同时开启或无效参数静默被忽略的状态。
- 默认宫格、分页宫格和多行滚动宫格在相同 `count` / `rows` 下使用相同的
  默认项目宽度；仅滚动布局显式 `itemMinWidth` 可以扩大项目宽度并触发滚动。
- `TActionSheetItem<T>` 只持有动作内容、状态与稳定业务值 `value`，不持有 `group`；
  选择动作只通过 `onSelected(item)` 回传，不暴露会随布局变化的全局索引。
- `TActionSheetItem.badge` 接收 `TBadgeConfig`，只描述徽标本体；列表徽标中心锚定
  标题右上角，宫格徽标中心锚定图标槽位右上角，不把徽标作为普通行内尾随内容。
  配置、局部 Theme、全局 Theme 与 ActionSheet 场景默认位置按 Badge 统一优先级
  解析，列表预留空间使用同一套字体、尺寸与 padding 数据。
  `textStyle` 只控制标题，不作为图标颜色的第二来源。宫格尾部空位由布局直接占位，不允许
  以 `item=null` 表达。需要标题与图标同色时，调用方分别设置 `textStyle` 与
  `Icon.color`，Demo 状态项不得依赖隐式联动。
- 删除 `showGroup`、`TActionSheetGroup` 与 `TActionSheetItem.group`；公开设计矩阵
  不包含二次分组能力，原有示例随统一布局入口同步迁移。
- `TActionSheetThemeData` 只持有视觉默认值，不持有 `count`、`rows`、
  `itemMinWidth` 或默认对齐等布局行为。
- `TActionSheetAlign` 只属于列表布局；宫格 Item 与面板副标题固定居中，
  `showGrid` 不暴露不能控制 Item 对齐的 `align` 参数。枚举的 `left/right` 表示
  物理左右，在 RTL 下不交换；标题、描述与徽标预留空间遵循同一物理对齐结果。
- `TActionSheetThemeData.gridItemHeight` 只提供宫格 Item 的默认高度；
  列表项高度仍由列表视觉契约决定。
- 默认、分页和滚动宫格统一复用 `TActionSheetItemWidget` 的 96dp 行高、40dp
  图标槽位、24dp 默认图标字号、8dp 图文间距和 `fontBodySmall` 标签字体；
  带描述宫格的描述文字与首行图标视觉间距为 28dp。
- Example 中常规宫格与多行滚动宫格的首个可视面板使用相同的前 8 项数据，
  使两种布局的字号、间距和图标呈现可以直接对照；13 个公开入口保持不变。
- ActionSheet 页面、常规宫格和多行滚动宫格 Golden 使用的确定性 CJK 字体必须
  覆盖实际文案字符，不得把“腾讯文档”“邮箱”“微云”或“带徽标”渲染为缺字方框。
- 多行滚动宫格先按 `count` 划分可视面板，再在每个面板内按行优先顺序排列，
  确保初始可视区域对应前 `count` 个项目。
- `count` 与 `rows` 必须为正数，`count >= rows` 且 `count` 能被 `rows` 整除。
- Example 展示 14 个场景：4 个列表类型、7 个宫格类型、1 个状态场景和 2 个对齐场景；
  分页宫格必须有独立公开入口并展示分页指示器。
- 公开页在“组件样式”后结束，不展示仅供内部验证的“单元测试”模块。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | fixed/paged/scroll 互斥布局各自持有有效参数，选择回调返回稳定业务项而非易变全局索引。 |
| 保留的边界与代价 | 徽标按真实槽位锚定；count/rows 决定网格，不增加没有设计场景的 group 或空项占位 API。 |

### 设计演变中的关键理由

- 84 高度会增加带描述列表的垂直空间，这是为了匹配官方视觉规范。
- Flutter Demo 使用本地 TDesign 图标表达小程序的远程社交平台图片，避免把网络可用性变成组件验收前提。
- 显式 `itemMinWidth` 大于自适应宽度时优先保证最小宽度，因此实际同时可见数量
  可以少于 `count`；这是调用方明确选择的滚动密度覆盖。
- 这是有意的 breaking API 重构，不提供旧签名兼容层，避免两个状态源长期并存。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 样式 token 和 84 高度有 Widget 测试保护。
- 14 个 Demo 各自有可见入口和独立代码片段。
- Widget 测试验证 `8 / 2`、`10 / 2` 的跨模式密度、滚动顺序和非法组合。
- Example 测试与 Golden 验证多行滚动 Demo 的默认可视容量和明暗视觉。
- Example 测试验证常规宫格与多行滚动宫格首屏数据和 Item 视觉指标一致。
- Flutter 3.32.0 Linux Golden 字体覆盖“腾、讯、档、箱、云、徽”且相关明暗快照无缺字方框。
- 列表徽标按标题右上角锚定，公开 Demo 的圆点与计数数据和官方移动端场景一致。
- Flutter 3.32.0 与 latest 均通过聚焦测试及严格 analyze。
- ActionSheet 生产源码 LCOV `LH/LF >= 95%`。
- 公开入口仅保留 `showList/showGrid`，旧分组 API 与分组字段完全移除。
- Widget 测试覆盖三种互斥布局、选择回调业务值以及全部非法布局参数。
- `showGrid` 无误导性对齐参数，Theme 宫格高度命名与实际作用域一致。
- 新增的宫格布局类型与选择回调已登记到 API 文档生成清单。
- Badge 槽位、标题样式与图标主题职责独立，Theme 内部插值辅助不进入公开 API。
- Demo、站点文档与生成检查全部使用新 API，13 个入口及视觉基线不减少。
- 在真实运行时与小程序基线完成页面、列表弹层像素对照，以及宫格选择、翻页等
  核心交互对照；全部入口的连续真机交互仍按 `acceptance.md` 记为未覆盖项。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。


## Popup 关闭保留的间接影响

showList、showGrid 和 showGridSections 使用 Popup 默认 false 配置，随 Popup 关闭保留修复，内容 State 在关闭后保留，同句柄 open 可重开，所属 Navigator 卸载时释放；直接使用独立面板不涉及该会话缓存。三个入口未提供 destroyOnClose，不能直接配置 true。参数限制与通用资源风险在本站 ActionSheet FAQ 说明，并精准链接 Popup FAQ；完整生命周期风险见 [Popup Spec](../018-Feedback-Popup/spec.md#faq-展示与-actionsheet-间接影响)。本轮只补文档，不修改入口、默认值、回调或绑定规则。
