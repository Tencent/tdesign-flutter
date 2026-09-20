import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'tabs_item_with_content_example.dart';
import 'tabs_item_with_icon_example.dart';
import 'tabs_item_with_line_example.dart';
import 'tabs_item_with_logo_example.dart';
import 'tabs_item_with_size_large_example.dart';
import 'tabs_item_with_size_small_example.dart';
import 'tabs_item_with_space_example.dart';
import 'tabs_item_with_split1_example.dart';
import 'tabs_item_with_split2_example.dart';
import 'tabs_item_with_split3_example.dart';
import 'tabs_item_with_split4_example.dart';
import 'tabs_item_with_status_example.dart';
import 'tabs_item_with_tag_example.dart';

@ExampleCodeManifest()
class TTabsPage extends StatelessWidget {
  const TTabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于内容分类后的展示切换。',
      exampleCodeGroup: 'tabs',
      padding: const EdgeInsets.only(top: 16),
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '均分选项卡',
              methodName: 'TabsItemWithSplit1Example',
              builder: (_) => const TabsItemWithSplit1Example(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'TabsItemWithSplit2Example',
              builder: (_) => const TabsItemWithSplit2Example(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'TabsItemWithSplit3Example',
              builder: (_) => const TabsItemWithSplit3Example(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'TabsItemWithSplit4Example',
              builder: (_) => const TabsItemWithSplit4Example(),
            ),
            ExampleItem(
              desc: '等距选项卡',
              methodName: 'TabsItemWithSpaceExample',
              builder: (_) => const TabsItemWithSpaceExample(),
            ),
            ExampleItem(
              desc: '带图标选项卡',
              methodName: 'TabsItemWithIconExample',
              builder: (_) => const TabsItemWithIconExample(),
            ),
            ExampleItem(
              desc: '带徽标选项卡',
              methodName: 'TabsItemWithLogoExample',
              builder: (_) => const TabsItemWithLogoExample(),
            ),
            ExampleItem(
              desc: '带内容区选项卡',
              methodName: 'TabsItemWithContentExample',
              builder: (_) => const TabsItemWithContentExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '选项卡状态',
              methodName: 'TabsItemWithStatusExample',
              builder: (_) => const TabsItemWithStatusExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '选项卡尺寸',
              methodName: 'TabsItemWithSizeSmallExample',
              builder: (_) => const TabsItemWithSizeSmallExample(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'TabsItemWithSizeLargeExample',
              builder: (_) => const TabsItemWithSizeLargeExample(),
            ),
            ExampleItem(
              desc: '选项卡样式',
              methodName: 'TabsItemWithLineExample',
              builder: (_) => const TabsItemWithLineExample(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'TabsItemWithTagExample',
              builder: (_) => const TabsItemWithTagExample(),
            ),
          ],
        ),
      ],
    );
  }
}
