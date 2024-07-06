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
      desc: 'Steps步骤条',
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
          ExampleItem(
              desc: 'Vertical Customize Steps 垂直自定义步骤条',
              builder: _buildVCustomizeSteps),
        ]),
      ],
    );
  }

  List<TDStepsItemData> basicHStepsListData1 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1'),
    TDStepsItemData(title: 'Steps2', content: 'Content2'),
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
            ),
          )
        ],
      ),
    );
  }
  List<TDStepsItemData> basicHStepsListData2 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1'),
    TDStepsItemData(title: 'Steps2', content: 'Content2'),
    TDStepsItemData(title: 'Steps3', content: 'Content3'),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }
  List<TDStepsItemData> basicHStepsListData3 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1'),
    TDStepsItemData(title: 'Steps2', content: 'Content2'),
    TDStepsItemData(title: 'Steps3', content: 'Content3'),
    TDStepsItemData(title: 'Steps4', content: 'Content4'),
  ];
  List<TDStepsItemData> basicStepsListData4 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps2', content: 'Content2'),
    TDStepsItemData(title: 'Steps3', content: 'Content3', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps4', content: 'Content4', successIcon: TDIcons.call),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> hIconStepsListData1 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps2', content: 'Content2', successIcon: TDIcons.call),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 0,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> hIconStepsListData2 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps2', content: 'Content2', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps3', content: 'Content3', successIcon: TDIcons.call),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> hIconStepsListData3 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps2', content: 'Content2', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps3', content: 'Content3', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps4', content: 'Content4', successIcon: TDIcons.call),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> simpleHStepsListData1 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1'),
    TDStepsItemData(title: 'Steps2', content: 'Content2'),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 0,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> simpleHStepsListData2 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1'),
    TDStepsItemData(title: 'Steps2', content: 'Content2'),
    TDStepsItemData(title: 'Steps3', content: 'Content3'),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> simpleHStepsListData3 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1'),
    TDStepsItemData(title: 'Steps2', content: 'Content2'),
    TDStepsItemData(title: 'Steps3', content: 'Content3'),
    TDStepsItemData(title: 'Steps4', content: 'Content4'),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> hErrorStepsListData1 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1'),
    TDStepsItemData(title: 'Error', content: 'Content2'),
    TDStepsItemData(title: 'Steps3', content: 'Content3'),
    TDStepsItemData(title: 'Steps4', content: 'Content4'),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> hErrorStepsListData2 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Error', content: 'Content2', successIcon: TDIcons.call, errorIcon: TDIcons.close_circle),
    TDStepsItemData(title: 'Steps3', content: 'Content3', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps4', content: 'Content4', successIcon: TDIcons.call),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> hErrorStepsListData3 = [
    TDStepsItemData(title: 'Steps1', content: 'Content1', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Error', content: 'Content2', successIcon: TDIcons.call, errorIcon: TDIcons.close_circle),
    TDStepsItemData(title: 'Steps3', content: 'Content3', successIcon: TDIcons.call),
    TDStepsItemData(title: 'Steps4', content: 'Content4', successIcon: TDIcons.call),
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
              direction: TDStepsDirection.horizontal,
              activeIndex: 1,
              status: TDStepsStatus.error,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vBasicStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content'),
    TDStepsItemData(title: 'Process', content: 'Customize content'),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vIconStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vSimpleStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              simple: true,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vErrorBasicStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content'),
    TDStepsItemData(title: 'Process', content: 'Customize content'),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vErrorIconStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart, errorIcon: TDIcons.close_circle),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vErrorSimpleStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Process', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
    TDStepsItemData(title: 'Default', content: 'Customize content', successIcon: TDIcons.cart),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
              simple: true,
              status: TDStepsStatus.error,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vCustomContentBasicStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content'),
    TDStepsItemData(title: 'Process', content: 'Customize content', customContent: Container(
      margin: const EdgeInsets.only(bottom: 16, top: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: const TDImage(
          assetUrl: 'assets/img/image.png',
          type: TDImageType.square,
        ),
      ),
    )),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 1,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> hReadOnlyStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'content'),
    TDStepsItemData(title: 'Process', content: 'content'),
    TDStepsItemData(title: 'Default', content: 'content'),
    TDStepsItemData(title: 'Default', content: 'content'),
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
              readOnly: true,
            ),
          )
        ],
      ),
    );
  }


  List<TDStepsItemData> vReadOnlyStepsListData = [
    TDStepsItemData(title: 'Filish', content: 'Customize content'),
    TDStepsItemData(title: 'Process', content: 'Customize content'),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
    TDStepsItemData(title: 'Default', content: 'Customize content'),
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
              direction: TDStepsDirection.vertical,
              activeIndex: 0,
              readOnly: true,
            ),
          )
        ],
      ),
    );
  }

  List<TDStepsItemData> vCustomizeStepsListData = [
    TDStepsItemData(title: 'Selected', content: ''),
    TDStepsItemData(title: 'Selected', content: ''),
    TDStepsItemData(title: 'Selected', content: ''),
    TDStepsItemData(title: 'Please Selected', content: ''),
  ];
  /// Vertical Customize Steps 垂直自定义步骤条
  @Demo(group: 'steps')
  Widget _buildVCustomizeSteps(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TDSteps(
              steps: vCustomizeStepsListData,
              direction: TDStepsDirection.vertical,
              simple: true,
              activeIndex: 3,
              verticalSelect: true,
            ),
          )
        ],
      ),
    );
  }

}
