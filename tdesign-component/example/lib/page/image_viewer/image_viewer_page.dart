import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'image_viewer_basic_example.dart';
import 'image_viewer_with_actions_example.dart';

@ExampleCodeManifest()
class TImageViewerPage extends StatelessWidget {
  const TImageViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'ImageViewer 图片预览',
      desc: '用于图片内容的缩略展示与查看。',
      exampleCodeGroup: 'image-viewer',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础图片预览',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'ImageViewerBasicExample',
              builder: (_) => const ImageViewerBasicExample(),
            ),
            ExampleItem(
              desc: '带操作图片预览',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ImageViewerWithActionsExample',
              builder: (_) => const ImageViewerWithActionsExample(),
            ),
          ],
        ),
      ],
    );
  }
}
