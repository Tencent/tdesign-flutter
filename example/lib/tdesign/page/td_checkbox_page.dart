import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

///
/// TdCheckbox演示
///
class TdCheckboxPage extends StatefulWidget {
  const TdCheckboxPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TdCheckboxPageState();
  }
}

class TdCheckboxPageState extends State<TdCheckboxPage> {
  bool isChecked = false;

  List<String>? checkIds;

  TdCheckBoxGroupController? controller;

  @override
  void initState() {
    super.initState();
    controller = TdCheckBoxGroupController();
  }

  Widget _divider() {
    return const Divider();
  }

  Widget _title(String title) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(title),
    );
  }

  Widget _desc(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 12, color: TDTheme.of().grayColor6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget current = ListView(
      children: [
        _title("基础多选框"),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TdCheckbox(
                title: "多选",
              ),
              _divider(),
              TdCheckbox(
                title: "多选",
              ),
              _divider(),
              TdCheckbox(
                title: "禁用状态",
                enable: false,
                checked: true,
              ),
              _divider(),
              TdCheckbox(
                title: "多选多选多选多选多选多选多选多选多选多选多选多选",
                enable: false,
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          color: Colors.white,
        ),

        _title("右侧多选框"),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TdCheckbox(
                contentDirection: TdContentDirection.left,
                title: "多选",
              ),
              _divider(),
              TdCheckbox(
                contentDirection: TdContentDirection.left,
                title: "多选",
                checked: true,
              ),
              _divider(),
              TdCheckbox(
                contentDirection: TdContentDirection.left,
                title: "多选",
                checked: true,
              ),
              _divider(),
              TdCheckbox(
                contentDirection: TdContentDirection.left,
                title: "多选",
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          color: Colors.white,
        ),

        _title("自定义图标多框类型"),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TdCheckbox(
                style: TdCheckboxStyle.square,
                title: "多选",
              ),
              _divider(),
              TdCheckbox(
                style: TdCheckboxStyle.square,
                title: "多选",
                checked: true,
              ),
              _divider(),
              TdCheckbox(
                style: TdCheckboxStyle.square,
                title: "多选",
                checked: true,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          color: Colors.white,
        ),


        _title("分组控制"),
        _desc(
            "通过TdCheckBoxGroup可以把多个TdCheckbox组成一个分组，TdCheckBox的布局和样式自由，只需要拥有同一个FdCheckboxGroup祖宗节点即可，可以通过TdCheckboxGroupController实现对分组的统一控制。"),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Row(
              children: [
                const Text("控制器:"),
                const SizedBox(
                  width: 10,
                ),
                MaterialButton(
                    child: const Text("勾选1和3"),
                    onPressed: () {
                      controller?.toggle("1", true);
                      controller?.toggle("3", true);
                    }),
                MaterialButton(
                    child: const Text("全选"),
                    onPressed: () {
                      controller?.toggleAll(true);
                    }),
                MaterialButton(
                    child: const Text("全部取消"),
                    onPressed: () {
                      controller?.toggleAll(false);
                    }),
                MaterialButton(
                    child: const Text("反选"),
                    onPressed: () {
                      controller?.reverseAll();
                    }),
              ],
            ),
          ),
        ),

        TdCheckboxGroup(
            controller: controller,
            onChangeGroup: (checkedId) {
              this.checkIds = checkedId;
              setState(() {});
              // FuiToast.show(context, "checked:$checkIds");
            },
            checkedIds: checkIds,
            onOverloadChecked: () {
              TDToast.showText(context, "最大只能勾选3个选项");
            },
            child: Container(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 7,
                  mainAxisExtent: 35,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) => TdCheckbox(
                  id: "$index",
                  title: "选项$index",
                ),
              ),
              padding: const EdgeInsets.all(16),
              color: Colors.white,
            )),

        _title("完全自定义样式"),

        TdCheckboxGroup(
            controller: controller,
            onChangeGroup: (checkedId) {
              this.checkIds = checkedId;
              setState(() {});
              // FuiToast.show(context, "checked:$checkIds");
            },
            customIconBuilder: (context, check)=>null,
            customContentBuilder: (context, check, title) {
              final theme = TDTheme.of(context);
              return Container(
                child: Text(title!, style: TextStyle(color: check ? Colors.white : Colors.black),),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: check ? theme.brandColor7 : theme.grayColor5),
                  color: check ? theme.brandColor7 : Colors.transparent
                ),
              );
            },
            checkedIds: checkIds,
            onOverloadChecked: () {
              TDToast.showText(context, "最大只能勾选3个选项");
            },
            child: Container(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 7,
                  mainAxisExtent: 35,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) => TdCheckbox(
                  id: "2$index",
                  title: "选项$index",
                ),
              ),
              padding: const EdgeInsets.all(16),
              color: Colors.white,
            )),

        //
        // ListTile(
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       FuiCheckboxGroup(
        //         controller: controller,
        //         onChangeGroup: (checkedId) {
        //           this.checkIds = checkedId;
        //           setState(() {});
        //           // FuiToast.show(context, "checked:$checkIds");
        //         },
        //         checkedIds: checkIds,
        //         maxChecked: 3,
        //         onOverloadChecked: () {
        //           FuiToast.show(context, "最大只能勾选3个选项");
        //         },
        //         child: Row(
        //           children: [
        //             FuiCheckbox(
        //               id: "1",
        //               title: "选项1",
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             FuiCheckbox(
        //               id: "2",
        //               title: "选项2",
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             FuiCheckbox(
        //               id: "3",
        //               title: "选项3",
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             FuiCheckbox(
        //               id: "4",
        //               title: "选项4",
        //             ),
        //           ],
        //         ).withSingleChildScrollView(scrollDirection: Axis.horizontal),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Row(
        //         children: [
        //           Text("勾选项目id:"),
        //           Text(
        //             "${checkIds?.join2(prefix: "[", suffix: "]") ?? "[]"}",
        //             style: TextStyle(color: Colors.red),
        //           ),
        //         ],
        //       ),
        //       Row(
        //         children: [
        //           Text("控制器:"),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           MaterialButton(
        //               child: Text("勾选1和3"),
        //               onPressed: () {
        //                 controller?.toggle("1", true);
        //                 controller?.toggle("3", true);
        //               }),
        //           MaterialButton(
        //               child: Text("全选"),
        //               onPressed: () {
        //                 controller?.toggleAll(true);
        //               }),
        //           MaterialButton(
        //               child: Text("全部取消"),
        //               onPressed: () {
        //                 controller?.toggleAll(false);
        //               }),
        //           MaterialButton(
        //               child: Text("反选"),
        //               onPressed: () {
        //                 controller?.reverseAll();
        //               }),
        //         ],
        //       ).withSingleChildScrollView(scrollDirection: Axis.horizontal),
        //     ],
        //   ).withPadding(bottom: 20, top: 20),
        // ),

        // ListTile(
        //   title: TdCheckbox(
        //     title: "复选框基本用法，点击可以修改选中状态",
        //     checked: isChecked,
        //     onCheckBoxChanged: (checked) {
        //       setState(() {
        //         this.isChecked = checked;
        //       });
        //     },
        //   ),
        //   subtitle: Text(isChecked == true ? "选择了" : "未选择").withMargin(top: 10),
        // ),
        // _divider(),
        // ListTile(
        //   title: Text("各种样式的CheckBox").withPadding(bottom: 20),
        //   subtitle: Row(
        //     children: [
        //       TdCheckbox(
        //         onCheckBoxChanged: (checked, id) {},
        //       ),
        //       SizedBox(
        //         width: 20,
        //       ),
        //       TdCheckbox(
        //         style: FuiCheckboxStyle.circleCheck,
        //         title: "圆形",
        //         onCheckBoxChanged: (checked, id) {},
        //       ),
        //       SizedBox(
        //         width: 20,
        //       ),
        //       TdCheckbox(
        //         title: "开关",
        //         style: FuiCheckboxStyle.cupertinoSwitch,
        //         onCheckBoxChanged: (checked, id) {},
        //       ),
        //     ],
        //   ).withSingleChildScrollView(scrollDirection: Axis.horizontal),
        // ),
        // _divider(),
        // ListTile(
        //   title: Text("文字内容相对icon的方位").withPadding(bottom: 20),
        //   subtitle: Row(
        //     children: [
        //       FuiCheckbox(
        //         title: "右边",
        //         onCheckBoxChanged: (checked, id) {},
        //       ),
        //       SizedBox(
        //         width: 30,
        //       ),
        //       FuiCheckbox(
        //         contentDirection: FuiContentDirection.left,
        //         title: "左边",
        //         onCheckBoxChanged: (checked, id) {},
        //       ),
        //       SizedBox(
        //         width: 30,
        //       ),
        //       FuiCheckbox(
        //         title: "下边",
        //         contentDirection: FuiContentDirection.bottom,
        //         onCheckBoxChanged: (checked, id) {},
        //       ),
        //       SizedBox(
        //         width: 30,
        //       ),
        //       FuiCheckbox(
        //         title: "上边",
        //         contentDirection: FuiContentDirection.top,
        //         onCheckBoxChanged: (checked, id) {},
        //       ),
        //     ],
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: FuiCheckbox(
        //     title: "带说明名字的CheckBox",
        //     subTitle: "这是一段说明文字",
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: FuiCheckbox(
        //     title: "选中，默认选择的颜色为FuiTheme里的PrimaryColor",
        //     checked: true,
        //     titleMaxLine: 3,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: FuiCheckbox(
        //     title: "不可用，未选中",
        //     enable: false,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: FuiCheckbox(
        //     title: "不可用，选中",
        //     enable: false,
        //     checked: true,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: TdCheckbox(
        //     title: "自定义选择之后的颜色",
        //     checked: true,
        //     checkedColor: Colors.red,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: TdCheckbox(
        //     title: "自定义未选中样式",
        //     uncheckedFillColor: Colors.yellow[200],
        //     uncheckedBorderColor: Colors.yellow,
        //     checkedColor: Colors.deepOrangeAccent,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: TdCheckbox(
        //     title: "单行文字，这是一段很长的文字，这是一段很长的文字，这是一段很长的文字，这是一段很长的文字，这是一段很长的文字",
        //     titleMaxLine: 1,
        //     checked: true,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: TdCheckbox(
        //     title: "多行文字，这是一段很长的文字，这是一段很长的文字，这是一段很长的文字，这是一段很长的文字，这是一段很长的文字",
        //     titleMaxLine: 3,
        //     checked: true,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: TdCheckbox(
        //     title: "定制文字和icon之间的距离",
        //     titleMaxLine: 3,
        //     spacing: 40,
        //     checked: true,
        //   ),
        // ),
        // _divider(),
        // ListTile(
        //   title: FuiCheckbox(
        //     customContentBuilder: (context, checked, title) {
        //       return Text("自定义Icon和Content").withBackground(Colors.blue);
        //     },
        //     spacing: 10,
        //     customIconBuilder: (context,checked) {
        //       return Icon(
        //         Icons.alarm,
        //         color: checked ? Colors.blue : Colors.grey[300],
        //         size: 20,
        //       );
        //     },
        //     checked: true,
        //   ),
        // ),
        // GroupTitleWidget("分组"),
        // Text(
        //   "通过FuiCheckBoxGroup可以把多个FuiCheckBox组成一个分组，FuiCheckBox的布局和样式自由，只需要拥有同一个FuiCheckBoxGroup祖宗节点即可，可以通过FuiCheckBoxGroupController实现对分组的统一控制。",
        //   style: TextStyle(
        //       color: FuiThemeManager.currentTheme.auxTextColor, fontSize: 12),
        // ).withPadding(all: 20),
        // SubGroupTitleWidget("常规分组用法"),
        // ListTile(
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       FuiCheckboxGroup(
        //         controller: controller,
        //         onChangeGroup: (checkedId) {
        //           this.checkIds = checkedId;
        //           setState(() {});
        //           // FuiToast.show(context, "checked:$checkIds");
        //         },
        //         checkedIds: checkIds,
        //         maxChecked: 3,
        //         onOverloadChecked: () {
        //           FuiToast.show(context, "最大只能勾选3个选项");
        //         },
        //         child: Row(
        //           children: [
        //             FuiCheckbox(
        //               id: "1",
        //               title: "选项1",
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             FuiCheckbox(
        //               id: "2",
        //               title: "选项2",
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             FuiCheckbox(
        //               id: "3",
        //               title: "选项3",
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             FuiCheckbox(
        //               id: "4",
        //               title: "选项4",
        //             ),
        //           ],
        //         ).withSingleChildScrollView(scrollDirection: Axis.horizontal),
        //       ),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Row(
        //         children: [
        //           Text("勾选项目id:"),
        //           Text(
        //             "${checkIds?.join2(prefix: "[", suffix: "]") ?? "[]"}",
        //             style: TextStyle(color: Colors.red),
        //           ),
        //         ],
        //       ),
        //       Row(
        //         children: [
        //           Text("控制器:"),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           MaterialButton(
        //               child: Text("勾选1和3"),
        //               onPressed: () {
        //                 controller?.toggle("1", true);
        //                 controller?.toggle("3", true);
        //               }),
        //           MaterialButton(
        //               child: Text("全选"),
        //               onPressed: () {
        //                 controller?.toggleAll(true);
        //               }),
        //           MaterialButton(
        //               child: Text("全部取消"),
        //               onPressed: () {
        //                 controller?.toggleAll(false);
        //               }),
        //           MaterialButton(
        //               child: Text("反选"),
        //               onPressed: () {
        //                 controller?.reverseAll();
        //               }),
        //         ],
        //       ).withSingleChildScrollView(scrollDirection: Axis.horizontal),
        //     ],
        //   ).withPadding(bottom: 20, top: 20),
        // ),
        // SubGroupTitleWidget("纵向布局分组内的CheckBox"),
        // ListTile(
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       FuiCheckboxGroup(
        //         onChangeGroup: (checkedId) {
        //           FuiToast.show(context, "checked:$checkedId");
        //         },
        //         checkedIds: checkIds,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             FuiCheckbox(
        //               id: "1",
        //               checkedColor: Colors.red,
        //               title: "选项1",
        //               subTitle: "选项1描述",
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "2",
        //               title: "选项2",
        //               subTitle: "选项2描述",
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "3",
        //               checkedColor: Colors.red,
        //               title: "选项3",
        //               subTitle: "选项3描述",
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "4",
        //               title: "选项4",
        //               subTitle: "选项4描述",
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ).withPadding(bottom: 20, top: 20),
        // ),
        //
        // SubGroupTitleWidget("使用Group统一定制样式"),
        // ListTile(
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       FuiCheckboxGroup(
        //         onChangeGroup: (checkedId) {
        //           FuiToast.show(context, "checked:$checkedId");
        //         },
        //         customIconBuilder: (context,checked) {
        //           return Icon(
        //             Icons.hail,
        //             color: checked ? Colors.blue : Colors.grey,
        //           );
        //         },
        //         checkedIds: checkIds,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             FuiCheckbox(
        //               id: "1",
        //               title: "选项1",
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "2",
        //               title: "选项2",
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "3",
        //               title: "选项3",
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "4",
        //               title: "选项4",
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ).withPadding(bottom: 20, top: 20),
        // ),
        //
        // SubGroupTitleWidget("使用Group统一定制样式，只保留Content"),
        // ListTile(
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       FuiCheckboxGroup(
        //         onChangeGroup: (checkedId) {
        //           FuiToast.show(context, "checked:$checkedId");
        //         },
        //         customContentBuilder: (context,checked, title) {
        //           final color = checked ? Colors.blue : Colors.grey;
        //           return Text(
        //             title ?? "",
        //             style: TextStyle(color: color),
        //           ).withCenter().withContainer(
        //             padding: 10,
        //             borderRadius: 4,
        //             borderColor: color,);
        //         },
        //         customIconBuilder: (context,_) => null,
        //         checkedIds: checkIds,
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             FuiCheckbox(
        //               id: "1",
        //               title: "选项1",
        //             ).withExpanded(),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "2",
        //               title: "选项2",
        //             ).withExpanded(),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             FuiCheckbox(
        //               id: "3",
        //               title: "选项3",
        //             ).withExpanded(),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ).withPadding(bottom: 20, top: 20),
        // ),
        // SubGroupTitleWidget("自由布局和定制CheckBox"),
        // ListTile(
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       FuiCheckboxGroup(
        //         onChangeGroup: (checkedId) {
        //           FuiToast.show(context, "checked:$checkedId");
        //         },
        //         checkedIds: checkIds,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               children: [
        //                 FuiCheckbox(
        //                   id: "1",
        //                   customIconBuilder: (context,checked) {
        //                     return Icon(
        //                       Icons.headset,
        //                       color: checked ? Colors.red : Colors.grey,
        //                     );
        //                   },
        //                   title: "选项1",
        //                   subTitle: "选项1描述",
        //                 ),
        //                 SizedBox(
        //                   width: 40,
        //                 ),
        //                 FuiCheckbox(
        //                   id: "2",
        //                   title: "选项2",
        //                   customIconBuilder: (context,checked) {
        //                     return Icon(
        //                       Icons.hail,
        //                       color: checked ? Colors.blue : Colors.grey,
        //                     );
        //                   },
        //                   subTitle: "选项2描述",
        //                 ),
        //               ],
        //             ),
        //             Row(
        //               children: [
        //                 FuiCheckbox(
        //                   id: "3",
        //                   customIconBuilder: (context,checked) {
        //                     return Icon(
        //                       Icons.call,
        //                       color: checked ? Colors.green : Colors.grey,
        //                     );
        //                   },
        //                   title: "选项3",
        //                   subTitle: "选项3描述",
        //                 ),
        //                 SizedBox(
        //                   width: 40,
        //                 ),
        //                 FuiCheckbox(
        //                   id: "4",
        //                   title: "选项4",
        //                   customIconBuilder: (context,checked) {
        //                     return Icon(
        //                       Icons.settings,
        //                       color: checked ? Colors.yellow : Colors.grey,
        //                     );
        //                   },
        //                   subTitle: "选项4描述",
        //                 ),
        //               ],
        //             )
        //           ],
        //         ),
        //       ),
        //     ],
        //   ).withPadding(bottom: 20, top: 20),
        // ),
      ],
    );

    current = Container(
      child: current,
      color: TDTheme.of(context).grayColor1,
    );

    current = Scaffold(
      appBar: AppBar(
        title: Text("CheckBox演示"),
      ),
      body: current,
    );
    return current;
  }
}
