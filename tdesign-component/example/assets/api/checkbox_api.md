## API

### TCheckbox

严格受控的复选框；`onChanged` 为 null 时禁用。

#### 构造方法

##### TCheckbox

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 | 否 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 | 否 |
| customIconBuilder | TCheckboxIconBuilder? | - | 自定义复选框指示器。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;bool?&gt;? | - | 选中态变更回调；为 null 时禁用。 | 否 |
| showDivider | bool | true | 普通模式是否显示底部分割线，默认显示；卡片模式不显示。 | 否 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 | 否 |
| subTitle | String? | - | 副标题文案。 | 否 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 | 否 |
| title | String? | - | 主标题文案。 | 否 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 | 否 |
| value | bool? | - | 受控选中态；null 表示半选。 | 是 |


### TCheckboxGroup

类型参数：`T`


数据驱动且严格受控的复选框组。

#### 构造方法

##### TCheckboxGroup

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 | 否 |
| columns | int | 1 | 每行列数，必须大于 0。 | 否 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 | 否 |
| direction | Axis | Axis.vertical | 排列方向。 | 否 |
| itemBuilder | TCheckboxOptionBuilder&lt;T&gt;? | - | 自定义数据项视觉；交互仍由组接管。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxSelected | int? | - | 最多可选数量。 null 时不限制；达到上限后阻止新增选择，但仍允许取消。设为 0 时不能新增选择。 | 否 |
| onChanged | ValueChanged&lt;List&lt;T&gt;&gt;? | - | 选中项列表变更回调；为 null 时整组禁用。 回调提供完整选中列表，按 options 的顺序排列；父组件需回传新的 value。 | 否 |
| onMaxSelected | VoidCallback? | - | 超过最多可选数量时触发。 | 否 |
| options | List&lt;TCheckboxOption&lt;T&gt;&gt; | - | 复选框数据项。 | 是 |
| showDivider | bool | true | 普通模式是否显示项间分割线，默认显示；卡片模式不显示。 | 否 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 | 否 |
| value | List&lt;T&gt; | - | 受控选中项列表。 | 是 |


### TCheckboxOption

类型参数：`T`


复选框组的数据项。

#### 构造方法

##### TCheckboxOption

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| disabled | bool | false | 是否禁用该项。 | 否 |
| label | String | - | 主文案。 | 是 |
| subTitle | String? | - | 副文案。 | 否 |
| value | T | - | 选项值。 | 是 |


### TContentDirection

选择控件相对于文案的排列方向。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TContentDirection | - | 控件位于文案右侧。 | - |
| right | TContentDirection | - | 控件位于文案左侧。 | - |


### TCheckboxSize

复选框指示器尺寸。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TCheckboxSize | - | 小尺寸。 | - |
| medium | TCheckboxSize | - | 中尺寸。 | - |
| large | TCheckboxSize | - | 大尺寸。 | - |


### TCheckboxVariant

复选框指示器的视觉变体。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| circle | TCheckboxVariant | - | 圆形指示器。 | - |
| square | TCheckboxVariant | - | 方形指示器。 | - |
| check | TCheckboxVariant | - | 仅显示勾选或半选图标。 | - |


### TCheckboxIconBuilder

自定义复选框指示器构建器。

位置参数：`context, value, disabled`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 复选框指示器的构建上下文。 | 是 |
| value | bool? | - | 当前选中状态；null 表示半选。 | 是 |
| disabled | bool | - | 当前复选框是否禁用。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 替换内置指示器的组件。 | - |


### TCheckboxOptionBuilder

类型参数：`T`


自定义复选框组数据项构建器。

位置参数：`context, option, selected, disabled`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 复选框组选项的构建上下文。 | 是 |
| option | TCheckboxOption&lt;T&gt; | - | 当前数据项。 | 是 |
| selected | bool | - | 当前数据项是否选中。 | 是 |
| disabled | bool | - | 当前数据项是否禁用。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | 当前数据项的自定义内容。 | - |


### TCheckboxThemeData

TCheckbox 组件级 ThemeExtension

通过 Theme 子树注入，控制子树默认样式。
被 TCheckbox 和 TCheckboxGroup 共用。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 卡片背景颜色。 卡片模式下生效；null 时使用 bgColorContainer Token。 | 否 |
| customSpace | EdgeInsetsGeometry? | - | 内容区域内边距。 null 时按是否有文案、卡片模式及当前字号计算内边距；纯指示器不增加文案内边距。 | 否 |
| disableColor | Color? | - | 禁用态指示器的前景色；未选时用于描边色。 | 否 |
| insetSpacing | double? | - | 文案与非指示器侧的内边距。 null 时使用 spacer2 Token。 | 否 |
| selectColor | Color? | - | 选中态颜色。 null 时使用 brandColor Token。 | 否 |
| spacing | double? | - | 指示器与文案间距。 null 时使用 spacer Token。 | 否 |
| subTitleColor | Color? | - | 副标题颜色。 启用态 null 时使用 textColorSecondary Token；禁用态始终使用 textColorDisabled。 | 否 |
| titleColor | Color? | - | 主标题颜色。 启用态 null 时使用 textColorPrimary Token；禁用态始终使用 textColorDisabled。 | 否 |
| variant | TCheckboxVariant? | - | 复选框指示器的默认视觉变体；未设置时使用圆形。 | 否 |
