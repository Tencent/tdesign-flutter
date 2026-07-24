# TTimeCounter

> **状态**：已实现 | **控制类**：E | **Sprint**：S3

**源码路径**：`lib/src/components/time_counter`

## 架构

`TTimeCounter` 使用 Flutter `Ticker` 驱动计时，命令式操作统一由 `TTimeCounterController` 提供，方向、尺寸和形态均使用明确枚举。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `time` | `int` | 必填 | 计时时长，单位毫秒且不能为负数 |
| `autoStart` | `bool` | `true` | 是否自动开始 |
| `content` | `TTimeCounterBuilder?` | `null` | `Widget Function(int time)` 自定义内容 |
| `format` | `String` | `HH:mm:ss` | 时间格式 |
| `showMillisecond` | `bool?` | `null` | 是否显示毫秒，优先于 Theme |
| `size` | `TTimeCounterSize?` | `null` | 尺寸，优先于 Theme |
| `splitWithUnit` | `bool?` | `null` | 是否使用本地化单位分隔，优先于 Theme |
| `variant` | `TTimeCounterVariant?` | `null` | 视觉形态，优先于 Theme |
| `direction` | `TTimeCounterDirection` | `down` | 计时方向 |
| `controller` | `TTimeCounterController?` | `null` | 开始、暂停、继续和重置控制器 |
| `onChanged` | `ValueChanged<int>?` | `null` | 当前毫秒值变化回调 |
| `onFinish` | `VoidCallback?` | `null` | 计时完成回调 |

## Theme

`TTimeCounterThemeData` 提供 `variant`、`size`、`showMillisecond` 和 `splitWithUnit` 默认值。Theme 不存回调、内容、controller 或计时时长。

## Export

公开导出 `TTimeCounter`、`TTimeCounterBuilder`、`TTimeCounterController`、三个公开枚举和 `TTimeCounterThemeData`。内部 `TTimeCounterStyle` 不导出。

## 验收

- 正计时、倒计时、格式化、controller 命令、更新生命周期和完成回调均有测试。
- TimeCounter 源码逐文件覆盖率均高于 98%。
