## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TRate
#### 简介
严格受控的评分组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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


### TRateThemeData
#### 简介
TRate 组件级 ThemeExtension。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| iconGap | double? | - | 图标间距。 | 否 |
| iconSize | double? | - | 图标尺寸。 | 否 |
| inactiveStarColor | Color? | - | 未选中星标颜色。 | 否 |
| overlayBoxShadow | List&lt;BoxShadow&gt;? | - | 当前值提示与半星选择浮层阴影。 | 否 |
| starColor | Color? | - | 选中星标颜色。 | 否 |
| textGap | double? | - | 图标与文案间距。 | 否 |
| textStyle | TextStyle? | - | 文案样式。 | 否 |
| textWidth | double? | - | 文案宽度。 | 否 |


### TRateIconBuilder
#### 简介
自定义评分图标构建器。
`filled` 表示构建选中或未选中图标；半星由组件裁剪选中图标实现。
#### 类型定义

```dart
typedef TRateIconBuilder = Widget Function(bool filled);
```
