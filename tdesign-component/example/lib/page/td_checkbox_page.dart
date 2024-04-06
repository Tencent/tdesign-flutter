import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

///
/// TDCheckbox演示
///
class TDCheckboxPage extends StatefulWidget {
  const TDCheckboxPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDCheckboxPageState();
  }
}

class TDCheckboxPageState extends State<TDCheckboxPage> {

  List<String>? checkIds = ['index:1','index:2','index:3',];

  TDCheckboxGroupController? controller;

  @override
  void initState() {
    super.initState();
    controller = TDCheckboxGroupController();
  }

  @override
  Widget build(BuildContext context) {

    return ExamplePage(
        title: tdTitle(),
        desc: '用于预设的一组选项中执行多项选择，并呈现选择结果。',
        exampleCodeGroup: 'checkbox',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '纵向多选框', builder: _verticalCheckbox),
            ExampleItem(desc: '横向多选框', builder: _horizontalCheckbox),
            ExampleItem(desc: '带全选多选框', builder: _checkAllSelected)
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '多选框状态', builder: _checkboxStatus),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '勾选样式', builder: _checkStyle),
            ExampleItem(desc: '勾选显示位置', builder: _checkPosition),
            ExampleItem(desc: '非通栏多选样式', builder: _passThroughStyle),
          ]),
          ExampleModule(title: '特殊样式', children: [
            ExampleItem(desc: '纵向卡片单选框', builder: _verticalCardStyle),
            ExampleItem(desc: '横向卡片单选框', builder: _horizontalCardStyle),
          ]),
        ],
    test: [
      ExampleItem(desc: '自定义Icon', builder: _customIconBuildStyle),
      ExampleItem(desc: '自定义颜色', builder: _customColor),
      ExampleItem(desc: '自定义字体尺寸', builder: _customFont),
    ],);
  }

  @Demo(group: 'checkbox')
  Widget _verticalCheckbox(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['index:1'],
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var title = '多选';
          var subTitle = '';
          if (index == 2) {
            title = '多选标题多行多选标题多行多选标题多行多选标题多行多选标题多行多选标题多行';
          }
          if (index == 3) {
            subTitle = '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息';
          }
          return TDCheckbox(
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

  @Demo(group: 'checkbox')
  Widget _horizontalCheckbox(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['1'],
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        TDCheckbox(
          id: '0',
          title: '多选标题',
          style: TDCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TDCheckbox(
          id: '1',
          title: '多选标题',
          style: TDCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TDCheckbox(
          id: '2',
          title: '上限四字',
          style: TDCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _checkAllSelected(BuildContext context) {
    const itemCount = 4;
    return TDCheckboxGroupContainer(
      selectIds: checkIds,
      passThrough: false,
      controller: controller,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (contet, index) {
          var title = '多选';
          if(index == 0){
            title = '全选';
            return SizedBox(
              height: 56,
              child: TDCheckbox(
                id: 'index:$index',
                title: title,
                customIconBuilder: (context, checked) {
                  var length = controller!.allChecked().length - (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null
                          && !allCheck
                          && length > 0;
                  return getAllIcon(allCheck, halfSelected);
                },
                onCheckBoxChanged: (checked){
                  if (checked) {
                    controller?.toggleAll(true);
                  } else {
                    controller?.toggleAll(false);
                  }
                },
              ),
            );
          }else{
            return SizedBox(
              height: index == itemCount - 1 ? null : 56,
              child: TDCheckbox(
                id: 'index:$index',
                title: title,
                subTitle: index == itemCount - 1 ? '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息' : null,
                subTitleMaxLine: 2,
                onCheckBoxChanged: (checked){
                  var length = controller!.allChecked().length - (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null
                          && !allCheck
                          && length > 0;
                  controller!.toggle('index:0', allCheck);
                  getAllIcon(allCheck, halfSelected);
                },
              ),
            );
          }
        },
        itemCount: itemCount,
      ),
    );
  }

  @Demo(group: 'checkbox')
  Widget _checkboxStatus(BuildContext context) {
    return TDCheckboxGroupContainer(
      contentDirection: TDContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children: const [
          TDCheckbox(
            id: '0',
            title: '选项禁用-已选',
            style: TDCheckboxStyle.circle,
            enable: false,
          ),
          TDCheckbox(
            id: '1',
            title: '选项禁用-默认',
            style: TDCheckboxStyle.circle,
            enable: false,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'checkbox')
  Widget _checkStyle(BuildContext context) {
    return Column(
      children: [
        TDCheckboxGroupContainer(
          style: TDCheckboxStyle.check,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        TDCheckboxGroupContainer(
          style: TDCheckboxStyle.square,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        )
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _checkPosition(BuildContext context) {
    return Column(
      children: [
        TDCheckboxGroupContainer(
          contentDirection: TDContentDirection.right,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        ),
        TDCheckboxGroupContainer(
          contentDirection: TDContentDirection.left,
          selectIds: const ['index:0'],
          child: const TDCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        )
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _passThroughStyle(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['index:0'],
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (contet, index) {
          var title = '多选';
          return TDCheckbox(
            id: 'index:$index',
            title: title,
            size: TDCheckBoxSize.large,
          );
        },
        itemCount: 4,
      ),
    );
  }

  @Demo(group: 'checkbox')
  Widget _verticalCardStyle(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalTdCheckboxes: const [
        TDCheckbox(
          id: 'index:0',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:1',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:2',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:3',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _horizontalCardStyle(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        TDCheckbox(
          id: 'index:0',
          title: '多选',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:1',
          title: '多选',
          cardMode: true,
        ),
        TDCheckbox(
          id: 'index:2',
          title: '多选',
          cardMode: true,
        ),
      ],
    );
  }



  @Demo(group: 'checkbox')
  Widget _customIconBuildStyle(BuildContext context) {
    return TDCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalTdCheckboxes:  [
        TDCheckbox(
          id: 'index:0',
          title: '多选',
          subTitle: '描述信息',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          cardMode: true,
          customIconBuilder: (context, checked){
            return const Icon(TDIcons.app, size: 12,);
          },
        ),
      ],
    );
  }
  @Demo(group: 'checkbox')
  Widget _customColor(BuildContext context) {
    return TDCheckboxGroupContainer(
      contentDirection: TDContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children:  [
          TDCheckbox(
            selectColor: TDTheme.of(context).errorColor3,
            disableColor: TDTheme.of(context).errorColor1,
            id: '0',
            title: '选项禁用-已选',
            style: TDCheckboxStyle.circle,
            enable: false,
          ),
          TDCheckbox(
            selectColor: TDTheme.of(context).errorColor3,
            disableColor: TDTheme.of(context).errorColor1,
            id: '1',
            title: '选项禁用-默认',
            style: TDCheckboxStyle.circle,
          ),

          TDCheckbox(
            selectColor: TDTheme.of(context).errorColor3,
            disableColor: TDTheme.of(context).errorColor1,
            id: 'index:0',
            title: '多选',
            subTitle: '描述信息',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'checkbox')
  Widget _customFont(BuildContext context) {
    return TDCheckboxGroupContainer(
      contentDirection: TDContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children:  [
          TDCheckbox(
            id: '0',
            title: '选项禁用-已选',
            subTitle: '描述文本',
            style: TDCheckboxStyle.circle,
            enable: false,
            titleFont: TDTheme.of(context).fontBodySmall,
            subTitleFont: TDTheme.of(context).fontBodyExtraSmall,
          ),
          TDCheckbox(
            id: '1',
            title: '选项禁用-默认',
            subTitle: '描述文本',
            style: TDCheckboxStyle.circle,
            titleFont: TDTheme.of(context).fontBodySmall,
            subTitleFont: TDTheme.of(context).fontBodyExtraSmall,
          ),

          TDCheckbox(
            id: 'index:0',
            title: '多选',
            subTitle: '描述信息',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
            titleFont: TDTheme.of(context).fontBodySmall,
            subTitleFont: TDTheme.of(context).fontBodyExtraSmall,
          ),
        ],
      ),
    );
  }

  Widget getAllIcon(bool checked, bool halfSelected) {
    return Icon(
        checked ? TDIcons.check_circle_filled : halfSelected ? TDIcons.minus_circle_filled : TDIcons.circle,
        size: 24,
        color: (checked || halfSelected) ? TDTheme.of(context).brandNormalColor : TDTheme.of(context).grayColor4
    );
  }
}
