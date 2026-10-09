## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TPicker
#### 简介
严格受控的滚轮选择器。
独立多列使用 `TPickerColumns`，层级联动使用 `TPickerLinked`。弹层和确认
操作由调用方组合，组件本身只负责滚轮选择。标准弹层使用 `TPickerPopup.show`。
### 主题配置
组件主题通过 `TPickerThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TPickerThemeData` 说明。

#### 声明

```dart
class TPicker extends StatefulWidget
```

#### 默认构造方法


```dart
const TPicker({
  super.key,
  required this.items,
  required this.value,
  this.onChanged,
  this.onColumnScrollEnd,
  this.itemBuilder,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| itemBuilder | TPickerItemBuilder? | - | 自定义选项构建器。 | 否 |
| items | TPickerItems | - | 不可变数据源；更新选项时创建新的数据源与列表，不原地修改。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;TPickerValue&gt;? | - | 值变化回调；为 null 时禁用。 | 否 |
| onColumnScrollEnd | void Function(int columnIndex, TPickerValue value)? | - | 某列滚动结束时的候选快照，不表示父级已接受该值。 | 否 |
| value | List&lt;Object?&gt; | - | 各列受控值。使用不可变列表，更新时提供新列表。 拖动期间可显示候选值；滚动结束后父级未接受 `onChanged` 的值时， 恢复到此值。父级接受变化时，应通过重建回传新的值。 | 是 |


### TPickerPopup
#### 简介
Picker 专用弹层入口。
`TPicker` 与 `TDateTimePicker` 的滚轮仍是可独立组合的纯面板；需要设计稿中的
底部弹层时使用 `show`。该入口统一为标准 `TPopupHeader` 和完整滚轮视窗预留
高度，避免调用方按通用 Popup 默认高度拼装后压缩或裁切滚轮。弹层高度在每次 `show`
时读取主题；复用已有句柄重新打开不会重新计算高度。

#### 声明

```dart
final class TPickerPopup
```


#### 静态方法

##### TPickerPopup.show

```dart
static TPopupHandle show(
  BuildContext context, {
  required Widget child,
  required TPickerPopupHeaderBuilder headerBuilder,
  TPopupBottomInset? inset,
  double? radius,
  Color? backgroundColor,
  TPopupOverlayConfig? overlay,
  bool destroyOnClose = false,
  Duration? animationDuration,
  VoidCallback? onOpened,
  VoidCallback? onClosed,
  TPopupVisibleChangeCallback? onVisibleChange,
  bool useSafeArea = false,
  BuildContext? navigatorContext,
  bool useRootNavigator = false,
})
```


打开包含标准头部和 Picker 滚轮的底部弹层。
弹层总高为当前 `TPickerThemeData.height`（默认 200）加
`TPopupHeader.headerHeight`（58）。`child` 通常为 `TPicker` 或
`TDateTimePicker`，其受控值、确认和取消状态仍由调用方管理。
## 返回值
已经发起打开的 Popup 控制句柄，可用于查询状态和关闭弹层。

返回类型：`TPopupHandle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |
| child | Widget | - | Picker 滚轮面板。 | 是 |
| headerBuilder | TPickerPopupHeaderBuilder | - | 标准 58px 头部构建器。 | 是 |
| inset | TPopupBottomInset? | - | 底部弹层的边缘缩进。 | 否 |
| radius | double? | - | 顶部圆角；null 时使用 Popup 主题或 TDesign 默认值。 | 否 |
| backgroundColor | Color? | - | 面板背景色；null 时使用 Popup 主题或容器色。 | 否 |
| overlay | TPopupOverlayConfig? | - | 蒙层行为；null 时沿用 Popup 默认值。 | 否 |
| destroyOnClose | bool | false | 默认 false；为 true 时路由被其他不透明路由覆盖可释放内容 State。 关闭路由后内容始终释放，再次打开会创建新 State。 | 否 |
| animationDuration | Duration? | - | 打开和关闭动画时长。 | 否 |
| onOpened | VoidCallback? | - | 打开动画完成回调。 | 否 |
| onClosed | VoidCallback? | - | 关闭动画完成回调。 | 否 |
| onVisibleChange | TPopupVisibleChangeCallback? | - | 弹层显隐变化回调。 | 否 |
| useSafeArea | bool | false | 是否避让底部安全区，默认 false。 | 否 |
| navigatorContext | BuildContext? | - | 可选的 Navigator 上下文；默认使用 `context`。 | 否 |
| useRootNavigator | bool | false | 是否使用根 Navigator，默认 false。 | 否 |


### TPickerOption
#### 简介
选择器选项。
选项及 `children` 按不可变数据使用；更新时创建新选项和新列表。

