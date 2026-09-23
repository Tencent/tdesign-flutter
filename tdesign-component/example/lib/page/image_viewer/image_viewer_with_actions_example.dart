import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'image-viewer')
class ImageViewerWithActionsExample extends StatelessWidget {
  const ImageViewerWithActionsExample({super.key});

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

  @override
  Widget build(BuildContext context) {
    return _buildWithActions(context);
  }
}
