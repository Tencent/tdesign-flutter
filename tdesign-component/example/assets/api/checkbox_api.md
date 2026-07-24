## API
### TCheckbox
#### 简介
严格受控的复选框；`onChanged` 为 null 时禁用。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 |
| customIconBuilder | TCheckboxIconBuilder? | - | 自定义复选框指示器。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<bool?>? | - | 选中态变更回调；为 null 时禁用。 |
| showDivider | bool | false | 是否显示底部分割线。 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 |
| subTitle | String? | - | 副标题文案。 |
| subTitleMaxLines | int | 1 | 副标题最大行数。 |
| title | String? | - | 主标题文案。 |
| titleMaxLines | int | 1 | 主标题最大行数。 |
| value | bool? | - | 受控选中态；null 表示半选。 |


### TCheckboxGroup
#### 简介
数据驱动且严格受控的复选框组。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 |
| columns | int | 1 | 每行列数。 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 |
| direction | Axis | Axis.vertical | 排列方向。 |
| itemBuilder | TCheckboxOptionBuilder<T>? | - | 自定义数据项视觉；交互仍由组接管。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxSelected | int? | - | 最多可选数量。 |
| onChanged | ValueChanged<List<T>>? | - | 选中项列表变更回调；为 null 时整组禁用。 |
| onMaxSelected | VoidCallback? | - | 超过最多可选数量时触发。 |
| options | List<TCheckboxOption<T>> | - | 复选框数据项。 |
| showDivider | bool | false | 是否显示项间分割线。 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 |
| value | List<T> | - | 受控选中项列表。 |


### TCheckboxOption
#### 简介
复选框组的数据项。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用该项。 |
| label | String | - | 主文案。 |
| subTitle | String? | - | 副文案。 |
| value | T | - | 选项值。 |


### TContentDirection
#### 简介
选择控件相对于文案的排列方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 控件位于文案右侧。 |
| right | 控件位于文案左侧。 |


### TCheckboxSize
#### 简介
复选框指示器尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸。 |
| medium | 中尺寸。 |
| large | 大尺寸。 |


### TCheckboxVariant
#### 简介
复选框指示器的视觉变体。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形指示器。 |
| square | 方形指示器。 |
| check | 仅显示勾选或半选图标。 |


### TCheckboxIconBuilder
#### 简介
自定义复选框指示器构建器。
#### 类型定义

```dart
typedef TCheckboxIconBuilder = Widget Function(BuildContext context, bool? value, bool disabled);
```


### TCheckboxOptionBuilder
#### 简介
自定义复选框组数据项构建器。
#### 类型定义

```dart
typedef TCheckboxOptionBuilder = Widget Function(BuildContext context, TCheckboxOption<T> option, bool selected, bool disabled);
```
