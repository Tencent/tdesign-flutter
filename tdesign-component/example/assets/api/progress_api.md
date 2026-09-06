## API
### TProgress
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | Widget? | - | 进度条标签。 |
| onLongPress | VoidCallback? | - | 长按 `button` 或 `micro` 进度条时触发。 可以独立于 `onTap` 使用；长按不会同时触发 `onTap`。线性和环形 形态不会响应长按。 |
| onTap | VoidCallback? | - | 点击 `button` 或 `micro` 进度条时触发。 这两个形态提供了可操作的视觉样式；线性和环形形态不会响应点击。 |
| status | TProgressStatus | TProgressStatus.primary | 当前任务状态，决定默认颜色和状态图标，默认为 `TProgressStatus.primary`。 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| variant | TProgressVariant | - | 进度条形态 |


### TProgressVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| linear | 线性进度条。 |
| plump | 百分比显示在进度条内部的胶囊形进度条。 |
| circular | 环形进度条。 |
| micro | 紧凑环形进度条。 |
| button | 按钮外观的线性进度条。 |


### TProgressStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | 常规进行中状态。 |
| warning | 警告状态。 |
| error | 错误状态。 |
| success | 成功状态。 |


### TProgressLabelPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| inside | 标签位于进度条内部。 |
| left | 标签位于进度条左侧。 |
| right | 标签位于进度条右侧。 |
