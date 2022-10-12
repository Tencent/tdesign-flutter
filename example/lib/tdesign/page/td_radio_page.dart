import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

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
        TDRadioGroup(
          selectId: 'index:0',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var title = '单选$index';
                if(index == 2){
                  title = '单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选';
                }
                return Container(
                  child: TDRadio(
                    id: 'index:$index',
                    title: title,
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
        TDRadioGroup(
          radioStyle: TDRadioStyle.check,
          selectId: 'index:1',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var title = '单选$index';
                if(index == 2){
                  title = '单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选';
                }
                return Container(
                  child: TDRadio(
                    id: 'index:$index',
                    title: title,
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
        TDRadioGroup(
          contentDirection: TDContentDirection.left,
          selectId: 'index:0',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TDRadio(
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
        TDRadioGroup(
          radioStyle: TDRadioStyle.check,
          contentDirection: TDContentDirection.left,
          selectId: 'index:0',
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: TDRadio(
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
        TDRadioGroup(
          contentDirection: TDContentDirection.left,
          child: Container(
            child: Column(
              children: [
                const TDRadio(
                  id: '0',
                  title: '勾选样式',
                  radioStyle: TDRadioStyle.check,
                ),
                _divider(),
                const TDRadio(
                  id: '1',
                  title: '矩形',
                  radioStyle: TDRadioStyle.square,
                ),
                _divider(),
                const TDRadio(
                  id: '3',
                  title: '圆形',
                ),
                _divider(),
                const TDRadio(
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
        TDRadioGroup(
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
                itemBuilder: (BuildContext context, int index) => TDRadio(
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
        title: const Text('单选框 Radio'),
      ),
      body: current,
    );
    return current;
  }
}
