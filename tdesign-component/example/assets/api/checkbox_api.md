## API

### TCheckbox

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
| maxSelected | int? | - | 最多可选数量。 | 否 |
| onChanged | ValueChanged&lt;List&lt;T&gt;&gt;? | - | 选中项列表变更回调；为 null 时整组禁用。 | 否 |
| onMaxSelected | VoidCallback? | - | 超过最多可选数量时触发。 | 否 |
| options | List&lt;TCheckboxOption&lt;T&gt;&gt; | - | 复选框数据项。 | 是 |
| showDivider | bool | true | 普通模式是否显示项间分割线，默认显示；卡片模式不显示。 | 否 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 | 否 |
| value | List&lt;T&gt; | - | 受控选中项列表。 | 是 |


### TContentDirection
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TContentDirection | - | 控件位于文案右侧。 | - |
| right | TContentDirection | - | 控件位于文案左侧。 | - |


### TCheckboxSize
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| small | TCheckboxSize | - | 小尺寸。 | - |
| medium | TCheckboxSize | - | 中尺寸。 | - |
| large | TCheckboxSize | - | 大尺寸。 | - |


### TCheckboxIconBuilder

位置参数：`context, value, disabled`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| value | bool? | - | - | 是 |
| disabled | bool | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |


### TCheckboxOptionBuilder

类型参数：`T`


位置参数：`context, option, selected, disabled`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| option | TCheckboxOption&lt;T&gt; | - | - | 是 |
| selected | bool | - | - | 是 |
| disabled | bool | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |
