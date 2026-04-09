import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TRadio演示
///
class TRadioPage extends StatefulWidget {
  const TRadioPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TRadioPageState();
  }
}

class TRadioPageState extends State<TRadioPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'radio',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纵向单选框', builder: _verticalRadios),
          ExampleItem(desc: '横向单选框', builder: _horizontalRadios),
          ExampleItem(desc: '横向单选框-换行', builder: _horizontalRadiosWrap),
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
      ],
      test: [
        ExampleItem(desc: '横向单选框-显示下划线', builder: _showBottomLine),
        ExampleItem(desc: '横向单选框-自定义下划线', builder: _customBottomLine),
        ExampleItem(desc: '横向单选框-自定义颜色和字体尺寸', builder: _customColorAndFont),
        ExampleItem(
            desc: '横向单选框-自定义禁用字体颜色', builder: _customDisableColorAndFont),
        ExampleItem(desc: '横向单选框-自定义选框左侧间距', builder: _customRadioLeftSpace),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _verticalRadios(BuildContext context) {
    return TCell(
      title: '单选标题',
      hover: false,
      required: true,
      descriptionWidget: TRadioGroup(
        selectId: '0',
        direction: Axis.horizontal,
        directionalTdRadios: const [
          TRadio(
            id: '0',
            title: '单选标题0',
            showDivider: false,
          ),
          TRadio(
            id: '1',
            title: '单选标题1',
            showDivider: false,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'radio')
  Widget _horizontalRadios(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      directionalTdRadios: const [
        TRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _horizontalRadiosWrap(BuildContext context) {
    return TRadioGroup(
      selectId: '0',
      direction: Axis.horizontal,
      rowCount: 4,
      directionalTdRadios: const [
        TRadio(id: '0', title: '单0'),
        TRadio(id: '1', title: '单1'),
        TRadio(id: '3', title: '单2'),
        TRadio(id: '4', title: '单3'),
        TRadio(id: '5', title: '单4'),
        TRadio(id: '6', title: '单5'),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _radioStatus(BuildContext context) {
    return TRadioGroup(
      contentDirection: TContentDirection.right,
      selectId: '0',
      child: const Column(
        children: [
          TRadio(
            id: '0',
            title: '选项禁用-已选',
            radioStyle: TRadioStyle.circle,
            enable: false,
          ),
          TRadio(
            id: '1',
            title: '选项禁用-默认',
            radioStyle: TRadioStyle.circle,
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
        TRadioGroup(
          radioCheckStyle: TRadioStyle.check,
          selectId: 'index:0',
          child: const TRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        TRadioGroup(
          radioCheckStyle: TRadioStyle.hollowCircle,
          selectId: 'index:0',
          child: const TRadio(
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
        TRadioGroup(
          contentDirection: TContentDirection.right,
          selectId: 'index:0',
          child: const TRadio(
            id: 'index:0',
            title: '单选',
          ),
        ),
        TRadioGroup(
          contentDirection: TContentDirection.left,
          selectId: 'index:0',
          child: const TRadio(
            id: 'index:0',
            title: '单选',
            showDivider: false,
          ),
        )
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _passThroughStyle(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:0',
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '单选';
          return TRadio(
            id: 'index:$index',
            title: title,
            size: TCheckBoxSize.large,
          );
        },
        itemCount: 4,
      ),
    );
  }

  @Demo(group: 'radio')
  Widget _verticalCardStyle(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.vertical,
      directionalTdRadios: const [
        TRadio(
          id: 'index:0',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TRadio(
          id: 'index:1',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TRadio(
          id: 'index:2',
          title: '单选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TRadio(
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
    return TRadioGroup(
      selectId: 'index:1',
      cardMode: true,
      direction: Axis.horizontal,
      rowCount: 2,
      directionalTdRadios: const [
        TRadio(
          id: 'index:0',
          title: '单选',
          cardMode: true,
        ),
        TRadio(
          id: 'index:1',
          title: '单选',
          cardMode: true,
        ),
        TRadio(
          id: 'index:2',
          title: '单选',
          cardMode: true,
        ),
        TRadio(
          id: 'index:3',
          title: '单选',
          cardMode: true,
        ),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _showBottomLine(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      showDivider: true,
      directionalTdRadios: const [
        TRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _customBottomLine(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      direction: Axis.horizontal,
      showDivider: true,
      divider: const TDivider(
        height: 20,
        color: Colors.red,
      ),
      directionalTdRadios: const [
        TRadio(
          id: '0',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '1',
          title: '单选标题',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
        TRadio(
          id: '2',
          title: '上限四字',
          radioStyle: TRadioStyle.circle,
          showDivider: false,
        ),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _customColorAndFont(BuildContext context) {
    return TRadioGroup(
      selectId: 'index:1',
      child: ListView(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TRadio(
            id: 'index:1',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            selectColor: TTheme.of(context).errorColor3,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
          TRadio(
            id: 'index:2',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行',
            selectColor: TTheme.of(context).errorColor3,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
          TRadio(
            id: 'index:3',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            selectColor: TTheme.of(context).errorColor3,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
          TRadio(
            id: 'index:4',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行',
            selectColor: TTheme.of(context).errorColor3,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
            radioStyle: TRadioStyle.hollowCircle,
          ),
          TRadio(
            id: 'index:6',
            title: '绿色',
            titleColor: Colors.green,
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '我是蓝色并且有灰色背景',
            subTitleColor: Colors.blue,
            selectColor: TTheme.of(context).errorColor3,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
            backgroundColor: TTheme.of(context).grayColor2,
          ),
          TRadio(
            id: 'index:5',
            title: '单选',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            selectColor: TTheme.of(context).errorColor3,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
            cardMode: true,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'radio')
  Widget _customDisableColorAndFont(BuildContext context) {
    return TRadioGroup(
      contentDirection: TContentDirection.right,
      selectId: '0',
      child: Column(
        children: [
          TRadio(
            id: '0',
            title: '选项禁用-已选',
            subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
            radioStyle: TRadioStyle.circle,
            enable: false,
            disableColor: TTheme.of(context).errorDisabledColor,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
          TRadio(
            id: '1',
            title: '选项禁用-默认',
            radioStyle: TRadioStyle.circle,
            enable: false,
            disableColor: TTheme.of(context).errorDisabledColor,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
        ],
      ),
    );
  }

  @Demo(group: '')
  Widget _customRadioLeftSpace(BuildContext context) {
    return TRadio(
      id: '0',
      title: '选项禁用-已选',
      subTitle: '描述信息',
      radioStyle: TRadioStyle.circle,
      checkBoxLeftSpace: 0,
      disableColor: TTheme.of(context).errorDisabledColor,
      titleFont: TTheme.of(context).fontBodySmall,
      subTitleFont: TTheme.of(context).fontBodyExtraSmall,
    );
  }
}
