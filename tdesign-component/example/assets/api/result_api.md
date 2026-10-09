## API

### TResult

#### 构造方法

##### TResult

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| description | String? | - | 描述文本，用于提供额外信息；为空时不占布局空间。 | 否 |
| icon | Widget? | - | 图标组件，用于在结果中显示一个图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| status | TResultStatus | TResultStatus.info | 当前结果状态，决定默认图标、颜色和无障碍语义，默认为 `TResultStatus.info`。 | 否 |
| title | String | '' | 标题文本，显示结果的主要信息，默认标题为空字符串 | 否 |


### TResultStatus
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| info | TResultStatus | - | 默认信息状态。 | - |
| success | TResultStatus | - | 成功结果状态。 | - |
| warning | TResultStatus | - | 警告结果状态。 | - |
| error | TResultStatus | - | 错误结果状态。 | - |
