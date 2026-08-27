import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_pull_down_refresh_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'pull_down_refresh',
      title: 'PullDownRefresh 下拉刷新',
      page: TPullDownRefreshPage(),
      expectedTexts: ['01 顶部下拉刷新', '02 自定义提示语', '03 刷新超时'],
      componentType: TPullDownRefresh,
    ),
  );
}
