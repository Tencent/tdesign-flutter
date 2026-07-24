## API
### TTable
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| columns | List<TTableColumn<T>> | - | 列配置。 |
| data | List<T> | - | 行数据。 |
| empty | Widget? | - | 空数据内容。 |
| footer | Widget? | - | 表格底部内容。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loading | bool | false | 是否显示加载状态。 |
| loadingWidget | Widget? | - | 自定义加载内容。 |
| onCellTap | TTableCellTap<T>? | - | 单元格点击回调。 |
| onScroll | ValueChanged<ScrollNotification>? | - | 垂直滚动通知。 |
| onSelectionChanged | ValueChanged<Set<T>>? | - | 请求更新选中行集合。 |
| onSortChanged | ValueChanged<TTableSort?>? | - | 请求更新排序值。 |
| rowSelectable | bool Function(T row, int index)? | - | 判断指定行是否可选。 |
| selectedRows | Set<T> | const {} | 当前受控选中行。 |
| selectionMode | TTableSelectionMode | TTableSelectionMode.none | 行选择模式。 |
| showHeader | bool | true | 是否显示表头。 |
| sort | TTableSort? | - | 当前受控排序值。 |


### TTableCellTap
#### 类型定义

```dart
typedef TTableCellTap = void Function(int rowIndex, T row, TTableColumn<T> column);
```
