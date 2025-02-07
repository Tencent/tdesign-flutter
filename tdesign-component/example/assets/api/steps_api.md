## API
### TDStepsItemData
#### 默认构造方法

| 参数 | 类型        | 默认值 | 说明 |
| --- |-----------| --- | --- |
| title | String?   | - | 标题 |
| content | String?   | - | 内容 |
| successIcon | IconData? | - | 成功图标 |
| errorIcon | IconData? | - | 失败图标 |
| customContent | Widget?   | - | 自定义内容 |

```
```
 ### TDSteps
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| steps | List<TDStepsItemData> | - | 步骤条数据 |
| activeIndex | int | 0 | 步骤条当前激活的索引 |
| direction | TDStepsDirection | TDStepsDirection.horizontal | 步骤条方向 |
| status | TDStepsStatus | TDStepsStatus.success | 步骤条状态 |
| simple | bool | false | 步骤条simple模式 |
| readOnly | bool | false | 步骤条readOnly模式 |
| verticalSelect | bool | false | 步骤条垂直自定义步骤条选择模式 |
