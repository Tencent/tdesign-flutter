import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'display_steps_example.dart';
import 'steps_custom_content_example.dart';
import 'steps_error_states_example.dart';
import 'steps_horizontal_default_example.dart';
import 'steps_horizontal_dot_example.dart';
import 'steps_horizontal_icon_example.dart';
import 'steps_vertical_default_example.dart';
import 'steps_vertical_dot_example.dart';
import 'steps_vertical_icon_example.dart';
import 'steps_vertical_selectable_example.dart';

const _stepsItemPadding = EdgeInsets.symmetric(horizontal: 16);

@ExampleCodeManifest()
class TStepsPage extends StatefulWidget {
  const TStepsPage({super.key});

  @override
  State<TStepsPage> createState() => _TStepsPageState();
}

class _TStepsPageState extends State<TStepsPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'steps',
      desc: '用于任务步骤展示或任务进度展示。',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: 'Horizontal Default Steps 水平默认步骤条',
              padding: _stepsItemPadding,
              methodName: 'StepsHorizontalDefaultExample',
              builder: (_) => const StepsHorizontalDefaultExample(),
            ),
            ExampleItem(
              desc: 'Horizontal Icon Steps 水平图标步骤条',
              padding: _stepsItemPadding,
              methodName: 'StepsHorizontalIconExample',
              builder: (_) => const StepsHorizontalIconExample(),
            ),
            ExampleItem(
              desc: 'Horizontal Dot Steps 水平简略步骤条',
              padding: _stepsItemPadding,
              methodName: 'StepsHorizontalDotExample',
              builder: (_) => const StepsHorizontalDotExample(),
            ),
            ExampleItem(
              desc: 'Vertical Default Steps 垂直默认步骤条',
              padding: _stepsItemPadding,
              methodName: 'StepsVerticalDefaultExample',
              builder: (_) => const StepsVerticalDefaultExample(),
            ),
            ExampleItem(
              desc: 'Vertical Icon Steps 垂直图标步骤条',
              padding: _stepsItemPadding,
              methodName: 'StepsVerticalIconExample',
              builder: (_) => const StepsVerticalIconExample(),
            ),
            ExampleItem(
              desc: 'Vertical Dot Steps 垂直简略步骤条',
              padding: _stepsItemPadding,
              methodName: 'StepsVerticalDotExample',
              builder: (_) => const StepsVerticalDotExample(),
            ),
            ExampleItem(
              desc: 'Customize Steps Content 自定义步骤条内容',
              padding: _stepsItemPadding,
              methodName: 'StepsCustomContentExample',
              builder: (_) => const StepsCustomContentExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: 'Error 错误状态',
              padding: _stepsItemPadding,
              methodName: 'StepsErrorStatesExample',
              builder: (_) => const StepsErrorStatesExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '特殊类型',
          children: [
            ExampleItem(
              desc: 'Vertical Customize Steps 垂直自定义步骤条',
              padding: _stepsItemPadding,
              methodName: 'StepsVerticalSelectableExample',
              builder: (_) => const StepsVerticalSelectableExample(),
            ),
            ExampleItem(
              desc: 'Read-only Steps 纯展示步骤条',
              padding: _stepsItemPadding,
              methodName: 'DisplayStepsExample',
              builder: (_) => const DisplayStepsExample(),
            ),
          ],
        ),
      ],
    );
  }

  /// Horizontal Default Steps 水平默认步骤条

  /// Horizontal Icon Steps 水平图标步骤条

  /// Horizontal Dot Steps 水平简略步骤条

  /// Vertical Default Steps 垂直默认步骤条

  /// Vertical Icon Steps 垂直图标步骤条

  /// Vertical Dot Steps 垂直简略步骤条

  /// Customize Steps Content 自定义步骤条内容

  /// Error 错误状态

  /// Vertical Customize Steps 垂直自定义步骤条
  ///
  /// 核心片段：导入 Flutter material.dart 和 tdesign_flutter.dart，
  /// 将此方法放在 StatefulWidget 的 State 中，由 build 调用。
  /// State 声明 `int _selectedStep = 3;` 保存当前步骤；
  /// 不在 build 中重新初始化，回调通过 setState 更新受控值。

  /// Read-only Steps 纯展示步骤条
}
