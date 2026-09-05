## API
### TSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| direction | TStepsDirection | TStepsDirection.horizontal | 步骤条方向 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | ValueChanged<int>? | - | 用户选择步骤时触发；为空时组件为只读，通过更新 `value` 实现受控模式。 垂直步骤条设置回调后会显示右侧箭头并允许选择。 |
| status | TStepsStatus | TStepsStatus.process | 当前 `value` 对应步骤的状态。 |
| steps | List<TStepsItemData> | - | 步骤条数据 |
| value | int | 0 | 步骤条当前激活的索引；越界值会收敛到有效范围。 |
| variant | TStepsVariant | TStepsVariant.defaultTheme | 步骤条视觉形态。 |


### TStepsItemData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| customContent | Widget? | - | 自定义内容 |
| customTitle | Widget? | - | 自定义标题 |
| errorIcon | IconData? | - | 失败图标 |
| icon | IconData? | - | 步骤图标；未设置时使用数字或状态图标。 |
| title | String? | - | 标题 |


### TStepsDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 水平方向 |
| vertical | 垂直方向 |


### TStepsVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认的数字或图标步骤条。 |
| dot | 点状步骤条，状态仍由 `TSteps.value` 和 `TSteps.status` 决定。 |
| display | 纯展示时间线，所有节点与连接线均使用完成态视觉。 |


### TStepsStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| process | 当前步骤进行中。 |
| error | 错误状态 |
