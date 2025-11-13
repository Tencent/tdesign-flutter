## API
### TDTable
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 表格背景色 |
| bordered | bool? | - | 是否显示表格边框 |
| columns | List<TDTableCol> | - | 列配置 |
| data | List<dynamic>? | - | 数据源 |
| defaultSort | String? | - | 默认排序 |
| empty | TDTableEmpty? | - | 空表格呈现样式 |
| footerWidget | Widget? | - | 自定义表尾 |
| height | double? | - | 表格高度，超出后会出现滚动条 |
| key |  | - |  |
| loading | bool? | false | 加载中状态 |
| loadingWidget | Widget? | - | 自定义加载中状态 |
| onCellTap | OnCellTap? | - | 单元格点击事件 |
| onRowSelect | OnRowSelect? | - | 行选择事件 |
| onScroll | OnScroll? | - | 表格滚动事件 |
| onSelect | OnSelect? | - | 选中行事件 |
| rowHeight | double? | - | 行高 |
| showHeader | bool? | true | 是否显示表头 |
| stripe | bool? | false | 斑马纹 |
| width | double? | - | 表格宽度 |

```
```
 ### TDTableEmpty
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| assetUrl | String? | - | 空状态图片 |
| text | String? | - | 空状态文字 |

```
```
 ### TDTableCol
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| align | TDTableColAlign? | TDTableColAlign.left | 列内容横向对齐方式 |
| cellBuilder | IndexedWidgetBuilder? | - | 自定义列 |
| checked | RowCheckFunc? | - | 当前行是否选中 |
| colKey | String? | - | 列取值字段 |
| ellipsis | bool? | - | 列内容超出时是否省略 |
| ellipsisTitle | bool? | - | 列标题超出时显示省略内容 |
| fixed | TDTableColFixed? | TDTableColFixed.none | 固定列 |
| selectable | SelectableFunc? | - | 当前行CheckBox是否可选，仅selection：true有效 |
| selection | bool? | - | 行是否显示复选框，自定义列时无效 |
| sortable | bool? | false | 是否可排序 |
| title | String? | - | 表头标题 |
| width | double? | - | 列宽 |
