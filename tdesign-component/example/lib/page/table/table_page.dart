import 'package:flutter/material.dart';

import '../../base/example_widget.dart';
import 'table_style.dart';
import 'table_type.dart';

/// Table 公开示例页面。
class TTablePage extends StatelessWidget {
  const TTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Table 表格',
      navBarTitle: 'Table',
      desc:
          '表格常用于展示同类结构下的多种数据，易于组织、对比和分析等，并可对数据进行搜索、筛选、排序等操作。一般包括表头、数据行和表尾三部分。',
      exampleCodeGroup: 'table',
      compactDemo: true,
      showTestModule: false,
      children: [tableTypeModule(), tableStyleModule()],
    );
  }
}
