## API
### TRadio
#### 简介
由最近的 `TRadioGroup` 控制选中状态的单选框。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 |
| customIconBuilder | TRadioIconBuilder? | - | 自定义单选框指示器。 |
| disabled | bool | false | 是否禁用当前选项。 |
| iconType | TRadioIconType | TRadioIconType.fill | 内置指示器样式；`customIconBuilder` 非空时以自定义指示器为准。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| size | TRadioSize | TRadioSize.medium | 单选框尺寸。 |
| subTitle | String? | - | 副标题文案。 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 |
| title | String? | - | 主标题文案。 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 |
| value | T | - | 当前选项值。 |
| variant | TRadioVariant | TRadioVariant.block | 完整视觉结构，默认使用通栏结构。 |


### TRadioGroup
#### 简介
严格受控的单选框组。
默认构造通过 `child` 接收调用方布局；标准数据列表使用
`TRadioGroup.options`。组内的 `TRadio` 从该组件读取选中值和变更回调。

#### 工厂构造方法

##### TRadioGroup.options

使用数据项生成标准布局的单选框组。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| value | T? | - | 受控选中值。 |
| options | List<TRadioOption<T>> | - | - |
| onChanged | ValueChanged<T>? | - | 选中值变更回调；为 null 时整组禁用。 |
| direction | Axis | - | 排列方向，默认纵向。 |
| columns | int | - | 每行列数，默认 1，必须大于 0。 |
| variant | TRadioVariant | - | 生成项的完整视觉结构，默认 `TRadioVariant.block`。 |
| showDivider | bool? | - | 是否显示项间分割线。 为空时仅 `TRadioVariant.block` 默认显示；非 block 结构不能设为 true。 |
| contentDirection | TContentDirection | - | 控件与文案排列方向，默认文案在指示器右侧。 |
| size | TRadioSize | - | 单选框尺寸，默认 `TRadioSize.medium`。 |
| iconType | TRadioIconType | - | 内置指示器样式，默认 `TRadioIconType.fill`。 |
| titleMaxLines | int | - | 主标题最大行数，默认 3 行。 |
| subTitleMaxLines | int | - | 副标题最大行数，默认 5 行。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 包含 `TRadio` 的自定义布局。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | ValueChanged<T>? | - | 选中值变更回调；为 null 时整组禁用。 |
| value | T? | - | 受控选中值。 |


### TRadioOption
#### 简介
单选框组的数据项。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用该项。 |
| label | String | - | 主文案。 |
| subTitle | String? | - | 副文案。 |
| value | T | - | 选项值。 |


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


### TRadioVariant
#### 简介
单选框的完整视觉结构。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| inline | 行内结构，不绘制通栏背景、外围内边距或标准块高。 |
| block | 通栏结构，使用标准块高、容器背景和外围内边距。 |
| card | 卡片结构。 |


### TRadioIconBuilder
#### 简介
自定义单选框指示器构建器。
#### 类型定义

```dart
typedef TRadioIconBuilder = Widget Function(BuildContext context, bool selected, bool disabled);
```
