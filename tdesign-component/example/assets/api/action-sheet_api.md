## API

### TActionSheetItem

类型参数：`T`


动作面板项目

#### 构造方法

##### TActionSheetItem

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| badge | TBadgeConfig? | - | 展示在项目内容上的徽标配置；为空时不显示。 列表模式下以标题为锚点；宫格模式下以 `icon` 为锚点，因此宫格模式仅在 `icon` 非空时展示。默认位置由 ActionSheet 管理，`TBadgeConfig.alignment` 与 `TBadgeConfig.offset` 可逐项覆盖；完全自定义外观使用 `TBadgeConfig.custom`。 | 否 |
| disabled | bool | false | 是否禁用 | 否 |
| icon | Widget? | - | 图标槽位；调用方拥有其背景、形状和显式尺寸。 未显式设置尺寸或颜色的 `Icon` 会继承 `TActionSheetThemeData`。 | 否 |
| label | String | - | 标题 | 是 |
| subtitle | String? | - | 列表模式下的描述信息；宫格模式不展示。 | 否 |
| textStyle | TextStyle? | - | 标题样式 | 否 |
| value | T | - | 稳定的业务值 | 是 |


### TActionSheet

动作面板命令式入口。

点击启用项目时先调用 onSelected，再请求关闭；回调为空时仍会关闭。
点击取消按钮先调用 onCancel，再请求关闭；onClosed 在关闭流程完成后通知。
各方法返回 TPopupHandle，可主动关闭面板。

#### 主题配置

组件主题通过 `TActionSheetThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TActionSheetThemeData` 说明。

#### 静态方法

##### TActionSheet.showGrid

类型参数：`T`


位置参数：`context`


显示宫格动作面板

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 | 是 |
| items | List&lt;TActionSheetItem&lt;T&gt;&gt; | - | 宫格中的动作项目。 | 是 |
| layout | TActionSheetGridLayout | const TActionSheetGridLayout.fixed() | 普通、分页或横向滚动宫格布局。 | 否 |
| cancelText | String? | - | 取消按钮文字。 | 否 |
| subtitle | String? | - | 面板副标题；为 null 或空字符串时不展示。 | 否 |
| showCancel | bool | true | 是否显示取消按钮。 | 否 |
| showOverlay | bool | true | 是否显示蒙层。 | 否 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 | 否 |
| useSafeArea | bool | true | 是否避让系统安全区。 | 否 |
| itemHeight | double? | - | 宫格项目高度。 | 否 |
| onCancel | VoidCallback? | - | 点击取消时回调。 | 否 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 | 否 |
| onSelected | TActionSheetOnSelected&lt;T&gt;? | - | 点击动作时回调。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupHandle | - | 已经发起打开的动作面板控制句柄，可用于查询状态与关闭面板。 | - |


##### TActionSheet.showGridSections

类型参数：`T`


位置参数：`context`


显示带标题分组的横向滚动宫格动作面板。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 | 是 |
| sections | List&lt;TActionSheetGridSection&lt;T&gt;&gt; | - | 带标题的分组列表，每组独立横向滚动。 | 是 |
| cancelText | String? | - | 取消按钮文字，为 null 时使用本地化文案。 | 否 |
| showCancel | bool | true | 是否显示取消按钮。 | 否 |
| showOverlay | bool | true | 是否显示蒙层。 | 否 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 | 否 |
| useSafeArea | bool | true | 是否避让系统安全区。 | 否 |
| itemWidth | double | 80 | 横向列表单项宽度，默认为 80。 | 否 |
| itemHeight | double? | - | 单项高度；为 null 时使用组件主题，最终回退为 96。 | 否 |
| onCancel | VoidCallback? | - | 点击取消时回调。 | 否 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 | 否 |
| onSelected | TActionSheetOnSelected&lt;T&gt;? | - | 点击项目时回传原始项目。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupHandle | - | 已经发起打开的动作面板控制句柄，可用于查询状态与关闭面板。 | - |


##### TActionSheet.showList

类型参数：`T`


位置参数：`context`


显示列表动作面板

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 | 是 |
| items | List&lt;TActionSheetItem&lt;T&gt;&gt; | - | 列表中的动作项目。 | 是 |
| align | TActionSheetAlign | TActionSheetAlign.center | 项目文字对齐方式。 | 否 |
| cancelText | String? | - | 取消按钮文字。 | 否 |
| subtitle | String? | - | 面板副标题；为 null 或空字符串时不展示。 | 否 |
| showCancel | bool | true | 是否显示取消按钮。 | 否 |
| showOverlay | bool | true | 是否显示蒙层。 | 否 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 | 否 |
| useSafeArea | bool | true | 是否避让系统安全区。 | 否 |
| onCancel | VoidCallback? | - | 点击取消时回调。 | 否 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 | 否 |
| onSelected | TActionSheetOnSelected&lt;T&gt;? | - | 点击动作时回调。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TPopupHandle | - | 已经发起打开的动作面板控制句柄，可用于查询状态与关闭面板。 | - |


