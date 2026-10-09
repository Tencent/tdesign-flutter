## API

### TRate

#### 构造方法

##### TRate

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| allowHalf | bool | false | 是否允许半星。 | 否 |
| count | int | 5 | 评分项数量。 | 否 |
| icon | TRateIconBuilder? | - | 自定义评分图标。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;double&gt;? | - | 评分变更回调；为 null 时禁用。 | 否 |
| onChangeEnd | ValueChanged&lt;double&gt;? | - | 结束交互时触发；指针取消时以当前受控值结束。 | 否 |
| onChangeStart | ValueChanged&lt;double&gt;? | - | 开始交互时触发；同一次指针或语义交互只触发一次。 | 否 |
| showValueIndicator | bool | true | 是否在整星点击、长按以及拖动评分时显示当前值提示。 默认为 true。半星点击的精确选择浮层不受此参数控制。 | 否 |
| texts | List&lt;String&gt;? | - | 各评分对应的辅助文案。 为 null 时不显示辅助文案；非 null 时显示。当当前评分 没有对应文案时，显示本地化的“未评分”。 | 否 |
| value | double | - | 受控评分值。 | 是 |


### TRateIconBuilder

位置参数：`filled`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| filled | bool | - | 表示构建选中或未选中图标；半星由组件裁剪选中图标实现。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |
