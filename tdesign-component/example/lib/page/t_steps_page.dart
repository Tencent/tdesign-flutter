import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TStepsPage extends StatefulWidget {
  const TStepsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TStepsPageState();
}

class _TStepsPageState extends State<TStepsPage> {
  EdgeInsets exampleItemPadding = const EdgeInsets.symmetric(horizontal: 32);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'steps',
      desc: '用于任务步骤展示或任务进度展示。',
      children: [
        ExampleModule(title: '水平默认步骤条', children: [
          ExampleItem(
            desc: '水平默认步骤条1',
            padding: exampleItemPadding,
            builder: _buildBasicHSteps1,
          ),
          ExampleItem(
            desc: '水平默认步骤条2',
            padding: exampleItemPadding,
            builder: _buildBasicHSteps2,
          ),
          ExampleItem(
            desc: '水平默认步骤条3',
            padding: exampleItemPadding,
            builder: _buildBasicHSteps3,
          ),
        ]),
        ExampleModule(title: '水平图标步骤条', children: [
          ExampleItem(
            desc: '水平图标步骤条1',
            padding: exampleItemPadding,
            builder: _buildHIconSteps1,
          ),
          ExampleItem(
            desc: '水平图标步骤条2',
            padding: exampleItemPadding,
            builder: _buildHIconSteps2,
          ),
          ExampleItem(
            desc: '水平图标步骤条3',
            padding: exampleItemPadding,
            builder: _buildHIconSteps3,
          ),
        ]),
        ExampleModule(title: '水平简略步骤条', children: [
          ExampleItem(
            desc: '水平简略步骤条1',
            padding: exampleItemPadding,
            builder: _buildSimpleHSteps1,
          ),
          ExampleItem(
            desc: '水平简略步骤条2',
            padding: exampleItemPadding,
            builder: _buildSimpleHSteps2,
          ),
          ExampleItem(
            desc: '水平简略步骤条3',
            padding: exampleItemPadding,
            builder: _buildSimpleHSteps3,
          ),
        ]),
        ExampleModule(title: '水平错误状态步骤条', children: [
          ExampleItem(
            desc: '水平错误状态基本步骤条',
            padding: exampleItemPadding,
            builder: _buildHErrorSteps1,
          ),
          ExampleItem(
            desc: '水平错误状态图标步骤条',
            padding: exampleItemPadding,
            builder: _buildHErrorSteps2,
          ),
          ExampleItem(
            desc: '水平错误状态简略步骤条',
            padding: exampleItemPadding,
            builder: _buildHErrorSteps3,
          ),
        ]),
        ExampleModule(title: '垂直步骤条', children: [
          ExampleItem(
            desc: '垂直默认步骤条',
            padding: exampleItemPadding,
            builder: _buildVBasicSteps,
          ),
          ExampleItem(
            desc: '垂直图标步骤条',
            padding: exampleItemPadding,
            builder: _buildVIconSteps,
          ),
          ExampleItem(
            desc: '垂直简略步骤条',
            padding: exampleItemPadding,
            builder: _buildVSimpleSteps,
          ),
          ExampleItem(
            desc: '垂直错误状态基本步骤条',
            padding: exampleItemPadding,
            builder: _buildVErrorBasicSteps,
          ),
          ExampleItem(
            desc: '垂直错误状态图标步骤条',
            padding: exampleItemPadding,
            builder: _buildVErrorIconSteps,
          ),
          ExampleItem(
            desc: '垂直错误状态简略步骤条',
            padding: exampleItemPadding,
            builder: _buildVErrorSimpleSteps,
          ),
          ExampleItem(
            desc: '垂直自定义标题基本步骤条',
            padding: exampleItemPadding,
            builder: _buildVCustomTitleBaseSteps,
          ),
          ExampleItem(
            desc: '垂直自定义内容基本步骤条',
            padding: exampleItemPadding,
            builder: _buildVCustomContentBaseSteps,
          ),
        ]),
        ExampleModule(title: 'Extension 步骤条', children: [
          ExampleItem(
            desc: 'Read-only Steps 纯展示水平步骤条',
            padding: exampleItemPadding,
            builder: _buildHReadOnlySteps,
          ),
          ExampleItem(
            desc: 'Read-only Steps 纯展示垂直步骤条',
            padding: exampleItemPadding,
            builder: _buildVReadOnlySteps,
          ),
          ExampleItem(
            desc: 'Vertical Customize Steps 垂直自定义步骤条',
            padding: exampleItemPadding,
            builder: _buildVCustomizeSteps,
          ),
        ]),
      ],
    );
  }

  /// 基本步骤1
  @Demo(group: 'steps')
  Widget _buildBasicHSteps1(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Steps1', content: 'Content1'),
        TStepsItemData(title: 'Steps2', content: 'Content2'),
      ],
    );
  }

  /// 基本步骤2
  @Demo(group: 'steps')
  Widget _buildBasicHSteps2(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Steps1', content: 'Content1'),
        TStepsItemData(title: 'Steps2', content: 'Content2'),
        TStepsItemData(title: 'Steps3', content: 'Content3'),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
    );
  }

  /// 基本步骤3
  @Demo(group: 'steps')
  Widget _buildBasicHSteps3(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Steps1', content: 'Content1'),
        TStepsItemData(title: 'Steps2', content: 'Content2'),
        TStepsItemData(title: 'Steps3', content: 'Content3'),
        TStepsItemData(title: 'Steps4', content: 'Content4'),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
    );
  }

  /// 水平图标步骤条1
  @Demo(group: 'steps')
  Widget _buildHIconSteps1(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps2',
          content: 'Content2',
          successIcon: TIcons.cart,
        ),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 0,
    );
  }

  /// 水平图标步骤条2
  @Demo(group: 'steps')
  Widget _buildHIconSteps2(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps2',
          content: 'Content2',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TIcons.cart,
        ),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
    );
  }

  /// 水平图标步骤条3
  @Demo(group: 'steps')
  Widget _buildHIconSteps3(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps2',
          content: 'Content2',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps4',
          content: 'Content4',
          successIcon: TIcons.cart,
        ),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
    );
  }

  /// 水平简略步骤条1
  @Demo(group: 'steps')
  Widget _buildSimpleHSteps1(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Steps1', content: 'Content1'),
        TStepsItemData(title: 'Steps2', content: 'Content2'),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 0,
      // 简略模式
      simple: true,
    );
  }

  /// 水平简略步骤条2
  @Demo(group: 'steps')
  Widget _buildSimpleHSteps2(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Steps1', content: 'Content1'),
        TStepsItemData(title: 'Steps2', content: 'Content2'),
        TStepsItemData(title: 'Steps3', content: 'Content3'),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
      // 简略模式
      simple: true,
    );
  }

  /// 水平简略步骤条3
  @Demo(group: 'steps')
  Widget _buildSimpleHSteps3(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Steps1', content: 'Content1'),
        TStepsItemData(title: 'Steps2', content: 'Content2'),
        TStepsItemData(title: 'Steps3', content: 'Content3'),
        TStepsItemData(title: 'Steps4', content: 'Content4'),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
      // 简略模式
      simple: true,
    );
  }

  /// 水平错误状态基本步骤条
  @Demo(group: 'steps')
  Widget _buildHErrorSteps1(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Steps1', content: 'Content1'),
        TStepsItemData(title: 'Error', content: 'Content2'),
        TStepsItemData(title: 'Steps3', content: 'Content3'),
        TStepsItemData(title: 'Steps4', content: 'Content4'),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
      // 错误状态
      status: TStepsStatus.error,
    );
  }

  /// 水平错误状态图标步骤条
  @Demo(group: 'steps')
  Widget _buildHErrorSteps2(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Error',
          content: 'Content2',
          successIcon: TIcons.cart,
          errorIcon: TIcons.close_circle,
        ),
        TStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps4',
          content: 'Content4',
          successIcon: TIcons.cart,
        ),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
      // 错误状态
      status: TStepsStatus.error,
    );
  }

  /// 水平错误状态简略步骤条
  @Demo(group: 'steps')
  Widget _buildHErrorSteps3(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Steps1',
          content: 'Content1',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Error',
          content: 'Content2',
          successIcon: TIcons.cart,
          errorIcon: TIcons.close_circle,
        ),
        TStepsItemData(
          title: 'Steps3',
          content: 'Content3',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Steps4',
          content: 'Content4',
          successIcon: TIcons.cart,
        ),
      ],
      // 水平方向
      direction: TStepsDirection.horizontal,
      activeIndex: 1,
      // 错误状态
      status: TStepsStatus.error,
      // 简略模式
      simple: true,
    );
  }

  /// 垂直默认步骤条
  @Demo(group: 'steps')
  Widget _buildVBasicSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Customize content'),
        TStepsItemData(title: 'Process', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
    );
  }

  /// 垂直图标步骤条
  @Demo(group: 'steps')
  Widget _buildVIconSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
    );
  }

  /// 垂直简略步骤条
  @Demo(group: 'steps')
  Widget _buildVSimpleSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
            title: 'Default',
            content: 'Customize content',
            successIcon: TIcons.cart),
        TStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
      // 简略模式
      simple: true,
    );
  }

  /// 垂直错误状态基本步骤条
  @Demo(group: 'steps')
  Widget _buildVErrorBasicSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Customize content'),
        TStepsItemData(title: 'Process', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
      // 错误状态
      status: TStepsStatus.error,
    );
  }

  /// 垂直错误状态图标步骤条
  @Demo(group: 'steps')
  Widget _buildVErrorIconSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TIcons.cart,
          errorIcon: TIcons.close_circle,
        ),
        TStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
      // 错误状态
      status: TStepsStatus.error,
    );
  }

  /// 垂直错误状态简略步骤条
  @Demo(group: 'steps')
  Widget _buildVErrorSimpleSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(
          title: 'Finish',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Process',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
        TStepsItemData(
          title: 'Default',
          content: 'Customize content',
          successIcon: TIcons.cart,
        ),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
      // 简略模式
      simple: true,
      // 错误状态
      status: TStepsStatus.error,
    );
  }

  /// 垂直自定义标题基本步骤条
  @Demo(group: 'steps')
  Widget _buildVCustomTitleBaseSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Customize content'),
        TStepsItemData(
          title: 'Process',
          content: 'Customize content',
          customTitle: const TText(
            '这是一个很长很长的自定义标题，可以自动换行的一个标题内容',
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
        TStepsItemData(title: 'Default', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
    );
  }

  /// 垂直自定义内容基本步骤条
  @Demo(group: 'steps')
  Widget _buildVCustomContentBaseSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Customize content'),
        TStepsItemData(
          title: '这是一个很长很长很长很长的文字，他是用来展示这个步骤的标题',
          content: 'Customize content',
          customContent: Container(
            margin: const EdgeInsets.only(bottom: 16, top: 4),
            child: const TImage(
              assetUrl: 'assets/img/image.png',
              type: TImageType.roundedSquare,
            ),
          ),
        ),
        TStepsItemData(title: 'Default', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 1,
    );
  }

  /// Read-only Steps 纯展示水平步骤条
  @Demo(group: 'steps')
  Widget _buildHReadOnlySteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Finish', content: 'content'),
        TStepsItemData(title: 'Process', content: 'content'),
        TStepsItemData(title: 'Default', content: 'content'),
        TStepsItemData(title: 'Default', content: 'content'),
      ],
      // 只读模式
      readOnly: true,
    );
  }

  /// Read-only Steps 纯展示垂直步骤条
  @Demo(group: 'steps')
  Widget _buildVReadOnlySteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Finish', content: 'Customize content'),
        TStepsItemData(title: 'Process', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
        TStepsItemData(title: 'Default', content: 'Customize content'),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      activeIndex: 0,
      // 只读模式
      readOnly: true,
    );
  }

  /// Vertical Customize Steps 垂直自定义步骤条
  @Demo(group: 'steps')
  Widget _buildVCustomizeSteps(BuildContext context) {
    return TSteps(
      steps: [
        TStepsItemData(title: 'Selected'),
        TStepsItemData(title: 'Selected'),
        TStepsItemData(title: 'Selected'),
        TStepsItemData(title: 'Please Selected'),
      ],
      // 垂直方向
      direction: TStepsDirection.vertical,
      // 简略模式
      simple: true,
      activeIndex: 3,
      // 步骤条垂直自定义步骤条选择模式
      verticalSelect: true,
    );
  }
}
