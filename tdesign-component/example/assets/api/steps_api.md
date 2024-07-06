## API
### TDSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 是否必填 | 说明        |
| --- | --- | --- | -- | --- |
| steps | TDStepsItemData |  - | 是 | 步骤条数据     |
| activeIndex | int | 0 | 否 | 当前激活步骤的索引 |
| direction | TDStepsDirection.horizontal/TDStepsDirection.vertical | TDStepsDirection.horizontal | 否 | 步骤条方向 |
| status | TDStepsStatus.success/TDStepsStatus.error | TDStepsStatus.success | 否 | 步骤条状态 |
| simple | bool | false | 否 | 是否简略模式 |
| readOnly | bool | false | 否 | 是否纯展示readOnly模式 |
| verticalSelect | bool | false | 否 | 是否是垂直自定义步骤条选择模式 |



