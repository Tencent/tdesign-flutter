import 'package:flutter/cupertino.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDTablePage extends StatelessWidget {
  const TDTablePage({Key? key}) : super(key: key);

  List<dynamic> _getData() {
    var data = <dynamic>[];
    for(var i = 0; i < 10; i++) {
      if(i == 9) {
        data.add({
          'title1': '内容内容内容内容',
          'title2': '内容',
          'title3': '内容',
          'title4': '内容',
        });
      }else {
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
              ExampleItem(desc: "可排序表格", builder: _sortableTable)
            ],
          )
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
      data: _getData(),
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
    );
  }
}
