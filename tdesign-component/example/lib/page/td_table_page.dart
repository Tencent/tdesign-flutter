import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDTablePage extends StatelessWidget {
  const TDTablePage({Key? key}) : super(key: key);

  List<dynamic> _getData(int index) {
    var data = <dynamic>[];
    for (var i = 0; i < 10; i++) {
      if (i == index) {
        data.add({
          'title1': '内容内容内容内容',
          'title2': '内容',
          'title3': '内容',
          'title4': '内容',
        });
      } else {
        data.add({
          'title1': '内容',
          'title2': '内容',
          'title3': '内容',
          'title4': '内容',
        });
      }
    }
    return data;
  }

  List<dynamic> _getData2() {
    var data = <dynamic>[];
    for (var i = 0; i < 10; i++) {
      if (i == 0) {
        data.add({
          'title1': '横向平铺内容不省略',
          'title2': '横向平铺内容不省略',
          'title3': '横向平铺内容不省略',
        });
      } else {
        data.add({
          'title1': '内容',
          'title2': '内容',
          'title3': '内容',
        });
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      desc: '表格常用于展示同类结构下的多种数据，易于组织、对比和分析等，并可对数据进行搜索、筛选、排序等操作。一般包括表头、数据行和表尾三部分。',
      exampleCodeGroup: 'table',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础表格', builder: _basicTable),
            ExampleItem(desc: '可排序表格', builder: _sortableTable),
            ExampleItem(desc: '带操作或按钮表格', builder: _operationBtnTable),
            ExampleItem(builder: _operationIconTable, padding: const EdgeInsets.only(top: 16)),
            ExampleItem(desc: '可固定首列表格', builder: _fixedFirstColTable),
            ExampleItem(desc: '可固定尾列表格', builder: _fixedEndColTable),
            ExampleItem(desc: '横向平铺可滚动表格', builder: _horizontalScrollTable),
          ],
        ),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '带斑马纹表格样式', builder: _stripeTable),
          ExampleItem(desc: '带边框表格样式', builder: _borderTable),
        ]),
      ],
      test: [
        ExampleItem(desc: '固定表头', builder: _fixedHeaderTable),
        ExampleItem(desc: '固定列尾+滚动表格', builder: _fixedScrollTable),
        ExampleItem(desc: '内容居中表格', builder: _centerTable),
        ExampleItem(desc: '空数据表格', builder: _emptyTable),
        ExampleItem(desc: '加载动画表格', builder: _loadingTable),
      ],
    );
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
  Widget _horizontalScrollTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', width: 160),
        TDTableCol(title: '标题', colKey: 'title2', width: 160),
        TDTableCol(title: '标题', colKey: 'title3', width: 160),
      ],
      data: _getData2(),
    );
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
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
  }

  @Demo(group: 'table')
  Widget _fixedHeaderTable(BuildContext context) {
    return TDTable(
      bordered: true,
      height: 240,
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }

  @Demo(group: 'table')
  Widget _fixedScrollTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', width: 200),
        TDTableCol(title: '标题', colKey: 'title2', width: 160),
        TDTableCol(title: '标题', colKey: 'title3', width: 160),
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
      data: _getData2(),
    );
  }

  @Demo(group: 'table')
  Widget _centerTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1', align: TDTableColAlign.center),
        TDTableCol(title: '标题', colKey: 'title2', align: TDTableColAlign.center),
        TDTableCol(title: '标题', colKey: 'title3', align: TDTableColAlign.center),
        TDTableCol(title: '标题', colKey: 'title4', align: TDTableColAlign.center)
      ],
      data: _getData(10),
    );
  }

  @Demo(group: 'table')
  Widget _emptyTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1'),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(title: '标题', colKey: 'title4')
      ],
    );
  }

  @Demo(group: 'table')
  Widget _loadingTable(BuildContext context) {
    return TDTable(
      columns: [
        TDTableCol(title: '标题', colKey: 'title1'),
        TDTableCol(title: '标题', colKey: 'title2'),
        TDTableCol(title: '标题', colKey: 'title3'),
        TDTableCol(title: '标题', colKey: 'title4')
      ],
      loading: true,
    );
  }
}
