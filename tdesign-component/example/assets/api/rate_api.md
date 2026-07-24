## API
### TRate
#### 简介
严格受控的评分组件。
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
| texts | List<String>? | - | 各评分对应的文案。 |
| value | double | - | 受控评分值。 |


### TRateThemeData
#### 简介
TRate 组件级 ThemeExtension。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| iconGap | double? | - | 图标间距。 |
| iconSize | double? | - | 图标尺寸。 |
| inactiveStarColor | Color? | - | 未选中星标颜色。 |
| showText | bool? | - | 是否显示评分文案。 |
| starColor | Color? | - | 选中星标颜色。 |
| textGap | double? | - | 图标与文案间距。 |
| textStyle | TextStyle? | - | 文案样式。 |
| textWidth | double? | - | 文案宽度。 |


### TRateIconBuilder
#### 简介
自定义评分图标构建器。
`filled` 表示构建选中或未选中图标；半星由组件裁剪选中图标实现。
#### 类型定义

```dart
typedef TRateIconBuilder = Widget Function(bool filled);
```
