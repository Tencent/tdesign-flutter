import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_indexes_page.dart';

import 'demo_page_test_utils.dart';

const indexesDemoPageTestSpec = DemoPageTestSpec(
  name: 'indexes',
  title: 'Indexes 索引',
  page: TIndexesPage(),
  expectedTexts: [
    '01 组件类型',
    '索引类型',
    '字母索引',
    '数字索引',
    '02 组件样式',
    '其他索引列表样式',
    '胶囊索引',
  ],
  componentType: TButton,
  expectedComponentCount: 3,
  supplementalCjkFontFamily: 'TDesign Indexes Golden CJK',
  supplementalCjkFontPath: 'test/fonts/IndexesGoldenCJK-Regular.otf',
);
