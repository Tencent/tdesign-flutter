part of 'upload_page.dart';

extension _UploadStatusModule on TUploadPage {
  ExampleModule get _uploadStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(desc: '加载状态', builder: _status),
      ExampleItem(desc: '从聊天记录上选', builder: _messageFile),
    ],
  );
}
