part of 'upload_page.dart';

extension _UploadTypeModule on TUploadPage {
  ExampleModule get _uploadTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '单选上传', builder: _single),
      ExampleItem(desc: '多选上传', builder: _multiple),
      ExampleItem(desc: '长按图片拖拽排片', builder: _tile),
    ],
  );
}
