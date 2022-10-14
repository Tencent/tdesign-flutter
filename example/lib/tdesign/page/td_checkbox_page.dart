import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_base.dart';

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

  List<String>? checkIds;

  TDCheckboxGroupController? controller;

  @override
  void initState() {
    super.initState();
    controller = TDCheckboxGroupController();
  }

  @override
  Widget build(BuildContext context) {
    const itemCount = 4;
    Widget getAllIcon(bool checked, bool halfSelected) {
      return Icon(
          checked ? TDIcons.check_circle_filled : halfSelected ? TDIcons.minus_circle_filled : TDIcons.circle,
          size: 24,
          color: (checked || halfSelected) ? TDTheme.of(context).brandColor8 : TDTheme.of(context).grayColor4
      );
    }

    return ExampleWidget(
      title: '多选框 Checkbox',
      apiPath: 'checkbox',
      children: [
        ExampleItem(desc: '基础多选框', builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TDCheckbox(
                title: '多选',
                checked: true,
              ),
              TDCheckbox(
                title: '多选',
              ),
              TDCheckbox(
                title: '禁用状态',
                enable: false,
                checked: true,
              ),
              TDCheckbox(
                title: '多选多选多选多选多选多选多选多选多选多选多选多选',
                titleMaxLine: 2,
                subTitleMaxLine: 2,
                enable: false,
              ),
              TDCheckbox(
                title: '多选',
                subTitle: '单选单选单选单选单选单选单选单选单选单选单选单选',
                titleMaxLine: 2,
                subTitleMaxLine: 2,
              ),
            ],
          );
        }),
        ExampleItem(desc: '右侧多选框', builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TDCheckbox(
                contentDirection: TDContentDirection.left,
                title: '多选',
                checked: true,
              ),
              TDCheckbox(
                contentDirection: TDContentDirection.left,
                title: '多选',
                checked: true,
              ),
              TDCheckbox(
                contentDirection: TDContentDirection.left,
                title: '多选多选多选多选多选多选多选多选多选多选多选多选多选',
              ),
              TDCheckbox(
                contentDirection: TDContentDirection.left,
                title: '多选',
                subTitle: '单选单选单选单选单选单选单选单选单选单选单选单选',
              ),
            ],
          );
        }),
        ExampleItem(desc: '自定义图标多框类型', builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TDCheckbox(
                style: TDCheckboxStyle.square,
                title: '多选',
              ),
              TDCheckbox(
                style: TDCheckboxStyle.square,
                title: '多选',
                checked: true,
              ),
              TDCheckbox(
                style: TDCheckboxStyle.square,
                title: '多选',
                checked: true,
              ),
            ],
          );
        }),
        ExampleItem(desc: '规格', builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TDCheckbox(
                title: '多选 H48',
                checked: true,
              ),
              TDCheckbox(
                title: '多选 H56',
                size: TDCheckBoxSize.large,
              ),
            ],
          );
        }),
        ExampleItem(desc: '带全选多选框', builder: (context){
          return TDCheckboxGroup(
              controller: controller,
              onChangeGroup: (checkedId) {
                checkIds = checkedId;
                setState(() {});
              },
              checkedIds: checkIds,
              onOverloadChecked: () {
                TDToast.showText('最大只能勾选3个选项', context: context);
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: (BuildContext context, int index) {
                  if(index == 0) {
                    return TDCheckbox(
                      contentDirection: TDContentDirection.right,
                      title: '全选',
                      id: '0',
                      customIconBuilder: (context, checked) {
                        var length = controller!.allChecked().length - (controller!.checked('0') ? 1 : 0);
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
                    );
                  }
                  return TDCheckbox(
                    contentDirection: TDContentDirection.right,
                    title: '多选${index}',
                    id: '$index',
                    onCheckBoxChanged: (checked) {
                      var length = controller!.allChecked().length - (controller!.checked('0') ? 1 : 0);
                      var allCheck = itemCount - 1 == length;
                      var halfSelected =
                          controller != null
                              && !allCheck
                              && length > 0;
                      controller!.toggle('0', allCheck);
                      getAllIcon(allCheck, halfSelected);
                    },
                  );
                },
              ));
        })
      ]
    );
  }
}
