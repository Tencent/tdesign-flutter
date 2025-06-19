## API
### TDTable
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| bordered | bool? | - | 是否显示表格边框 |
| columns | List<TDTableCol> | - | 列配置 |
| data | List<dynamic>? | - | 数据源 |
| empty | TDTableEmpty? | - | 空表格呈现样式 |
| height | double? | - | 表格高度，超出后会出现滚动条 |
| rowHeight | double? | - | 行高 |
| loading | bool? | false | 加载中状态 |
| loadingWidget | Widget? | - | 自定义加载中状态 |
| showHeader | bool? | true | 是否显示表头 |
| stripe | bool? | false | 斑马纹 |
| backgroundColor | Color? | - | 表格背景色 |
| width | double? | - | 表格宽度 |
| defaultSort | String? | - | 默认排序 |
| onCellTap | OnCellTap? | - | 单元格点击事件 |
| onScroll | OnScroll? | - | 表格滚动事件 |
| onSelect | OnSelect? | - | 选中行事件 |
| onRowSelect | OnRowSelect? | - | 行选择事件 |
