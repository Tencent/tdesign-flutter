import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TStepsPage extends StatefulWidget {
  const TStepsPage({super.key});

  @override
  State<TStepsPage> createState() => _TStepsPageState();
}

class _TStepsPageState extends State<TStepsPage> {
  static const _itemPadding = EdgeInsets.symmetric(horizontal: 16);

  int _selectedStep = 3;

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
              padding: _itemPadding,
              builder: _buildHorizontalDefault,
            ),
            ExampleItem(
              desc: 'Horizontal Icon Steps 水平图标步骤条',
              padding: _itemPadding,
              builder: _buildHorizontalIcon,
            ),
            ExampleItem(
              desc: 'Horizontal Dot Steps 水平简略步骤条',
              padding: _itemPadding,
              builder: _buildHorizontalDot,
            ),
            ExampleItem(
              desc: 'Vertical Default Steps 垂直默认步骤条',
              padding: _itemPadding,
              builder: _buildVerticalDefault,
            ),
            ExampleItem(
              desc: 'Vertical Icon Steps 垂直图标步骤条',
              padding: _itemPadding,
              builder: _buildVerticalIcon,
            ),
            ExampleItem(
              desc: 'Vertical Dot Steps 垂直简略步骤条',
              padding: _itemPadding,
              builder: _buildVerticalDot,
            ),
            ExampleItem(
              desc: 'Customize Steps Content 自定义步骤条内容',
              padding: _itemPadding,
              builder: _buildCustomContent,
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: 'Error 错误状态',
              padding: _itemPadding,
              builder: _buildErrorStates,
            ),
          ],
        ),
        ExampleModule(
          title: '特殊类型',
          children: [
            ExampleItem(
              desc: 'Vertical Customize Steps 垂直自定义步骤条',
              padding: _itemPadding,
              builder: _buildVerticalSelectable,
            ),
            ExampleItem(
              desc: 'Read-only Steps 纯展示步骤条',
              padding: _itemPadding,
              builder: _buildDisplaySteps,
            ),
          ],
        ),
      ],
    );
  }

  List<TStepsItemData> _defaultItems() => const [
    TStepsItemData(title: 'Finish', content: 'Content'),
    TStepsItemData(title: 'Process', content: 'Content'),
    TStepsItemData(title: 'Default', content: 'Content'),
    TStepsItemData(title: 'Default', content: 'Content'),
  ];

  List<TStepsItemData> _iconItems({bool error = false}) => [
    const TStepsItemData(
      title: 'Finish',
      content: 'Content',
      icon: TIcons.cart,
    ),
    TStepsItemData(
      title: error ? 'Error' : 'Process',
      content: 'Content',
      icon: TIcons.cart,
      errorIcon: TIcons.close_circle,
    ),
    const TStepsItemData(
      title: 'Default',
      content: 'Content',
      icon: TIcons.cart,
    ),
    const TStepsItemData(
      title: 'Default',
      content: 'Content',
      icon: TIcons.cart,
    ),
  ];

  List<TStepsItemData> _errorItems() => const [
    TStepsItemData(title: 'Finish', content: 'Content'),
    TStepsItemData(title: 'Error', content: 'Content'),
    TStepsItemData(title: 'Default', content: 'Content'),
    TStepsItemData(title: 'Default', content: 'Content'),
  ];

  /// Horizontal Default Steps 水平默认步骤条
  @ExampleCode(group: 'steps')
  Widget _buildHorizontalDefault(BuildContext context) {
    return TSteps(steps: _defaultItems(), value: 1);
  }

  /// Horizontal Icon Steps 水平图标步骤条
  @ExampleCode(group: 'steps')
  Widget _buildHorizontalIcon(BuildContext context) {
    return TSteps(steps: _iconItems(), value: 1);
  }

  /// Horizontal Dot Steps 水平简略步骤条
  @ExampleCode(group: 'steps')
  Widget _buildHorizontalDot(BuildContext context) {
    return TSteps(steps: _defaultItems(), value: 1, variant: TStepsVariant.dot);
  }

  /// Vertical Default Steps 垂直默认步骤条
  @ExampleCode(group: 'steps')
  Widget _buildVerticalDefault(BuildContext context) {
    return TSteps(
      steps: _defaultItems(),
      value: 1,
      direction: TStepsDirection.vertical,
    );
  }

  /// Vertical Icon Steps 垂直图标步骤条
  @ExampleCode(group: 'steps')
  Widget _buildVerticalIcon(BuildContext context) {
    return TSteps(
      steps: _iconItems(),
      value: 1,
      direction: TStepsDirection.vertical,
    );
  }

  /// Vertical Dot Steps 垂直简略步骤条
  @ExampleCode(group: 'steps')
  Widget _buildVerticalDot(BuildContext context) {
    return TSteps(
      steps: _defaultItems(),
      value: 1,
      direction: TStepsDirection.vertical,
      variant: TStepsVariant.dot,
    );
  }

  /// Customize Steps Content 自定义步骤条内容
  @ExampleCode(group: 'steps')
  Widget _buildCustomContent(BuildContext context) {
    return const TSteps(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Customize content'),
        TStepsItemData(
          title: 'Process',
          customContent: Padding(
            padding: EdgeInsets.only(top: 4, bottom: 16),
            child: TImage(
              src: 'assets/img/image.png',
              width: 280,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        TStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      value: 1,
      direction: TStepsDirection.vertical,
    );
  }

  /// Error 错误状态
  @ExampleCode(group: 'steps')
  Widget _buildErrorStates(BuildContext context) {
    return Column(
      children: [
        TSteps(steps: _errorItems(), value: 1, status: TStepsStatus.error),
        const SizedBox(height: 32),
        TSteps(
          steps: _iconItems(error: true),
          value: 1,
          status: TStepsStatus.error,
        ),
        const SizedBox(height: 32),
        TSteps(
          steps: _errorItems(),
          value: 1,
          status: TStepsStatus.error,
          variant: TStepsVariant.dot,
        ),
      ],
    );
  }

  /// Vertical Customize Steps 垂直自定义步骤条
  @ExampleCode(group: 'steps')
  Widget _buildVerticalSelectable(BuildContext context) {
    return TSteps(
      steps: const [
        TStepsItemData(title: '已完成步骤'),
        TStepsItemData(title: '已完成步骤'),
        TStepsItemData(title: '已完成步骤'),
        TStepsItemData(title: '当前步骤'),
      ],
      direction: TStepsDirection.vertical,
      variant: TStepsVariant.dot,
      value: _selectedStep,
      onChange: (index) {
        setState(() => _selectedStep = index);
        TToast.showText('选择了步骤 ${index + 1}', context: context);
      },
    );
  }

  /// Read-only Steps 纯展示步骤条
  @ExampleCode(group: 'steps')
  Widget _buildDisplaySteps(BuildContext context) {
    return const TSteps(
      steps: [
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
        TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
      ],
      direction: TStepsDirection.vertical,
      variant: TStepsVariant.display,
    );
  }
}
