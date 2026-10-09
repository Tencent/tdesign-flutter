## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TActionSheetItem
#### 简介
动作面板项目

#### 声明

```dart
class TActionSheetItem<T>
```

#### 默认构造方法


```dart
const TActionSheetItem({
  required this.value,
  required this.label,
  this.textStyle,
  this.icon,
  this.badge,
  this.subtitle,
  this.disabled = false,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| badge | TBadgeConfig? | - | 展示在项目内容上的徽标配置；为空时不显示。 列表模式下以标题为锚点；宫格模式下以 `icon` 为锚点，因此宫格模式仅在 `icon` 非空时展示。默认位置由 ActionSheet 管理，`TBadgeConfig.alignment` 与 `TBadgeConfig.offset` 可逐项覆盖；完全自定义外观使用 `TBadgeConfig.custom`。 | 否 |
| disabled | bool | false | 是否禁用 | 否 |
| icon | Widget? | - | 图标槽位；调用方拥有其背景、形状和显式尺寸。 未显式设置尺寸或颜色的 `Icon` 会继承 `TActionSheetThemeData`。 | 否 |
| label | String | - | 标题 | 是 |
| subtitle | String? | - | 列表模式下的描述信息；宫格模式不展示。 | 否 |
| textStyle | TextStyle? | - | 标题样式 | 否 |
| value | T | - | 稳定的业务值 | 是 |


### TActionSheet
#### 简介
动作面板命令式入口。
点击启用项目时先调用 onSelected，再请求关闭；回调为空时仍会关闭。
点击取消按钮先调用 onCancel，再请求关闭；onClosed 在关闭流程完成后通知。
各方法返回 TPopupHandle，可主动关闭面板。
### 主题配置
组件主题通过 `TActionSheetThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TActionSheetThemeData` 说明。

#### 声明

```dart
final class TActionSheet
```


#### 静态方法

##### TActionSheet.showGrid

```dart
static TPopupHandle showGrid<T>(
  BuildContext context, {
  required List<TActionSheetItem<T>> items,
  TActionSheetGridLayout layout = const TActionSheetGridLayout.fixed(),
  String? cancelText,
  String? subtitle,
  bool showCancel = true,
  bool showOverlay = true,
  bool closeOnOverlayClick = true,
  bool useSafeArea = true,
  double? itemHeight,
  VoidCallback? onCancel,
  VoidCallback? onClosed,
  TActionSheetOnSelected<T>? onSelected,
})
```


显示宫格动作面板
## 返回值
已经发起打开的动作面板控制句柄，可用于查询状态与关闭面板。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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


##### TActionSheet.showGridSections

```dart
static TPopupHandle showGridSections<T>(
  BuildContext context, {
  required List<TActionSheetGridSection<T>> sections,
  String? cancelText,
  bool showCancel = true,
  bool showOverlay = true,
  bool closeOnOverlayClick = true,
  bool useSafeArea = true,
  double itemWidth = 80,
  double? itemHeight,
  VoidCallback? onCancel,
  VoidCallback? onClosed,
  TActionSheetOnSelected<T>? onSelected,
})
```


显示带标题分组的横向滚动宫格动作面板。
## 返回值
已经发起打开的动作面板控制句柄，可用于查询状态与关闭面板。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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


##### TActionSheet.showList

```dart
static TPopupHandle showList<T>(
  BuildContext context, {
  required List<TActionSheetItem<T>> items,
  TActionSheetAlign align = TActionSheetAlign.center,
  String? cancelText,
  String? subtitle,
  bool showCancel = true,
  bool showOverlay = true,
  bool closeOnOverlayClick = true,
  bool useSafeArea = true,
  VoidCallback? onCancel,
  VoidCallback? onClosed,
  TActionSheetOnSelected<T>? onSelected,
})
```


显示列表动作面板
## 返回值
已经发起打开的动作面板控制句柄，可用于查询状态与关闭面板。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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


### TActionSheetThemeData
#### 简介
TActionSheet 组件级视觉 ThemeExtension

#### 声明

```dart
class TActionSheetThemeData extends ThemeExtension<TActionSheetThemeData>
```

#### 默认构造方法


```dart
const TActionSheetThemeData({
  this.gridItemHeight,
  this.barrierColor,
  this.panelRadius,
  this.iconSize,
  this.gridIconExtent,
  this.iconColor,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| barrierColor | Color? | - | 蒙层颜色 | 否 |
| gridIconExtent | double? | - | 宫格布局的图标槽位尺寸；未设置时默认 40dp。 | 否 |
| gridItemHeight | double? | - | 宫格项目高度 未配置时为 96 逻辑像素，show 方法的 itemHeight 优先。 | 否 |
| iconColor | Color? | - | 默认图标颜色。 未配置时使用 textColorPrimary Token；禁用项使用 textColorDisabled。 | 否 |
| iconSize | double? | - | 默认图标字形尺寸；同时作为列表图标槽位尺寸。 未配置时为 24 逻辑像素。 | 否 |
| panelRadius | double? | - | 面板圆角 | 否 |


#### 实例方法

##### TActionSheetThemeData.copyWith

```dart
TActionSheetThemeData copyWith({
  double? gridItemHeight,
  Color? barrierColor,
  double? panelRadius,
  double? iconSize,
  double? gridIconExtent,
  Color? iconColor,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TActionSheetThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| gridItemHeight | double? | - | 宫格项目高度 未配置时为 96 逻辑像素，show 方法的 itemHeight 优先。 | 否 |
| barrierColor | Color? | - | 蒙层颜色 | 否 |
| panelRadius | double? | - | 面板圆角 | 否 |
| iconSize | double? | - | 默认图标字形尺寸；同时作为列表图标槽位尺寸。 未配置时为 24 逻辑像素。 | 否 |
| gridIconExtent | double? | - | 宫格布局的图标槽位尺寸；未设置时默认 40dp。 | 否 |
| iconColor | Color? | - | 默认图标颜色。 未配置时使用 textColorPrimary Token；禁用项使用 textColorDisabled。 | 否 |


##### TActionSheetThemeData.lerp

```dart
TActionSheetThemeData lerp(
  ThemeExtension<TActionSheetThemeData>? other,
  double t,
)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TActionSheetThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TActionSheetThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


##### TActionSheetThemeData.merge

```dart
TActionSheetThemeData merge(TActionSheetThemeData? other)
```


合并主题配置。
## 返回值
返回合并后的主题；`other` 的非空字段覆盖当前字段，other 为空时返回当前主题。

返回类型：`TActionSheetThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | TActionSheetThemeData? | - | 要合并的目标主题；为空时保留当前配置。 | 是 |


### TActionSheetGridLayout
#### 简介
动作面板宫格布局
使用 `TActionSheetGridLayout.fixed`、`TActionSheetGridLayout.paged` 或
`TActionSheetGridLayout.scroll` 创建互斥的布局配置。

#### 声明

```dart
sealed class TActionSheetGridLayout
```


#### 工厂构造方法

##### TActionSheetGridLayout.fixed

```dart
const factory TActionSheetGridLayout.fixed({int count, int rows})
```


普通固定宫格

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 | 否 |
| rows | int | - | 行数，默认 2；必须大于 0。 | 否 |


##### TActionSheetGridLayout.paged

```dart
const factory TActionSheetGridLayout.paged({int count, int rows})
```


整页切换并显示分页指示器的宫格

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 | 否 |
| rows | int | - | 行数，默认 2；必须大于 0。 | 否 |


##### TActionSheetGridLayout.scroll

```dart
const factory TActionSheetGridLayout.scroll({
  int count,
  int rows,
  double? itemMinWidth,
})
```


可连续横向滚动的宫格

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 | 否 |
| rows | int | - | 行数，默认 2；必须大于 0。 | 否 |
| itemMinWidth | double? | - | 横向滚动项目的最小宽度；仅滚动布局可能返回非空值。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| count | int | - | 一个可视面板期望容纳的项目数，默认 8。必须大于 0、不得小于 rows， 且能被 rows 整除。 |
| itemMinWidth | double? | - | 横向滚动项目的最小宽度；仅滚动布局可能返回非空值。 |
| mode | TActionSheetGridMode | - | 布局模式 |
| rows | int | - | 行数，默认 2；必须大于 0。 |


### TActionSheetGridSection
#### 简介
横向滚动宫格中的一个带标题分组。
通过 `TActionSheet.showGridSections` 展示。每个分组独立横向滚动，
`title` 显示在该组项目上方；`items` 为空时仍保留标题。

#### 声明

```dart
class TActionSheetGridSection<T>
```

#### 默认构造方法


```dart
const TActionSheetGridSection({required this.title, required this.items})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| items | List&lt;TActionSheetItem&lt;T&gt;&gt; | - | 该分组中的宫格项目。 | 是 |
| title | String | - | 分组标题。 | 是 |


### TActionSheetAlign
#### 简介
动作面板列表内容的物理对齐方式，不随文字方向交换左右。
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
`item` 被点击的原始动作项目。
## 返回值
无返回值。
#### 类型定义

```dart
typedef TActionSheetOnSelected<T> = void Function(TActionSheetItem<T> item);
```
