import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'slider_capsule_example.dart';
import 'slider_disabled_example.dart';
import 'slider_labeled_example.dart';
import 'slider_non_zero_example.dart';
import 'slider_range_example.dart';
import 'slider_scale_example.dart';
import 'slider_single_example.dart';
import 'slider_vertical_example.dart';

@ExampleCodeManifest()
class TSliderPage extends StatefulWidget {
  const TSliderPage({super.key});

  @override
  State<TSliderPage> createState() => _TSliderPageState();
}

class _TSliderPageState extends State<TSliderPage> {
  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(),
    desc: '用于选择横轴上的数值、区间、档位。',
    exampleCodeGroup: 'slider',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(
            desc: '单游标滑块',
            methodName: 'SliderSingleExample',
            builder: (_) => const SliderSingleExample(),
          ),
          ExampleItem(
            desc: '双游标滑块',
            methodName: 'SliderRangeExample',
            builder: (_) => const SliderRangeExample(),
          ),
          ExampleItem(
            desc: '带数值滑动选择器',
            methodName: 'SliderLabeledExample',
            builder: (_) => const SliderLabeledExample(),
          ),
          ExampleItem(
            desc: '起始非零滑动选择器',
            methodName: 'SliderNonZeroExample',
            builder: (_) => const SliderNonZeroExample(),
          ),
          ExampleItem(
            desc: '带刻度滑动选择器',
            methodName: 'SliderScaleExample',
            builder: (_) => const SliderScaleExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '组件状态',
        children: [
          ExampleItem(
            desc: '滑块禁用状态',
            methodName: 'SliderDisabledExample',
            builder: (_) => const SliderDisabledExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '特殊样式',
        children: [
          ExampleItem(
            desc: '胶囊型滑块',
            methodName: 'SliderCapsuleExample',
            builder: (_) => const SliderCapsuleExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '垂直状态',
        children: [
          ExampleItem(
            desc: '',
            methodName: 'SliderVerticalExample',
            builder: (_) => const SliderVerticalExample(),
          ),
        ],
      ),
    ],
  );
}