### TActionSheetThemeData

TActionSheet 组件级视觉 ThemeExtension

#### 构造方法

##### TActionSheetThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色 | 否 |
| gridIconExtent | double? | - | 宫格布局的图标槽位尺寸；未设置时默认 40dp。 | 否 |
| gridItemHeight | double? | - | 宫格项目高度 未配置时为 96 逻辑像素，show 方法的 itemHeight 优先。 | 否 |
| iconColor | Color? | - | 默认图标颜色。 未配置时使用 textColorPrimary Token；禁用项使用 textColorDisabled。 | 否 |
| iconSize | double? | - | 默认图标字形尺寸；同时作为列表图标槽位尺寸。 未配置时为 24 逻辑像素。 | 否 |
| panelRadius | double? | - | 面板圆角 | 否 |


#### 实例方法

##### TActionSheetThemeData.copyWith

复制主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| gridItemHeight | double? | - | 字段含义：宫格项目高度 未配置时为 96 逻辑像素，show 方法的 itemHeight 优先。 调用时的空值行为见方法说明。 | 否 |
| barrierColor | Color? | - | 字段含义：蒙层颜色 调用时的空值行为见方法说明。 | 否 |
| panelRadius | double? | - | 字段含义：面板圆角 调用时的空值行为见方法说明。 | 否 |
| iconSize | double? | - | 字段含义：默认图标字形尺寸；同时作为列表图标槽位尺寸。 未配置时为 24 逻辑像素。 调用时的空值行为见方法说明。 | 否 |
| gridIconExtent | double? | - | 字段含义：宫格布局的图标槽位尺寸；未设置时默认 40dp。 调用时的空值行为见方法说明。 | 否 |
| iconColor | Color? | - | 字段含义：默认图标颜色。 未配置时使用 textColorPrimary Token；禁用项使用 textColorDisabled。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TActionSheetThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TActionSheetThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TActionSheetThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TActionSheetThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


##### TActionSheetThemeData.merge

位置参数：`other`


合并主题配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | TActionSheetThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TActionSheetThemeData | - | 返回合并后的主题；`other` 的非空字段覆盖当前字段，other 为空时返回当前主题。 | - |


### TActionSheetGridLayout

动作面板宫格布局

使用 `TActionSheetGridLayout.fixed`、`TActionSheetGridLayout.paged` 或
`TActionSheetGridLayout.scroll` 创建互斥的布局配置。

#### 构造方法

##### TActionSheetGridLayout.fixed

普通固定宫格

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 | 否 |
| rows | int | - | 行数，默认 2；必须大于 0。 | 否 |


##### TActionSheetGridLayout.paged

整页切换并显示分页指示器的宫格

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 | 否 |
| rows | int | - | 行数，默认 2；必须大于 0。 | 否 |


##### TActionSheetGridLayout.scroll

可连续横向滚动的宫格

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 | 否 |
| rows | int | - | 行数，默认 2；必须大于 0。 | 否 |
| itemMinWidth | double? | - | 横向滚动项目的最小宽度；仅滚动布局可能返回非空值。 | 否 |


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 | - |
| itemMinWidth | double? | - | 横向滚动项目的最小宽度；仅滚动布局可能返回非空值。 | - |
| mode | TActionSheetGridMode | - | 布局模式 | - |
| rows | int | - | 行数，默认 2；必须大于 0。 | - |


### TActionSheetGridSection

类型参数：`T`


横向滚动宫格中的一个带标题分组。

通过 `TActionSheet.showGridSections` 展示。每个分组独立横向滚动，
`title` 显示在该组项目上方；`items` 为空时仍保留标题。

#### 构造方法

##### TActionSheetGridSection

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| items | List&lt;TActionSheetItem&lt;T&gt;&gt; | - | 该分组中的宫格项目。 | 是 |
| title | String | - | 分组标题。 | 是 |


### TActionSheetAlign

动作面板列表内容的物理对齐方式，不随文字方向交换左右。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| center | TActionSheetAlign | - | 居中对齐 | - |
| left | TActionSheetAlign | - | 左对齐 | - |
| right | TActionSheetAlign | - | 右对齐 | - |


### TActionSheetGridMode

宫格布局模式
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| fixed | TActionSheetGridMode | - | 固定宫格 | - |
| paged | TActionSheetGridMode | - | 分页宫格 | - |
| scroll | TActionSheetGridMode | - | 横向滚动宫格 | - |


### TActionSheetOnSelected

类型参数：`T`


选择动作面板项目时触发

位置参数：`item`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| item | TActionSheetItem&lt;T&gt; | - | 被点击的原始动作项目。 | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | void | - | 无返回值。 | - |
