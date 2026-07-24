# TInput - v1.0 定稿

> **状态**：已实现 | **控制类**：D | **Sprint**：S2

**源码路径**：`lib/src/components/input`

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `TextField` 薄包装 |
| 控制 | `controller` 主路径 / `initialValue` 辅路径，二者互斥 |
| 禁用 | `enabled: false`；只读使用 `readOnly: true` |
| Material Theme | `InputDecorationTheme` 负责边框、颜色、内边距与文本样式 |
| TDesign Theme | `TInputThemeData` 只保留清除按钮和多行最小行数默认值 |
| P0 | `InputDecoration? decoration` |

## API

### TInput / TInput.multiline

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
| `suffix` | `Widget?` | - | 后缀组件；优先于内置清除按钮 |
| `maxLines` | `int?` | 单行 `1` / 多行 `null` | 最大行数 |
| `minLines` | `int?` | - | 最小行数 |
| `maxLength` | `int?` | - | 最大字符数 |
| `autofocus` | `bool` | `false` | 是否自动聚焦 |
| `focusNode` | `FocusNode?` | - | 焦点节点 |
| `inputType` | `TextInputType` | 单行 `text` / 多行 `multiline` | 键盘类型 |
| `inputAction` | `TextInputAction?` | - | 键盘动作 |
| `textAlign` | `TextAlign` | `start` | 文本对齐 |
| `obscureText` | `bool` | `false` | 单行输入是否隐藏文本 |
| `inputFormatters` | `List<TextInputFormatter>?` | - | 输入格式化器 |
| `decoration` | `InputDecoration?` | - | Material P0 逃逸口 |

`TInput.multiline` 不提供 `obscureText`，默认 `maxLines: null`，默认最小行数读取 `TInputThemeData.multilineMinLines`。

## Theme

| 字段 | 说明 |
|---|---|
| `showClearButton` | 有文本且无 suffix 时是否显示清除按钮 |
| `clearIconSize` | 清除图标尺寸 |
| `multilineMinLines` | 多行输入默认最小行数 |

Theme 注入使用 `Theme.of(context).mergeExtension(...)`。实例 `decoration` 中已有的 label、hint、prefixIcon、suffixIcon 优先于快捷参数。

## 实现约束

- 不公开业务 Controller、布局枚举、尺寸枚举、卡片样式、间距对象或额外 formatter 包装。
- `TextInputType.visiblePassword` 只控制键盘，不能替代 `obscureText`。
- 清除操作更新当前 controller，并通过 `onChanged('')` 通知。
- `TInputResolve` 为内部装饰解析入口，不从公共总出口导出。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖控制器生命周期、initialValue、提交、禁用、只读、密码、格式化、清除和多行 |
| 文档 | tools 生成 API 说明列不得为 `-` |
| 覆盖率 | 组件源码总覆盖率及各文件不低于 95% |
| API 边界 | 不出现布局枚举、卡片样式、重复 decoration 或额外 formatter 包装 |
