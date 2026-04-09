import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TTextPage extends StatelessWidget {
  const TTextPage({Key? key}) : super(key: key);

  final exampleTxt = '文本Text';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'text',
      children: [
        ExampleModule(title: '使用示例', children: [
          ExampleItem(desc: '系统Text:', builder: _buildSystemText),
          ExampleItem(desc: '普通TDText:', builder: _buildNormalTDText),
          ExampleItem(desc: '指定常用属性:', builder: _buildGeneralProp),
          ExampleItem(
              desc: 'style覆盖textColor,不覆盖font:',
              builder: _buildStyleCoverColor),
          ExampleItem(
              desc: 'style覆盖textColor和font:',
              builder: _buildStyleCoverColorAndFont),
          ExampleItem(desc: 'TText.rich测试:', builder: _buildRichText),
          ExampleItem(desc: '获取系统Text:', builder: _getSystemText),
          ExampleItem(
              desc: '中文居中:（带有英文可能不居中）', builder: _buildVerticalCenterText),
          ExampleItem(desc: '自定义内部padding:', builder: _buildCustomPaddingText),
          ExampleItem(desc: '删除线:', builder: _buildTextThrough),
        ]),
      ],
      test: [
        ExampleItem(
            desc: '中文居中-系统字体',
            builder: (context) {
              return Container(
                color: TTheme.of(context).brandFocusColor,
                child: Text(exampleTxt),
              );
            }),
        ExampleItem(
            desc: '中文居中-TD字体',
            builder: (context) {
              return Container(
                color: TTheme.of(context).brandFocusColor,
                child: TText(
                  exampleTxt,
                  forceVerticalCenter: true,
                ),
              );
            }),
      ],
    );
  }

  @Demo(group: 'text')
  Widget _buildNormalTDText(BuildContext context) {
    return TText(
      exampleTxt,
    );
  }

  @Demo(group: 'text')
  Widget _buildSystemText(BuildContext context) {
    return Text(
      exampleTxt,
    );
  }

  @Demo(group: 'text')
  Widget _buildGeneralProp(BuildContext context) {
    return TText(
      exampleTxt,
      font: TTheme.of(context).fontHeadlineLarge,
      textColor: TTheme.of(context).brandNormalColor,
      backgroundColor: TTheme.of(context).brandFocusColor,
    );
  }

  @Demo(group: 'text')
  Widget _buildStyleCoverColor(BuildContext context) {
    return TText(
      exampleTxt,
      font: TTheme.of(context).fontBodyLarge,
      textColor: TTheme.of(context).brandNormalColor,
      style: TextStyle(color: TTheme.of(context).errorNormalColor),
    );
  }

  @Demo(group: 'text')
  Widget _buildStyleCoverColorAndFont(BuildContext context) {
    return TText(
      exampleTxt,
      font: TTheme.of(context).fontBodyLarge,
      textColor: TTheme.of(context).brandNormalColor,
    );
  }

  @Demo(group: 'text')
  Widget _buildRichText(BuildContext context) {
    return TText.rich(
      TextSpan(children: [
        TTextSpan(
            text: 'TTextSpan1',
            font: TTheme.of(context).fontTitleExtraLarge,
            textColor: TTheme.of(context).warningNormalColor,
            isTextThrough: true,
            lineThroughColor: TTheme.of(context).brandNormalColor,
            style: TextStyle(color: TTheme.of(context).errorNormalColor)),
        TextSpan(
            text: 'TextSpan2',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).brandNormalColor)),
        const WidgetSpan(
            child: Icon(
          TIcons.setting,
          size: 24,
        )),
      ]),
      font: TTheme.of(context).fontBodyLarge,
      textColor: TTheme.of(context).brandNormalColor,
      style:
          TextStyle(color: TTheme.of(context).errorNormalColor, fontSize: 32),
    );
  }

  @Demo(group: 'text')
  Widget _getSystemText(BuildContext context) {
    return TText(
      exampleTxt,
      backgroundColor: TTheme.of(context).brandFocusColor,
    ).getRawText(context: context);
  }

  @Demo(group: 'text')
  Widget _buildVerticalCenterText(BuildContext context) {
    return TText(
      '中华人民共和国腾讯科技',
      // font: Font(size: 100, lineHeight: 100),
      forceVerticalCenter: true,
      backgroundColor: TTheme.of(context).brandFocusColor,
    );
  }

  @Demo(group: 'text')
  Widget _buildCustomPaddingText(BuildContext context) {
    return TTextConfiguration(
      paddingConfig: CustomTextPaddingConfig(),
      child: const CustomPaddingText(),
    );
  }

  @Demo(group: 'text')
  Widget _buildTextThrough(BuildContext context) {
    return TText(exampleTxt, isTextThrough: true);
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
        TText(
          '中华人民共和国腾讯科技fgjpqy',
          forceVerticalCenter: true,
          backgroundColor: TTheme.of(context).brandFocusColor,
        ),
        TText(
          'English',
          font: TTheme.of(context).fontHeadlineLarge,
          forceVerticalCenter: true,
          backgroundColor: TTheme.of(context).brandFocusColor,
        ),
      ],
    );
  }
}

/// 重写内部padding方法
class CustomTextPaddingConfig extends TTextPaddingConfig {
  @override
  EdgeInsetsGeometry getPadding(String? data, double fontSize, double height) {
    var supperPadding = super.getPadding(data, fontSize, height);
    return EdgeInsets.only(left: 30, top: supperPadding.vertical.toDouble());
  }
}
