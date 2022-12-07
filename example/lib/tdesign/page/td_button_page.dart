import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../../annotation/demo.dart';
import '../example_widget.dart';

class TDButtonPage extends StatefulWidget {
  const TDButtonPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDButtonPageState();
}

class _TDButtonPageState extends State<TDButtonPage> {

  void onTap() {
    TDToast.showText('点击了按钮',context: context);
  }

  void onLongPress() {
    TDToast.showText('长按了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).grayColor2,
      child: ExamplePage(
          title: '按钮 Button',
          desc: '用于开启一个闭环的操作任务，如“删除”对象、“购买”商品等。',
          exampleCodeGroup:'button',
          padding: const EdgeInsets.only(top: 8,bottom: 8),
          children: [
          ExampleModule(title: '默认',
          children: [
            ExampleItem(desc: '可点击', builder: _buildNormalClickButton),
            ExampleItem(desc: '不可点击', builder: _buildNormalUnClickButton),


            ExampleItem(desc: '可点击', builder: _buildWeeklyClickButton),
            ExampleItem(desc: '不可点击', builder: (context){
              return TDButton(content: '弱按钮',
                style: TDButtonStyle.weakly(),
                disabled: true,
                onTap: onTap,
                onLongPress: onLongPress,);
            }),


            ExampleItem(desc: '可点击', builder: (context){
              return TDButton(content: '次按钮',
                style: TDButtonStyle.secondary(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '不可点击', builder: (context){
              return TDButton(content: '次按钮',
                style: TDButtonStyle.secondary(),
                disabled: true,
                onTap: onTap,
                onLongPress: onLongPress,);
            }),


            ExampleItem(desc: '可点击', builder: (context){
              return TDButton(content: '带图标按钮',
                style: TDButtonStyle.weakly(),
                icon: TDIcons.app,
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '不可点击', builder: (context){
              return TDButton(content: '带图标按钮',
                style: TDButtonStyle.weakly(),
                icon: TDIcons.app,
                disabled: true,
                onTap: onTap,
                onLongPress: onLongPress,);
            }),

            ExampleItem(desc: '可点击', builder: (context){
              return TDButton(content: '强警告按钮',
                style: TDButtonStyle.warningPrimary(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '不可点击', builder: (context){
              return TDButton(content: '强警告按钮',
                style: TDButtonStyle.warningPrimary(),
                disabled: true,
                onTap: onTap,
                onLongPress: onLongPress,);
            }),


            ExampleItem(desc: '可点击', builder: (context){
              return TDButton(content: '弱警告按钮',
                style: TDButtonStyle.warningWeakly(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '不可点击', builder: (context){
              return TDButton(content: '弱警告按钮',
                style: TDButtonStyle.warningWeakly(),
                disabled: true,
                onTap: onTap,
                onLongPress: onLongPress,);
            }),


            ExampleItem(desc: '可点击', builder: (context){
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                color: Colors.black12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TDButton(content: '幽灵按钮',
                      style: TDButtonStyle.ghost(),
                      onTap: onTap,
                      onLongPress: onLongPress,
                    )
                  ],),
              );
            }),
            ExampleItem(desc: '不可点击', builder: (context){
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                color: Colors.black12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TDButton(content: '幽灵按钮',
                      style: TDButtonStyle.ghost(),
                      // width: 343,
                      disabled: true,
                      onTap: onTap,
                      onLongPress: onLongPress,)
                  ],),
              );
            }),


            ExampleItem(desc: '可点击', builder: (context){
              return TDTextButton('文字按钮',
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '不可点击', builder: (context){
              return TDTextButton('文字按钮',
                onTap: onTap,
                onLongPress: onLongPress,
                disabled: true,
              );
            }),


            ExampleItem(desc: '可点击', builder: (context){
              return TDButton(content: '通栏按钮',
                style: TDButtonStyle.full(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '不可点击', builder: (context){
              return TDButton(content: '通栏按钮',
                style: TDButtonStyle.full(),
                disabled: true,
                onTap: onTap,
                onLongPress: onLongPress,);
            }),


            ExampleItem(desc: '两个按钮', builder: (context){
              return Row(
                children: [
                  Expanded(child: TDButton(content: '次按钮',
                    style: TDButtonStyle.fullSecondary(),
                    onTap: onTap,
                    onLongPress: onLongPress,
                  )),
                  Expanded(child: TDButton(content: '主按钮',
                    style: TDButtonStyle.full(),
                    onTap: onTap,
                    onLongPress: onLongPress,
                  )),
                ],
              );
            }),





            ExampleItem(desc: '尺寸', builder: (context){
              return SizedBox(
                height: 50,
                child: TDText(
                  '下方是尺寸示例',
                  font: TDTheme.of().fontTitleExtraLarge,
                  textColor: TDTheme.of().warningNormalColor,
                ),
              );
            }),


            ExampleItem(desc: '大', builder: (context){
              return TDButton(content: '强按钮',
                style: TDButtonStyle.primary(),
                size: TDButtonSize.large,
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '中(默认)', builder: (context){
              return TDButton(content: '强按钮',
                size: TDButtonSize.medium,
                style: TDButtonStyle.primary(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '小(宽度自适应)', builder: (context){
              return TDButton(content: '强按钮',
                size: TDButtonSize.small,
                style: TDButtonStyle.primary(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '小(宽度自适应)', builder: (context){
              return TDButton(content: '弱按钮',
                size: TDButtonSize.small,
                style: TDButtonStyle.weakly(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '小(宽度自适应)', builder: (context){
              return TDButton(content: '次按钮',
                size: TDButtonSize.small,
                style: TDButtonStyle.secondary(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '小(宽度自适应)', builder: (context){
              return TDButton(content: '带图标按钮',
                size: TDButtonSize.small,
                style: TDButtonStyle.weakly(),
                icon: TDIcons.app,
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '小(宽度自适应)', builder: (context){
              return TDButton(content: '强警告按钮',
                size: TDButtonSize.small,
                style: TDButtonStyle.warningPrimary(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '小(宽度自适应)', builder: (context){
              return TDButton(content: '弱警告按钮',
                size: TDButtonSize.small,
                style: TDButtonStyle.warningWeakly(),
                onTap: onTap,
                onLongPress: onLongPress,
              );
            }),
            ExampleItem(desc: '小(宽度自适应)', builder: (context){
              return Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                color: Colors.black12,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    TDButton(content: '幽灵按钮',
                      size: TDButtonSize.small,
                      style: TDButtonStyle.ghost(),
                      onTap: onTap,
                      onLongPress: onLongPress,
                    )
                  ],),
              );
            }),


          ]),

            ExampleModule(title: '组件状态', children: [
              ExampleItem(desc: '可点击', builder: (context){
                return TDButton(content: '强按钮',
                  style: TDButtonStyle.primary(),
                  onTap: onTap,
                  onLongPress: onLongPress,
                );
              }),
              ExampleItem(desc: '不可点击', builder: (context){
                return TDButton(content: '强按钮',
                  style: TDButtonStyle.primary(),
                  disabled: true,
                  onTap: onTap,
                  onLongPress: onLongPress,);
              }),


              ExampleItem(desc: '可点击', builder: (context){
                return TDButton(content: '弱按钮',
                  style: TDButtonStyle.weakly(),
                  onTap: onTap,
                  onLongPress: onLongPress,
                );
              }),
            ])
      ]
    ));
  }

  @Demo(group: 'button')
  TDButton _buildNormalClickButton(BuildContext context) {
    return TDButton(content: '强按钮',
      style: TDButtonStyle.primary(),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  @Demo(group: 'button')
  Widget _buildNormalUnClickButton(BuildContext context) {
    return TDButton(content: '强按钮',
      style: TDButtonStyle.primary(),
      disabled: true,
      onTap: onTap,
      onLongPress: onLongPress,);
  }

  @Demo(group: 'button')
  Widget _buildWeeklyClickButton(BuildContext context) {
    return TDButton(content: '弱按钮',
      style: TDButtonStyle.weakly(),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
