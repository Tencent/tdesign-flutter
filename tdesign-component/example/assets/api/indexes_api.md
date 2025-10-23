## API
### TDIndexes
#### 简介
索引
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 锚点自定义构建 |
| builderContent | Widget? Function(BuildContext context, String index) | - | 内容自定义构建 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 |
| capsuleTheme | bool? | false | 锚点是否为胶囊式样式 |
| indexList | List<String>? | - | 索引字符列表。不传默认 A-Z |
| indexListMaxHeight | double? | 0.8 | 索引列表最大高度（父容器高度的百分比，默认 0.8） |
| key |  | - |  |
| onChange | void Function(String index)? | - | 索引发生变更时触发事件 |
| onSelect | void Function(String index)? | - | 点击侧边栏时触发事件 |
| reverse | bool? | false | 反方向滚动置顶 |
| scrollController | ScrollController? | - | 滚动控制器 |
| sticky | bool? | true | 锚点是否吸顶 |
| stickyOffset | double? | 0 | 锚点吸顶时与顶部的距离 |

```
```
 ### TDIndexesList
#### 简介
索引
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeIndex | ValueNotifier<String> | - | 选中索引 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 |
| indexList | List<String> | - | 索引字符列表。不传默认 A-Z |
| indexListMaxHeight | double | 0.8 | 索引列表最大高度（父容器高度的百分比，默认0.8） |
| key |  | - |  |
| onSelect | void Function(String newIndex, String oldIndex) | - | 点击侧边栏时触发事件 |

```
```
 ### TDIndexesAnchor
#### 简介
索引锚点
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| activeIndex | ValueNotifier<String> | - | 选中索引 |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 索引锚点构建 |
| capsuleTheme | bool | - | 是否为胶囊式样式 |
| key |  | - |  |
| sticky | bool | - | 索引是否吸顶 |
| text | String | - | 锚点文本 |
