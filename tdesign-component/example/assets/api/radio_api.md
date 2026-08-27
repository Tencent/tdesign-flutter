## API
### TRadio
#### 简介
遵循 Material value/groupValue 语义的严格受控单选框。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 |
| customIconBuilder | TRadioIconBuilder? | - | 自定义单选框指示器。 |
| groupValue | T? | - | 组内受控选中值。 |
| iconType | TRadioIconType | TRadioIconType.fill | 内置指示器样式；`customIconBuilder` 非空时以自定义指示器为准。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<T>? | - | 选中值变更回调；为 null 时禁用。 |
| showDivider | bool | false | 是否显示底部分割线。 |
| size | TRadioSize | TRadioSize.medium | 单选框尺寸。 |
| subTitle | String? | - | 副标题文案。 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 |
| title | String? | - | 主标题文案。 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 |
| value | T | - | 当前选项值。 |


### TRadioGroup
#### 简介
数据驱动且严格受控的单选框组。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 |
| columns | int | 1 | 每行列数，必须大于 0。 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 |
| direction | Axis | Axis.vertical | 排列方向。 |
| iconType | TRadioIconType | TRadioIconType.fill | 内置指示器样式。 |
| itemBuilder | TRadioOptionBuilder<T>? | - | 自定义数据项视觉；交互仍由组接管。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<T>? | - | 选中值变更回调；为 null 时整组禁用。 |
| options | List<TRadioOption<T>> | - | 单选框数据项。 |
| showDivider | bool | false | 是否显示项间分割线。 |
| size | TRadioSize | TRadioSize.medium | 单选框尺寸。 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 |
| value | T? | - | 受控选中值。 |


### TRadioSize
#### 简介
单选框指示器尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸。 |
| medium | 中尺寸。 |
| large | 大尺寸。 |


### TRadioIconType
#### 简介
单选框内置指示器样式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| dot | 圆环内显示实心圆点。 |
| check | 选中时显示勾选标记。 |
| fill | 选中时显示带反色勾选标记的实心圆。 |


### TRadioIconBuilder
#### 简介
自定义单选框指示器构建器。
#### 类型定义

```dart
typedef TRadioIconBuilder = Widget Function(BuildContext context, bool selected, bool disabled);
```


### TRadioOptionBuilder
#### 简介
自定义单选框组数据项构建器。
#### 类型定义

```dart
typedef TRadioOptionBuilder = Widget Function(BuildContext context, TRadioOption<T> option, bool selected, bool disabled);
```
