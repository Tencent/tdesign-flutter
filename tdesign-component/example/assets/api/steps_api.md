## API
### TSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| direction | TStepsDirection | TStepsDirection.horizontal | 步骤条方向 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | ValueChanged<int>? | - | 用户选择步骤时触发；通过更新 `value` 实现受控模式。 |
| readOnly | bool? | - | 步骤条readOnly模式（优先级高于 ThemeData） |
| simple | bool? | - | 步骤条simple模式（优先级高于 ThemeData） |
| status | TStepsStatus | TStepsStatus.success | 步骤条状态。 |
| steps | List<TStepsItemData> | - | 步骤条数据 |
| value | int | 0 | 步骤条当前激活的索引 |
| verticalSelect | bool? | - | 步骤条垂直自定义步骤条选择模式（优先级高于 ThemeData） |


### TStepsItemData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| customContent | Widget? | - | 自定义内容 |
| customTitle | Widget? | - | 自定义标题 |
| errorIcon | IconData? | - | 失败图标 |
| successIcon | IconData? | - | 成功图标 |
| title | String? | - | 标题 |


### TStepsDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 水平方向 |
| vertical | 垂直方向 |


### TStepsStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| success | 成功状态 |
| error | 错误状态 |
