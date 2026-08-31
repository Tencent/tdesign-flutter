import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_loading_page.dart';

import 'demo_page_test_utils.dart';

const loadingDemoPageTestSpec = DemoPageTestSpec(
  name: 'loading',
  title: 'Loading 加载',
  page: TLoadingPage(),
  useAlignmentCjkFont: true,
  precacheAssetImages: ['assets/img/loading-logo2.png'],
  expectedTexts: [
    '01 组件类型',
    '纯图标',
    '图标加文字横向',
    '图标加文字竖向',
    '纯文字',
    '02 组件尺寸',
    '大尺寸',
    '中尺寸',
    '小尺寸',
    '03 加载速度',
    '加载速度调整',
    '800',
  ],
  componentType: TLoading,
  expectedComponentCount: 13,
);
