import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'upload')
class UploadLayoutsExample extends StatefulWidget {
  const UploadLayoutsExample({super.key});

  @override
  State<UploadLayoutsExample> createState() => _UploadLayoutsExampleState();
}

class _UploadLayoutsExampleState extends State<UploadLayoutsExample> {
  var _gridFiles = _gridLayoutFiles;
  var _listLayoutFiles = _listFiles;

  Widget _layouts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TText('宫格布局上传'),
          const SizedBox(height: 16),
          TUpload(
            files: _gridFiles,
            maxFiles: null,
            onChanged: (value) => setState(() => _gridFiles = value),
          ),
          const SizedBox(height: 16),
          const TText('列表布局上传'),
          const SizedBox(height: 16),
          TUpload(
            files: _listLayoutFiles,
            maxFiles: null,
            layout: TUploadLayout.list,
            onChanged: (value) => setState(() => _listLayoutFiles = value),
          ),
        ],
      ),
    );
  }

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
    return _layouts(context);
  }
}
