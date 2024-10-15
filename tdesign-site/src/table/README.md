---
title: Table 表格
description: 表格常用于展示同类结构下的多种数据，易于组织、对比和分析等，并可对数据进行搜索、筛选、排序等操作。一般包括表头、数据行和表尾三部分。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_table_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_table_page.dart)

### 1 组件类型

基础表格
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }</pre>

</td-code-block>
                                  

可排序表格
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _sortableTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', ellipsis: true, sortable: true),
        TDTableCol(title: '标题', colKey: 'title2', sortable: true),
        TDTableCol(title: '标题', colKey: 'title3', sortable: true),
        TDTableCol(title: '标题', colKey: 'title4', sortable: true)
      ],
      data: _getData(9),
    );
  }</pre>

</td-code-block>
                                  

带操作或按钮表格
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _operationBtnTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(
          title: '标题',
          colKey: 'title4',
          cellBuilder: (BuildContext context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TDText(
                  '修改',
                  forceVerticalCenter: true,
                  style: TextStyle(
                    color: TDTheme.of(context).brandNormalColor,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
                TDText(
                  '通过',
                  forceVerticalCenter: true,
                  style: TextStyle(
                    color: TDTheme.of(context).brandNormalColor,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ],
            );
          },
        )
      ],
      data: _getData(9),
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _operationIconTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(
          title: '标题',
          colKey: 'title4',
          cellBuilder: (BuildContext context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(TDIcons.upload, color: TDTheme.of(context).brandNormalColor, size: 16),
                Icon(TDIcons.delete, color: TDTheme.of(context).brandNormalColor, size: 16),
              ],
            );
          },
        )
      ],
      data: _getData(9),
    );
  }</pre>

</td-code-block>
                                  

可固定首列表格
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _fixedFirstColTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1'),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(title: '标题', colKey: 'title4', fixed: TDTableColFixed.left),
      ],
      data: _getData(10),
    );
  }</pre>

</td-code-block>
                                  

可固定尾列表格
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _fixedEndColTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1'),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(
          title: '标题',
          colKey: 'title4',
          fixed: TDTableColFixed.right,
          cellBuilder: (BuildContext context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TDText(
                  '修改',
                  style: TextStyle(
                    color: TDTheme.of(context).brandNormalColor,
                    fontSize: 14,
                  ),
                ),
                TDText(
                  '通过',
                  style: TextStyle(
                    color: TDTheme.of(context).brandNormalColor,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
      ],
      data: _getData(10),
    );
  }</pre>

</td-code-block>
                                  

横向平铺可滚动表格
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _horizontalScrollTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', width: 160),
        TDTableCol(title: '标题', colKey: 'title2', width: 160),
        TDTableCol(title: '标题', colKey: 'title3', width: 160),
      ],
      data: _getData2(),
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

带斑马纹表格样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _stripeTable(BuildContext context) {
    return TDTable(
      stripe: true,
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }</pre>

</td-code-block>
                                  

带边框表格样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _borderTable(BuildContext context) {
    return TDTable(
      bordered: true,
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }</pre>

</td-code-block>
                                  


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
| loading | bool? | false | 加载中状态 |
| loadingWidget | Widget? | - | 自定义加载中状态 |
| showHeader | bool? | true | 是否显示表头 |
| stripe | bool? | false | 斑马纹 |
| backgroundColor | Color? | - | 表格背景色 |
| width | double? | - | 表格宽度 |
| defaultSort | String? | - | 默认排序 |
| onCellTap | OnCellTap? | - | 单元格点击事件 |
| onScroll | OnScroll? | - | 表格滚动事件 |


  