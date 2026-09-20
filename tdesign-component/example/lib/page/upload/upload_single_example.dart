import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'upload')
class UploadSingleExample extends StatefulWidget {
  const UploadSingleExample({super.key});

  @override
  State<UploadSingleExample> createState() => _UploadSingleExampleState();
}

class _UploadSingleExampleState extends State<UploadSingleExample> {
  var _files = const <TUploadFile>[];

  Widget _single(BuildContext context) {
    return _demo(
      TUpload(
        files: _files,
        maxFiles: 1,
        onChanged: (value) => setState(() => _files = value),
      ),
      title: '上传图片',
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

  @override
  Widget build(BuildContext context) {
    return _single(context);
  }
}
