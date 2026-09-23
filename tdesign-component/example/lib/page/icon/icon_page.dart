import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide TIcons;
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';
import 'package:url_launcher/link.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'basic_ticon_example.dart';
import 'icon_from_name_example.dart';
import 'priority_demo_example.dart';
import 'show_all_icons_example.dart';
import 'sized_ticon_example.dart';
import 'theme_demo_example.dart';

@ExampleCodeManifest()
class TIconPage extends StatefulWidget {
  const TIconPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIconPageState();
}

class _TIconPageState extends State<TIconPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: 'Icon 作为UI构成中重要的元素，一定程度上影响UI界面整体呈现出的风格。',
      exampleCodeGroup: 'icon',
      children: [
        ExampleModule(
          title: '主题与图标',
          children: [
            ExampleItem(
              desc: 'TIcon 基础用法:',
              methodName: 'BasicTIconExample',
              builder: (_) => const BasicTIconExample(),
            ),
            ExampleItem(
              desc: '指定 size 和 color:',
              methodName: 'SizedTIconExample',
              builder: (_) => const SizedTIconExample(),
            ),
            ExampleItem(
              desc: 'TIcon.fromName 通过名称:',
              methodName: 'IconFromNameExample',
              builder: (_) => const IconFromNameExample(),
            ),
            ExampleItem(
              desc: 'Theme 默认 size/color:',
                methodName: 'IconThemeExample',
                builder: (_) => const IconThemeExample(),
            ),
            ExampleItem(
              desc: '构造器优先级覆盖 Theme:',
                methodName: 'IconPriorityExample',
                builder: (_) => const IconPriorityExample(),
            ),
          ],
        ),
        ExampleModule(
          title: 'icon示例',
          children: [
            ExampleItem(
              desc: 'icon数量: ${TIcons.allIconsMap.length}',
              methodName: 'ShowAllIconsExample',
              builder: (_) => const ShowAllIconsExample(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Icon Demo 使用的懒加载网格，避免一次性创建全部图标。
