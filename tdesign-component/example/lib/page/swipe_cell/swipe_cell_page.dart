import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'swipe_cell_swiper_cell_example.dart';
import 'swipe_cell_swiper_icon_cell_example.dart';
import 'swipe_cell_swiper_right_cell_example.dart';
import 'swipe_cell_swiper_right_left_cell_example.dart';

@ExampleCodeManifest()
class TSwipeCellPage extends StatelessWidget {
  const TSwipeCellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'SwipeCell',
      desc: '用于承载列表中的更多操作，通过左右滑动来展示，按钮宽度根据内容自适应、高度根据列表高度而变化。',
      backgroundColor: context.tTheme.bgColorPage,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '左滑操作',
              methodName: 'SwipeCellSwiperCellExample',
              builder: (_) => const SwipeCellSwiperCellExample(),
            ),
            ExampleItem(
              desc: '右滑操作',
              methodName: 'SwipeCellSwiperRightCellExample',
              builder: (_) => const SwipeCellSwiperRightCellExample(),
            ),
            ExampleItem(
              desc: '左右滑操作',
              methodName: 'SwipeCellSwiperRightLeftCellExample',
              builder: (_) => const SwipeCellSwiperRightLeftCellExample(),
            ),
            ExampleItem(
              desc: '带图标的滑动操作',
              methodName: 'SwipeCellSwiperIconCellExample',
              builder: (_) => const SwipeCellSwiperIconCellExample(),
            ),
          ],
        ),
      ],
      test: const [],
    );
  }
}
