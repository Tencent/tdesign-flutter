part of 'image_page.dart';

extension _ImageStatusModule on TImagePage {
  ExampleModule get _imageStatusModule => const ExampleModule(
    title: '组件状态',
    children: [ExampleItem(ignoreCode: true, builder: _buildImageStates)],
  );
}
