# ActionSheet 官方基线对齐

## 背景

ActionSheet 当前 Demo 以自定义业务场景取代了官方小程序的公开示例矩阵，且列表描述项高度、描述色与宫格分页点颜色存在可见差异。

## 目标

- 以 `tdesign-miniprogram` ActionSheet 当前 Demo 为唯一基线，提供一对一的公开 Demo 矩阵。
- 对齐列表描述项高度、描述文本 token 和宫格分页点 token。
- 统一默认宫格、分页宫格和多行滚动宫格的可视容量与密度语义。
- 将公开入口收敛为 `showList` 与 `showGrid`，不保留缺少公开设计证据的二次分组能力。
- 使用互斥的强类型宫格布局配置表达普通、分页与滚动模式，不允许无效参数组合。

## 非目标

- 不新增字符串联合 item、`suffixIcon` 或 `popupProps` 等非 Flutter-native API。
- 不以 Mobile Vue Demo 代替小程序基线。
- 不新增 Section 或其他分组数据模型。

## 范围

### 涉及

- ActionSheet 列表与宫格的可见样式。
- ActionSheet 公开入口、Item、回调、宫格布局与 ThemeExtension 契约。
- ActionSheet 组件 Widget 测试。
- Example 页与自动生成的代码片段。

### 不涉及

- Popup 底层路由与动画协议。

## 行为契约

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
- `TActionSheetItem.badge` 是 Widget 槽位，不绑定具体 Badge 实现；`textStyle`
  只控制标题，不作为图标颜色的第二来源。宫格尾部空位由布局直接占位，不允许
  以 `item=null` 表达。需要标题与图标同色时，调用方分别设置 `textStyle` 与
  `Icon.color`，Demo 状态项不得依赖隐式联动。
- 删除 `showGroup`、`TActionSheetGroup` 与 `TActionSheetItem.group`；公开设计矩阵
  不包含二次分组能力，现有 13 个 Demo 不受影响。
- `TActionSheetThemeData` 只持有视觉默认值，不持有 `count`、`rows`、
  `itemMinWidth` 或默认对齐等布局行为。
- `TActionSheetAlign` 只属于列表布局；宫格 Item 与面板副标题固定居中，
  `showGrid` 不暴露不能控制 Item 对齐的 `align` 参数。
- `TActionSheetThemeData.gridItemHeight` 只提供宫格 Item 的默认高度；
  列表项高度仍由列表视觉契约决定。
- 默认、分页和滚动宫格统一复用 `TActionSheetItemWidget` 的 96dp 行高、48dp
  图标槽位、24dp 默认图标字号、8dp 图文间距和 `fontBodySmall` 标签字体。
- Example 中常规宫格与多行滚动宫格的首个可视面板使用相同的前 8 项数据，
  使两种布局的字号、间距和图标呈现可以直接对照；13 个公开入口保持不变。
- ActionSheet 页面、常规宫格和多行滚动宫格 Golden 使用的确定性 CJK 字体必须
  覆盖实际文案字符，不得把“腾讯文档”“邮箱”“微云”或“带徽标”渲染为缺字方框。
- 多行滚动宫格先按 `count` 划分可视面板，再在每个面板内按行优先顺序排列，
  确保初始可视区域对应前 `count` 个项目。
- `count` 与 `rows` 必须为正数，`count >= rows` 且 `count` 能被 `rows` 整除。
- Example 保留 13 个现有场景：4 个列表类型、6 个宫格类型、1 个状态场景和 2 个对齐场景。
- 公开页在“组件样式”后结束，不展示仅供内部验证的“单元测试”模块。

## 验收标准

- [x] 样式 token 和 84 高度有 Widget 测试保护。
- [x] 13 个 Demo 各自有可见入口和独立代码片段。
- [x] Widget 测试验证 `8 / 2`、`10 / 2` 的跨模式密度、滚动顺序和非法组合。
- [x] Example 测试与 Golden 验证多行滚动 Demo 的默认可视容量和明暗视觉。
- [x] Example 测试验证常规宫格与多行滚动宫格首屏数据和 Item 视觉指标一致。
- [x] Flutter 3.32.0 Linux Golden 字体覆盖“腾、讯、档、箱、云、徽”且相关明暗快照无缺字方框。
- [x] Flutter 3.32.0 与 latest 均通过聚焦测试及严格 analyze。
- [x] ActionSheet 生产源码 LCOV `LH/LF >= 95%`。
- [x] 公开入口仅保留 `showList/showGrid`，旧分组 API 与分组字段完全移除。
- [x] Widget 测试覆盖三种互斥布局、选择回调业务值以及全部非法布局参数。
- [x] `showGrid` 无误导性对齐参数，Theme 宫格高度命名与实际作用域一致。
- [x] 新增的宫格布局类型与选择回调已登记到 API 文档生成清单。
- [x] Badge 槽位、标题样式与图标主题职责独立，Theme 内部插值辅助不进入公开 API。
- [ ] Demo、站点文档与生成检查全部使用新 API，13 个入口及视觉基线不减少。
- [ ] 在真实运行时与小程序基线完成像素和交互对照。
