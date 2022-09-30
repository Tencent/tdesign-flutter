import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_base.dart';

class TdInputViewPage extends StatefulWidget {
  const TdInputViewPage({Key? key}) : super(key: key);

  @override
  _TdInputViewPageState createState() => _TdInputViewPageState();
}

class _TdInputViewPageState extends State<TdInputViewPage> {
  String inputText = '请输入...';
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ExampleWidget(
      backgroundColor: Color(0xFFF0F2F5),
      title: '输入框 Input',
      children: [
        ExampleItem(
            desc: '基础文本框',
            builder: (_) {
              return TDInput(
                leftLabel: '标签文字',
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
              );
            }),
        ExampleItem(
            desc: '无标题文本框',
            builder: (_) {
              return TDInput(
                controller: controller,
                backgroundColor: Colors.white,
                hintText: '请输入文字',
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
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
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
                rightBtn: GestureDetector(
                    onTap: () => controller.clear(),
                    child: Icon(
                      TDIcons.error_circle_filled,
                      color: TDTheme.of(context).fontGyColor3,
                    )),
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
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
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
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
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
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
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
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
              );
            }),
        ExampleItem(
            desc: '状态--不可编辑文字',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                leftLabel: '标签文字',
                readOnly: true,
                textStyle: TextStyle(color: TDTheme.of(context).fontGyColor3),
                controller: controller,
                hintText: '不可编辑文字',
                hintTextStyle: TextStyle(color: TDTheme.of(context).fontGyColor1),
                backgroundColor: Colors.white,
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
              );
            }),
        ExampleItem(
            desc: '状态--一段错误填写的内容',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                leftLabel: '标签文字',
                readOnly: true,
                textStyle: TextStyle(color: TDTheme.of(context).fontGyColor3),
                controller: controller,
                hintText: '一段错误填写的内容',
                errorText: '提示信息',
                hintTextStyle: TextStyle(color: TDTheme.of(context).errorColor6),
                backgroundColor: Colors.white,
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
              );
            }),
        ExampleItem(
            desc: '小规格H48',
            builder: (_) {
              return TDInput(
                type: TDInputType.normal,
                leftLabel: '小规格H48',
                textStyle: TextStyle(color: TDTheme.of(context).fontGyColor3),
                controller: controller,
                hintText: '请填写内容',
                backgroundColor: Colors.white,
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
              );
            }),
        ExampleItem(
            desc: '大规格H56',
            builder: (_) {
              return TDInput(
                size: TDInputSize.large,
                type: TDInputType.normal,
                leftLabel: '大规格H56',
                textStyle: TextStyle(color: TDTheme.of(context).fontGyColor3),
                controller: controller,
                hintText: '请填写内容',
                backgroundColor: Colors.white,
                onChanged: (txt) => setState(() {
                  inputText = '输入内容为：$txt';
                }),
              );
            }),
      ],
    );
  }
}
