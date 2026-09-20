import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'upload')
class UploadStatusExample extends StatefulWidget {
  const UploadStatusExample({super.key});

  @override
  State<UploadStatusExample> createState() => _UploadStatusExampleState();
}

class _UploadStatusExampleState extends State<UploadStatusExample> {
  var _files = _statusFiles;

  Widget _status(BuildContext context) {
    return _demo(
      TUpload(
        files: _files,
        maxFiles: 4,
        onChanged: (value) => setState(() => _files = value),
      ),
      title: '上传图片',
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return _status(context);
  }
}
