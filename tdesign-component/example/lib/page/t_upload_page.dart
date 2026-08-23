import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TUpload 演示。
class TUploadPage extends StatelessWidget {
  const TUploadPage({super.key});

  static const _imageFiles = [
    TUploadFile(
      id: 'image-1',
      name: 'image-1.png',
      url: 'https://tdesign.gtimg.com/demo/images/example1.png',
      size: 1024 * 128,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'image-2',
      name: 'image-2.png',
      url: 'https://tdesign.gtimg.com/demo/images/example2.png',
      size: 1024 * 256,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'image-3',
      name: 'image-3.png',
      url: 'https://tdesign.gtimg.com/demo/images/example3.png',
      size: 1024 * 512,
      status: TUploadFileStatus.success,
    ),
  ];

  static const _statusFiles = [
    TUploadFile(
      id: 'loading',
      name: 'loading.png',
      url: 'https://tdesign.gtimg.com/demo/images/example1.png',
      status: TUploadFileStatus.uploading,
    ),
    TUploadFile(
      id: 'progress',
      name: 'progress.png',
      url: 'https://tdesign.gtimg.com/demo/images/example2.png',
      status: TUploadFileStatus.uploading,
      progress: 0.68,
    ),
    TUploadFile(
      id: 'retry',
      name: 'retry.png',
      url: 'https://tdesign.gtimg.com/demo/images/example3.png',
      status: TUploadFileStatus.retry,
    ),
    TUploadFile(
      id: 'failed',
      name: 'failed.png',
      url: 'https://tdesign.gtimg.com/demo/images/example1.png',
      status: TUploadFileStatus.error,
    ),
  ];

  static const _listFiles = [
    TUploadFile(
      id: 'document',
      name: '设计说明.pdf',
      size: 1024 * 768,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'photo',
      name: '产品截图.png',
      url: 'https://tdesign.gtimg.com/demo/images/example1.png',
      size: 1024 * 256,
      status: TUploadFileStatus.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'upload',
      desc:
          '用于相册读取或拉起拍照的图片上传功能。（为避免涉及用户隐私，Upload 组件示例均为禁用态，使用时请自行取消禁用态，以便正常使用上传功能。）',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '单选上传', builder: _single),
            ExampleItem(desc: '多选上传', builder: _multiple),
            ExampleItem(desc: '长按图片拖拽排片', builder: _drag),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '加载状态', builder: _status),
            ExampleItem(desc: '从聊天记录上选', builder: _messageFile),
          ],
        ),
        ExampleModule(
          title: '组件风格',
          children: [ExampleItem(desc: '宫格/列表布局', builder: _layouts)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'upload')
  Widget _single(BuildContext context) {
    return _demo(TUpload(files: const [], maxFiles: 1), title: '上传图片');
  }

  @ExampleCode(group: 'upload')
  Widget _multiple(BuildContext context) {
    return _demo(TUpload(files: _imageFiles, maxFiles: 4), title: '上传图片');
  }

  @ExampleCode(group: 'upload')
  Widget _drag(BuildContext context) {
    return _demo(TUpload(files: _imageFiles, maxFiles: 4), title: '上传图片');
  }

  @ExampleCode(group: 'upload')
  Widget _status(BuildContext context) {
    return _demo(TUpload(files: _statusFiles, maxFiles: 4), title: '上传图片');
  }

  @ExampleCode(group: 'upload')
  Widget _messageFile(BuildContext context) {
    return _demo(
      TUpload(files: [_imageFiles.first], maxFiles: 4),
      title: '上传图片',
    );
  }

  @ExampleCode(group: 'upload')
  Widget _layouts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TText('宫格布局上传'),
          const SizedBox(height: 8),
          TUpload(files: _imageFiles, maxFiles: 4),
          const SizedBox(height: 24),
          const TText('列表布局上传'),
          const SizedBox(height: 8),
          TUpload(files: _listFiles, maxFiles: 3, layout: TUploadLayout.list),
        ],
      ),
    );
  }

  Widget _demo(TUpload upload, {required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TText(title),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: upload,
        ),
      ],
    );
  }
}
