import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

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
              builder: _buildBasic,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ExampleItem(
              desc: '带操作图片预览',
              builder: _buildWithActions,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'image-viewer')
  Widget _buildBasic(BuildContext context) {
    const images = <ImageProvider<Object>>[
      AssetImage('assets/img/image.png'),
      AssetImage('assets/img/t_action_sheet_8.png'),
    ];
    return SizedBox(
      width: double.infinity,
      child: TButton(
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () => TImageViewer.show(
          context: context,
          images: images,
          showClose: false,
          showIndex: true,
        ),
        child: const Text('基础图片预览'),
      ),
    );
  }

  @ExampleCode(group: 'image-viewer')
  Widget _buildWithActions(BuildContext context) {
    const images = <ImageProvider<Object>>[
      AssetImage('assets/img/image.png'),
      AssetImage('assets/img/t_action_sheet_8.png'),
    ];
    return SizedBox(
      width: double.infinity,
      child: TButton(
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () => TImageViewer.show(
          context: context,
          images: images,
          showClose: true,
          showDelete: true,
          showIndex: true,
          onDelete: (index) => TActionSheet.showList<int>(
            context,
            subtitle: '要删除这张照片吗？',
            items: [
              TActionSheetItem(
                value: 1,
                label: '删除',
                textStyle: TextStyle(color: context.tTheme.errorNormalColor),
              ),
            ],
            onSelected: (_) =>
                TToast.showText('已选择第 ${index + 1} 张图片', context: context),
          ),
        ),
        child: const Text('带操作图片预览'),
      ),
    );
  }
}
