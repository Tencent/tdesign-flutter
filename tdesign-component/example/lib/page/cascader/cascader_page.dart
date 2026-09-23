import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'cascader_any_example.dart';
import 'cascader_base_example.dart';
import 'cascader_initial_example.dart';
import 'cascader_keys_example.dart';
import 'cascader_subtitle_example.dart';
import 'cascader_tab_example.dart';

@ExampleCodeManifest()
/// TCascader 演示。
class TCascaderPage extends StatefulWidget {
  const TCascaderPage({super.key});

  @override
  State<TCascaderPage> createState() => _TCascaderPageState();
}

class _TCascaderPageState extends State<TCascaderPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于多层级数据的逐级选择。',
      exampleCodeGroup: 'cascader',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '垂直级联选择器',
              methodName: 'CascaderBaseExample',
              builder: (_) => const CascaderBaseExample(),
            ),
            ExampleItem(
              desc: '垂直级联选择器-带字母定位',
              methodName: 'CascaderInitialExample',
              builder: (_) => const CascaderInitialExample(),
            ),
            ExampleItem(
              desc: '水平级联选择器',
              methodName: 'CascaderTabExample',
              builder: (_) => const CascaderTabExample(),
            ),
            ExampleItem(
              desc: '水平级联选择器-带字母定位',
              methodName: 'CascaderKeysExample',
              builder: (_) => const CascaderKeysExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '带标题级联选择器',
              methodName: 'CascaderSubtitleExample',
              builder: (_) => const CascaderSubtitleExample(),
            ),
            ExampleItem(
              desc: '无标题级联选择器',
              methodName: 'CascaderAnyExample',
              builder: (_) => const CascaderAnyExample(),
            ),
          ],
        ),
      ],
    );
  }

  /// 六个公开入口严格按 Figma 移动端展示排列；step/tab、定位副标题和
  /// 有/无标题都由各自示例显式配置，选中路径由调用方受控保存。
}
