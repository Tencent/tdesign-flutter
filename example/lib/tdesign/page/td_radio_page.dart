import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

///
/// TdRadio演示
///
class TdRadioPage extends StatefulWidget {
  const TdRadioPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TdRadioPageState();
  }
}

class TdRadioPageState extends State<TdRadioPage> {

  @override
  void initState() {
    super.initState();
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


  @override
  Widget build(BuildContext context) {
    Widget current = ListView(
      children: [
        _title('基础单选框'),
        TdRadioGroup(
          selectId: 'index:0',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TdRadio(
                    id: 'index:$index',
                    title: '单选$index',
                  ),
                  height: 40,
                  alignment: Alignment.centerLeft,
                );
              },
              itemCount: 4,
            ),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
          ),
        ),
        _title('左边勾选样式'),
        TdRadioGroup(
          radioStyle: TdRadioStyle.check,
          selectId: 'index:1',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TdRadio(
                    id: 'index:$index',
                    title: '单选$index',
                  ),
                  height: 40,
                  alignment: Alignment.centerLeft,
                );
              },
              itemCount: 4,
            ),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
          ),
        ),
        _title('右边单选框'),
        TdRadioGroup(
          contentDirection: TdContentDirection.left,
          selectId: 'index:0',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TdRadio(
                    id: 'index:$index',
                    title: '单选$index',
                  ),
                  height: 40,
                  alignment: Alignment.centerLeft,
                );
              },
              itemCount: 4,
            ),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
          ),
        ),
        _title('右边勾选样式'),
        TdRadioGroup(
          radioStyle: TdRadioStyle.check,
          contentDirection: TdContentDirection.left,
          selectId: 'index:0',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TdRadio(
                    id: 'index:$index',
                    title: '单选$index',
                  ),
                  height: 40,
                  alignment: Alignment.centerLeft,
                );
              },
              itemCount: 4,
            ),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
          ),
        ),
        _title('各种状态和样式'),
        TdRadioGroup(
          contentDirection: TdContentDirection.left,
          child: Container(
            child: Column(
              children: [
                const TdRadio(
                  id: '0',
                  title: '勾选样式',
                  radioStyle: TdRadioStyle.check,
                ),
                _divider(),
                const TdRadio(
                  id: '1',
                  title: '矩形',
                  radioStyle: TdRadioStyle.square,
                ),
                _divider(),
                const TdRadio(
                  id: '3',
                  title: '圆形',
                ),
                _divider(),
                const TdRadio(
                  enable: false,
                  id: '2',
                  title: '不可选',
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
          ),
        ),
        _title('完全自定义样式'),
        TdRadioGroup(
            selectId: '20',
            customIconBuilder: (context, check) => null,
            customContentBuilder: (context, check, title) {
              final theme = TDTheme.of(context);
              return Container(
                child: Text(
                  title!,
                  style: TextStyle(color: check ? Colors.white : Colors.black),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    border: Border.all(
                        color: check ? theme.brandColor7 : theme.grayColor5),
                    color: check ? theme.brandColor7 : Colors.transparent),
              );
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) => TdRadio(
                  id: '2$index',
                  title: '选项$index',
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
        title: const Text('Radio演示'),
      ),
      body: current,
    );
    return current;
  }
}
