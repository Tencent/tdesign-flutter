# Checkbox 设计细节对齐

## 背景

Checkbox Demo 与指定设计稿在命名、多行对齐、禁用未选样式、卡片内容间距和分割线起点上存在偏差；同时 Flutter 默认主题的移动端 Gy4 仍为 `#DDDDDD`，与移动端规范 `#DCDCDC` 不一致。

## 目标

- 统一使用“多选框”命名和“特殊样式”分组。
- 多行文案与指示器顶部对齐。
- 禁用未选使用禁用背景色和组件描边色。
- 将默认主题中的移动端 Gy4 从 `#DDDDDD` 修正为 `#DCDCDC`。
- 卡片文案垂直居中并与上下边框保持 16dp。
- 普通分割线从文案起点开始。

## 非目标

- 不新增或修改公开 API。
- 不改变选择状态和回调语义。

## 范围

### 涉及

- `TCheckbox`、`TSelectionCard`、Checkbox Demo 及测试。
- 默认主题 Gy4 以及所有实际使用该共享 Token 的 Linux Golden。

### 不涉及

- 不修改 Radio 和其他组件的布局、状态或交互契约；它们只继承 Gy4 的共享默认色值修正。

## 行为契约

默认亮色主题下，禁用未选指示器填充采用 `bgColorComponentDisabled`（`#EEEEEE`）、描边采用 `componentBorderColor`（Gy4，`#DCDCDC`）；布局尺寸均从现有 TDesign Token 派生。

## 验收标准

- [x] 六项已确认的 Checkbox 偏差均完成修复。
- [x] 不硬编码设计色值。
- [x] 组件和 Demo 回归覆盖新行为。
