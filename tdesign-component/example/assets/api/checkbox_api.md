## API
### TCheckbox
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
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 |
| title | String? | - | 主标题文案。 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 |
| value | bool? | - | 受控选中态；null 表示半选。 |


### TCheckboxGroup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 |
| columns | int | 1 | 每行列数，必须大于 0。 |
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


### TContentDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 控件位于文案右侧。 |
| right | 控件位于文案左侧。 |


### TCheckboxSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸。 |
| medium | 中尺寸。 |
| large | 大尺寸。 |


### TCheckboxIconBuilder
#### 类型定义

```dart
typedef TCheckboxIconBuilder = Widget Function(BuildContext context, bool? value, bool disabled);
```


### TCheckboxOptionBuilder
#### 类型定义

```dart
typedef TCheckboxOptionBuilder = Widget Function(BuildContext context, TCheckboxOption<T> option, bool selected, bool disabled);
```
