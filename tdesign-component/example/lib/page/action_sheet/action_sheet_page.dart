import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'action_sheet_badge_grid_example.dart';
import 'action_sheet_badge_list_example.dart';
import 'action_sheet_basic_grid_example.dart';
import 'action_sheet_basic_list_example.dart';
import 'action_sheet_center_list_example.dart';
import 'action_sheet_description_grid_example.dart';
import 'action_sheet_description_list_example.dart';
import 'action_sheet_description_scroll_grid_example.dart';
import 'action_sheet_icon_list_example.dart';
import 'action_sheet_left_list_example.dart';
import 'action_sheet_paged_grid_example.dart';
import 'action_sheet_scroll_grid_example.dart';
import 'action_sheet_status_icon_list_example.dart';

@ExampleCodeManifest()
class TActionSheetPage extends StatelessWidget {
  const TActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '从底部弹出的模态框，提供和当前场景相关的操作动作，也支持提供信息输入和描述。',
      exampleCodeGroup: 'action_sheet',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '列表型动作面板',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'ActionSheetBasicListExample',
              builder: (_) => const ActionSheetBasicListExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetDescriptionListExample',
              builder: (_) => const ActionSheetDescriptionListExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetIconListExample',
              builder: (_) => const ActionSheetIconListExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetBadgeListExample',
              builder: (_) => const ActionSheetBadgeListExample(),
            ),
            ExampleItem(
              desc: '宫格型动作面板',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'ActionSheetBasicGridExample',
              builder: (_) => const ActionSheetBasicGridExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetDescriptionGridExample',
              builder: (_) => const ActionSheetDescriptionGridExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetPagedGridExample',
              builder: (_) => const ActionSheetPagedGridExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetBadgeGridExample',
              builder: (_) => const ActionSheetBadgeGridExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetScrollGridExample',
              builder: (_) => const ActionSheetScrollGridExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetDescriptionScrollGridExample',
              builder: (_) => const ActionSheetDescriptionScrollGridExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '列表型选项状态',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'ActionSheetStatusIconListExample',
              builder: (_) => const ActionSheetStatusIconListExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '列表型对齐方式',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'ActionSheetCenterListExample',
              builder: (_) => const ActionSheetCenterListExample(),
            ),
            ExampleItem(
              desc: '',
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              methodName: 'ActionSheetLeftListExample',
              builder: (_) => const ActionSheetLeftListExample(),
            ),
          ],
        ),
      ],
    );
  }
}
