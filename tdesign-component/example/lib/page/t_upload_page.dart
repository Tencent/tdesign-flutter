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
      name: 'uploaded1.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example4.png',
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'image-2',
      name: 'uploaded2.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example6.png',
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'image-3',
      name: 'uploaded3.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example5.png',
      status: TUploadFileStatus.success,
    ),
  ];

  static const _statusFiles = [
    TUploadFile(
      id: 'loading',
      name: 'uploaded1.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example4.png',
      status: TUploadFileStatus.uploading,
    ),
    TUploadFile(
      id: 'progress',
      name: 'uploaded2.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example5.png',
      status: TUploadFileStatus.uploading,
      progress: 0.68,
    ),
    TUploadFile(
      id: 'retry',
      name: 'uploaded3.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example6.png',
      status: TUploadFileStatus.retryableError,
    ),
    TUploadFile(
      id: 'failed',
      name: 'uploaded4.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example5.png',
      status: TUploadFileStatus.error,
    ),
  ];

  static const _gridLayoutFiles = [
    TUploadFile(
      id: 'grid-loading',
      name: 'loading-file.txt',
      status: TUploadFileStatus.uploading,
    ),
    TUploadFile(
      id: 'grid-progress',
      name: 'loading-file2.txt',
      status: TUploadFileStatus.uploading,
      progress: 0.68,
    ),
    TUploadFile(
      id: 'grid-retry',
      name: 'failed-file.txt',
      status: TUploadFileStatus.retryableError,
    ),
    TUploadFile(
      id: 'grid-failed',
      name: 'error-file.txt',
      status: TUploadFileStatus.error,
    ),
    TUploadFile(
      id: 'grid-excel',
      name: 'report.xlsx',
      size: 153600,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'grid-pdf',
      name: 'document.pdf',
      size: 327680,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'grid-powerpoint',
      name: 'presentation.pptx',
      size: 524288,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'grid-word',
      name: 'article.docx',
      size: 262144,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'grid-image-loading',
      name: 'image-loading.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/upload6.png',
      status: TUploadFileStatus.uploading,
    ),
    TUploadFile(
      id: 'grid-image-progress',
      name: 'image-percent.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/upload6.png',
      status: TUploadFileStatus.uploading,
      progress: 0.68,
    ),
    TUploadFile(
      id: 'grid-image-retry',
      name: 'image-reload.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/upload6.png',
      status: TUploadFileStatus.retryableError,
    ),
    TUploadFile(
      id: 'grid-image-failed',
      name: 'image-failed.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/upload6.png',
      status: TUploadFileStatus.error,
    ),
    TUploadFile(
      id: 'grid-image-done',
      name: 'image-done.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/upload6.png',
      status: TUploadFileStatus.success,
    ),
  ];

  static const _listFiles = [
    TUploadFile(
      id: 'list-loading',
      name: 'Technical Design Document.pdf',
      size: 222208,
      status: TUploadFileStatus.uploading,
      progress: 0.3,
    ),
    TUploadFile(
      id: 'list-failed',
      name: 'Technical Design Document.pdf',
      size: 222208,
      status: TUploadFileStatus.error,
    ),
    TUploadFile(
      id: 'list-image',
      name: 'Design Mockup.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/upload6.png',
      size: 1048576,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'list-video',
      name: 'Product Demo.mp4',
      size: 5242880,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'list-word',
      name: 'Project Proposal.docx',
      size: 131072,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'list-excel',
      name: 'Financial Report.xlsx',
      size: 262144,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'list-pdf',
      name: 'User Manual.pdf',
      size: 524288,
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'list-powerpoint',
      name: 'Quarterly Review.pptx',
      size: 786432,
      status: TUploadFileStatus.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'upload',
      desc: '用于相册读取或拉起拍照的图片上传功能。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '单选上传', builder: _single),
            ExampleItem(desc: '多选上传', builder: _multiple),
            ExampleItem(desc: '长按图片拖拽排片', builder: _tile),
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
    var files = const <TUploadFile>[];
    return StatefulBuilder(
      builder: (context, setState) => _demo(
        TUpload(
          files: files,
          maxFiles: 1,
          onChanged: (value) => setState(() => files = value),
        ),
        title: '上传图片',
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _multiple(BuildContext context) {
    var files = _imageFiles;
    return StatefulBuilder(
      builder: (context, setState) => _demo(
        TUpload(
          files: files,
          maxFiles: 4,
          onChanged: (value) => setState(() => files = value),
        ),
        title: '上传图片',
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _tile(BuildContext context) {
    var files = _imageFiles;
    return StatefulBuilder(
      builder: (context, setState) => _demo(
        TUpload(
          files: files,
          maxFiles: 4,
          draggable: true,
          onChanged: (value) => setState(() => files = value),
        ),
        title: '上传图片',
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _status(BuildContext context) {
    var files = _statusFiles;
    return StatefulBuilder(
      builder: (context, setState) => _demo(
        TUpload(
          files: files,
          maxFiles: 4,
          onChanged: (value) => setState(() => files = value),
        ),
        title: '上传图片',
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _messageFile(BuildContext context) {
    var files = [_imageFiles.first];
    return StatefulBuilder(
      builder: (context, setState) => _demo(
        TUpload(
          files: files,
          maxFiles: 4,
          onChanged: (value) => setState(() => files = value),
        ),
        title: '上传图片',
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _layouts(BuildContext context) {
    var gridFiles = _gridLayoutFiles;
    var listFiles = _listFiles;
    return StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TText('宫格布局上传'),
            const SizedBox(height: 16),
            TUpload(
              files: gridFiles,
              maxFiles: null,
              onChanged: (value) => setState(() => gridFiles = value),
            ),
            const SizedBox(height: 16),
            const TText('列表布局上传'),
            const SizedBox(height: 16),
            TUpload(
              files: listFiles,
              maxFiles: null,
              layout: TUploadLayout.list,
              onChanged: (value) => setState(() => listFiles = value),
            ),
          ],
        ),
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
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: upload,
        ),
      ],
    );
  }
}
