import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_backtop_page.dart';

import 'demo_page_test_utils.dart';

const backTopDemoPageTestSpec = DemoPageTestSpec(
  name: 'backtop',
  title: 'BackTop 返回顶部',
  page: TBackTopPage(),
  expectedTexts: ['01 组件类型', '圆形返回顶部', '半圆形返回顶部', '顶部', '返回\n顶部'],
  componentType: TBackTop,
  expectedComponentCount: 9,
  useAlignmentCjkFont: true,
);
