import 'package:tdesign_flutter_example/page/t_image_viewer_page.dart';

import 'demo_page_test_utils.dart';

const imageViewerDemoPageTestSpec = DemoPageTestSpec(
  name: 'image_viewer',
  title: 'ImageViewer 图片预览',
  page: TImageViewerPage(),
  expectedTexts: ['01 组件类型', '基础图片预览', '带操作图片预览'],
  precacheAssetImages: [
    'assets/img/image.png',
    'assets/img/t_action_sheet_8.png',
  ],
  goldenAtPhoneViewport: true,
);
