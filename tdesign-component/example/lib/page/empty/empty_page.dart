import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'icon_empty_example.dart';
import 'image_empty_example.dart';
import 'operation_empty_example.dart';

@ExampleCodeManifest()
class TEmptyPage extends StatelessWidget {
  const TEmptyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'empty',
      desc: '用于空状态时的占位提示。',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '图标空状态',
              methodName: 'IconEmptyExample',
              builder: (_) => const IconEmptyExample(),
            ),
            ExampleItem(
              desc: '自定义图片空状态',
              methodName: 'ImageEmptyExample',
              builder: (_) => const ImageEmptyExample(),
            ),
            ExampleItem(
              desc: '带操作空状态',
              methodName: 'OperationEmptyExample',
              builder: (_) => const OperationEmptyExample(),
            ),
          ],
        ),
      ],
    );
  }
}
