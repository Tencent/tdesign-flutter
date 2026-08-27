import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_rate_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'rate',
      title: 'Rate 评分',
      page: TRatePage(),
      expectedTexts: [
        '01 组件类型',
        '实心评分',
        '自定义评分',
        '第三方图标评分',
        '自定义评分数量',
        '带描述评分',
        '02 组件状态',
        '只可选全星时',
        '只可选半星时',
        '03 组件样式',
        '评分大小',
        '设置评分颜色',
        '04 特殊样式',
        '竖向带描述评分',
      ],
      componentType: TRate,
      expectedComponentCount: 14,
    ),
  );
}
