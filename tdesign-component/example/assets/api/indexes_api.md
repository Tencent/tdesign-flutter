## API
### TIndexes
#### 简介
索引
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 锚点自定义构建 |
| builderContent | Widget? Function(BuildContext context, String index) | - | 内容自定义构建 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 |
| capsuleTheme | bool | false | 锚点是否为胶囊式样式 |
| indexList | List<String>? | - | 索引字符列表。不传默认 A-Z；默认值要求 `builderContent` 能处理 A-Z 全部索引，自定义数据建议显式传入 |
| indexListMaxHeight | double? | - | 索引列表最大高度（父容器高度的百分比，默认 0.8） |
| initialIndex | String? | - | 初始激活索引。为空时使用 `indexList` 的第一项 仅在组件首次创建时生效；后续活动索引由滚动位置派生。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | void Function(String index)? | - | 索引发生变更时触发事件 |
| onSelect | void Function(String index)? | - | 点击侧边栏时触发事件 |
| reverse | bool | false | 是否反向滚动 |
| scrollController | ScrollController? | - | 滚动控制器 |
| sticky | bool | true | 锚点是否吸顶 |
| stickyOffset | double | 0 | 锚点吸顶时与顶部的距离 |


### TIndexesAnchor
#### 简介
索引锚点
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeIndex | ValueNotifier<String> | - | 选中索引 |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 索引锚点构建 |
| capsuleTheme | bool | - | 是否为胶囊式样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| sticky | bool | - | 索引是否吸顶 |
| text | String | - | 锚点文本 |


### TIndexesList
#### 简介
索引
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeIndex | ValueNotifier<String> | - | 选中索引 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 |
| indexList | List<String> | - | 索引字符列表。不传默认 A-Z |
| indexListMaxHeight | double | 0.8 | 索引列表最大高度（父容器高度的百分比，默认0.8） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onSelect | void Function(String newIndex, String oldIndex) | - | 点击侧边栏时触发事件 |


### TIndexesThemeData
#### 简介
索引组件的子树级视觉主题。
仅管理尺寸、颜色和字体。吸顶、滚动方向与胶囊模式属于组件实例行为。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeAnchorBackgroundColor | Color? | - | 激活锚点背景色。 |
| activeAnchorColor | Color? | - | 激活锚点文字颜色。 |
| activeAnchorFont | Font? | - | 激活锚点字体。 |
| activeIndexBackgroundColor | Color? | - | 激活索引背景色。 |
| activeIndexColor | Color? | - | 激活索引文字颜色。 |
| activeIndexFont | Font? | - | 激活索引字体。 |
| anchorBackgroundColor | Color? | - | 普通锚点背景色。 |
| anchorBorderColor | Color? | - | 激活锚点边框颜色。 |
| anchorColor | Color? | - | 普通锚点文字颜色。 |
| anchorFont | Font? | - | 普通锚点字体。 |
| anchorHorizontalPadding | double? | - | 锚点水平内边距。 |
| anchorVerticalPadding | double? | - | 锚点垂直内边距。 |
| capsuleMargin | double? | - | 胶囊锚点的水平外边距。 |
| indexColor | Color? | - | 普通索引文字颜色。 |
| indexFont | Font? | - | 普通索引字体。 |
| indexItemSize | double? | - | 单个索引的尺寸。 |
| indexItemSpacing | double? | - | 相邻索引之间的距离。 |
| indexListMaxHeight | double? | - | 索引列表最大高度占父容器高度的比例。 |
| sidebarRight | double? | - | 侧栏距容器右侧的距离。 |
| tipBackgroundColor | Color? | - | 按压提示背景色。 |
| tipColor | Color? | - | 按压提示文字颜色。 |
| tipFont | Font? | - | 按压提示字体。 |
| tipGap | double? | - | 按压提示与索引之间的距离。 |
| tipMaxWidth | double? | - | 按压提示的最大宽度。 |
| tipSize | double? | - | 按压提示的最小尺寸。 |
