import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_skeleton_page.dart';

import 'demo_page_test_utils.dart';

const skeletonDemoPageTestSpec = DemoPageTestSpec(
  name: 'skeleton',
  title: 'Skeleton 骨架屏',
  page: TSkeletonPage(),
  expectedTexts: [
    '01 骨架屏类型',
    '头像骨架屏',
    '图片骨架屏',
    '文本骨架屏',
    '段落骨架屏',
    '单元格骨架屏',
    '宫格骨架屏',
    '图文组合骨架屏',
    '02 组件动效',
    '渐变加载效果',
    '闪烁加载效果',
  ],
  componentType: TSkeleton,
  expectedComponentCount: 17,
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'Noto Sans SC',
  supplementalCjkFontPath: 'test/fonts/SkeletonGoldenCJK-Regular.otf',
);
