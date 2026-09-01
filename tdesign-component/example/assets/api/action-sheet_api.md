## API
### TActionSheetItem
#### 简介
动作面板项目
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 角标 |
| disabled | bool | false | 是否禁用 |
| icon | Widget? | - | 图标槽位；调用方拥有其背景、形状和显式尺寸。 未显式设置尺寸或颜色的 `Icon` 会继承 `TActionSheetThemeData`。 |
| label | String | - | 标题 |
| subtitle | String? | - | 描述信息 |
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
| subtitle | String? | - | 面板副标题。 |
| showCancel | bool | true | 是否显示取消按钮。 |
| showOverlay | bool | true | 是否显示蒙层。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 |
| useSafeArea | bool | true | 是否避让系统安全区。 |
| itemHeight | double? | - | 宫格项目高度。 |
| onCancel | VoidCallback? | - | 点击取消时回调。 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 |
| onSelected | TActionSheetOnSelected<T>? | - | 点击动作时回调。 |


##### TActionSheet.showList

显示列表动作面板

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 |
| items | List<TActionSheetItem<T>> | - | 列表中的动作项目。 |
| align | TActionSheetAlign | TActionSheetAlign.center | 项目文字对齐方式。 |
| cancelText | String? | - | 取消按钮文字。 |
| subtitle | String? | - | 面板副标题。 |
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

#### 静态方法

##### TActionSheetThemeData.lerpDouble

返回类型：`double?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| a | double? | - | - |
| b | double? | - | - |
| t | double | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色 |
| gridIconExtent | double? | - | 宫格布局的图标槽位尺寸。 |
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
