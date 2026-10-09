## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TIndexes
#### 简介
索引

#### 声明

```dart
class TIndexes extends StatefulWidget
```

#### 默认构造方法


```dart
const TIndexes({
  Key? key,
  this.indexList,
  this.initialIndex,
  this.useSafeArea = false,
  this.sticky = true,
  this.stickyOffset = 0,
  this.capsuleTheme = false,
  this.reverse = false,
  this.scrollController,
  this.onChanged,
  this.onSelect,
  required this.builderContent,
  this.builderAnchor,
  this.builderIndex,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 锚点自定义构建 | 否 |
| builderContent | Widget? Function(BuildContext context, String index) | - | 内容自定义构建 | 是 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 | 否 |
| capsuleTheme | bool | false | 锚点是否为胶囊式样式 | 否 |
| indexList | List&lt;String&gt;? | - | 索引字符列表。不传默认 A-Z；默认值要求 `builderContent` 能处理 A-Z 全部索引，自定义数据建议显式传入。 列表更新后若不再包含当前活动项，组件回退到新列表首项、同步滚动位置并触发 `onChanged`。 | 否 |
| initialIndex | String? | - | 初始激活索引。为空时使用 `indexList` 的第一项 仅在组件首次创建时生效；后续活动索引由滚动位置派生。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | void Function(String index)? | - | 当前激活索引发生变更时触发（含滚动吸顶派生与用户侧栏选择） | 否 |
| onSelect | void Function(String index)? | - | 用户在侧边栏点击或拖动选择索引（激活索引变化）时触发；滚动吸顶派生不会触发本回调 | 否 |
| reverse | bool | false | 是否反向滚动 | 否 |
| scrollController | ScrollController? | - | 滚动控制器 | 否 |
| sticky | bool | true | 锚点是否吸顶 | 否 |
| stickyOffset | double | 0 | 锚点吸顶时与顶部的距离 | 否 |
| useSafeArea | bool | false | 是否避让系统安全区，默认 false。 仅在组件自身负责屏幕边缘布局时开启；若外层 Popup 或页面壳已经处理安全区， 应保持关闭，避免重复避让。 | 否 |


### TIndexesAnchor
#### 简介
索引锚点

#### 声明

```dart
class TIndexesAnchor extends StatelessWidget
```

#### 默认构造方法


```dart
const TIndexesAnchor({
  Key? key,
  required this.sticky,
  required this.text,
  required this.capsuleTheme,
  this.builderAnchor,
  required this.activeIndex,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| activeIndex | ValueNotifier&lt;String&gt; | - | 选中索引 | 是 |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 索引锚点构建 | 否 |
| capsuleTheme | bool | - | 是否为胶囊式样式 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| sticky | bool | - | 索引是否吸顶 | 是 |
| text | String | - | 锚点文本 | 是 |


### TIndexesList
#### 简介
索引

#### 声明

```dart
class TIndexesList extends StatefulWidget
```

#### 默认构造方法


```dart
const TIndexesList({
  Key? key,
  required this.indexList,
  this.indexListMaxHeight = 0.8,
  required this.activeIndex,
  required this.onSelect,
  this.builderIndex,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| activeIndex | ValueNotifier&lt;String&gt; | - | 选中索引 | 是 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 | 否 |
| indexList | List&lt;String&gt; | - | 索引字符列表，需显式传入实际展示的索引序列。本组件不自带默认值；通常由 TIndexes 装配并透传（TIndexes 未指定时默认使用 A-Z） | 是 |
| indexListMaxHeight | double | 0.8 | 索引列表最大高度（父容器高度的百分比，默认0.8） | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onSelect | void Function(String newIndex, String oldIndex) | - | 用户点击或拖动侧边栏、激活索引发生变化时触发 | 是 |


### TIndexesThemeData
#### 简介
索引组件的子树级视觉主题。
仅管理尺寸、颜色和字体。吸顶、滚动方向与胶囊模式属于组件实例行为。

#### 声明

```dart
class TIndexesThemeData extends ThemeExtension<TIndexesThemeData>
```

#### 默认构造方法


```dart
const TIndexesThemeData({
  this.indexListMaxHeight,
  this.sidebarRight,
  this.indexItemSize,
  this.indexItemSpacing,
  this.tipSize,
  this.tipMaxWidth,
  this.tipGap,
  this.indexColor,
  this.activeIndexColor,
  this.activeIndexBackgroundColor,
  this.tipColor,
  this.tipBackgroundColor,
  this.indexFont,
  this.activeIndexFont,
  this.tipFont,
  this.anchorColor,
  this.activeAnchorColor,
  this.anchorBackgroundColor,
  this.activeAnchorBackgroundColor,
  this.anchorBorderColor,
  this.anchorFont,
  this.activeAnchorFont,
  this.anchorVerticalPadding,
  this.anchorHorizontalPadding,
  this.capsuleMargin,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| activeAnchorBackgroundColor | Color? | - | 激活锚点背景色。 | 否 |
| activeAnchorColor | Color? | - | 激活锚点文字颜色。 | 否 |
| activeAnchorFont | Font? | - | 激活锚点字体。 | 否 |
| activeIndexBackgroundColor | Color? | - | 激活索引背景色。 | 否 |
| activeIndexColor | Color? | - | 激活索引文字颜色。 | 否 |
| activeIndexFont | Font? | - | 激活索引字体。 | 否 |
| anchorBackgroundColor | Color? | - | 普通锚点背景色。 | 否 |
| anchorBorderColor | Color? | - | 激活锚点边框颜色。 | 否 |
| anchorColor | Color? | - | 普通锚点文字颜色。 | 否 |
| anchorFont | Font? | - | 普通锚点字体。 | 否 |
| anchorHorizontalPadding | double? | - | 锚点水平内边距。 | 否 |
| anchorVerticalPadding | double? | - | 锚点垂直内边距。 | 否 |
| capsuleMargin | double? | - | 胶囊锚点的水平外边距。 | 否 |
| indexColor | Color? | - | 普通索引文字颜色。 | 否 |
| indexFont | Font? | - | 普通索引字体。 | 否 |
| indexItemSize | double? | - | 单个索引的尺寸。 | 否 |
| indexItemSpacing | double? | - | 相邻索引之间的距离。 | 否 |
| indexListMaxHeight | double? | - | 索引列表最大高度占父容器高度的比例。 | 否 |
| sidebarRight | double? | - | 侧栏距容器右侧的距离。 | 否 |
| tipBackgroundColor | Color? | - | 按压提示背景色。 | 否 |
| tipColor | Color? | - | 按压提示文字颜色。 | 否 |
| tipFont | Font? | - | 按压提示字体。 | 否 |
| tipGap | double? | - | 按压提示与索引之间的距离。 | 否 |
| tipMaxWidth | double? | - | 按压提示的最大宽度。 | 否 |
| tipSize | double? | - | 按压提示的最小尺寸。 | 否 |


#### 实例方法

##### TIndexesThemeData.copyWith

```dart
TIndexesThemeData copyWith({
  double? indexListMaxHeight,
  double? sidebarRight,
  double? indexItemSize,
  double? indexItemSpacing,
  double? tipSize,
  double? tipMaxWidth,
  double? tipGap,
  Color? indexColor,
  Color? activeIndexColor,
  Color? activeIndexBackgroundColor,
  Color? tipColor,
  Color? tipBackgroundColor,
  Font? indexFont,
  Font? activeIndexFont,
  Font? tipFont,
  Color? anchorColor,
  Color? activeAnchorColor,
  Color? anchorBackgroundColor,
  Color? activeAnchorBackgroundColor,
  Color? anchorBorderColor,
  Font? anchorFont,
  Font? activeAnchorFont,
  double? anchorVerticalPadding,
  double? anchorHorizontalPadding,
  double? capsuleMargin,
})
```


返回类型：`TIndexesThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| indexListMaxHeight | double? | - | 索引列表最大高度占父容器高度的比例。 | 否 |
| sidebarRight | double? | - | 侧栏距容器右侧的距离。 | 否 |
| indexItemSize | double? | - | 单个索引的尺寸。 | 否 |
| indexItemSpacing | double? | - | 相邻索引之间的距离。 | 否 |
| tipSize | double? | - | 按压提示的最小尺寸。 | 否 |
| tipMaxWidth | double? | - | 按压提示的最大宽度。 | 否 |
| tipGap | double? | - | 按压提示与索引之间的距离。 | 否 |
| indexColor | Color? | - | 普通索引文字颜色。 | 否 |
| activeIndexColor | Color? | - | 激活索引文字颜色。 | 否 |
| activeIndexBackgroundColor | Color? | - | 激活索引背景色。 | 否 |
| tipColor | Color? | - | 按压提示文字颜色。 | 否 |
| tipBackgroundColor | Color? | - | 按压提示背景色。 | 否 |
| indexFont | Font? | - | 普通索引字体。 | 否 |
| activeIndexFont | Font? | - | 激活索引字体。 | 否 |
| tipFont | Font? | - | 按压提示字体。 | 否 |
| anchorColor | Color? | - | 普通锚点文字颜色。 | 否 |
| activeAnchorColor | Color? | - | 激活锚点文字颜色。 | 否 |
| anchorBackgroundColor | Color? | - | 普通锚点背景色。 | 否 |
| activeAnchorBackgroundColor | Color? | - | 激活锚点背景色。 | 否 |
| anchorBorderColor | Color? | - | 激活锚点边框颜色。 | 否 |
| anchorFont | Font? | - | 普通锚点字体。 | 否 |
| activeAnchorFont | Font? | - | 激活锚点字体。 | 否 |
| anchorVerticalPadding | double? | - | 锚点垂直内边距。 | 否 |
| anchorHorizontalPadding | double? | - | 锚点水平内边距。 | 否 |
| capsuleMargin | double? | - | 胶囊锚点的水平外边距。 | 否 |


##### TIndexesThemeData.lerp

```dart
TIndexesThemeData lerp(ThemeExtension<TIndexesThemeData>? other, double t)
```


返回类型：`TIndexesThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TIndexesThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |
