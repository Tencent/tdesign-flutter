# Collapse 设计对齐

## 证据与目标

- Flutter 基线：`origin/develop@2ed620b9`。
- Figma：Collapse `28600:37263`，375 宽移动端展示。
- 小程序：`origin/develop@cc2384cc5` 的 Collapse Demo、API 与样式。
- 公开 Demo 顺序收敛为基础、带操作说明、手风琴、卡片；使用中文标题和内容，并覆盖设计稿中的初始展开状态。
- Flutter 使用组级 `List<T> value` / `ValueChanged<List<T>>? onChanged` 表达
  multiple 与 accordion 的统一受控状态，不复制小程序的非受控
  `defaultValue` / `defaultExpandAll`。

## 公开 API 契约

- `TCollapse.children` 保持 `List<TCollapsePanel<T>>`，对应小程序默认插槽中的
  有序 Panel 列表。
- `TCollapse.value` 改为必传 `List<T>`，是所有模式唯一的展开状态源；列表值必须
  唯一，且全部匹配唯一的 `TCollapsePanel.value`。
- `TCollapse.onChanged` 统一返回点击后的完整展开列表；为 `null` 时整组不可交互，
  不再增加与 nullable callback 重复的组级 `disabled`。
- `TCollapseMode.multiple` 允许多个展开值；`TCollapseMode.accordion` 最多允许一个
  展开值，再次点击已展开项返回空列表。
- `TCollapsePanel.value` 改为必传；移除 Panel 级 `isExpanded` 和组级
  `onExpansionChanged`，不保留第二套状态或事件源。
- `leadingBuilder`、`trailingBuilder`、`expandIconBuilder` 均接收当前
  `isExpanded` 并返回 Widget，分别对应头部 leading、操作区和展开图标。
- `expandIconBuilder` 省略时使用 TDesign 默认箭头，显式传 `null` 时隐藏箭头，
  传入 builder 时替换默认箭头；不增加重复的 `showExpandIcon`。
- 移除仅返回 String 的 `expandIconTextBuilder`，操作文案迁移到
  `trailingBuilder`。

## 行为契约

- 基础、操作说明各一个面板且默认展开。
- 手风琴和卡片各三项；两组均为第一项初始展开。
- 手风琴与卡片末项均为可交互的普通面板，不展示禁用态。
- 公开 Demo 不展示仅供内部验证的“单元测试”模块。
- 通栏及展开内容分隔线左缩进 16，标题最小高度与设计稿一致。
- `onChanged == null` 或 Panel `disabled == true` 时对应面板不可点击，并暴露禁用
  语义与视觉；父级不可交互时 Panel 不能自行重新启用。
- 自定义 leading、trailing 和展开图标使用组件提供的默认/禁用
  `DefaultTextStyle` 与 `IconTheme`，整个 Header 仍是唯一的展开点击目标。

## 验收

- [x] Demo 结构和交互测试通过。
- [x] 组件回归和覆盖率门禁通过。
- [x] Flutter 3.32.0 与 latest analyze/test 通过。
- [x] Flutter 3.32.0 Linux light/dark Golden 更新后复验通过。
- [x] 统一受控 API、三个 Header 扩展点及迁移后的 Demo/文档通过双版本回归。
