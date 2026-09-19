part of 'image_page.dart';

extension _ImageTypeModule on TImagePage {
  ExampleModule get _imageTypeModule => const ExampleModule(
    title: '组件类型',
    children: [ExampleItem(ignoreCode: true, builder: _buildImageTypes)],
  );
}
