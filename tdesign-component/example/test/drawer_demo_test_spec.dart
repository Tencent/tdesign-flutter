import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_drawer_page.dart';

import 'demo_page_test_utils.dart';

const drawerDemoPageTestSpec = DemoPageTestSpec(
  name: 'drawer',
  title: 'Drawer 抽屉',
  page: TDrawerPage(),
  expectedTexts: [
    '01 组件类型',
    '基础抽屉',
    '带图标抽屉',
    '02 组件样式',
    '带标题样式',
    '小标题抽屉',
    '大标题抽屉',
    '抽屉方向',
    '左侧抽屉',
    '右侧抽屉',
    '带底部插槽样式',
    '带底部插槽',
  ],
  componentType: TButton,
  expectedComponentCount: 7,
  useFeedbackGoldenFont: true,
  supplementalCjkFontFamily: 'Drawer Golden CJK',
  supplementalCjkFontPath: 'test/fonts/DrawerGoldenCJK-Regular.otf',
  goldenAtPhoneViewport: true,
  phoneViewportHeight: 1024,
);