#### 声明

```dart
class TPickerOption
```

#### 默认构造方法


```dart
const TPickerOption({
  required this.label,
  required this.value,
  this.disabled = false,
  this.children = const [],
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| children | List&lt;TPickerOption&gt; | const [] | 联动模式下的子选项。 | 否 |
| disabled | bool | false | 是否禁用。 | 否 |
| label | String | - | 展示文案。 | 是 |
| value | Object? | - | 业务值。 | 是 |


### TPickerValue
#### 简介
各列当前选中项的只读快照。
组件回调产生的列表不可修改。手工构造时，调用方须提供不可变列表；
const 构造不会复制或冻结传入的 `selectedOptions` 和 `indexes`。

#### 声明

```dart
class TPickerValue
```

#### 默认构造方法


```dart
const TPickerValue({required this.selectedOptions, required this.indexes})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| indexes | List&lt;int&gt; | - | 各列选中索引。 | 是 |
| selectedOptions | List&lt;TPickerOption&gt; | - | 各列选中的完整选项。 | 是 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| labels | List&lt;String&gt; | - | 各列展示文案。 |
| values | List&lt;Object?&gt; | - | 各列业务值。 |


### TPickerColumns
#### 简介
互不联动的多列数据源。
`columns` 及每列列表不得原地修改；变更时传入新的数据源和列表。

#### 声明

```dart
class TPickerColumns extends TPickerItems
```

#### 默认构造方法


```dart
const TPickerColumns(this.columns)
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| columns | List&lt;List&lt;TPickerOption&gt;&gt; | - | 各列选项。 | 是 |


### TPickerLinked
#### 简介
由 `TPickerOption.children` 描述层级关系的联动数据源。
`options` 及所有子选项列表不得原地修改；变更时创建新的数据源。

#### 声明

```dart
class TPickerLinked extends TPickerItems
```

#### 默认构造方法


```dart
const TPickerLinked(this.options)
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| options | List&lt;TPickerOption&gt; | - | 根选项。 | 是 |


### TPickerThemeData
#### 简介
TPicker 组件级 ThemeExtension
被 TPicker 和 TDateTimePicker 共用。

#### 声明

```dart
class TPickerThemeData extends ThemeExtension<TPickerThemeData>
```

#### 默认构造方法


```dart
const TPickerThemeData({this.height, this.itemCount})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| height | double? | - | 滚轮视窗高度，单位为逻辑像素；null 时使用默认值 200。 必须为有限正数，行高由此高度除以 `itemCount`（默认 5）得到。 | 否 |
| itemCount | int? | - | 每屏显示项数，null 时使用默认值 5；必须大于零。 | 否 |


#### 实例方法

##### TPickerThemeData.copyWith

```dart
TPickerThemeData copyWith({double? height, int? itemCount})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TPickerThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| height | double? | - | 滚轮视窗高度，单位为逻辑像素；null 时使用默认值 200。 必须为有限正数，行高由此高度除以 `itemCount`（默认 5）得到。 | 否 |
| itemCount | int? | - | 每屏显示项数，null 时使用默认值 5；必须大于零。 | 否 |


##### TPickerThemeData.lerp

```dart
TPickerThemeData lerp(ThemeExtension<TPickerThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TPickerThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TPickerThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TPickerItems
#### 简介
选择器数据源。

#### 声明

```dart
sealed class TPickerItems
```

#### 默认构造方法


```dart
const TPickerItems()
```


### TPickerPopupHeaderBuilder
#### 简介
构建 Picker 标准弹层头部。
返回类型限定为 `TPopupHeader`，使弹层尺寸计算与实际头部的
`TPopupHeader.headerHeight` 保持一致。
`context` 弹层头部的构建上下文。
`close` 请求关闭当前 Picker 弹层的回调。
## 返回值
标准弹层头部；其 headerHeight 参与弹层总高度计算。
#### 类型定义

```dart
typedef TPickerPopupHeaderBuilder = TPopupHeader Function(BuildContext context, VoidCallback close);
```


### TPickerItemBuilder
#### 简介
选择器子项构建器。
`context` 滚轮选项的构建上下文。
`option` 当前选项数据。
`columnIndex` 当前列索引，从 0 开始。
`itemIndex` 当前选项在列中的索引，从 0 开始。
`distance` 当前选项距滚轮中心的绝对距离，以选项高度为单位。
## 返回值
当前选项内容；返回 null 时使用默认文字渲染。
#### 类型定义

```dart
typedef TPickerItemBuilder = Widget? Function(BuildContext context, TPickerOption option, int columnIndex, int itemIndex, double distance);
```
