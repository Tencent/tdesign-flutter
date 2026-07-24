# TSkeleton

`TSkeleton` 提供预设骨架和强类型行列布局。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `variant` | `TSkeletonVariant` | `text` | 预设形态 |
| `animation` | `TSkeletonAnimation?` | `null` | 渐变或闪烁动画 |
| `delay` | `int` | `0` | 延迟显示毫秒数 |

`TSkeleton.fromRowCol` 接受 `TSkeletonRowCol`。布局由 `TSkeletonRowColObj` 的 circle、rect、text 和 spacer 构造器组成，样式使用普通 Color、double 和枚举值，不要求调用方提供 BuildContext 回调。

## Theme

`TSkeletonThemeData` 只保存 `blockColor/highlightColor/borderRadius/rowSpacing`。预设形态、动画类型、延迟和布局对象均为实例语义。

## 验收要求

- delay 回调在 dispose 后不调用 setState。
- 无根级 Flexible；组件可放入任意正常约束。
- 实例块样式优先于 Theme，Theme 再回退 Token。
