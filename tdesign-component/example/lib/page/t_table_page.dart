import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TTablePage extends StatelessWidget {
  const TTablePage({Key? key}) : super(key: key);

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

  List<dynamic> _getFixedColData(int count) {
    var data = <dynamic>[];
    for (var i = 0; i < count; i++) {
      data.add({
        'title1': '内容$i',
        'title2': '内容',
        'title3': '内容',
        'title4': '内容',
        'title5': '内容',
        'title6': '内容',
      });
    }
    return data;
  }

  List<dynamic> _getData2() {
    var data = <dynamic>[
      {
        'title1': '横向平铺内容不省略',
        'title2': '横向平铺内容不省略',
        'title3': '横向平铺内容不省略',
      }
    ];
    for (var i = 0; i < 10; i++) {
      data.add({
        'title1': '内容',
        'title2': '内容',
        'title3': '内容',
      });
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc:
          '表格常用于展示同类结构下的多种数据，易于组织、对比和分析等，并可对数据进行搜索、筛选、排序等操作。一般包括表头、数据行和表尾三部分。',
      exampleCodeGroup: 'table',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础表格', builder: _basicTable),
            ExampleItem(desc: '可排序表格', builder: _sortableTable),
            ExampleItem(desc: '带操作或按钮表格', builder: _operationBtnTable),
            ExampleItem(
                builder: _operationIconTable,
                padding: const EdgeInsets.only(top: 16)),
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
        ExampleItem(desc: '可选表格+默认选中', builder: _selectTable),
        ExampleItem(desc: '自定义表尾组件', builder: (context) => ShowFooterTable()),
      ],
    );
  }

  @Demo(group: 'table')
  Widget _basicTable(BuildContext context) {
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }

  @Demo(group: 'table')
  Widget _sortableTable(BuildContext context) {
    return TTable(
      columns: [
        TTableCol(
            title: '标题', colKey: 'title1', ellipsis: true, sortable: true),
        TTableCol(title: '标题', colKey: 'title2', sortable: true),
        TTableCol(title: '标题', colKey: 'title3', sortable: true),
        TTableCol(title: '标题', colKey: 'title4', sortable: true)
      ],
      data: _getData(9),
    );
  }

  @Demo(group: 'table')
  Widget _operationBtnTable(BuildContext context) {
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(
          title: '标题',
          colKey: 'title4',
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TText(
                  '修改',
                  style: TextStyle(
                      color: TTheme.of(context).brandNormalColor, fontSize: 14),
                ),
                TText(
                  '通过',
                  style: TextStyle(
                      color: TTheme.of(context).brandNormalColor, fontSize: 14),
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
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(
          title: '标题',
          colKey: 'title4',
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(TIcons.upload,
                    color: TTheme.of(context).brandNormalColor, size: 16),
                Icon(TIcons.delete,
                    color: TTheme.of(context).brandNormalColor, size: 16),
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
    return TTable(
      bordered: true,
      height: 240,
      columns: [
        TTableCol(
            title: '固定列',
            colKey: 'title1',
            fixed: TTableColFixed.left,
            width: 100),
        TTableCol(title: '标题二', colKey: 'title2', width: 160),
        TTableCol(title: '标题三', colKey: 'title3', width: 160),
        TTableCol(title: '标题四', colKey: 'title4', width: 160),
        TTableCol(title: '标题五', colKey: 'title5', width: 160),
        TTableCol(title: '标题六', colKey: 'title6', width: 160),
      ],
      data: _getFixedColData(15),
    );
  }

  @Demo(group: 'table')
  Widget _fixedEndColTable(BuildContext context) {
    return TTable(
      bordered: true,
      height: 240,
      columns: [
        TTableCol(title: '标题一', colKey: 'title1', width: 160),
        TTableCol(title: '标题二', colKey: 'title2', width: 160),
        TTableCol(title: '标题三', colKey: 'title3', width: 160),
        TTableCol(title: '标题四', colKey: 'title5', width: 160),
        TTableCol(title: '标题五', colKey: 'title6', width: 160),
        TTableCol(
          title: '操作',
          colKey: 'title4',
          fixed: TTableColFixed.right,
          width: 100,
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TText(
                  '修改',
                  style: TextStyle(
                    color: TTheme.of(context).brandNormalColor,
                    fontSize: 14,
                  ),
                ),
                TText(
                  '通过',
                  style: TextStyle(
                    color: TTheme.of(context).brandNormalColor,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          },
        ),
      ],
      data: _getFixedColData(15),
    );
  }

  @Demo(group: 'table')
  Widget _horizontalScrollTable(BuildContext context) {
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1', width: 160),
        TTableCol(title: '标题', colKey: 'title2', width: 160),
        TTableCol(title: '标题', colKey: 'title3', width: 160),
      ],
      data: _getData2(),
    );
  }

  @Demo(group: 'table')
  Widget _stripeTable(BuildContext context) {
    return TTable(
      stripe: true,
      columns: [
        TTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }

  @Demo(group: 'table')
  Widget _borderTable(BuildContext context) {
    return TTable(
      bordered: true,
      columns: [
        TTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }

  @Demo(group: 'table')
  Widget _fixedHeaderTable(BuildContext context) {
    return TTable(
      bordered: true,
      height: 240,
      columns: [
        TTableCol(title: '标题', colKey: 'title1', ellipsis: true),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
      data: _getData(9),
    );
  }

  @Demo(group: 'table')
  Widget _fixedScrollTable(BuildContext context) {
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1', width: 200),
        TTableCol(title: '标题', colKey: 'title2', width: 160),
        TTableCol(title: '标题', colKey: 'title3', width: 160),
        TTableCol(
          title: '标题',
          colKey: 'title4',
          fixed: TTableColFixed.right,
          cellBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TText(
                  '修改',
                  style: TextStyle(
                    color: TTheme.of(context).brandNormalColor,
                    fontSize: 14,
                  ),
                ),
                TText(
                  '通过',
                  style: TextStyle(
                    color: TTheme.of(context).brandNormalColor,
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
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1', align: TTableColAlign.center),
        TTableCol(title: '标题', colKey: 'title2', align: TTableColAlign.center),
        TTableCol(title: '标题', colKey: 'title3', align: TTableColAlign.center),
        TTableCol(title: '标题', colKey: 'title4', align: TTableColAlign.center)
      ],
      data: _getData(10),
    );
  }

  @Demo(group: 'table')
  Widget _emptyTable(BuildContext context) {
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1'),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
    );
  }

  @Demo(group: 'table')
  Widget _loadingTable(BuildContext context) {
    return TTable(
      columns: [
        TTableCol(title: '标题', colKey: 'title1'),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
      loading: true,
    );
  }

  @Demo(group: 'table')
  Widget _selectTable(BuildContext context) {
    return TTable(
      data: _getData(10),
      columns: [
        TTableCol(
            selection: true,
            checked: (index, row) {
              return index == 0;
            },
            width: 50,
            selectable: (index, row) {
              return index % 2 == 0;
            }),
        TTableCol(title: '标题', colKey: 'title1'),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
    );
  }
}

class ShowFooterTable extends StatefulWidget {
  const ShowFooterTable({super.key});

  @override
  State<ShowFooterTable> createState() => _ShowFooterTableState();
}

class _ShowFooterTableState extends State<ShowFooterTable> {
  var _hasMore = true;
  var _data = [];
  var _pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _hasMore = _pageIndex <= 2;
    });
    if (!_hasMore) {
      return;
    }
    setState(() {
      _data.addAll(_getData(10));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showFooterTable(context);
  }

  @Demo(group: 'table')
  Widget _showFooterTable(BuildContext context) {
    return TTable(
      height: 100,
      footerWidget: _hasMore ? TText('加载更多...') : TText('没有更多数据了'),
      onScroll: (controller) {
        if (controller.position.pixels == controller.position.maxScrollExtent &&
            _hasMore) {
          _pageIndex += 1;
          _fetchData();
        }
      },
      data: _data,
      columns: [
        TTableCol(title: '标题', colKey: 'title1'),
        TTableCol(title: '标题', colKey: 'title2'),
        TTableCol(title: '标题', colKey: 'title3'),
        TTableCol(title: '标题', colKey: 'title4')
      ],
    );
  }

  List<dynamic> _getData(int index) {
    var data = <dynamic>[];
    for (var i = 0; i < 10; i++) {
      data.add({
        'title1': '内容',
        'title2': '内容',
        'title3': '内容',
        'title4': '内容',
      });
    }
    return data;
  }
}
