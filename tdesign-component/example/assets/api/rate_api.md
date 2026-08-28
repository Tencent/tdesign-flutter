## API
### TRate
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| allowHalf | bool | false | 是否允许半星。 |
| count | int | 5 | 评分项数量。 |
| icon | TRateIconBuilder? | - | 自定义评分图标。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<double>? | - | 评分变更回调；为 null 时禁用。 |
| onChangeEnd | ValueChanged<double>? | - | 结束交互时触发。 |
| onChangeStart | ValueChanged<double>? | - | 开始交互时触发。 |
| texts | List<String>? | - | 各评分对应的辅助文案。 为 null 时不显示辅助文案；非 null 时显示。当当前评分 没有对应文案时，显示本地化的“未评分”。 |
| value | double | - | 受控评分值。 |


### TRateIconBuilder
#### 类型定义

```dart
typedef TRateIconBuilder = Widget Function(bool filled);
```
