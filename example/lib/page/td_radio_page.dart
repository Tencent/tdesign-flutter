import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TDRadio演示
///
class TDRadioPage extends StatefulWidget {
  const TDRadioPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDRadioPageState();
  }
}

class TDRadioPageState extends State<TDRadioPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: '单选框 Radio',
        exampleCodeGroup: 'radio',
        backgroundColor: const Color(0xfff6f6f6),
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '纵向单选框', builder: _verticleRadios),
            ExampleItem(desc: '横向单选框', builder: _horizontalRadios),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '单选框状态', builder: _radioStatus),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '勾选样式', builder: _checkStyle),
            ExampleItem(desc: '勾选显示位置', builder: _checkPosition),
            ExampleItem(desc: '非通栏单选样式', builder: _passThroughStyle),
          ]),
          ExampleModule(title: '特殊样式', children: [
            ExampleItem(desc: '纵向卡片单选框', builder: _verticalCardStyle),
            ExampleItem(desc: '横向卡片单选框', builder: _horizontalCardStyle),
          ]),
        ]);
  }

  @Demo(group: 'radio')
  Widget _verticleRadios(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var title = '单选';
          var subTitle = '';
          if (index == 2) {
            title = '单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行';
          }
          if (index == 3) {
            subTitle = '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息';
          }
          return TDRadio(
            id: 'index:$index',
            title: title,
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: subTitle,
          );
        },
        itemCount: 4,
      ),
    );
  }

  @Demo(group: 'radio')
  Widget _horizontalRadios(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      directionalTdRadios: const [
        TDRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
        TDRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TDRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _radioStatus(BuildContext context) {
    return TDRadioGroup(
      contentDirection: TDContentDirection.right,
      selectId: '0',
      child: Column(
        children: const [
          TDRadio(
            id: '0',
            title: '选项禁用-已选',
            radioStyle: TDRadioStyle.circle,
            enable: false,
          ),
          TDRadio(
            id: '1',
            title: '选项禁用-默认',
            radioStyle: TDRadioStyle.circle,
            enable: false,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'radio')
  Widget _checkStyle(BuildContext context) {
    return Column(
      children: [
        TDRadioGroup(
          radioCheckStyle: TDRadioStyle.check,
          selectId: 'index:0',
          child: const TDRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        TDRadioGroup(
          radioCheckStyle: TDRadioStyle.hollowCircle,
          selectId: 'index:0',
          child: const TDRadio(
            id: 'index:0',
            title: '单选',
          ),
        )
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _checkPosition(BuildContext context) {
    return Column(
      children: [
        TDRadioGroup(
          contentDirection: TDContentDirection.right,
          selectId: 'index:0',
          child: const TDRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        TDRadioGroup(
          contentDirection: TDContentDirection.left,
          selectId: 'index:0',
          child: const TDRadio(
            id: 'index:0',
            title: '单选',
          ),
        )
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _passThroughStyle(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:0',
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (contet, index) {
          var title = '单选';
          return SizedBox(
            height: 56,
            child: TDRadio(
              id: 'index:$index',
              title: title,
            ),
          );
        },
        itemCount: 4,
      ),
    );
  }

  @Demo(group: 'radio')
  Widget _verticalCardStyle(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.vertical,
      directionalTdRadios: const [
        TDRadio(
          id: 'index:0',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:1',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:2',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:3',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _horizontalCardStyle(BuildContext context) {
    return TDRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.horizontal,
      directionalTdRadios: const [
        TDRadio(
          id: 'index:0',
          title: '单选',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:1',
          title: '单选',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:2',
          title: '单选',
          cardMode: true,
        ),
        TDRadio(
          id: 'index:3',
          title: '单选',
          cardMode: true,
        ),
      ],
    );
  }
}
