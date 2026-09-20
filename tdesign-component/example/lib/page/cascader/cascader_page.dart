import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'cascader_any_example.dart';
import 'cascader_base_example.dart';
import 'cascader_initial_example.dart';
import 'cascader_keys_example.dart';
import 'cascader_search_example.dart';
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
          title: '类型',
          children: [
            ExampleItem(
              desc: '',
              methodName: 'CascaderBaseExample',
              builder: (_) => const CascaderBaseExample(),
            ),
            ExampleItem(
              desc: '选项卡风格',
              methodName: 'CascaderTabExample',
              builder: (_) => const CascaderTabExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '进阶',
          children: [
            ExampleItem(
              desc: '带初始值',
              methodName: 'CascaderInitialExample',
              builder: (_) => const CascaderInitialExample(),
            ),
            ExampleItem(
              desc: '自定义 keys',
              methodName: 'CascaderKeysExample',
              builder: (_) => const CascaderKeysExample(),
            ),
            ExampleItem(
              desc: '使用次级标题',
              methodName: 'CascaderSubtitleExample',
              builder: (_) => const CascaderSubtitleExample(),
            ),
            ExampleItem(
              desc: '选择任意一项',
              methodName: 'CascaderAnyExample',
              builder: (_) => const CascaderAnyExample(),
            ),
            ExampleItem(
              desc: '支持搜索',
              methodName: 'CascaderSearchExample',
              builder: (_) => const CascaderSearchExample(),
            ),
          ],
        ),
      ],
    );
  }

  /// 核心组合片段：放入调用方 StatefulWidget，导入 flutter/material.dart 和
  /// tdesign_flutter/tdesign_flutter.dart。value 是父级持有的已提交路径，
  /// onChanged 用 setState 保存新路径；TCascader 本身保持平铺和严格受控。
  ///
  /// 默认数据覆盖省/市/区三级；自定义字段在本方法中转换为 TCascaderOption。
  /// 基础、tab、初始值、字段映射和次级标题在末级选择后提交并关闭；
  /// allowIntermediateSelection 仅用于“选择任意一项”，关闭按钮提交当前草稿；
  /// searchable 在 Popup 组合层提供搜索，命中末级后直接提交并关闭。
  ///
  /// 七个公开示例通过同一受控组合传入各自配置：基础示例使用默认 step；
  /// 选项卡传 `variant: TCascaderVariant.tab`；初始值由 `useInitialValue` 配置；
  /// 自定义 keys 由 `mapCustomKeys` 在数据进入组件时转换；次级标题传
  /// `subtitles`；任意层选择传 `allowIntermediateSelection: true`；搜索传
  /// `searchable: true`。每个实例都通过
  /// `onChanged: (next) => setState(() => _values[id] = next)` 回写受控值。
}
