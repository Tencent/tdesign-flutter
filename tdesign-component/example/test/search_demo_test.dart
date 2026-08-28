import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_search_bar_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'search',
      title: 'Search 搜索框',
      page: TSearchBarPage(),
      expectedTexts: ['01 组件类型', '02 组件样式', '03 组件状态'],
      componentType: TSearchBar,
    ),
  );
}
