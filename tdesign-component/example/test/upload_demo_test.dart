import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_upload_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'upload',
      title: 'Upload 上传',
      page: TUploadPage(),
      expectedTexts: ['01 组件类型', '02 组件状态', '03 组件风格'],
      componentType: TUpload,
    ),
  );
}
