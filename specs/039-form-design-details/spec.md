# Form Demo 设计细节对齐

## 背景

Form Demo 的排布选择器、禁用开关、水平字段对齐、竖向性别间距和底部操作与指定设计稿不一致。

## 目标

- 未选排布按钮使用 `#F3F3F3` 对应的语义 Token。
- 禁用态开关关闭轨道使用 `#DCDCDC` 对应的语义 Token。
- 水平表单性别项垂直居中，选择类内容统一左对齐。
- 竖向性别标题到选项 8dp、选项到底部 16dp。
- 两种排布均按“重置、提交”排列，重置为浅色、提交为主要样式。

## 非目标

- 不新增或修改 Form、Radio、Button、Switch 公开 API。
- 不改变表单校验和提交数据语义。

## 范围

### 涉及

- Form Demo 组合和 Demo 测试。

### 不涉及

- 通用组件的默认主题契约。

## 行为契约

Demo 只通过现有组件 API、Theme 和基础布局组合表达设计；颜色使用 `bgColorSecondaryContainer`、`componentBorderColor` 等语义 Token。

## 验收标准

- [x] 四组已确认的 Form 偏差均完成修复。
- [x] 不硬编码颜色。
- [x] Demo 回归覆盖颜色、对齐、间距、顺序和主题。
