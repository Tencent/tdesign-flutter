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
        style: TextStyle(fontSize: 12, color: TDTheme.of(context).grayColor6),
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
              checkIds = checkedId;
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
              checkIds = checkedId;
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
