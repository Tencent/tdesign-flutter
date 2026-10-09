## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TNavBar
#### 简介
NavBar 组件
展示页面标题、起始内容与操作项，可作为 Scaffold 的 appBar。
操作项 `onTap: null` 时禁用；标题颜色、背景与内边距通过
`TNavBarThemeData` 配置。
### 主题配置
组件主题通过 `TNavBarThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
`TNavBarThemeData` 说明。

#### 声明

```dart
class TNavBar extends StatelessWidget implements PreferredSizeWidget
```

#### 默认构造方法


```dart
const TNavBar({
  Key? key,
  this.title,
  this.leading,
  this.actions,
  this.centerTitle = true,
  this.useDefaultBack = false,
  this.onBack,
  this.belowTitleWidget,
  this.flexibleSpace,
  this.height = 48,
  this.useBorderStyle = false,
  this.useSafeArea = false,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| actions | List&lt;TNavBarItem&gt;? | - | 右侧操作项（对齐 AppBar.actions） | 否 |
| belowTitleWidget | Widget? | - | NavBar 标题区域下方的 Widget。 该内容位于 `height` 所定义的内容高度内；内容较高时，调用方需要同步增大 `height`，避免挤压标题栏。 | 否 |
| centerTitle | bool | true | 标题是否居中 | 否 |
| flexibleSpace | Widget? | - | 固定背景 Widget。 位于导航栏内容下层；若 Theme 的背景色完全不透明，背景内容不会透出。 | 否 |
| height | double | 48 | 高度；作为 `PreferredSizeWidget.preferredSize` 的唯一高度来源 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| leading | List&lt;TNavBarItem&gt;? | - | 左侧操作项（对齐 AppBar.leading） | 否 |
| onBack | VoidCallback? | - | 默认返回按钮的点击事件。 仅在 `useDefaultBack` 为 true 时生效。提供该回调时，由调用方完全接管返回 行为；未提供时，默认返回按钮会执行 `Navigator.maybePop`。 | 否 |
| title | Widget? | - | 标题控件。 文本标题可传入 `Text`，用法与 `AppBar.title` 一致。 标题自身的显式文本样式优先于 NavBar 提供的默认标题样式；例如 `TText` 默认会解析正文颜色，如需使用 Theme 的标题颜色，请通过 `TText.style` 传入相同颜色，或改用未显式设置颜色的 `Text`。 | 否 |
| useBorderStyle | bool | false | 是否使用边框模式 | 否 |
| useDefaultBack | bool | false | 是否使用默认的返回按钮，默认不显示 | 否 |
| useSafeArea | bool | false | 是否避让顶部系统安全区。 默认为 false。仅当导航栏直接位于页面顶部且外层未处理安全区时开启。 开启后，安全区高度只计入实际渲染高度，不计入 `preferredSize`； `height` 始终表示导航栏内容高度。 | 否 |


### TNavBarItem
#### 简介
NavBar 操作项

#### 声明

```dart
class TNavBarItem
```

#### 默认构造方法


```dart
const TNavBarItem({
  this.icon,
  this.iconColor,
  this.onTap,
  this.iconSize = 24.0,
  this.padding,
  this.customWidget,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| customWidget | Widget? | - | 自定义组件，优先级高于 icon，可以是任意 Widget | 否 |
| icon | IconData? | - | 图标 | 否 |
| iconColor | Color? | - | 图标颜色 | 否 |
| iconSize | double? | 24.0 | 图标尺寸，默认 24；显式传入 null 时由当前 `IconTheme` 决定。 | 否 |
| onTap | VoidCallback? | - | 点击回调；`null` 表示禁用 | 否 |
| padding | EdgeInsetsGeometry? | - | 内部填充 | 否 |


### TNavBarBorder
#### 简介
NavBar 边框配置（迁入 ThemeData）

#### 声明

```dart
class TNavBarBorder
```

#### 默认构造方法


```dart
const TNavBarBorder({
  this.width = 1.0,
  this.radius = 22.0,
  this.color,
  this.padding,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| color | Color? | - | 边框颜色 | 否 |
| padding | EdgeInsetsGeometry? | - | 内部填充 | 否 |
| radius | double | 22.0 | 边框圆角 | 否 |
| width | double | 1.0 | 边框宽度 | 否 |


### TNavBarThemeData
#### 简介
NavBar 组件 ThemeExtension
管理 TNavBar 的子树级默认样式（标题颜色、背景、内边距、阴影、边框等）。
构造器参数优先级高于 ThemeData。高度属于 PreferredSizeWidget 契约，只能通过 TNavBar.height 设置。

#### 声明

```dart
class TNavBarThemeData extends ThemeExtension<TNavBarThemeData>
```

#### 默认构造方法


```dart
const TNavBarThemeData({
  this.titleColor,
  this.backIconColor,
  this.backgroundColor,
  this.padding,
  this.titleMargin,
  this.opacity,
  this.border,
  this.boxShadow,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 | 否 |
| backIconColor | Color? | - | 返回图标颜色 | 否 |
| border | TNavBarBorder? | - | 操作项边框配置，仅在 TNavBar.useBorderStyle 为 true 时生效 | 否 |
| boxShadow | List&lt;BoxShadow&gt;? | - | 底部阴影 | 否 |
| opacity | double? | - | 背景颜色透明度，未配置时为 1 | 否 |
| padding | EdgeInsetsGeometry? | - | 内部填充 | 否 |
| titleColor | Color? | - | 标题的子树默认颜色。 仅在 NavBar 标题未自行提供前景色时生效；标题 Widget 自身的显式颜色优先。 | 否 |
| titleMargin | double? | - | 中间文案左右两边间距 | 否 |


#### 实例方法

##### TNavBarThemeData.copyWith

```dart
TNavBarThemeData copyWith({
  Color? titleColor,
  Color? backIconColor,
  Color? backgroundColor,
  EdgeInsetsGeometry? padding,
  double? titleMargin,
  double? opacity,
  TNavBarBorder? border,
  List<BoxShadow>? boxShadow,
})
```


复制主题配置。
## 返回值
返回只替换非空参数的新主题。
参数省略或传入 `null` 都会保留原值，符合 Flutter `copyWith` 的常见语义。
如需清除某个配置并恢复下层 Theme 或 Token，请重新构造
`TNavBarThemeData`，只传入仍需保留的字段。

返回类型：`TNavBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| titleColor | Color? | - | 标题的子树默认颜色。 仅在 NavBar 标题未自行提供前景色时生效；标题 Widget 自身的显式颜色优先。 | 否 |
| backIconColor | Color? | - | 返回图标颜色 | 否 |
| backgroundColor | Color? | - | 背景颜色 | 否 |
| padding | EdgeInsetsGeometry? | - | 内部填充 | 否 |
| titleMargin | double? | - | 中间文案左右两边间距 | 否 |
| opacity | double? | - | 背景颜色透明度，未配置时为 1 | 否 |
| border | TNavBarBorder? | - | 操作项边框配置，仅在 TNavBar.useBorderStyle 为 true 时生效 | 否 |
| boxShadow | List&lt;BoxShadow&gt;? | - | 底部阴影 | 否 |


##### TNavBarThemeData.lerp

```dart
TNavBarThemeData lerp(ThemeExtension<TNavBarThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TNavBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TNavBarThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |
