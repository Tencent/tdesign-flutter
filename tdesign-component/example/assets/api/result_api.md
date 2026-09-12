## API
### TResult
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| description | String? | - | 描述文本，用于提供额外信息；为空时不占布局空间。 |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| status | TResultStatus | TResultStatus.info | 当前结果状态，决定默认图标、颜色和无障碍语义，默认为 `TResultStatus.info`。 |
| title | String | '' | 标题文本，显示结果的主要信息，默认标题为空字符串 |


### TResultStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| info | 默认信息状态。 |
| success | 成功结果状态。 |
| warning | 警告结果状态。 |
| error | 错误结果状态。 |
