## API
### TActionSheetItem
#### 简介
动作面板项目
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| badge | TBadge? | - | 角标 |
| disabled | bool | false | 是否禁用 |
| group | String? | - | 分组，用于带描述多行滚动宫格 仅分组动作面板使用；未配置时该项目不会进入任何分组 |
| icon | Widget? | - | 图标槽位；调用方拥有其背景、形状和显式尺寸。 未显式设置尺寸或颜色的 `Icon` 会继承 `TActionSheetThemeData`。 |
| label | String | - | 标题 |
| subtitle | String? | - | 描述信息 |
| textStyle | TextStyle? | - | 标题样式 |


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
| items | List<TActionSheetItem> | - | 宫格中的动作项目。 |
| align | TActionSheetAlign? | - | 项目对齐方式。 |
| cancelText | String? | - | 取消按钮文字。 |
| subtitle | String? | - | 面板副标题。 |
| showCancel | bool | true | 是否显示取消按钮。 |
| showOverlay | bool | true | 是否显示蒙层。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 |
| useSafeArea | bool | true | 是否避让系统安全区。 |
| showPagination | bool | false | 是否显示分页指示器。 |
| scrollable | bool | false | 是否允许滚动。 |
| count | int? | - | 一个可视面板期望容纳的项目数，默认 8。 |
| rows | int? | - | 宫格行数，默认 2；`count` 必须能被 `rows` 整除。 |
| itemHeight | double? | - | 项目高度。 |
| itemMinWidth | double? | - | 横向滚动项目的最小宽度；未指定时按面板宽度、`count` 和 `rows` 自适应。 |
| onCancel | VoidCallback? | - | 点击取消时回调。 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 |
| onChanged | TActionSheetOnChanged? | - | 点击动作时回调。 |


##### TActionSheet.showGroup

显示分组动作面板

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 |
| items | List<TActionSheetItem> | - | 分组中的动作项目。 |
| align | TActionSheetAlign? | - | 项目对齐方式。 |
| cancelText | String? | - | 取消按钮文字。 |
| showCancel | bool | true | 是否显示取消按钮。 |
| showOverlay | bool | true | 是否显示蒙层。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 |
| useSafeArea | bool | true | 是否避让系统安全区。 |
| itemHeight | double? | - | 项目高度。 |
| itemMinWidth | double? | - | 项目最小宽度。 |
| onCancel | VoidCallback? | - | 点击取消时回调。 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 |
| onChanged | TActionSheetOnChanged? | - | 点击动作时回调。 |


##### TActionSheet.showList

显示列表动作面板

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 用于查找承载弹层的 Navigator。 |
| items | List<TActionSheetItem> | - | 列表中的动作项目。 |
| align | TActionSheetAlign? | - | 项目文字对齐方式。 |
| cancelText | String? | - | 取消按钮文字。 |
| subtitle | String? | - | 面板副标题。 |
| showCancel | bool | true | 是否显示取消按钮。 |
| showOverlay | bool | true | 是否显示蒙层。 |
| closeOnOverlayClick | bool | true | 点击蒙层是否关闭。 |
| useSafeArea | bool | true | 是否避让系统安全区。 |
| onCancel | VoidCallback? | - | 点击取消时回调。 |
| onClosed | VoidCallback? | - | 面板关闭后回调。 |
| onChanged | TActionSheetOnChanged? | - | 点击动作时回调。 |


### TActionSheetThemeData
#### 简介
TActionSheet 组件级 ThemeExtension

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
| count | int? | - | 宫格列数 |
| defaultAlign | TActionSheetAlign? | - | 默认对齐 |
| gridIconExtent | double? | - | 宫格和分组布局的图标槽位尺寸。 |
| iconColor | Color? | - | 默认图标颜色。 |
| iconSize | double? | - | 默认图标字形尺寸；同时作为列表图标槽位尺寸。 |
| itemHeight | double? | - | 项高度 |
| itemMinWidth | double? | - | 横向滚动宫格与分组项目的最小宽度。 滚动宫格未配置时会按 `count / rows` 自适应项目宽度；配置后作为最小宽度。 |
| panelRadius | double? | - | 面板圆角 |
| rows | int? | - | 宫格行数 |


### TActionSheetAlign
#### 简介
动作面板内容对齐方式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| center | 居中对齐 |
| left | 左对齐 |
| right | 右对齐 |
