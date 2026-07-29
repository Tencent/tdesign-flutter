## API
### TProgress
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | Widget? | - | 进度条标签。 |
| onTap | VoidCallback? | - | 点击 `button` 或 `micro` 进度条时触发。 这两个形态提供了可操作的视觉样式；线性和环形形态不会响应点击。 |
| value | double? | - | 进度值；确定模式限制在 0 到 1，null 表示不确定进度。 |
| variant | TProgressVariant | - | 进度条形态 |


### TProgressVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| linear | 线性进度条。 |
| circular | 环形进度条。 |
| micro | 紧凑环形进度条。 |
| button | 按钮外观的线性进度条。 |


### TProgressLabelPosition
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| inside | 标签位于进度条内部。 |
| left | 标签位于进度条左侧。 |
| right | 标签位于进度条右侧。 |
