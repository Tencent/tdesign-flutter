import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_swipe_cell_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'swipe_cell',
      title: 'SwipeCell 滑动操作',
      page: TSwipeCellPage(),
      expectedTexts: ['01 组件类型'],
      componentType: TSwipeCell,
    ),
  );
}
