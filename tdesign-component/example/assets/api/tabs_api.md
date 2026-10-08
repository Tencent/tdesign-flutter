## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TTabsBar
#### 简介
标签栏
支持滚动、指示器自定义，以及 Line、Tag、Card 三种 TDesign 形态。

#### 声明

```dart
class TTabsBar extends StatelessWidget
```

#### 默认构造方法


```dart
const TTabsBar({
  Key? key,
  required this.tabs,
  this.controller,
  this.isScrollable = false,
  this.onTap,
  this.size = TTabsBarSize.small,
  this.variant = TTabsBarVariant.line,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| controller | TabController? | - | 可选的标签控制器；为空时使用最近的 `DefaultTabController`。 仅在需要读取当前索引、命令式切换或跨组件共享状态时显式传入。 必须存在显式控制器或祖先 DefaultTabController，其 length 须等于 tabs.length。显式控制器由调用方释放。 | 否 |
| isScrollable | bool | false | 是否横向滚动。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onTap | ValueChanged&lt;int&gt;? | - | 点击事件 仅用于点击通知；为 null 时仍可切换标签，禁用单项请使用 TTab.enabled。 | 否 |
| size | TTabsBarSize | TTabsBarSize.small | 选项卡文字尺寸，默认为 `TTabsBarSize.small`。 | 否 |
| tabs | List&lt;TTab&gt; | - | tab数组 | 是 |
| variant | TTabsBarVariant | TTabsBarVariant.line | 选项卡结构形态，默认为 `TTabsBarVariant.line`。 | 否 |


### TTab
#### 简介
Tab 组件
TDesign 选项卡标签，通常作为 `TTabsBar.tabs` 的子项使用。

#### 声明

```dart
class TTab extends Tab
```

#### 默认构造方法


```dart
const TTab({Key? key, this.text, this.child, this.icon, this.enabled = true})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 自定义标签内容；与 text 互斥，可与 icon 同时提供。 | 否 |
| enabled | bool | true | 是否可用，默认 true。 设为 `false` 时使用禁用样式，并由 `TTabsBar` 阻止该项被选择。 Material `TabBar` 不识别此扩展字段；直接将 `TTab` 用作 Material `TabBar.tabs` 时只会呈现禁用样式，不会阻止其切换。 | 否 |
| icon | Widget? | - | 图标 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| text | String? | - | 文字内容；与 child 互斥，text、child、icon 至少提供一个。 | 否 |


### TTabsBarView
#### 简介
TabBarView 组件
Material TabBarView 薄包装。
`physics` 为空时默认不可滑动。

#### 声明

```dart
class TTabsBarView extends StatelessWidget
```

#### 默认构造方法


```dart
const TTabsBarView({
  Key? key,
  required this.children,
  this.controller,
  this.physics,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| children | List&lt;Widget&gt; | - | 子widget列表 | 是 |
| controller | TabController? | - | 可选的内容区控制器；为空时使用最近的 `DefaultTabController`。 与 `TTabsBar` 放在同一 `DefaultTabController` 下即可共享选中状态。 必须存在显式控制器或祖先 DefaultTabController，其 length 须等于 children.length。显式控制器由调用方释放。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| physics | ScrollPhysics? | - | 滑动物理特性；未传时默认不可滑动。 | 否 |


### TTabsBarIndicator
#### 简介
TDesign自定义下标

#### 声明

```dart
class TTabsBarIndicator extends Decoration
```

#### 默认构造方法


```dart
const TTabsBarIndicator({
  required this.indicatorColor,
  this.indicatorWidth,
  this.indicatorHeight,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| indicatorColor | Color | - | 指示器颜色 | 是 |
| indicatorHeight | double? | - | 指示器高度 | 否 |
| indicatorWidth | double? | - | 指示器宽度 | 否 |


### TTabsBarThemeData
#### 简介
TabBar 组件 ThemeExtension
管理 TTabsBar 的子树级视觉默认样式。

#### 声明

```dart
class TTabsBarThemeData extends ThemeExtension<TTabsBarThemeData>
```

#### 默认构造方法


```dart
const TTabsBarThemeData({
  this.backgroundColor,
  this.labelStyle,
  this.unselectedLabelStyle,
  this.disabledLabelStyle,
  this.labelPadding,
  this.indicator,
  this.dividerColor,
  this.dividerHeight,
  this.selectedTagBackgroundColor,
  this.tagBackgroundColor,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 栏背景色。 | 否 |
| disabledLabelStyle | TextStyle? | - | 禁用标签文字和图标样式。 | 否 |
| dividerColor | Color? | - | 分割线颜色。 | 否 |
| dividerHeight | double? | - | 分割线高度；小于等于 0 时不展示。 | 否 |
| indicator | Decoration? | - | 组件主题指示器；非空时覆盖内置形态指示器。 为空时 Line 使用 TDesign 默认指示器，Tag 与 Card 不展示指示器。 | 否 |
| labelPadding | EdgeInsetsGeometry? | - | 标签内容边距。 | 否 |
| labelStyle | TextStyle? | - | 选中标签文字样式。 | 否 |
| selectedTagBackgroundColor | Color? | - | Tag 形态下的选中背景色。 | 否 |
| tagBackgroundColor | Color? | - | Tag 形态下的默认背景色。 | 否 |
| unselectedLabelStyle | TextStyle? | - | 未选中标签文字样式。 | 否 |


#### 实例方法

##### TTabsBarThemeData.copyWith

```dart
TTabsBarThemeData copyWith({
  Color? backgroundColor,
  TextStyle? labelStyle,
  TextStyle? unselectedLabelStyle,
  TextStyle? disabledLabelStyle,
  EdgeInsetsGeometry? labelPadding,
  Decoration? indicator,
  Color? dividerColor,
  double? dividerHeight,
  Color? selectedTagBackgroundColor,
  Color? tagBackgroundColor,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TTabsBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 栏背景色。 | 否 |
| labelStyle | TextStyle? | - | 选中标签文字样式。 | 否 |
| unselectedLabelStyle | TextStyle? | - | 未选中标签文字样式。 | 否 |
| disabledLabelStyle | TextStyle? | - | 禁用标签文字和图标样式。 | 否 |
| labelPadding | EdgeInsetsGeometry? | - | 标签内容边距。 | 否 |
| indicator | Decoration? | - | 组件主题指示器；非空时覆盖内置形态指示器。 为空时 Line 使用 TDesign 默认指示器，Tag 与 Card 不展示指示器。 | 否 |
| dividerColor | Color? | - | 分割线颜色。 | 否 |
| dividerHeight | double? | - | 分割线高度；小于等于 0 时不展示。 | 否 |
| selectedTagBackgroundColor | Color? | - | Tag 形态下的选中背景色。 | 否 |
| tagBackgroundColor | Color? | - | Tag 形态下的默认背景色。 | 否 |


##### TTabsBarThemeData.lerp

```dart
TTabsBarThemeData lerp(ThemeExtension<TTabsBarThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TTabsBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTabsBarThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TTabsBarVariant
#### 简介
TabsBar 形态枚举。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| line | 底部指示器样式。 |
| tag | 胶囊标签样式。 |
| card | 卡片样式。 |


### TTabsBarSize
#### 简介
选项卡文字尺寸。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸，使用 14px 字体 Token。 |
| large | 大尺寸，使用 16px 字体 Token。 |
