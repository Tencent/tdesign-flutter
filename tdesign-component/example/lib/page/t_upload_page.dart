import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TUpload 演示。
class TUploadPage extends StatefulWidget {
  const TUploadPage({super.key});

  @override
  State<TUploadPage> createState() => _TUploadPageState();
}

class _TUploadPageState extends State<TUploadPage> {
  List<TUploadFile> _files = [];
  List<TUploadFile> _statusFiles = const [
    TUploadFile(
      id: 'uploading',
      name: 'uploading.png',
      url: 'https://tdesign.gtimg.com/demo/images/example1.png',
      status: TUploadFileStatus.uploading,
      progress: 0.68,
    ),
    TUploadFile(
      id: 'error',
      name: 'error.png',
      url: 'https://tdesign.gtimg.com/demo/images/example2.png',
      status: TUploadFileStatus.error,
      errorText: '重新上传',
    ),
  ];
  static const _disabledFiles = [
    TUploadFile(
      id: 'disabled-success',
      name: 'disabled-success.png',
      url: 'https://tdesign.gtimg.com/demo/images/example3.png',
      status: TUploadFileStatus.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'upload',
      desc: '用于选择文件并展示业务上传状态。',
      children: [
        ExampleModule(title: '基础能力', children: [
          ExampleItem(desc: '图片选择', builder: _buildBasic),
          ExampleItem(desc: '空态可用与禁用', builder: _buildEmptyStates),
          ExampleItem(desc: '上传状态', builder: _buildStatus),
          ExampleItem(desc: '圆形主题', builder: _buildCircle),
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'upload')
  Widget _buildBasic(BuildContext context) {
    return _section(
      TUpload(
        files: _files,
        maxFiles: 4,
        maxFileSize: 5 * 1024 * 1024,
        onValidationError: (error) => _show('$error'),
        onError: (error) => _show('$error'),
        onChanged: (files) => setState(() => _files = files),
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _buildEmptyStates(BuildContext context) {
    return _section(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                const TText('可用'),
                const SizedBox(height: 8),
                TUpload(
                  files: const [],
                  maxFiles: 1,
                  picker: () async => const [],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                const TText('禁用'),
                const SizedBox(height: 8),
                TUpload(files: const [], maxFiles: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _buildStatus(BuildContext context) {
    return _section(
      TUpload(
        files: _statusFiles,
        maxFiles: 4,
        onRetry: (file) => _show('重试 ${file.name}'),
        onChanged: (files) => setState(() => _statusFiles = files),
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _buildCircle(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TUploadThemeData(
          variant: TUploadVariant.circle,
          itemSize: 72,
          spacing: 12,
        ),
      ),
      child: _section(
        TUpload(
          files: _files,
          maxFiles: 4,
          onChanged: (files) => setState(() => _files = files),
        ),
      ),
    );
  }

  @ExampleCode(group: 'upload')
  Widget _buildDisabled(BuildContext context) {
    return _section(TUpload(files: _disabledFiles, maxFiles: 4));
  }

  Widget _section(Widget child) {
    return Padding(padding: const EdgeInsets.all(16), child: child);
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
