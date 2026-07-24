# TTextarea - v1.0 定稿

> **状态**：已实现 | **控制类**：D | **Sprint**：S2

**源码路径**：`lib/src/components/textarea`

## 架构

`TTextarea` 是 `TInput.multiline` 的语义别名，不维护独立状态、Theme 或 resolve 逻辑。控制、禁用、Material Theme 和清除行为均与 [TInput](./input.md) 一致。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `controller` | `TextEditingController?` | - | 主控制路径 |
| `initialValue` | `String?` | - | 内部 controller 初值，仅初始化一次 |
| `onChanged` | `ValueChanged<String>?` | - | 文本变化通知 |
| `onSubmitted` | `ValueChanged<String>?` | - | 提交回调 |
| `onEditingComplete` | `VoidCallback?` | - | 编辑完成回调 |
| `enabled` | `bool` | `true` | 是否可交互 |
| `readOnly` | `bool` | `false` | 是否只读 |
| `label` | `String?` | - | 标签文案 |
| `hintText` | `String?` | - | 占位提示 |
| `prefix` | `Widget?` | - | 前缀组件 |
| `suffix` | `Widget?` | - | 后缀组件 |
| `maxLines` | `int?` | `null` | 最大行数 |
| `minLines` | `int?` | Theme 默认 | 最小行数 |
| `maxLength` | `int?` | - | 最大字符数 |
| `autofocus` | `bool` | `false` | 是否自动聚焦 |
| `focusNode` | `FocusNode?` | - | 焦点节点 |
| `inputType` | `TextInputType` | `multiline` | 键盘类型 |
| `inputAction` | `TextInputAction?` | - | 键盘动作 |
| `textAlign` | `TextAlign` | `start` | 文本对齐 |
| `inputFormatters` | `List<TextInputFormatter>?` | - | 输入格式化器 |
| `decoration` | `InputDecoration?` | - | Material P0 逃逸口 |

## 实现约束

- 不提供独立布局枚举、ThemeData 或第二套 controller 生命周期。
- 构造器参数逐项委托给 `TInput.multiline`。
- `controller` 与 `initialValue` 互斥。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖委托完整性、多行默认值、Theme 最小行数、提交与互斥断言 |
| 文档 | tools 生成 API 说明列不得为 `-` |
| 覆盖率 | 组件源码不低于 95% |
| API 边界 | 不出现布局枚举、计数开关、重复装饰或实例 L4 样式参数 |
