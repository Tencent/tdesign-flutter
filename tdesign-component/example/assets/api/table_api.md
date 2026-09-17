## API
### TTable
#### 简介
强类型、受控排序与选择的表格组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bordered | bool? | - | 是否显示完整单元格边框。 为空时读取 `TTableThemeData.bordered`，最后回退为 `false`。 |
| columns | List<TTableColumn<T>> | - | 列配置。 |
| data | List<T> | - | 行数据。 |
| empty | Widget? | - | 空数据内容。 |
| footer | Widget? | - | 表格底部内容。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loading | bool | false | 是否在表体上显示加载遮罩。 |
| loadingWidget | Widget? | - | 自定义加载内容。 |
| maxHeight | double? | - | 表体的最大可视高度；内容超过此高度时在表体内滚动。 |
| onCellTap | TTableCellTap<T>? | - | 单元格点击回调。 |
| onRowTap | TTableRowTap<T>? | - | 行点击回调。 点击普通单元格时，会在 `onCellTap` 之后调用该回调；点击选择控件时不触发。 |
| onScroll | ValueChanged<ScrollNotification>? | - | 垂直滚动通知。 |
| onSelectionChanged | ValueChanged<Set<T>>? | - | 请求更新选中行集合。 |
| onSortChanged | ValueChanged<TTableSort?>? | - | 请求更新排序值。 |
| rowSelectable | bool Function(T row, int index)? | - | 判断指定行是否可选。 |
| selectedRows | Set<T> | const {} | 当前受控选中行。 |
| selectionMode | TTableSelectionMode | TTableSelectionMode.none | 行选择模式。 |
| showHeader | bool | true | 是否显示表头。 |
| sort | TTableSort? | - | 当前受控排序值。 |
| stripe | bool? | - | 是否为奇数数据行显示斑马纹背景。 为空时读取 `TTableThemeData.stripe`，最后回退为 `false`。 |


### TTableColumn
#### 简介
强类型表格列配置。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TTableColumnAlign | TTableColumnAlign.left | 内容对齐方式。 |
| cellBuilder | TTableCellBuilder<T> | - | 单元格构建器。 |
| comparator | Comparator<T>? | - | 排序比较器；为空时该列不可排序。 |
| fixed | TTableColumnFixed | TTableColumnFixed.none | 固定位置。 |
| header | Widget | - | 表头内容。 |
| id | String | - | 列唯一标识，用于受控排序。 |
| width | double? | - | 列宽。 为空时与其他未指定宽度的列均分表格剩余宽度；显式宽度超出可用区域时， 中间非固定列可横向滚动。 |


### TTableThemeData
#### 简介
表格组件级 ThemeExtension。
仅保存表格的视觉默认值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 默认行背景色。 |
| borderColor | Color? | - | 边框颜色。 |
| bordered | bool? | - | 是否显示单元格边框。 |
| cellPadding | EdgeInsetsGeometry? | - | 单元格内边距。 |
| headerColor | Color? | - | 表头背景色。 |
| headerHeight | double? | - | 表头高度。 |
| rowHeight | double? | - | 数据行高度。 |
| stripe | bool? | - | 是否显示斑马纹。 |
| stripeColor | Color? | - | 斑马纹背景色。 |
| width | double? | - | 表格宽度。 |


### TTableSort
#### 简介
受控排序值。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columnId | String | - | 排序列标识。 |
| direction | TTableSortDirection | - | 排序方向。 |


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


### TTableCellTap
#### 简介
单元格点击回调。
#### 类型定义

```dart
typedef TTableCellTap = void Function(int rowIndex, T row, TTableColumn<T> column);
```


### TTableRowTap
#### 简介
行点击回调。
#### 类型定义

```dart
typedef TTableRowTap = void Function(int rowIndex, T row);
```


### TTableCellBuilder
#### 简介
单元格构建器。
#### 类型定义

```dart
typedef TTableCellBuilder = Widget Function(BuildContext context, T row, int rowIndex);
```
