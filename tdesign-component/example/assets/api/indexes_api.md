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
| capsuleTheme | bool? | - | 锚点是否为胶囊式样式（优先级高于 ThemeData） |
| indexList | List<String>? | - | 索引字符列表。不传默认 A-Z；默认值要求 `builderContent` 能处理 A-Z 全部索引，自定义数据建议显式传入 |
| indexListMaxHeight | double? | - | 索引列表最大高度（父容器高度的百分比，默认 0.8） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | void Function(String index)? | - | 索引发生变更时触发事件 |
| onSelect | void Function(String index)? | - | 点击侧边栏时触发事件 |
| reverse | bool? | - | 反方向滚动置顶（优先级高于 ThemeData） |
| scrollController | ScrollController? | - | 滚动控制器 |
| sticky | bool? | - | 锚点是否吸顶（优先级高于 ThemeData） |
| stickyOffset | double? | - | 锚点吸顶时与顶部的距离（优先级高于 ThemeData） |


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
