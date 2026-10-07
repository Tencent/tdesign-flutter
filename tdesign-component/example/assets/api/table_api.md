## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TTable
#### 简介
强类型、受控排序与选择的表格组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bordered | bool? | - | 是否显示完整单元格边框。 未设置时为 `false`。 | 否 |
| cellSpanBuilder | TTableCellSpanBuilder&lt;T&gt;? | - | 返回逻辑单元格的行列跨度。 为空时所有单元格跨度均为 `1 × 1`。该回调仅为尚未被其他合并区域覆盖的 坐标调用；返回 `null` 等同于 `TTableCellSpan` 的默认值。跨度不得越界、重叠， 也不得跨越左固定区、水平滚动区和右固定区。 | 否 |
| columns | List&lt;TTableColumn&lt;T&gt;&gt; | - | 列配置。 | 是 |
| data | List&lt;T&gt; | - | 行数据。 | 是 |
| empty | Widget? | - | 空数据内容。 | 否 |
| footer | Widget? | - | 表格底部内容。 | 否 |
| height | double? | - | 表格固定高度。 表头和 `footer` 占用空间后，剩余高度作为表体的垂直滚动视口。与 `maxHeight` 互斥；为空时表格随内容自然增长。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loading | bool | false | 是否在表体上显示加载遮罩。 | 否 |
| loadingWidget | Widget? | - | 自定义加载内容。 | 否 |
| maxHeight | double? | - | 表体的最大可视高度；内容超过此高度时在表体内滚动。 | 否 |
| onCellTap | TTableCellTap&lt;T&gt;? | - | 单元格点击回调，context 同时提供行列索引、行数据和列配置。 | 否 |
| onRowTap | TTableRowTap&lt;T&gt;? | - | 行点击回调。 点击普通单元格时，会在 `onCellTap` 之后调用该回调；点击选择控件时不触发。 | 否 |
| onScroll | ValueChanged&lt;ScrollNotification&gt;? | - | 垂直滚动通知。 | 否 |
| onSelectionChanged | ValueChanged&lt;Set&lt;T&gt;&gt;? | - | 请求更新选中行集合。 | 否 |
| onSortChanged | ValueChanged&lt;TTableSort?&gt;? | - | 请求更新排序值。 | 否 |
| rowKey | TTableRowKey&lt;T&gt;? | - | 返回行数据的稳定唯一标识。 为空时直接使用行对象及其 `==`、`hashCode` 语义。提供后，受控选择会按 key 匹配、替换和移除行，并稳定标识单元格子树，使数据刷新或排序后新建的 行对象仍能命中同一业务行。同一份 `data` 中的 key 必须唯一；未提供时单元格 子树按可见行位置标识。 | 否 |
| rowSelectable | bool Function(T row, int index)? | - | 判断指定行是否可选。 | 否 |
| selectedRows | Set&lt;T&gt; | const {} | 当前受控选中行。 | 否 |
| selectionMode | TTableSelectionMode | TTableSelectionMode.none | 行选择模式。 | 否 |
| showHeader | bool | true | 是否显示表头。 | 否 |
| sort | TTableSort? | - | 当前受控排序值。 | 否 |
| stripe | bool? | - | 是否为奇数数据行显示斑马纹背景。 未设置时为 `false`。 | 否 |


### TTableColumn
#### 简介
强类型表格列配置。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| align | TTableColumnAlign | TTableColumnAlign.left | 内容对齐方式。 | 否 |
| cellBuilder | TTableCellBuilder&lt;T&gt; | - | 单元格构建器。 | 是 |
| comparator | Comparator&lt;T&gt;? | - | 排序比较器；为空时该列不可排序。 | 否 |
| fixed | TTableColumnFixed | TTableColumnFixed.none | 固定位置。 | 否 |
| header | Widget | - | 表头内容。 | 是 |
| id | String | - | 列唯一标识，用于受控排序。 | 是 |
| minWidth | double? | - | 列宽下限。 指定 `width` 时实际宽度不小于该值；`width` 为空时，自动均分会先满足 每列的最小宽度。所有列宽之和超出表格时，中间非固定列可横向滚动。 | 否 |
| width | double? | - | 列宽。 为空时与其他未指定宽度的列均分表格剩余宽度；显式宽度超出可用区域时， 中间非固定列可横向滚动。 | 否 |


### TTableThemeData
#### 简介
表格组件级 ThemeExtension。
仅保存表格的视觉默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认行背景色。 | 否 |
| borderColor | Color? | - | 边框颜色。 | 否 |
| cellPadding | EdgeInsetsGeometry? | - | 单元格内边距。 | 否 |
| headerColor | Color? | - | 表头背景色。 | 否 |
| headerHeight | double? | - | 表头高度。 | 否 |
| rowHeight | double? | - | 数据行高度。 | 否 |
| stripeColor | Color? | - | 斑马纹背景色。 | 否 |
| width | double? | - | 表格宽度。 | 否 |


### TTableSort
#### 简介
受控排序值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| columnId | String | - | 排序列标识。 | 是 |
| direction | TTableSortDirection | - | 排序方向。 | 是 |


### TTableCellContext
#### 简介
表格逻辑单元格上下文。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| column | TTableColumn&lt;T&gt; | - | 当前列配置。 | 是 |
| columnIndex | int | - | 当前列在 `TTable.columns` 中的索引。 | 是 |
| row | T | - | 当前行数据。 | 是 |
| rowIndex | int | - | 当前行在排序后可见数据中的索引。 | 是 |


### TTableCellSpan
#### 简介
单元格跨越的逻辑行列数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| columnSpan | int | 1 | 跨越的逻辑列数，默认为 `1`。 | 否 |
| rowSpan | int | 1 | 跨越的逻辑行数，默认为 `1`。 | 否 |


### TTableSelectionMode
#### 简介
表格选择模式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| none | 不显示选择列。 |
| multiple | 支持多行选择。 |


### TTableSortDirection
#### 简介
排序方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| ascending | 升序。 |
| descending | 降序。 |


### TTableColumnFixed
#### 简介
固定列位置。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 固定在左侧。 |
| right | 固定在右侧。 |
| none | 跟随中间区域水平滚动。 |


### TTableColumnAlign
#### 简介
列内容对齐方式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 左对齐。 |
| center | 居中对齐。 |
| right | 右对齐。 |


### TTableCellSpanBuilder
#### 简介
单元格跨度构建器。
仅为未被其他合并区域覆盖的逻辑单元格调用。该回调会在组件构建期间执行，
应保持同步且无副作用。
#### 类型定义

```dart
typedef TTableCellSpanBuilder<T> = TTableCellSpan? Function(TTableCellContext<T> context);
```


### TTableCellTap
#### 简介
单元格点击回调。
#### 类型定义

```dart
typedef TTableCellTap<T> = void Function(TTableCellContext<T> context);
```


### TTableRowKey
#### 简介
返回行数据的稳定唯一标识。
#### 类型定义

```dart
typedef TTableRowKey<T> = Object Function(T row);
```


### TTableRowTap
#### 简介
行点击回调。
#### 类型定义

```dart
typedef TTableRowTap<T> = void Function(int rowIndex, T row);
```


### TTableCellBuilder
#### 简介
单元格构建器。
#### 类型定义

```dart
typedef TTableCellBuilder<T> = Widget Function(BuildContext context, T row, int rowIndex);
```
