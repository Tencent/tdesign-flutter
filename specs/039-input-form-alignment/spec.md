# Input 与 Form 排版对齐

## 背景与目标

实际 Demo 中横向单列表单标签字号偏小、纵向布局未区分字号，输入框图标间距不足，错误态和超长标签示例也未居中。本次统一组件 Token 与公开 Demo 配置。

## 行为契约

- 横向 `TFormItem` 标签使用 `fontBodyLarge`，纵向标签使用 `fontBodyMedium`。
- `TInput` 前后图标与编辑区间距使用 `spacer16`。
- Form 默认垂直对齐仍为 start；需要居中的错误态和超长标签 Demo 显式设置 center。
- Theme 显式样式继续覆盖默认 Token。

## 非目标

- 不把所有横向表单默认改成居中，不新增重复的像素参数。
