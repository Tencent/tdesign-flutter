part of 'upload_page.dart';

extension _UploadStyleModule on TUploadPage {
  ExampleModule get _uploadStyleModule => ExampleModule(
    title: '组件风格',
    children: [ExampleItem(desc: '宫格/列表布局', builder: _layouts)],
  );
}
