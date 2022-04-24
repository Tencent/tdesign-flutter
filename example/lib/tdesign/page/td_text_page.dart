import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_base.dart';

class TdTextPage extends StatelessWidget {
  const TdTextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String exampleTxt = "文本Text";
    return ExampleWidget(
      title: "TDText",
      children: [
        ExampleItem(
            desc: "系统Text:",
            builder: (_) {
              return Text(
                exampleTxt,
              );
            }),
        ExampleItem(
            desc: "普通TDText:",
            builder: (_) {
              return TDText(
                exampleTxt,
              );
            }),
        ExampleItem(
            desc: "指定fontXL:",
            builder: (_) {
              return TDText(
                exampleTxt,
                font: TDTheme.of(context).fontXL,
              );
            }),
        ExampleItem(
            desc: "style覆盖textColor,不覆盖font:",
            builder: (_) {
              return TDText(
                exampleTxt,
                font: TDTheme.of(context).fontM,
                textColor: TDTheme.of(context).brandNormalColor,
                customStyle:
                    TextStyle(color: TDTheme.of(context).errorNormalColor),
              );
            }),
        ExampleItem(
            desc: "style覆盖textColor和font:",
            builder: (_) {
              return TDText(
                exampleTxt,
                font: TDTheme.of(context).fontM,
                textColor: TDTheme.of(context).brandNormalColor,
                customStyle: TextStyle(
                    color: TDTheme.of(context).errorNormalColor, fontSize: 32),
              );
            }),
        ExampleItem(
            desc: "TDText.rich测试:",
            builder: (_) {
              return TDText.rich(
                TextSpan(children: [
                  TDTextSpan(
                      text: "TextSpan1",
                      font: TDTheme.of(context).fontXL,
                      textColor: TDTheme.of(context).warningNormalColor,
                      isTextThrough: true,
                      lineThroughColor: TDTheme.of(context).brandNormalColor,
                      customStyle: TextStyle(
                          color: TDTheme.of(context).errorNormalColor)),
                  TextSpan(
                      text: "TextSpan2",
                      style: TextStyle(
                          fontSize: 24,
                          color: TDTheme.of(context).brandNormalColor)),
                  WidgetSpan(
                    child: Icon(TDIcons.setting, size: 24,)
                  ),
                ]),
                font: TDTheme.of(context).fontM,
                textColor: TDTheme.of(context).brandNormalColor,
                customStyle: TextStyle(
                    color: TDTheme.of(context).errorNormalColor, fontSize: 32),
              );
            }),
      ],
    );
  }
}


