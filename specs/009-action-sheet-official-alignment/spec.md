# ActionSheet 官方基线对齐

## 背景

ActionSheet 当前 Demo 以自定义业务场景取代了官方小程序的公开示例矩阵，且列表描述项高度、描述色与宫格分页点颜色存在可见差异。

## 目标

- 以 `tdesign-miniprogram` ActionSheet 当前 Demo 为唯一基线，提供一对一的公开 Demo 矩阵。
- 对齐列表描述项高度、描述文本 token 和宫格分页点 token。
- 统一默认宫格、分页宫格和多行滚动宫格的可视容量与密度语义。
- 保持现有强类型 `TActionSheetItem` 与命令式入口，不为追平 Web 形态扩大 API。

## 非目标

- 不删除现有 `showGroup` 公开能力。
- 不新增字符串联合 item、`suffixIcon` 或 `popupProps` 等非 Flutter-native API。
- 不以 Mobile Vue Demo 代替小程序基线。

## 范围

### 涉及

- ActionSheet 列表与宫格的可见样式。
- ActionSheet 组件 Widget 测试。
- Example 页与自动生成的代码片段。

### 不涉及

- Popup 底层路由与动画协议。
- `showGroup` 的公开签名或行为。

## 行为契约

- 无描述列表项高 56；带描述列表项高 84。
- 面板描述和 item 描述均使用 `textColorPlaceholder`。
- 分页当前点使用 `brandNormalColor`，非当前点使用 `textDisabledColor`。
- `count` 表示一个可视面板期望容纳的项目数量，`rows` 表示行数，
  `items.length` 表示全部数据数量；每行列数统一由 `count ~/ rows` 推导。
- 默认宫格、分页宫格和多行滚动宫格在相同 `count` / `rows` 下使用相同的
  默认项目宽度；仅显式 `itemMinWidth` 或 Theme 默认值可以扩大项目宽度并触发滚动。
- 默认、分页和滚动宫格统一复用 `TActionSheetItemWidget` 的 96dp 行高、48dp
  图标槽位、24dp 默认图标字号、8dp 图文间距和 `fontBodySmall` 标签字体。
- Example 中常规宫格与多行滚动宫格的首个可视面板使用相同的前 8 项数据，
  使两种布局的字号、间距和图标呈现可以直接对照；13 个公开入口保持不变。
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
- [x] Flutter 3.32.0 与 latest 均通过聚焦测试及严格 analyze。
- [x] ActionSheet 生产源码 LCOV `LH/LF >= 95%`。
- [ ] 在真实运行时与小程序基线完成像素和交互对照。
