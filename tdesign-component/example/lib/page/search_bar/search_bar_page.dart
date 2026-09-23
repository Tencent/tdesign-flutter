import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'search_bar_action_example.dart';
import 'search_bar_base_example.dart';
import 'search_bar_center_example.dart';
import 'search_bar_max_length_example.dart';
import 'search_bar_shape_example.dart';

@ExampleCodeManifest()
class TSearchBarPage extends StatefulWidget {
  const TSearchBarPage({super.key});

  @override
  State<TSearchBarPage> createState() => _TSearchBarPageState();
}

class _TSearchBarPageState extends State<TSearchBarPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于用户输入搜索信息，并进行页面内容搜索。',
      compactDemo: true,
      showTestModule: false,
      exampleCodeGroup: 'search',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础搜索框',
              center: false,
              methodName: 'SearchBarBaseExample',
              builder: (_) => const SearchBarBaseExample(),
            ),
            ExampleItem(
              desc: '字数限制',
              center: false,
              methodName: 'SearchBarMaxLengthExample',
              builder: (_) => const SearchBarMaxLengthExample(),
            ),
            ExampleItem(
              desc: '获取焦点后显示取消按钮',
              center: false,
              methodName: 'SearchBarActionExample',
              builder: (_) => const SearchBarActionExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '搜索框形状',
              center: false,
              methodName: 'SearchBarShapeExample',
              builder: (_) => const SearchBarShapeExample(),
            ),
            ExampleItem(
              desc: '默认状态其他对齐方式',
              center: false,
              methodName: 'SearchBarCenterExample',
              builder: (_) => const SearchBarCenterExample(),
            ),
          ],
        ),
      ],
      test: const [],
    );
  }
}
