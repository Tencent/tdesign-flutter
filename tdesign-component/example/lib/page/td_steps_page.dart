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
        ExampleModule(title: '水平默认步骤条', children: [
          ExampleItem(
              desc: '水平默认步骤条1',
              builder: _buildBasicHSteps1),
          ExampleItem(
              desc: '水平默认步骤条2',
              builder: _buildBasicHSteps2),
          ExampleItem(
              desc: '水平默认步骤条3',
              builder: _buildBasicHSteps3),
        ]),
        ExampleModule(title: '水平图标步骤条', children: [
          ExampleItem(
              desc: '水平图标步骤条1',
              builder: _buildHIconSteps1),
          ExampleItem(
              desc: '水平图标步骤条2',
              builder: _buildHIconSteps2),
          ExampleItem(
              desc: '水平图标步骤条3',
              builder: _buildHIconSteps3),
        ]),
        ExampleModule(title: '水平简略步骤条', children: [
          ExampleItem(
              desc: '水平简略步骤条1',
              builder: _buildSimpleHSteps1),
          ExampleItem(
              desc: '水平简略步骤条2',
              builder: _buildSimpleHSteps2),
          ExampleItem(
              desc: '水平简略步骤条3',
              builder: _buildSimpleHSteps3),
        ]),
      ],
    );
  }

  List<StepsItemData> basicHStepsListData1 = [
    StepsItemData(title: 'steps1', content: 'content1'),
    StepsItemData(title: 'steps2', content: 'content2'),
  ];
  /// 基本步骤1
  @Demo(group: 'steps')
  Widget _buildBasicHSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: basicHStepsListData1,
              direction: StatusDirection.horizontal,
              activeIndex: 0,
            ),
          )
        ],
      ),
    );
  }
  List<StepsItemData> basicHStepsListData2 = [
    StepsItemData(title: 'steps1', content: 'content1'),
    StepsItemData(title: 'steps2', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3'),
  ];
  /// 基本步骤2
  @Demo(group: 'steps')
  Widget _buildBasicHSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: basicHStepsListData2,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }
  List<StepsItemData> basicHStepsListData3 = [
    StepsItemData(title: 'steps1', content: 'content1'),
    StepsItemData(title: 'steps2', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3'),
    StepsItemData(title: 'steps4', content: 'content4'),
  ];
  List<StepsItemData> basicStepsListData4 = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3', successIcon: TDIcons.call),
    StepsItemData(title: 'steps4', content: 'content4', successIcon: TDIcons.call),
  ];
  /// 基本步骤3
  @Demo(group: 'steps')
  Widget _buildBasicHSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: basicHStepsListData3,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> hIconStepsListData1 = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2', successIcon: TDIcons.call),
  ];
  /// 水平图标步骤条1
  @Demo(group: 'steps')
  Widget _buildHIconSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hIconStepsListData1,
              direction: StatusDirection.horizontal,
              activeIndex: 0,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> hIconStepsListData2 = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2', successIcon: TDIcons.call),
  ];
  /// 水平图标步骤条1
  @Demo(group: 'steps')
  Widget _buildHIconSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hIconStepsListData2,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> hIconStepsListData3 = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2', successIcon: TDIcons.call),
    StepsItemData(title: 'steps2', content: 'content2', successIcon: TDIcons.call),
  ];
  /// 水平图标步骤条1
  @Demo(group: 'steps')
  Widget _buildHIconSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hIconStepsListData3,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> simpleHStepsListData1 = [
    StepsItemData(title: 'steps1', content: 'content1'),
    StepsItemData(title: 'steps2', content: 'content2'),
  ];
  /// 水平简略步骤条1
  @Demo(group: 'steps')
  Widget _buildSimpleHSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: simpleHStepsListData1,
              direction: StatusDirection.horizontal,
              activeIndex: 0,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> simpleHStepsListData2 = [
    StepsItemData(title: 'steps1', content: 'content1'),
    StepsItemData(title: 'steps2', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3'),
  ];
  /// 水平简略步骤条2
  @Demo(group: 'steps')
  Widget _buildSimpleHSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: simpleHStepsListData2,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> simpleHStepsListData3 = [
    StepsItemData(title: 'steps1', content: 'content1'),
    StepsItemData(title: 'steps2', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3'),
    StepsItemData(title: 'steps3', content: 'content3'),
  ];
  /// 水平简略步骤条3
  @Demo(group: 'steps')
  Widget _buildSimpleHSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: simpleHStepsListData3,
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
