## API
### TActionSheetItem
#### 简介
动作面板项目
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadgeConfig? | - | 展示在项目内容上的徽标配置；为空时不显示。 列表模式下以标题为锚点；宫格模式下以 `icon` 为锚点，因此宫格模式仅在 `icon` 非空时展示。默认位置由 ActionSheet 管理，`TBadgeConfig.alignment` 与 `TBadgeConfig.offset` 可逐项覆盖；完全自定义外观使用 `TBadgeConfig.custom`。 |
| disabled | bool | false | 是否禁用 |
| icon | Widget? | - | 图标槽位；调用方拥有其背景、形状和显式尺寸。 未显式设置尺寸或颜色的 `Icon` 会继承 `TActionSheetThemeData`。 |
| label | String | - | 标题 |
| subtitle | String? | - | 列表模式下的描述信息；宫格模式不展示。 |
| textStyle | TextStyle? | - | 标题样式 |
| value | T | - | 稳定的业务值 |


### TActionSheet
#### 简介
动作面板命令式入口

#### 静态方法

##### TActionSheet.showGrid

显示宫格动作面板

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 |
| items | List<TActionSheetItem<T>> | - | 宫格中的动作项目。 |
| layout | TActionSheetGridLayout | const TActionSheetGridLayout.fixed() | 普通、分页或横向滚动宫格布局。 |
| cancelText | String? | - | 取消按钮文字。 |
| subtitle | String? | - | 面板副标题；为 null 或空字符串时不展示。 |
| showCancel | bool | true | 是否显示取消按钮。 |
| showOverlay | bool | true | 是否显示蒙层。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 |
| useSafeArea | bool | true | 是否避让系统安全区。 |
| itemHeight | double? | - | 宫格项目高度。 |
| onCancel | VoidCallback? | - | 点击取消时回调。 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 |
| onSelected | TActionSheetOnSelected<T>? | - | 点击动作时回调。 |


##### TActionSheet.showGridSections

显示带标题分组的横向滚动宫格动作面板。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 |
| sections | List<TActionSheetGridSection<T>> | - | 带标题的分组列表，每组独立横向滚动。 |
| cancelText | String? | - | 取消按钮文字，为 null 时使用本地化文案。 |
| showCancel | bool | true | 是否显示取消按钮。 |
| showOverlay | bool | true | 是否显示蒙层。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 |
| useSafeArea | bool | true | 是否避让系统安全区。 |
| itemWidth | double | 80 | 横向列表单项宽度，默认为 80。 |
| itemHeight | double? | - | 单项高度；为 null 时使用组件主题，最终回退为 96。 |
| onCancel | VoidCallback? | - | 点击取消时回调。 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 |
| onSelected | TActionSheetOnSelected<T>? | - | 点击项目时回传原始项目。 |


##### TActionSheet.showList

显示列表动作面板

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 |
| items | List<TActionSheetItem<T>> | - | 列表中的动作项目。 |
| align | TActionSheetAlign | TActionSheetAlign.center | 项目文字对齐方式。 |
| cancelText | String? | - | 取消按钮文字。 |
| subtitle | String? | - | 面板副标题；为 null 或空字符串时不展示。 |
| showCancel | bool | true | 是否显示取消按钮。 |
| showOverlay | bool | true | 是否显示蒙层。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 |
| useSafeArea | bool | true | 是否避让系统安全区。 |
| onCancel | VoidCallback? | - | 点击取消时回调。 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 |
| onSelected | TActionSheetOnSelected<T>? | - | 点击动作时回调。 |


### TActionSheetThemeData
#### 简介
TActionSheet 组件级视觉 ThemeExtension
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色 |
| gridIconExtent | double? | - | 宫格布局的图标槽位尺寸；未设置时默认 40dp。 |
| gridItemHeight | double? | - | 宫格项目高度 |
| iconColor | Color? | - | 默认图标颜色。 |
| iconSize | double? | - | 默认图标字形尺寸；同时作为列表图标槽位尺寸。 |
| panelRadius | double? | - | 面板圆角 |


### TActionSheetGridLayout
#### 简介
动作面板宫格布局
使用 `TActionSheetGridLayout.fixed`、`TActionSheetGridLayout.paged` 或
`TActionSheetGridLayout.scroll` 创建互斥的布局配置。

#### 工厂构造方法

##### TActionSheetGridLayout.fixed

普通固定宫格

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数 |
| rows | int | - | 行数 |


##### TActionSheetGridLayout.paged

整页切换并显示分页指示器的宫格

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数 |
| rows | int | - | 行数 |


##### TActionSheetGridLayout.scroll

可连续横向滚动的宫格

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数 |
| rows | int | - | 行数 |
| itemMinWidth | double? | - | - |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数 |
| mode | TActionSheetGridMode | - | 布局模式 |
| rows | int | - | 行数 |


### TActionSheetGridSection
#### 简介
横向滚动宫格中的一个带标题分组。
通过 `TActionSheet.showGridSections` 展示。每个分组独立横向滚动，
`title` 显示在该组项目上方；`items` 为空时仍保留标题。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | List<TActionSheetItem<T>> | - | 该分组中的宫格项目。 |
| title | String | - | 分组标题。 |


### TActionSheetAlign
#### 简介
动作面板列表内容对齐方式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| center | 居中对齐 |
| left | 左对齐 |
| right | 右对齐 |


### TActionSheetGridMode
#### 简介
宫格布局模式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| fixed | 固定宫格 |
| paged | 分页宫格 |
| scroll | 横向滚动宫格 |


### TActionSheetOnSelected
#### 简介
选择动作面板项目时触发
#### 类型定义

```dart
typedef TActionSheetOnSelected = void Function(TActionSheetItem<T> item);
```
