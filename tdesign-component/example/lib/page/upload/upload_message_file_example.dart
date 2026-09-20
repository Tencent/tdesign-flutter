import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'upload')
class UploadMessageFileExample extends StatefulWidget {
  const UploadMessageFileExample({super.key});

  @override
  State<UploadMessageFileExample> createState() =>
      _UploadMessageFileExampleState();
}

class _UploadMessageFileExampleState extends State<UploadMessageFileExample> {
  var _files = [_imageFiles.first];

  Widget _messageFile(BuildContext context) {
    return _demo(
      TUpload(
        files: _files,
        maxFiles: 4,
        onChanged: (value) => setState(() => _files = value),
      ),
      title: '上传图片',
    );
  }

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
    return _messageFile(context);
  }
}
