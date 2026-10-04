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
| showDivider | bool | true | 普通模式是否显示底部分割线，默认显示；卡片模式不显示。 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 |
| subTitle | String? | - | 副标题文案。 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 |
| title | String? | - | 主标题文案。 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 |
| value | bool? | - | 受控选中态；null 表示半选。 外部受控选中状态；null 表示聚合半选，点击半选转为 true。 用户交互为二态选择，不自动循环产生 null。 |


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
| onSelectionLimitExceeded | VoidCallback? | - | 已达到 `maxSelected` 后再次尝试添加未选项时触发；本次不调用 `onChanged`。 |
| options | List<TCheckboxOption<T>> | - | 复选框数据项。 |
| showDivider | bool | true | 普通模式是否显示项间分割线，默认显示；卡片模式不显示。 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 |
| value | List<T> | - | 受控选中项列表。 |


### TCheckboxOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用该项。 |
| label | String | - | 主文案。 |
| subTitle | String? | - | 副文案。 |
| value | T | - | 选项值。 |


### TCheckboxThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 卡片背景颜色。 |
| customSpace | EdgeInsetsGeometry? | - | 内容区域内边距。 |
| disableColor | Color? | - | 禁用态指示器的前景色；未选时用于描边色。 |
| insetSpacing | double? | - | 文案与非指示器侧的内边距。 |
| selectColor | Color? | - | 选中态颜色。 |
| spacing | double? | - | 指示器与文案间距。 |
| subTitleColor | Color? | - | 副标题颜色。 |
| titleColor | Color? | - | 主标题颜色。 |
| variant | TCheckboxVariant? | - | 复选框指示器的默认视觉变体；未设置时使用圆形。 |


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


### TCheckboxVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | 圆形指示器。 |
| square | 方形指示器。 |
| check | 仅显示勾选或半选图标。 |


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
