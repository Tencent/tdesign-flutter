import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'capsule_indexes_example.dart';
import 'letter_indexes_example.dart';
import 'number_indexes_example.dart';

@ExampleCodeManifest()
class TIndexesPage extends StatelessWidget {
  const TIndexesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于页面中信息快速检索，可以根据目录中的页码快速找到所需的内容。',
      exampleCodeGroup: 'indexes',
      navBarKey: navBarkey,
      compactDemo: true,
      backgroundColor: context.tTheme.bgColorContainer,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '索引类型',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'LetterIndexesExample',
              builder: (_) => const LetterIndexesExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'NumberIndexesExample',
              builder: (_) => const NumberIndexesExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '其他索引列表样式',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'CapsuleIndexesExample',
              builder: (_) => const CapsuleIndexesExample(),
            ),
          ],
        ),
      ],
    );
  }
}

/// 核心示例：`_list` 是页面级“索引 -> 城市列表”数据。
///
/// 数据结构示例：`{'index': 'A', 'children': ['阿坝', '阿拉善']}`；接入时可替换为
/// 业务自己的索引及内容列表。
