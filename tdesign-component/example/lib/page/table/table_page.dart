import 'package:flutter/material.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'table_basic_example.dart';
import 'table_bordered_example.dart';
import 'table_fixed_first_example.dart';
import 'table_fixed_last_example.dart';
import 'table_horizontal_scroll_example.dart';
import 'table_operation_icon_example.dart';
import 'table_operation_text_example.dart';
import 'table_sortable_example.dart';
import 'table_stripe_example.dart';

@ExampleCodeManifest()
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
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础表格',
              compactContentSpacing: 8,
              methodName: 'TableBasicExample',
              builder: (_) => const TableBasicExample(),
            ),
            ExampleItem(
              desc: '可排序表格',
              compactContentSpacing: 8,
              methodName: 'TableSortableExample',
              builder: (_) => const TableSortableExample(),
            ),
            ExampleItem(
              desc: '带操作或按钮表格',
              compactContentSpacing: 8,
              methodName: 'TableOperationTextExample',
              builder: (_) => const TableOperationTextExample(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'TableOperationIconExample',
              builder: (_) => const TableOperationIconExample(),
            ),
            ExampleItem(
              desc: '可固定首列表格',
              compactContentSpacing: 8,
              methodName: 'TableFixedFirstExample',
              builder: (_) => const TableFixedFirstExample(),
            ),
            ExampleItem(
              desc: '可固定尾列表格',
              compactContentSpacing: 7,
              methodName: 'TableFixedLastExample',
              builder: (_) => const TableFixedLastExample(),
            ),
            ExampleItem(
              desc: '横向平铺可滚动表格',
              compactContentSpacing: 8,
              methodName: 'TableHorizontalScrollExample',
              builder: (_) => const TableHorizontalScrollExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '带斑马纹表格样式',
              compactContentSpacing: 14,
              methodName: 'TableStripeExample',
              builder: (_) => const TableStripeExample(),
            ),
            ExampleItem(
              desc: '带边框表格样式',
              compactContentSpacing: 8,
              methodName: 'TableBorderedExample',
              builder: (_) => const TableBorderedExample(),
            ),
          ],
        ),
      ],
    );
  }
}
