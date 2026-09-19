part of 'image_viewer_page.dart';

extension _ImageViewerTypeModule on TImageViewerPage {
  ExampleModule get _imageViewerTypeModule => ExampleModule(
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
  );
}
