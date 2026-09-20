import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'capsule_tab_bar_example.dart';
import 'custom_tab_bar_example.dart';
import 'double_layer_tab_bar_example.dart';
import 'icon_tab_bar_example.dart';
import 'icon_text_tab_bar_example.dart';
import 'text_tab_bar_example.dart';
import 'weak_tab_bars_example.dart';

@ExampleCodeManifest()
class TTabBarPage extends StatefulWidget {
  const TTabBarPage({super.key});

  @override
  State<TTabBarPage> createState() => _TTabBarPageState();
}

class _TTabBarPageState extends State<TTabBarPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'TabBar 底部标签栏',
      desc: '用于在不同功能模块之间进行快速切换，位于页面底部。',
      exampleCodeGroup: 'tabBar',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '纯文本标签栏',
              methodName: 'TextTabBarExample',
              builder: (_) => const TextTabBarExample(),
            ),
            ExampleItem(
              desc: '图标加文本标签栏',
              methodName: 'IconTextTabBarExample',
              builder: (_) => const IconTextTabBarExample(),
            ),
            ExampleItem(
              desc: '纯图标标签栏',
              methodName: 'IconTabBarExample',
              builder: (_) => const IconTabBarExample(),
            ),
            ExampleItem(
              desc: '双层级文本标签栏',
              methodName: 'DoubleLayerTabBarExample',
              builder: (_) => const DoubleLayerTabBarExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '弱选中标签栏',
              methodName: 'WeakTabBarsExample',
              builder: (_) => const WeakTabBarsExample(),
            ),
            ExampleItem(
              desc: '悬浮胶囊标签栏',
              methodName: 'CapsuleTabBarExample',
              builder: (_) => const CapsuleTabBarExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '自定义',
          children: [
            ExampleItem(
              desc: '自定义样式',
              methodName: 'CustomTabBarExample',
              builder: (_) => const CustomTabBarExample(),
            ),
          ],
        ),
      ],
    );
  }

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _textValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _iconTextValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _iconValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _doubleLayerValue = 3;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `final _weakValues = [0, 0, 0];`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _capsuleValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。

  /// 核心片段：导入 material.dart 和 tdesign_flutter.dart。
  /// 在 StatefulWidget 的 State 中声明 `int _customValue = 0;`，
  /// 从 build 调用本方法；状态由 State 持有并通过 setState 重建。
}
