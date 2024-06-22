import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDStepsPage extends StatefulWidget {
  const TDStepsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDStepsPageState();
}

class _TDStepsPageState extends State<TDStepsPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: TDTheme.of(context).whiteColor1,
      title: tdTitle(),
      exampleCodeGroup: 'steps',
      desc: 'steps步骤条',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
              desc: '基本步骤',
              builder: _buildBasicSteps),
        ]),
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
              desc: '简略步骤',
              builder: _buildSimpleSteps),
        ]),
      ],
    );
  }

  List<StepsItemData> basicStepsListData = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3', successIcon: TDIcons.call),
    StepsItemData(title: 'steps4', content: 'content4', successIcon: TDIcons.call),
  ];
  /// 基本步骤1
  @Demo(group: 'steps')
  Widget _buildBasicSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: basicStepsListData,
              direction: StatusDirection.horizontal,
              activeIndex: 2,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> simpleStepsListData = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3', successIcon: TDIcons.call),
    StepsItemData(title: 'steps4', content: 'content4'),
  ];
  /// 基本步骤2
  @Demo(group: 'steps')
  Widget _buildSimpleSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: simpleStepsListData,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }
}
