# Checkbox 设计细节对齐

## 背景

Checkbox Demo 与指定设计稿在命名、多行对齐、禁用未选样式、卡片内容间距和分割线起点上存在偏差。

## 目标

- 统一使用“多选框”命名和“特殊样式”分组。
- 多行文案与指示器顶部对齐。
- 禁用未选使用禁用背景色和组件描边色。
- 卡片文案垂直居中并与上下边框保持 16dp。
- 普通分割线从文案起点开始。

## 非目标

- 不新增或修改公开 API。
- 不改变选择状态和回调语义。

## 范围

### 涉及

- `TCheckbox`、`TSelectionCard`、Checkbox Demo 及测试。

### 不涉及

- Radio 和其他选择组件的视觉契约。

## 行为契约

默认主题下，禁用未选指示器填充采用 `bgColorComponentDisabled`、描边采用 `componentBorderColor`；布局尺寸均从现有 TDesign Token 派生。

## 验收标准

- [x] 六项已确认的 Checkbox 偏差均完成修复。
- [x] 不硬编码设计色值。
- [x] 组件和 Demo 回归覆盖新行为。
