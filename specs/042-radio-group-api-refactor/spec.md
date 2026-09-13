# Radio 单一状态源与视觉形态重构

## 背景

当前 `TRadio` 通过 `value/groupValue/onChanged` 独立持有组状态，`TRadioGroup`
又持有同一份 `value/onChanged` 并将其转发给每个选项。Group 同时负责数据生成、
布局、卡片开关、分割线和自定义项交互，导致状态入口重复，`itemBuilder` 绕过
`TRadio` 后又由 Group 补充手势与语义。

普通 Radio 只要包含标题就会隐式采用通栏最小高度、背景和内边距。Form 等紧凑
场景无法通过组件 API 表达，只能修改 Theme 间距或在 Demo 中重新拼装图标、文案、
点击与无障碍语义。

## 目标

- `TRadioGroup` 成为选中值和变更回调的唯一状态源。
- 保留 `TRadio` 与 `TRadioGroup` 两个公开 Widget，不拆分 Tile/Card 等相近组件。
- 通过互斥的 `TRadioVariant.inline/block/card` 显式表达完整视觉结构。
- 同时提供自由子树组合和标准数据生成两种 Group 调用方式。
- 普通、禁用、自定义指示器、横纵向、多列、通栏及卡片能力不退化。
- 支持 Flutter 3.32.0 与 latest。

## 非目标

- 本 Spec 不调整 `TFormItem` 的标签、padding、按钮或字段布局。
- 本 Spec 仅对 Form Demo 做新 API 的机械迁移并保持 `block` 现状；Form 在本重构
  合并后单独接入 `inline` 并验收布局。
- 不同步重构 Checkbox API。
- 不改变 Radio 的主题 token 和颜色优先级。

## 范围

### 涉及

- `TRadio`、`TRadioGroup`、`TRadioOption` 的公开契约和实现。
- Radio 官方 Demo、生成示例代码、Widget 测试和视觉回归。
- API dartdoc、Spec 与 breaking 迁移说明。

### 不涉及

- Form PR #1105 的布局修复和截图更新；仅允许保持现有视觉的编译迁移。
- Material `RadioGroup` 的直接依赖。

## 行为契约

1. `TRadioGroup<T>` 默认构造接收 `value`、`onChanged` 和 `child`，只向子树提供组状态。
2. `TRadioGroup<T>.options` 接收 `options`、标准布局及统一外观参数，并使用同一 Group
   状态机制生成 `TRadio<T>`，不得建立第二套手势或语义路径。
3. `TRadio<T>` 仅声明选项 `value` 和单项 `disabled`；选中值、整组禁用及变更回调
   必须从最近的同类型 Group 获取。缺少 Group 时抛出清晰的 `FlutterError`。
4. `onChanged == null` 表示整组禁用；`TRadio.disabled` 或
   `TRadioOption.disabled` 仅禁用对应选项。禁用项不得触发回调。
5. `TRadioVariant.inline` 不绘制通栏背景、外围 inset、标准块高或分割线；保留指示器、
   文案、内容间距、选中状态、点击和互斥语义。
6. `TRadioVariant.block` 保持现有 48/56/64 三档通栏高度、背景和内容布局；分割线由
   `.options` 的相邻项布局负责，末项不显示。
7. `TRadioVariant.card` 保持卡片选择视觉和组布局，不显示普通分割线。
8. `.options` 的 `showDivider` 为空时仅对 `block` 默认开启；显式在非 `block`
   variant 开启分割线属于非法组合并触发断言。
9. 每次有效点击最多触发一次 Group 回调，每个选项只产生一条单选语义交互链路。
10. Group 使用仓库内部 `InheritedWidget` 传递状态，不能依赖 latest-only Flutter API。
11. `.options` 的横向 `inline` 布局按内容自然收缩并换行，不使用 `columns`
    等分父约束；其他需要网格对齐的布局继续由 `columns` 约束。

## 验收标准

- [x] 公开 API 不再包含 `TRadio.groupValue`、`TRadio.onChanged`、`cardMode` 和
      `TRadioGroup.itemBuilder`。
- [x] 自由 child 和 `.options` 两条路径均正确选中、禁用并只回调一次。
- [x] inline/block/card 三种结构的尺寸、背景、指示器和分割线符合契约。
- [x] Radio Demo 全部迁移至新 API，且不通过外层样式模拟 inline 能力。
- [x] 组件测试、Demo 测试、生成器检查、analyze、双版本回归及 Radio Golden 通过。
- [x] Form 仅完成保持 block 现状的 API 迁移，不包含布局修复。
