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
        ExampleModule(title: '水平错误状态步骤条', children: [
          ExampleItem(
              desc: '水平错误状态基本步骤条',
              builder: _buildHErrorSteps1),
          ExampleItem(
              desc: '水平错误状态图标步骤条',
              builder: _buildHErrorSteps2),
          ExampleItem(
              desc: '水平错误状态简略步骤条',
              builder: _buildHErrorSteps3),
        ]),

        ExampleModule(title: '垂直步骤条', children: [
          ExampleItem(
              desc: '垂直默认步骤条',
              builder: _buildVBasicSteps),
          ExampleItem(
              desc: '垂直图标步骤条',
              builder: _buildVIconSteps),
          ExampleItem(
              desc: '垂直简略步骤条',
              builder: _buildVSimpleSteps),
          ExampleItem(
              desc: '垂直错误状态基本步骤条',
              builder: _buildVErrorBasicSteps),
          ExampleItem(
              desc: '垂直错误状态图标步骤条',
              builder: _buildVErrorIconSteps),
          ExampleItem(
              desc: '垂直错误状态简略步骤条',
              builder: _buildVErrorSimpleSteps),
          ExampleItem(
              desc: '垂直自定义内容基本步骤条',
              builder: _buildVCustomContentBaseSteps),
        ]),
        ExampleModule(title: 'Extension步骤条', children: [
          ExampleItem(
              desc: 'Read-only Steps 纯展示水平步骤条',
              builder: _buildHReadOnlySteps),
          ExampleItem(
              desc: 'Read-only Steps 纯展示垂直步骤条',
              builder: _buildVReadOnlySteps),
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

  List<StepsItemData> hErrorStepsListData1 = [
    StepsItemData(title: 'steps1', content: 'content1'),
    StepsItemData(title: 'Error', content: 'content2'),
    StepsItemData(title: 'steps3', content: 'content3'),
    StepsItemData(title: 'steps3', content: 'content3'),
  ];
  /// 水平简略步骤条3
  @Demo(group: 'steps')
  Widget _buildHErrorSteps1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hErrorStepsListData1,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
              status: StepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> hErrorStepsListData2 = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'Error', content: 'content2', successIcon: TDIcons.call, errorIcon: TDIcons.close_circle),
    StepsItemData(title: 'steps3', content: 'content3', successIcon: TDIcons.call),
    StepsItemData(title: 'steps3', content: 'content3', successIcon: TDIcons.call),
  ];
  /// 水平简略步骤条3
  @Demo(group: 'steps')
  Widget _buildHErrorSteps2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hErrorStepsListData2,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
              status: StepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> hErrorStepsListData3 = [
    StepsItemData(title: 'steps1', content: 'content1', successIcon: TDIcons.call),
    StepsItemData(title: 'Error', content: 'content2', successIcon: TDIcons.call, errorIcon: TDIcons.close_circle),
    StepsItemData(title: 'steps3', content: 'content3', successIcon: TDIcons.call),
    StepsItemData(title: 'steps3', content: 'content3', successIcon: TDIcons.call),
  ];
  /// 水平简略步骤条3
  @Demo(group: 'steps')
  Widget _buildHErrorSteps3(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hErrorStepsListData3,
              direction: StatusDirection.horizontal,
              activeIndex: 1,
              status: StepsStatus.error,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> vBasicStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content'),
    StepsItemData(title: 'Process', content: 'Customize content'),
    StepsItemData(title: 'Default', content: 'Customize content'),
    StepsItemData(title: 'Default', content: 'Customize content'),
  ];
  /// 垂直默认步骤条
  @Demo(group: 'steps')
  Widget _buildVBasicSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vBasicStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> vIconStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
  ];
  /// 垂直图标步骤条
  @Demo(group: 'steps')
  Widget _buildVIconSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vIconStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> vSimpleStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
  ];
  /// 垂直简略步骤条
  @Demo(group: 'steps')
  Widget _buildVSimpleSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vSimpleStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> vErrorBasicStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content'),
    StepsItemData(title: 'Process', content: 'Customize content'),
    StepsItemData(title: 'Default', content: 'Customize content'),
    StepsItemData(title: 'Default', content: 'Customize content'),
  ];
  /// 垂直错误状态基本步骤条
  @Demo(group: 'steps')
  Widget _buildVErrorBasicSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vErrorBasicStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 1,
              status: StepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> vErrorIconStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart, errorIcon: TDIcons.close_circle),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
  ];
  /// 垂直错误状态图标步骤条
  @Demo(group: 'steps')
  Widget _buildVErrorIconSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vErrorIconStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 1,
              status: StepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> vErrorSimpleStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    StepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
  ];
  /// 垂直错误状态图标步骤条
  @Demo(group: 'steps')
  Widget _buildVErrorSimpleSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vErrorSimpleStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 1,
              simple: true,
              status: StepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> vCustomContentBasicStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content'),
    StepsItemData(title: 'Process', content: 'Customize content', customContent: const TDImage(
      assetUrl: 'assets/img/image.png',
      type: TDImageType.square,
    )),
    StepsItemData(title: 'Default', content: 'Customize content'),
    StepsItemData(title: 'Default', content: 'Customize content'),
  ];
  /// 垂直自定义内容基本步骤条
  @Demo(group: 'steps')
  Widget _buildVCustomContentBaseSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vCustomContentBasicStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<StepsItemData> hReadOnlyStepsListData = [
    StepsItemData(title: 'Filish', content: 'content'),
    StepsItemData(title: 'Process', content: 'content'),
    StepsItemData(title: 'Default', content: 'content'),
    StepsItemData(title: 'Default', content: 'content'),
  ];
  /// 水平自定义内容基本步骤条
  @Demo(group: 'steps')
  Widget _buildHReadOnlySteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: hReadOnlyStepsListData,
              direction: StatusDirection.horizontal,
              activeIndex: 0,
              readOnly: true,
            ),
          )
        ],
      ),
    );
  }


  List<StepsItemData> vReadOnlyStepsListData = [
    StepsItemData(title: 'Filish', content: 'Customize content'),
    StepsItemData(title: 'Process', content: 'Customize content'),
    StepsItemData(title: 'Default', content: 'Customize content'),
    StepsItemData(title: 'Default', content: 'Customize content'),
  ];
  /// 垂直自定义内容基本步骤条
  @Demo(group: 'steps')
  Widget _buildVReadOnlySteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vReadOnlyStepsListData,
              direction: StatusDirection.vertical,
              activeIndex: 0,
              readOnly: true,
            ),
          )
        ],
      ),
    );
  }

}
