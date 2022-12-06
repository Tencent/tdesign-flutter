import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_widget.dart';

class TDInputViewPage extends StatefulWidget {
  const TDInputViewPage({Key? key}) : super(key: key);

  @override
  _TDInputViewPageState createState() => _TDInputViewPageState();
}

class _TDInputViewPageState extends State<TDInputViewPage> {
  String inputText = '请输入...';
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: const Color(0xFFF0F2F5),
      title: '输入框 Input',
      children: [
      ExampleModule(title: '默认',
      children: [
        ExampleItem(
            desc: '基础文本框',
            builder: (_) {
              return TDInput(
                leftLabel: '标签文字',
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
              );
            }),
        ExampleItem(
            desc: '无标题文本框',
            builder: (_) {
              return TDInput(
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
              );
            }),
        ExampleItem(
            desc: '带提示信息文本框',
            builder: (_) {
              return TDInput(
                leftLabel: '标签文字',
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
                rightBtn: Icon(
                  TDIcons.error_circle_filled,
                  color: TDTheme.of(context).fontGyColor3,
                ),
              );
            }),
        ExampleItem(
            desc: '两行样式文本框',
            builder: (_) {
              return TDInput(
                leftLabel: '标签文字',
                type: TDInputType.twoLine,
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
              );
            }),
        ExampleItem(
            desc: '长标题文本框',
            builder: (_) {
              return TDInput(
                leftLabel: '超长需换行的标签',
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
              );
            }),
        ExampleItem(
            desc: '长文本输入文本框-无标题',
            builder: (_) {
              return TDInput(
                type: TDInputType.longText,
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
                maxLines: 8,
              );
            }),
        ExampleItem(
            desc: '长文本输入文本框',
            builder: (_) {
              return TDInput(
                type: TDInputType.longText,
                leftLabel: '标签文字',
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
                maxLines: 8,
              );
            }),
        ExampleItem(
            desc: '状态--不可编辑文字',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                leftLabel: '标签文字',
                readOnly: true,
                controller: controller,
                hintText: '不可编辑文字',
                hintTextStyle: TextStyle(color: TDTheme.of(context).fontGyColor1),
                backgroundColor: Colors.white,
              );
            }),
        ExampleItem(
            desc: '状态--一段错误填写的内容',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                leftLabel: '标签文字',
                readOnly: true,
                controller: controller,
                hintText: '一段错误填写的内容',
                errorText: '提示信息',
                hintTextStyle: TextStyle(color: TDTheme.of(context).errorColor6),
                backgroundColor: Colors.white,
              );
            }),
        ExampleItem(
            desc: '小规格H48',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                leftLabel: '小规格H48',
                controller: controller,
                hintText: '请填写内容',
                backgroundColor: Colors.white,
              );
            }),
        ExampleItem(
            desc: '大规格H56',
            builder: (_) {
              return TDInput(
                size: TDInputSize.large,
                type: TDInputType.normal,
                leftLabel: '大规格H56',
                controller: controller,
                hintText: '请填写内容',
                backgroundColor: Colors.white,
              );
            }),
        ExampleItem(
            desc: '特殊类型',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                controller: controller,
                hintText: '请输入手机号码',
                backgroundColor: Colors.white,
                rightBtn: Row(
                  children: [
                    Container(width: 0.5, height: 24, color: TDTheme.of(context).grayColor3,),
                    const SizedBox(width: 16,),
                    TDText('发送验证码', textColor: TDTheme.of(context).brandColor8),
                  ],
                ),
                onTapBtn: (){
                  TDToast.showText('点击了发送验证码', context: context);
                },
              );
            }),
        ExampleItem(
            desc: '特殊类型',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                size: TDInputSize.small,
                controller: controller,
                leftLabel: '验证码',
                hintText: '输入验证码',
                backgroundColor: Colors.white,
                rightBtn: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 0.5, height: 36, color: TDTheme.of(context).grayColor3,),
                    const SizedBox(width: 16,),
                    Image.network('https://img2018.cnblogs.com/blog/736399/202001/736399-20200108170302307-1377487770.jpg', width: 72, height: 36,)
                  ],
                ),
                onTapBtn: (){
                  TDToast.showText('点击了发送验证码', context: context);
                },
              );
            }),
        ExampleItem(
            desc: '特殊类型',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                controller: controller,
                obscureText: true,
                leftLabel: '输入密码',
                hintText: '请输入密码',
                backgroundColor: Colors.white,
                rightBtn: Icon(TDIcons.close_circle_filled, color: TDTheme.of(context).fontGyColor3,),
                onTapBtn: (){
                  controller.clear();
                },
              );
            }),
        ExampleItem(
            desc: '特殊类型',
            builder: (_) {
              return TDInput(
                type: TDInputType.special,
                controller: controller,
                leftLabel: '价格',
                hintText: '0.00',
                backgroundColor: Colors.white,
                textAlign: TextAlign.end,
                rightWidget: TDText('元', textColor: TDTheme.of(context).fontGyColor1),
              );
            }),
        ExampleItem(
            desc: '特殊类型',
            builder: (_) {
              return TDInput(
                type: TDInputType.special,
                controller: controller,
                leftLabel: '数量',
                hintText: '输入数量',
                backgroundColor: Colors.white,
                textAlign: TextAlign.end,
                rightWidget: TDText('个', textColor: TDTheme.of(context).fontGyColor1),
              );
            }),
      ],
    )]);
  }
}
