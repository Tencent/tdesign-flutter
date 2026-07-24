# TSearchBar — v1.0 定稿

> **状态**：已实现 | **控制类**：D | **Sprint**：S2

**源码路径**：`lib/src/components/search-bar`

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 基于 TInput / TextField 的搜索输入组合 |
| Theme | `TSearchBarThemeData` |
| 禁用 | `enabled: false` |
| 只读 | `readOnly: true` |

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `controller` | `TextEditingController?` | - | 文本控制器主路径 |
| `initialValue` | `String?` | - | 初始文本；仅初始化一次 |
| `onChanged` | `ValueChanged<String>?` | - | 文本变化通知 |
| `onSubmitted` | `ValueChanged<String>?` | - | 提交回调 |
| `enabled` | `bool` | `true` | 是否可交互 |
| `readOnly` | `bool` | `false` | 是否只读 |
| `hintText` | `String?` | - | 占位提示 |
| `needCancel` | `bool` | `false` | 是否显示取消按钮 |
| `cancelText` | `String` | `取消` | 取消按钮文案 |
| `onCancelPressed` | `VoidCallback?` | - | 取消按钮点击 |
| `onClearPressed` | `VoidCallback?` | - | 清除按钮点击 |
| `autoFocus` | `bool` | `false` | 是否自动聚焦 |
| `inputAction` | `TextInputAction` | `search` | 键盘动作 |
| `decoration` | `InputDecoration?` | - | Material 输入装饰逃逸口 |

## Theme

`TSearchBarThemeData` 通过 `Theme.of(context).mergeExtension(...)` 注入子树，或通过 `MaterialApp.theme.extensions` 注入全局。

| 字段 | 说明 |
|---|---|
| `variant` | 搜索框形态 |
| `textAlignment` | 文本对齐方式 |
| `padding` | 外层内边距 |
| `backgroundColor` | 背景色 |
| `cursorHeight` | 光标高度 |
| `autoHeight` | 是否自动高度 |

## 实现约束

- 文本控制遵循控制类 D：`controller` 为主路径，`initialValue` 只作为初始化输入。
- 禁用与只读分开表达：`enabled: false` 完全不可交互，`readOnly: true` 可聚焦但不可编辑。
- 搜索条特有的取消、清除、提交行为通过显式回调表达。
- 样式默认走 `TSearchBarThemeData`，输入细节可通过 `decoration` 作为 Material 逃逸口。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖文本输入、提交、取消、清除、禁用、只读、Theme |
| 文档 | 公开 API 说明列不得为 `-` |
| 覆盖率 | 组件源码总覆盖率不低于 95% |
| API 边界 | 源码、测试、示例、API 文档不得出现额外搜索样式枚举或重复回调入口 |
