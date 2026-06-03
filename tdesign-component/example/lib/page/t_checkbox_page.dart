import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

/// TCheckbox演示
class TCheckboxPage extends StatefulWidget {
  const TCheckboxPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TCheckboxPageState();
  }
}

class TCheckboxPageState extends State<TCheckboxPage> {
  List<String>? checkIds = [
    'index:1',
    'index:2',
    'index:3',
  ];

  TCheckboxGroupController? controller;

  @override
  void initState() {
    super.initState();
    controller = TCheckboxGroupController();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于预设的一组选项中执行多项选择，并呈现选择结果。',
      exampleCodeGroup: 'checkbox',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纵向多选框', builder: _verticalCheckbox),
          ExampleItem(desc: '横向多选框', builder: _horizontalCheckbox),
          ExampleItem(desc: '横向多选框-换行', builder: _horizontalCheckboxWrap),
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
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _verticalCheckbox(BuildContext context) {
    return TCheckboxGroupContainer(
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
          return TCheckbox(
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
    return TCheckboxGroupContainer(
      selectIds: const ['1'],
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        TCheckbox(
          id: '0',
          title: '多选标题',
          style: TCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TCheckbox(
          id: '1',
          title: '多选标题',
          style: TCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TCheckbox(
          id: '2',
          title: '上限四字',
          style: TCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _horizontalCheckboxWrap(BuildContext context) {
    return TCheckboxGroupContainer(
      selectIds: const ['0', '1'],
      direction: Axis.horizontal,
      rowCount: 2,
      directionalTdCheckboxes: const [
        TCheckbox(
          id: '0',
          title: '多选标题0',
          style: TCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TCheckbox(
          id: '1',
          title: '多选标题1',
          style: TCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TCheckbox(
          id: '2',
          title: '多选标题2',
          style: TCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
        TCheckbox(
          id: '3',
          title: '多选标题3',
          style: TCheckboxStyle.circle,
          insetSpacing: 12,
          showDivider: false,
        ),
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _checkAllSelected(BuildContext context) {
    const itemCount = 4;
    return TCheckboxGroupContainer(
      selectIds: checkIds,
      passThrough: false,
      controller: controller,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '多选';
          if (index == 0) {
            title = '全选';
            return SizedBox(
              height: 56,
              child: TCheckbox(
                id: 'index:$index',
                title: title,
                customIconBuilder: (context, checked) {
                  var length = controller!.allChecked().length -
                      (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null && !allCheck && length > 0;
                  return getAllIcon(allCheck, halfSelected);
                },
                onCheckBoxChanged: (checked) {
                  if (checked) {
                    controller?.toggleAll(true);
                  } else {
                    controller?.toggleAll(false);
                  }
                },
              ),
            );
          } else {
            return SizedBox(
              height: index == itemCount - 1 ? null : 56,
              child: TCheckbox(
                id: 'index:$index',
                title: title,
                subTitle: index == itemCount - 1
                    ? '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息'
                    : null,
                subTitleMaxLine: 2,
                onCheckBoxChanged: (checked) {
                  var length = controller!.allChecked().length -
                      (controller!.checked('index:0') ? 1 : 0);
                  var allCheck = itemCount - 1 == length;
                  var halfSelected =
                      controller != null && !allCheck && length > 0;
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
    return TCheckboxGroupContainer(
      contentDirection: TContentDirection.right,
      selectIds: const ['0'],
      child: const Column(
        children: [
          TCheckbox(
            id: '0',
            title: '选项禁用-已选',
            style: TCheckboxStyle.circle,
            enable: false,
          ),
          TCheckbox(
            id: '1',
            title: '选项禁用-默认',
            style: TCheckboxStyle.circle,
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
        TCheckboxGroupContainer(
          style: TCheckboxStyle.check,
          selectIds: const ['index:0'],
          child: const TCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        TCheckboxGroupContainer(
          style: TCheckboxStyle.square,
          selectIds: const ['index:0'],
          child: const TCheckbox(
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
        TCheckboxGroupContainer(
          contentDirection: TContentDirection.right,
          selectIds: const ['index:0'],
          child: const TCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        ),
        TCheckboxGroupContainer(
          contentDirection: TContentDirection.left,
          selectIds: const ['index:0'],
          child: const TCheckbox(
            id: 'index:0',
            title: '多选',
          ),
        )
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _passThroughStyle(BuildContext context) {
    return TCheckboxGroupContainer(
      selectIds: const ['index:0'],
      passThrough: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var title = '多选';
          return TCheckbox(
            id: 'index:$index',
            title: title,
            size: TCheckBoxSize.large,
          );
        },
        itemCount: 4,
      ),
    );
  }

  @Demo(group: 'checkbox')
  Widget _verticalCardStyle(BuildContext context) {
    return TCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalTdCheckboxes: const [
        TCheckbox(
          id: 'index:0',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TCheckbox(
          id: 'index:1',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TCheckbox(
          id: 'index:2',
          title: '多选',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          subTitle: '描述信息',
          cardMode: true,
        ),
        TCheckbox(
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
    return TCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.horizontal,
      directionalTdCheckboxes: const [
        TCheckbox(
          id: 'index:0',
          title: '多选',
          cardMode: true,
        ),
        TCheckbox(
          id: 'index:1',
          title: '多选',
          cardMode: true,
        ),
        TCheckbox(
          id: 'index:2',
          title: '多选',
          cardMode: true,
        ),
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _customIconBuildStyle(BuildContext context) {
    return TCheckboxGroupContainer(
      selectIds: const ['index:1'],
      cardMode: true,
      direction: Axis.vertical,
      directionalTdCheckboxes: [
        TCheckbox(
          id: 'index:0',
          title: '多选',
          subTitle: '描述信息',
          titleMaxLine: 2,
          subTitleMaxLine: 2,
          cardMode: true,
          customIconBuilder: (context, checked) {
            return const Icon(
              TIcons.app,
              size: 12,
            );
          },
        ),
      ],
    );
  }

  @Demo(group: 'checkbox')
  Widget _customColor(BuildContext context) {
    return TCheckboxGroupContainer(
      contentDirection: TContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children: [
          TCheckbox(
            selectColor: TTheme.of(context).errorColor3,
            disableColor: TTheme.of(context).errorColor1,
            id: '0',
            title: '选项禁用-已选',
            style: TCheckboxStyle.circle,
            enable: false,
          ),
          TCheckbox(
            selectColor: TTheme.of(context).errorColor3,
            disableColor: TTheme.of(context).errorColor1,
            id: '1',
            title: '选项禁用-默认',
            style: TCheckboxStyle.circle,
          ),
          TCheckbox(
            selectColor: TTheme.of(context).errorColor3,
            disableColor: TTheme.of(context).errorColor1,
            id: 'index:0',
            title: '多选',
            subTitle: '描述信息',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
          ),
          TCheckbox(
            selectColor: TTheme.of(context).errorColor3,
            id: 'index:1',
            title: '多选',
            titleColor: Colors.green,
            subTitle: '描述信息',
            subTitleColor: Colors.blue,
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
    return TCheckboxGroupContainer(
      contentDirection: TContentDirection.right,
      selectIds: const ['0'],
      child: Column(
        children: [
          TCheckbox(
            id: '0',
            title: '选项禁用-已选',
            subTitle: '描述文本',
            style: TCheckboxStyle.circle,
            enable: false,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
          TCheckbox(
            id: '1',
            title: '选项禁用-默认',
            subTitle: '描述文本',
            style: TCheckboxStyle.circle,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
          TCheckbox(
            id: 'index:0',
            title: '多选',
            subTitle: '描述信息',
            titleMaxLine: 2,
            subTitleMaxLine: 2,
            cardMode: true,
            titleFont: TTheme.of(context).fontBodySmall,
            subTitleFont: TTheme.of(context).fontBodyExtraSmall,
          ),
        ],
      ),
    );
  }

  Widget getAllIcon(bool checked, bool halfSelected) {
    return Icon(
        checked
            ? TIcons.check_circle_filled
            : halfSelected
                ? TIcons.minus_circle_filled
                : TIcons.circle,
        size: 24,
        color: (checked || halfSelected)
            ? TTheme.of(context).brandNormalColor
            : TTheme.of(context).grayColor4);
  }
}
