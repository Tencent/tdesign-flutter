# TResult

> **状态**：已实现 | **控制类**：纯展示 | **Sprint**：S3

`TResult` 展示默认、成功、警告或失败结果。实例 `variant` 是唯一结果语义来源，Theme 不重复保存该字段。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `variant` | `TResultVariant` | `defaultTheme` | 结果语义 |
| `title` | `String` | 空字符串 | 标题 |
| `subtitle` | `String?` | `null` | 描述 |
| `icon` | `Widget?` | `null` | 覆盖默认语义图标 |

`TResultThemeData` 只提供标题样式。组件源码覆盖率为 97.14%，ThemeData 为 100%。
