import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'upload_layouts_example.dart';
import 'upload_message_file_example.dart';
import 'upload_multiple_example.dart';
import 'upload_single_example.dart';
import 'upload_status_example.dart';
import 'upload_tile_example.dart';

@ExampleCodeManifest()
/// TUpload 演示。
class TUploadPage extends StatelessWidget {
  const TUploadPage({super.key});

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
            ExampleItem(
              desc: '单选上传',
              methodName: 'UploadSingleExample',
              builder: (_) => const UploadSingleExample(),
            ),
            ExampleItem(
              desc: '多选上传',
              methodName: 'UploadMultipleExample',
              builder: (_) => const UploadMultipleExample(),
            ),
            ExampleItem(
              desc: '长按图片拖拽排片',
              methodName: 'UploadTileExample',
              builder: (_) => const UploadTileExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '加载状态',
              methodName: 'UploadStatusExample',
              builder: (_) => const UploadStatusExample(),
            ),
            ExampleItem(
              desc: '从聊天记录上选',
              methodName: 'UploadMessageFileExample',
              builder: (_) => const UploadMessageFileExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件风格',
          children: [
            ExampleItem(
              desc: '宫格/列表布局',
              methodName: 'UploadLayoutsExample',
              builder: (_) => const UploadLayoutsExample(),
            ),
          ],
        ),
      ],
    );
  }
}
