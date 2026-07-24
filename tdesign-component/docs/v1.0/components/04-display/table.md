# TTable

`TTable<T>` 是强类型表格。排序和选择均由外部受控，组件不会修改输入数据。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `columns` | `List<TTableColumn<T>>` | 必填 | 强类型列配置 |
| `data` | `List<T>` | 必填 | 行数据 |
| `selectionMode` | `TTableSelectionMode` | `none` | 行选择模式 |
| `selectedRows` | `Set<T>` | 空集合 | 当前受控选择集合 |
| `onSelectionChanged` | `ValueChanged<Set<T>>?` | `null` | 请求更新选择集合 |
| `rowSelectable` | `bool Function(T, int)?` | `null` | 行是否可选 |
| `sort` | `TTableSort?` | `null` | 当前受控排序 |
| `onSortChanged` | `ValueChanged<TTableSort?>?` | `null` | 请求更新排序 |
| `loading` | `bool` | `false` | 加载业务状态 |
| `loadingWidget` | `Widget?` | `null` | 加载内容 |
| `empty` | `Widget?` | `null` | 空内容 |
| `footer` | `Widget?` | `null` | 表尾内容 |
| `showHeader` | `bool` | `true` | 显示表头 |
| `onCellTap` | `TTableCellTap<T>?` | `null` | 单元格点击 |
| `onScroll` | `ValueChanged<ScrollNotification>?` | `null` | 垂直滚动通知 |

## TTableColumn

列配置包含 `id/header/cellBuilder/width/fixed/align/comparator`。`cellBuilder` 和 `comparator` 统一使用表格行类型 `T`。

## 控制语义

- 排序根据 `sort` 对数据副本执行，不修改传入 List。
- 点击可排序表头只调用 `onSortChanged`。
- 行和全选 Checkbox 只生成新的 Set 并调用 `onSelectionChanged`。
- 选择列使用局部 compact CheckboxTheme，不影响应用全局密度。

## Theme

`TTableThemeData` 只保存边框、斑马纹、行高、表头高度、尺寸、颜色和内边距。loading、Widget 槽位、数据、排序、选择和回调不进入 Theme。
