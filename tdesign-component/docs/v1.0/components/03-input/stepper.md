# TStepper — v1.0 定稿

> **状态**：已实现 | **控制类**：C | **Sprint**：S2

**源码路径**：`lib/src/components/stepper`

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `IconButton` + `TextField` 组合 |
| Theme | `TStepperThemeData` |
| 禁用 | `onChanged: null` |

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `num` | - | 受控数值 |
| `onChanged` | `ValueChanged<num>?` | - | 数值变化；为 null 时禁用 |
| `min` | `num` | `0` | 最小值 |
| `max` | `num` | `100` | 最大值 |
| `step` | `num` | `1` | 步长 |

### 类型

| 类型 | 成员 / 字段 | 说明 |
|---|---|---|
| `TStepperVariant` | `normal` / `filled` | 步进器形态 |
| `TStepperThemeData` | ThemeExtension | 组件级主题 |

## Theme

`TStepperThemeData` 通过 `Theme.of(context).mergeExtension(...)` 注入子树，或通过 `MaterialApp.theme.extensions` 注入全局。

| 字段 | 说明 |
|---|---|
| `variant` | `normal` 或 `filled` |
| `inputWidth` | 输入框宽度 |

## 实现约束

- Stepper 严格受控，不提供命令式控制器或外部事件流。
- 边界由 `min` / `max` 统一截断；到达边界时不重复触发相同值回调。
- 文本输入提交时解析数值，非法文本回退当前值。
- 禁用只通过 `onChanged: null` 表达，按钮和输入框同步禁用。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖加减、边界、步长、小数、禁用、文本输入、外部 value 同步、Theme |
| 文档 | 公开 API 说明列不得为 `-` |
| 覆盖率 | 组件源码总覆盖率不低于 95% |
| API 边界 | 源码、测试、示例、API 文档不得出现命令式控制器、外部事件流、重复尺寸或重复 theme 入口 |
