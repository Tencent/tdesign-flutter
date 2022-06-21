import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_base.dart';

class TdTextPage extends StatelessWidget {
  const TdTextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var exampleTxt = "文本Text";
    // debugPaintBaselinesEnabled = true;
    return ExampleWidget(
      padding: EdgeInsets.all(8),
      title: 'TDText',
      children: [
        ExampleItem(
            desc: '系统Text:',
            builder: (_) {
              return Text(
                exampleTxt,
              );
            }),
        ExampleItem(
            desc: '普通TDText:',
            builder: (_) {
              return TDText(
                exampleTxt,
              );
            }),
        ExampleItem(
            desc: '指定常用属性:',
            builder: (_) {
              return TDText(
                exampleTxt,
                font: TDTheme.of(context).fontXL,
                textColor: TDTheme.of(context).brandNormalColor,
                backgroundColor: TDTheme.of(context).successHoverColor,
              );
            }),
        ExampleItem(
            desc: 'style覆盖textColor,不覆盖font:',
            builder: (_) {
              return TDText(
                exampleTxt,
                font: TDTheme.of(context).fontM,
                textColor: TDTheme.of(context).brandNormalColor,
                style:
                    TextStyle(color: TDTheme.of(context).errorNormalColor),
              );
            }),
        ExampleItem(
            desc: 'style覆盖textColor和font:',
            builder: (_) {
              return TDText(
                exampleTxt,
                font: TDTheme.of(context).fontM,
                textColor: TDTheme.of(context).brandNormalColor,
              );
            }),
        ExampleItem(
            desc: 'TDText.rich测试:',
            builder: (_) {
              return TDText.rich(
                TextSpan(children: [
                  TDTextSpan(
                      text: 'TDTextSpan1',
                      font: TDTheme.of(context).fontL,
                      textColor: TDTheme.of(context).warningNormalColor,
                      isTextThrough: true,
                      lineThroughColor: TDTheme.of(context).brandNormalColor,
                      style: TextStyle(
                          color: TDTheme.of(context).errorNormalColor)),
                  TextSpan(
                      text: 'TextSpan2',
                      style: TextStyle(
                          fontSize: 14,
                          color: TDTheme.of(context).brandNormalColor)),
                  WidgetSpan(
                    child: Icon(TDIcons.setting, size: 24,)
                  ),
                ]),
                font: TDTheme.of(context).fontM,
                textColor: TDTheme.of(context).brandNormalColor,
                style: TextStyle(
                    color: TDTheme.of(context).errorNormalColor, fontSize: 32),
              );
            }),
        ExampleItem(
            desc: '获取系统Text:',
            builder: (_) {
              return TDText(
                exampleTxt,
                backgroundColor: TDTheme.of(context).successHoverColor,
              ).getRawText(context: context);
            }),
        ExampleItem(
            desc: '中文居中:（带有英文可能不居中）',
            builder: (_) {
              return TDText(
                '中华人民共和国腾讯科技',
                // font: Font(size: 100, lineHeight: 100),
                forceVerticalCenter: true,
                backgroundColor: Colors.orange,
              );
            }),
        ExampleItem(
            desc: '自定义内部padding:',
            builder: (_) {
              return TDTextConfiguration(
                paddingConfig: CustomTextPaddingConfig(),
                child: CustomPaddingText(),
              );
            }),
      ],
    );
  }
}

/// 自定义控件，内部的context可拿到外部TDTextConfiguration的配置信息
class CustomPaddingText extends StatelessWidget {
  const CustomPaddingText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TDText(
        '中华人民共和国腾讯科技fgjpqy',
        // font: Font(size: 100, lineHeight: 100),
        forceVerticalCenter: true,
        backgroundColor: Colors.orange,
      ),
        TDText(
        'English',
        font: TDTheme.of(context).fontXL,
        forceVerticalCenter: true,
        backgroundColor: Colors.orange,
      ),
      ],
    );
  }
}

/// 重写内部padding方法
class CustomTextPaddingConfig extends TDTextPaddingConfig {
  @override
  EdgeInsetsGeometry getPadding(String data, double fontSize, double height) {
    var supperPadding =  super.getPadding(data, fontSize, height);
    return EdgeInsets.only(left: 30, top: supperPadding.vertical.toDouble());
  }
}

