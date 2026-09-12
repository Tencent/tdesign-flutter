import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_tabs_page.dart';

import 'demo_page_test_utils.dart';

const tabsDemoPageTestSpec = DemoPageTestSpec(
  name: 'tabs',
  title: 'Tabs 选项卡',
  page: TTabsPage(),
  expectedTexts: ['组件类型', '带内容区选项卡', '组件状态', '组件样式', '选项卡尺寸'],
  componentType: TTabsBar,
  supplementalCjkFontFamily: 'Noto Sans CJK SC',
  supplementalCjkFontPath: 'test/fonts/TabsGoldenCJK-Regular.otf',
);
