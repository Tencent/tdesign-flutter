import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'image_states_example.dart';
import 'image_types_example.dart';

@ExampleCodeManifest()
class TImagePage extends StatelessWidget {
  const TImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'image',
      desc: '用于展示效果，主要为上下左右居中裁切、拉伸、平铺等方式。',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '',
              methodName: 'ImageTypesExample',
              builder: (_) => const ImageTypesExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '',
              methodName: 'ImageStatesExample',
              builder: (_) => const ImageStatesExample(),
            ),
          ],
        ),
      ],
    );
  }
}
