# TSelectTag

> **状态**：已实现 | **控制类**：B | **Sprint**：S3

`TSelectTag` 与 `TTag` 属于同一组件族，共用 `TTagThemeData` 和公开类型。

## 控制方案

组件严格使用 `value + onChanged`：

- `value` 是唯一选中状态来源。
- 点击只回调 `!value`，组件不缓存业务状态。
- `onChanged == null` 时禁用交互并使用禁用视觉状态。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `text` | `String` | 必填 | 标签文案 |
| `value` | `bool` | 必填 | 当前选中状态 |
| `onChanged` | `ValueChanged<bool>?` | `null` | 状态变更回调 |
| `colorScheme` | `TTagColorScheme?` | `null` | 选中态语义色 |
| `icon` | `IconData?` | `null` | 标签图标 |
| `size` | `TTagSize` | `medium` | 标签尺寸 |

## 验收

- 选中、未选中、禁用和回调取反均有测试。
- 实现为 StatelessWidget，不使用业务状态缓存或 coverage ignore。
