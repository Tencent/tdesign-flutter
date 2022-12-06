import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_widget.dart';

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
        children: [
          ExampleModule(desc: '基础文本框', builder: (context){
            return TDRadioGroup(
              selectId: 'index:0',
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var title = '单选';
                  var subTitle = '';
                  if(index == 2){
                    title = '单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选';
                  }
                  if(index == 3){
                    subTitle = '单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选';
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
          }),
          ExampleModule(desc: '左边勾选样式', builder: (context){
            return TDRadioGroup(
              radioStyle: TDRadioStyle.check,
              selectId: 'index:1',
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var title = '单选';
                  var subTitle = '';
                  if(index == 2){
                    title = '单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选';
                  }
                  if(index == 3){
                    subTitle = '单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选单选';
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
          }),
          ExampleModule(desc: '右侧勾选样式', builder: (context) {
            return TDRadioGroup(
              radioStyle: TDRadioStyle.check,
              contentDirection: TDContentDirection.left,
              selectId: 'index:0',
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return TDRadio(
                    id: 'index:$index',
                    title: '单选$index',
                  );
                },
                itemCount: 4,
              ),
            );
          }),
          ExampleModule(desc: '右侧圆形单选框', builder: (context){
            return TDRadioGroup(
              contentDirection: TDContentDirection.left,
              selectId: 'index:0',
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return TDRadio(
                    id: 'index:$index',
                    title: '单选$index',
                  );
                },
                itemCount: 4,
              ),
            );
          }),
          ExampleModule(desc: '自定义图标单选框', builder: (context){
            return TDRadioGroup(
              contentDirection: TDContentDirection.right,
              child: Column(
                children: const [
                  TDRadio(
                    id: '0',
                    title: '单选',
                    radioStyle: TDRadioStyle.square,
                  ),
                  TDRadio(
                    id: '1',
                    title: '单选',
                    radioStyle: TDRadioStyle.square,
                  ),
                ],
              ),
            );
          }),
          ExampleModule(desc: '规格', builder: (context){
            return TDRadioGroup(
              contentDirection: TDContentDirection.right,
              child: Column(
                children: const [
                  TDRadio(
                    id: '0',
                    title: '单选 H48',
                    radioStyle: TDRadioStyle.circle,
                  ),
                  TDRadio(
                    id: '1',
                    size: TDCheckBoxSize.large,
                    title: '单选 H56',
                    radioStyle: TDRadioStyle.circle,
                  ),
                ],
              ),
            );
          }),
          ExampleModule(desc: '状态', builder: (context){
            return TDRadioGroup(
              contentDirection: TDContentDirection.right,
              selectId: '0',
              child: Column(
                children: const [
                  TDRadio(
                    id: '0',
                    title: '单选',
                    radioStyle: TDRadioStyle.circle,
                    enable: false,
                  ),
                  TDRadio(
                    id: '1',
                    title: '单选',
                    radioStyle: TDRadioStyle.circle,
                    enable: false,
                  ),
                ],
              ),
            );
          }),
          ExampleModule(desc: '状态', builder: (context){
            return TDRadioGroup(
              contentDirection: TDContentDirection.right,
              selectId: '0',
              child: Column(
                children: const [
                  TDRadio(
                    id: '0',
                    title: '单选',
                    radioStyle: TDRadioStyle.check,
                    enable: false,
                  ),
                  TDRadio(
                    id: '1',
                    title: '单选',
                    radioStyle: TDRadioStyle.check,
                    enable: false,
                  ),
                ],
              ),
            );
          }),
          ExampleModule(desc: '状态', builder: (context){
            return TDRadioGroup(
              contentDirection: TDContentDirection.left,
              selectId: '0',
              child: Column(
                children: const [
                  TDRadio(
                    id: '0',
                    title: '单选',
                    radioStyle: TDRadioStyle.circle,
                    enable: false,
                  ),
                  TDRadio(
                    id: '1',
                    title: '单选',
                    radioStyle: TDRadioStyle.circle,
                    enable: false,
                  ),
                ],
              ),
            );
          }),
          ExampleModule(desc: '状态', builder: (context){
            return TDRadioGroup(
              contentDirection: TDContentDirection.left,
              selectId: '0',
              child: Column(
                children: const [
                  TDRadio(
                    id: '0',
                    title: '单选',
                    radioStyle: TDRadioStyle.check,
                    enable: false,
                  ),
                  TDRadio(
                    id: '1',
                    title: '单选',
                    radioStyle: TDRadioStyle.check,
                    enable: false,
                  ),
                ],
              ),
            );
          }),
        ]
    );
  }
}
