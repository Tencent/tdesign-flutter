## API
### TDStepsItemData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| content | String? | - | 内容 |
| customContent | Widget? | - | 自定义内容 |
| customTitle | Widget? | - | 自定义标题 |
| errorIcon | IconData? | - | 失败图标 |
| successIcon | IconData? | - | 成功图标 |
| title | String? | - | 标题 |

```
```
 ### TDSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeIndex | int | 0 | 步骤条当前激活的索引 |
| direction | TDStepsDirection | TDStepsDirection.horizontal | 步骤条方向 |
| key |  | - |  |
| readOnly | bool | false | 步骤条readOnly模式 |
| simple | bool | false | 步骤条simple模式 |
| status | TDStepsStatus | TDStepsStatus.success | 步骤条状态 |
| steps | List<TDStepsItemData> | - | 步骤条数据 |
| verticalSelect | bool | false | 步骤条垂直自定义步骤条选择模式 |
