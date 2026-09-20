import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'avatar_skeleton_example.dart';
import 'cell_skeleton_example.dart';
import 'combine_skeleton_example.dart';
import 'flashed_skeleton_example.dart';
import 'gradient_skeleton_example.dart';
import 'grid_skeleton_example.dart';
import 'image_skeleton_example.dart';
import 'paragraph_skeleton_example.dart';
import 'text_skeleton_example.dart';

@ExampleCodeManifest()
class TSkeletonPage extends StatelessWidget {
  const TSkeletonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于等待加载内容所展示的占位图形组合，有动态效果加载效果，减少用户等待焦虑。',
      exampleCodeGroup: 'skeleton',
      children: [
        ExampleModule(
          title: '骨架屏类型',
          children: [
            ExampleItem(
              desc: '头像骨架屏',
              methodName: 'AvatarSkeletonExample',
              builder: (_) => const AvatarSkeletonExample(),
            ),
            ExampleItem(
              desc: '图片骨架屏',
              methodName: 'ImageSkeletonExample',
              builder: (_) => const ImageSkeletonExample(),
            ),
            ExampleItem(
              desc: '文本骨架屏',
              methodName: 'TextSkeletonExample',
              builder: (_) => const TextSkeletonExample(),
            ),
            ExampleItem(
              desc: '段落骨架屏',
              methodName: 'ParagraphSkeletonExample',
              builder: (_) => const ParagraphSkeletonExample(),
            ),
            ExampleItem(
              desc: '单元格骨架屏',
              methodName: 'CellSkeletonExample',
              builder: (_) => const CellSkeletonExample(),
            ),
            ExampleItem(
              desc: '宫格骨架屏',
              methodName: 'GridSkeletonExample',
              builder: (_) => const GridSkeletonExample(),
            ),
            ExampleItem(
              desc: '图文组合骨架屏',
              methodName: 'CombineSkeletonExample',
              builder: (_) => const CombineSkeletonExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件动效',
          children: [
            ExampleItem(
              desc: '渐变加载效果',
              methodName: 'GradientSkeletonExample',
              builder: (_) => const GradientSkeletonExample(),
            ),
            ExampleItem(
              desc: '闪烁加载效果',
              methodName: 'FlashedSkeletonExample',
              builder: (_) => const FlashedSkeletonExample(),
            ),
          ],
        ),
      ],
    );
  }
}
