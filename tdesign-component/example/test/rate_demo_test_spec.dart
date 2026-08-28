import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_rate_page.dart';

import 'demo_page_test_utils.dart';

const rateDemoPageTestSpec = DemoPageTestSpec(
  name: 'rate',
  title: 'Rate 评分',
  page: TRatePage(),
  expectedTexts: [
    '01 组件类型',
    '实心评分',
    '自定义评分',
    '第三方图标评分',
    '第三方图标',
    '自定义评分数量',
    '带描述评分',
    '3分',
    '一般',
    '未评分',
    '02 组件状态',
    '只可选全星时',
    '只可选半星时',
    '点击或滑动',
    '03 组件样式',
    '评分大小',
    '大尺寸 24',
    '小尺寸 20',
    '设置评分颜色',
    '填充评分',
    '线描评分',
    '04 特殊样式',
    '竖向带描述评分',
    '可以前往',
  ],
  componentType: TRate,
  expectedComponentCount: 14,
);
