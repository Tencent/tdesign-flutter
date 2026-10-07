## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TCollapse
#### 简介
折叠面板列表组件，需配合 `TCollapsePanel` 使用

#### 声明

```dart
class TCollapse<T extends Object> extends StatefulWidget
```

#### 默认构造方法


```dart
const TCollapse({
  required this.children,
  required this.value,
  this.mode = TCollapseMode.multiple,
  this.variant,
  this.animationDuration,
  this.onChanged,
  Key? key,
})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| animationDuration | Duration? | - | 折叠面板展开和收起的动画时长；未设置时使用 Flutter 主题动画默认值。 | 否 |
| children | List&lt;TCollapsePanel&lt;T&gt;&gt; | - | 折叠面板列表的子组件 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| mode | TCollapseMode | TCollapseMode.multiple | 折叠面板模式 | 否 |
| onChanged | ValueChanged&lt;List&lt;T&gt;&gt;? | - | 展开值列表变更回调。 回调返回点击后的完整、不可修改列表。为 null 时整组不可交互，并使用禁用 视觉和语义；单项仍可通过 `TCollapsePanel.disabled` 禁用。 | 否 |
| value | List&lt;T&gt; | - | 当前展开面板的值列表，是所有模式唯一的展开状态源。 列表中的值必须唯一，并与唯一的 `TCollapsePanel.value` 匹配。 `TCollapseMode.accordion` 模式最多允许一个值。 | 是 |
| variant | TCollapseVariant? | - | 折叠面板视觉形态；未设置时为 `TCollapseVariant.block`。 | 否 |


### TCollapsePanel
#### 简介
折叠面板配置。

#### 声明

```dart
class TCollapsePanel<T extends Object>
```

#### 默认构造方法


```dart
const TCollapsePanel({
  required this.value,
  required this.headerBuilder,
  required this.body,
  this.bodyHeight,
  this.key,
  this.disabled = false,
  this.placement = TCollapsePlacement.bottom,
  this.semanticsLabel,
  this.leadingBuilder,
  this.trailingBuilder,
  this.expandIconBuilder = _defaultExpandIconBuilder,
  this.backgroundColor,
})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 折叠面板的背景色。 | 否 |
| body | Widget | - | 折叠面板的内容组件。 | 是 |
| bodyHeight | double? | - | 展开内容区域的固定高度（包含内容内边距）。 适用于 `ListView` 等需要有界高度的内容；为空时由内容自然决定高度。 | 否 |
| disabled | bool | false | 是否禁用面板交互。 | 否 |
| expandIconBuilder | TCollapsePanelBuilder? | _defaultExpandIconBuilder | 构建展开图标。 省略时使用 TDesign 默认箭头；显式传入 null 时隐藏箭头；传入 builder 时以其返回的 Widget 替换默认箭头。Widget 会继承组件解析出的图标主题。 | 否 |
| headerBuilder | ExpansionPanelHeaderBuilder | - | 折叠面板的头部组件构造函数。 | 是 |
| key | Key? | - | 面板标识，用于列表插入、删除和重排时保留内容状态。 | 否 |
| leadingBuilder | TCollapsePanelBuilder? | - | 构建标题左侧区域。 返回的 Widget 会继承组件解析出的文字和图标主题。 | 否 |
| placement | TCollapsePlacement | TCollapsePlacement.bottom | 内容相对标题的展开方向。 | 否 |
| semanticsLabel | String? | - | 面板标题的无障碍标签；复杂自定义标题无法自动提取文本时使用。 | 否 |
| trailingBuilder | TCollapsePanelBuilder? | - | 构建标题右侧、展开图标之前的操作区域。 可根据 builder 收到的 `isExpanded` 显示“展开/收起”等文案或任意 Widget。 | 否 |
| value | T | - | 面板唯一标识，用于匹配父级 `TCollapse.value` 中的展开值。 | 是 |


### TCollapseThemeData
#### 简介
折叠面板组件级 ThemeExtension

#### 声明

```dart
class TCollapseThemeData extends ThemeExtension<TCollapseThemeData>
```

#### 默认构造方法


```dart
const TCollapseThemeData({
  this.backgroundColor,
  this.elevation,
  this.headerTextStyle,
  this.contentTextStyle,
  this.disabledHeaderTextStyle,
  this.iconColor,
  this.disabledIconColor,
  this.dividerColor,
  this.contentPadding,
  this.cardMargin,
  this.cardBorderRadius,
})
```

#### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认面板背景色 | 否 |
| cardBorderRadius | BorderRadius? | - | 卡片圆角。 | 否 |
| cardMargin | EdgeInsetsGeometry? | - | 卡片外边距。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距。 | 否 |
| contentTextStyle | TextStyle? | - | 内容文字样式。 | 否 |
| disabledHeaderTextStyle | TextStyle? | - | 禁用状态标题文字样式。 | 否 |
| disabledIconColor | Color? | - | 禁用状态展开图标颜色。 | 否 |
| dividerColor | Color? | - | 分隔线颜色。 | 否 |
| elevation | double? | - | 阴影 | 否 |
| headerTextStyle | TextStyle? | - | 标题文字样式。 | 否 |
| iconColor | Color? | - | 展开图标颜色。 | 否 |


#### 实例方法

##### TCollapseThemeData.copyWith

```dart
TCollapseThemeData copyWith({
  Color? backgroundColor,
  double? elevation,
  TextStyle? headerTextStyle,
  TextStyle? contentTextStyle,
  TextStyle? disabledHeaderTextStyle,
  Color? iconColor,
  Color? disabledIconColor,
  Color? dividerColor,
  EdgeInsetsGeometry? contentPadding,
  EdgeInsetsGeometry? cardMargin,
  BorderRadius? cardBorderRadius,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TCollapseThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认面板背景色 | 否 |
| elevation | double? | - | 阴影 | 否 |
| headerTextStyle | TextStyle? | - | 标题文字样式。 | 否 |
| contentTextStyle | TextStyle? | - | 内容文字样式。 | 否 |
| disabledHeaderTextStyle | TextStyle? | - | 禁用状态标题文字样式。 | 否 |
| iconColor | Color? | - | 展开图标颜色。 | 否 |
| disabledIconColor | Color? | - | 禁用状态展开图标颜色。 | 否 |
| dividerColor | Color? | - | 分隔线颜色。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 内容内边距。 | 否 |
| cardMargin | EdgeInsetsGeometry? | - | 卡片外边距。 | 否 |
| cardBorderRadius | BorderRadius? | - | 卡片圆角。 | 否 |


##### TCollapseThemeData.lerp

```dart
TCollapseThemeData lerp(
  ThemeExtension<TCollapseThemeData>? other,
  double t,
)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TCollapseThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TCollapseThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TCollapseMode
#### 简介
折叠面板展开模式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| multiple | 多个面板可同时展开。 |
| accordion | 最多展开一个面板。 |


### TCollapseVariant
#### 简介
折叠面板视觉形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| block | 通栏形态。 |
| card | 卡片形态。 |


### TCollapsePlacement
#### 简介
折叠内容相对标题的展开方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| bottom | 内容在标题下方展开。 |
| top | 内容在标题上方展开。 |


### TCollapsePanelBuilder
#### 简介
根据折叠状态构建面板头部区域内容的回调。
#### 类型定义

```dart
typedef TCollapsePanelBuilder = Widget Function(BuildContext context, bool isExpanded);
```
