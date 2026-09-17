import 'package:tdesign_flutter_example/page/t_table_page.dart';

import 'demo_page_test_utils.dart';

const tableDemoPageTestSpec = DemoPageTestSpec(
  name: 'table',
  title: 'Table 表格',
  page: TTablePage(),
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Table Golden CJK',
  supplementalCjkFontPath: 'test/fonts/TableGoldenCJK-Regular.otf',
  expectedTexts: [
    '表格常用于展示同类结构下的多种数据，易于组织、对比和分析等，并可对数据进行搜索、筛选、排序等操作。一般包括表头、数据行和表尾三部分。',
    '01 组件类型',
    '基础表格',
    '可排序表格',
    '带操作或按钮表格',
    '可固定首列表格',
    '可固定尾列表格',
    '横向平铺可滚动表格',
    '02 组件样式',
    '带斑马纹表格样式',
    '带边框表格样式',
  ],
);
