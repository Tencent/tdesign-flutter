## API

### TRadio

类型参数：`T`


由最近的 `TRadioGroup` 控制选中状态的单选框。

必须作为同类型 `TRadioGroup` 的后代使用：

#### 构造方法

##### TRadio

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 | 否 |
| customIconBuilder | TRadioIconBuilder? | - | 自定义单选框指示器。 | 否 |
| disabled | bool | false | 是否禁用当前选项。 | 否 |
| iconType | TRadioIconType | TRadioIconType.fill | 内置指示器样式；`customIconBuilder` 非空时以自定义指示器为准。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| size | TRadioSize | TRadioSize.medium | 单选框尺寸。 | 否 |
| subTitle | String? | - | 副标题文案。 | 否 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 | 否 |
| title | String? | - | 主标题文案。 | 否 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 | 否 |
| value | T | - | 当前选项值。 | 是 |
| variant | TRadioVariant | TRadioVariant.block | 完整视觉结构，默认使用通栏结构。 | 否 |


### TRadioGroup

类型参数：`T`


严格受控的单选组。

默认构造通过 `child` 接收调用方布局；标准数据列表使用
`TRadioGroup.options`。组内的 `TRadio` 从该组件读取选中值和变更回调。

#### 构造方法

##### TRadioGroup

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| child | Widget | - | 包含 `TRadio` 的自定义布局。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;T&gt;? | - | 启用项被点选时通知其值；重复点选已选项也会通知，不自动去重。 为 null 时整组禁用；父组件须回传新 value 才能改变选中状态。 | 否 |
| value | T? | - | 受控选中值。 | 是 |


##### TRadioGroup.options

使用数据项生成标准布局的单选框组。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| value | T? | - | 受控选中值。 | 是 |
| options | List&lt;TRadioOption&lt;T&gt;&gt; | - | 单选框数据项。 | 是 |
| onChanged | ValueChanged&lt;T&gt;? | - | 启用项被点选时通知其值；重复点选已选项也会通知，不自动去重。 为 null 时整组禁用；父组件须回传新 value 才能改变选中状态。 | 否 |
| direction | Axis | Axis.vertical | 排列方向，默认纵向。 | 否 |
| columns | int | 1 | 每行列数，默认 1，必须大于 0。 横向 `TRadioVariant.inline` 按内容自然收缩并在行内两端对齐， 不使用该列数等分宽度。 | 否 |
| variant | TRadioVariant | TRadioVariant.block | 生成项的完整视觉结构，默认 `TRadioVariant.block`。 | 否 |
| showDivider | bool? | - | 是否显示项间分割线。 为空时仅 `TRadioVariant.block` 默认显示；非 block 结构不能设为 true。 | 否 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向，默认文案在指示器右侧。 | 否 |
| size | TRadioSize | TRadioSize.medium | 单选框尺寸，默认 `TRadioSize.medium`。 | 否 |
| iconType | TRadioIconType | TRadioIconType.fill | 内置指示器样式，默认 `TRadioIconType.fill`。 | 否 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 | 否 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 | 否 |


### TRadioOption

类型参数：`T`


单选框组的数据项。

#### 构造方法

##### TRadioOption

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| disabled | bool | false | 是否禁用该项。 | 否 |
| label | String | - | 主文案。 | 是 |
| subTitle | String? | - | 副文案。 | 否 |
| value | T | - | 选项值。 | 是 |


### TRadioSize

单选框指示器尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TRadioSize | - | 小尺寸。 | - |
| medium | TRadioSize | - | 中尺寸。 | - |
| large | TRadioSize | - | 大尺寸。 | - |


### TRadioIconType

单选框内置指示器样式。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| dot | TRadioIconType | - | 圆环内显示实心圆点。 | - |
| check | TRadioIconType | - | 选中时显示勾选标记。 | - |
| fill | TRadioIconType | - | 选中时显示带反色勾选标记的实心圆。 | - |


### TRadioVariant

单选框的完整视觉结构。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| inline | TRadioVariant | - | 行内结构，不绘制通栏背景、外围内边距或标准块高。 | - |
| block | TRadioVariant | - | 通栏结构，使用标准块高、容器背景和外围内边距。 | - |
| card | TRadioVariant | - | 卡片结构。 | - |


### TRadioIconBuilder

自定义单选框指示器构建器。

位置参数：`context, selected, disabled`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 单选框指示器的构建上下文。 | 是 |
| selected | bool | - | 当前选项是否选中。 | 是 |
| disabled | bool | - | 当前选项是否禁用。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 替换内置单选指示器的组件。 | - |


### TRadioThemeData

TRadio 组件级 ThemeExtension

通过 Theme 子树注入，控制子树默认样式。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 卡片背景颜色。 卡片模式下生效；null 时使用 bgColorContainer Token。 | 否 |
| disableColor | Color? | - | 禁用态颜色。 null 时选中禁用态使用 brandColorDisabled，未选中禁用态描边使用 componentBorder Token。 | 否 |
| insetSpacing | double? | - | 文案与非指示器侧的内边距。 null 时使用 spacer2 Token。 | 否 |
| selectColor | Color? | - | 选中态颜色。 null 时使用 brandColor Token。 | 否 |
| spacing | double? | - | 指示器与文案间距。 null 时使用 spacer Token。 | 否 |
| subTitleColor | Color? | - | 副标题颜色。 启用态 null 时使用 textColorSecondary Token；禁用态始终使用 textColorDisabled。 | 否 |
| titleColor | Color? | - | 主标题颜色。 启用态 null 时使用 textColorPrimary Token；禁用态始终使用 textColorDisabled。 | 否 |
