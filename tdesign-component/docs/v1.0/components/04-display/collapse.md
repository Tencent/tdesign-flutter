# TCollapse

`TCollapse<T>` 提供多开和手风琴两种折叠模式。手风琴模式使用泛型受控值，不缓存当前业务值。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `children` | `List<TCollapsePanel<T>>` | 必填 | 面板配置 |
| `mode` | `TCollapseMode` | `multiple` | 展开模式 |
| `value` | `T?` | `null` | 手风琴模式当前展开值 |
| `onChanged` | `ValueChanged<T?>?` | `null` | 请求更新手风琴值 |
| `onExpansionChanged` | `ExpansionPanelCallback?` | `null` | 面板点击通知 |
| `animationDuration` | `Duration?` | Theme / Material 默认 | 动画时长 |
| `elevation` | `double?` | Theme / `0` | 阴影高度 |

`TCollapsePanel<T>` 提供 `headerBuilder`、`body`、`isExpanded`、`value`、`backgroundColor` 与 `expandIconTextBuilder`。

## 控制语义

- `multiple`：每个 Panel 的 `isExpanded` 由父级回写。
- `accordion`：`value` 是唯一展开状态源，点击只调用 `onChanged`。
- accordion 的 Panel value 必须非空且互不重复。

## Theme

`TCollapseThemeData` 只保存 `variant/backgroundColor/animationDuration/elevation` 等视觉默认。展开模式、当前值、面板内容和回调不进入 Theme。
