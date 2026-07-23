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
          ExampleItem(desc: '普通TText:', builder: _buildNormalTText),
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
          ExampleItem(desc: 'v1.0 Theme默认:', builder: _buildThemeDemo),
        ]),
      ],
      test: [
        ExampleItem(
            desc: '中文居中-系统字体',
            builder: (context) {
              return Container(
                color: context.tTheme.brandFocusColor,
                child: Text(exampleTxt),
              );
            }),
        ExampleItem(
            desc: '中文居中-TD字体',
            builder: (context) {
              return Container(
                color: context.tTheme.brandFocusColor,
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
  Widget _buildNormalTText(BuildContext context) {
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
      font: context.tTheme.fontHeadlineLarge,
      textColor: context.tTheme.brandNormalColor,
      backgroundColor: context.tTheme.brandFocusColor,
    );
  }

  @Demo(group: 'text')
  Widget _buildStyleCoverColor(BuildContext context) {
    return TText(
      exampleTxt,
      font: context.tTheme.fontBodyLarge,
      textColor: context.tTheme.brandNormalColor,
      style: TextStyle(color: context.tTheme.errorNormalColor),
    );
  }

  @Demo(group: 'text')
  Widget _buildStyleCoverColorAndFont(BuildContext context) {
    return TText(
      exampleTxt,
      font: context.tTheme.fontBodyLarge,
      textColor: context.tTheme.brandNormalColor,
      style: TextStyle(
        color: context.tTheme.errorNormalColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @Demo(group: 'text')
  Widget _buildRichText(BuildContext context) {
    return TText.rich(
      TextSpan(children: [
        TTextSpan(
            text: 'TTextSpan1',
            font: context.tTheme.fontTitleExtraLarge,
            textColor: context.tTheme.warningNormalColor,
            isTextThrough: true,
            lineThroughColor: context.tTheme.brandNormalColor,
            style: TextStyle(color: context.tTheme.errorNormalColor)),
        TextSpan(
            text: 'TextSpan2',
            style: TextStyle(
                fontSize: 14, color: context.tTheme.brandNormalColor)),
        const WidgetSpan(
            child: Icon(
          TIcons.setting,
          size: 24,
        )),
      ]),
      font: context.tTheme.fontBodyLarge,
      textColor: context.tTheme.brandNormalColor,
      style: TextStyle(color: context.tTheme.errorNormalColor, fontSize: 32),
    );
  }

  @Demo(group: 'text')
  Widget _getSystemText(BuildContext context) {
    return TText(
      exampleTxt,
      backgroundColor: context.tTheme.brandFocusColor,
    ).getRawText(context: context);
  }

  @Demo(group: 'text')
  Widget _buildVerticalCenterText(BuildContext context) {
    return TText(
      '中华人民共和国腾讯科技',
      // font: Font(size: 100, lineHeight: 100),
      forceVerticalCenter: true,
      backgroundColor: context.tTheme.brandFocusColor,
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

  @Demo(group: 'text')
  Widget _buildThemeDemo(BuildContext context) {
    // v1.0 新增：通过 TTextThemeData 统一控制子树 TText 默认样式
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ...Theme.of(context).extensions.values,
          TTextThemeData(
            defaultTextColor: context.tTheme.brandNormalColor,
            forceVerticalCenter: true,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: context.tTheme.brandFocusColor,
            child: TText(exampleTxt),
          ),
          const SizedBox(height: 4),
          Text(
            '↑ 继承 TTextThemeData 默认颜色和强制居中',
            style: TextStyle(
              fontSize: 12,
              color: context.tTheme.textColorSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 自定义控件，内部的context可拿到外部TTextConfiguration的配置信息
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
          backgroundColor: context.tTheme.brandFocusColor,
        ),
        TText(
          'English',
          font: context.tTheme.fontHeadlineLarge,
          forceVerticalCenter: true,
          backgroundColor: context.tTheme.brandFocusColor,
        ),
      ],
    );
  }
}

/// 重写内部padding方法
class CustomTextPaddingConfig extends TTextPaddingConfig {
  @override
  EdgeInsetsGeometry getPadding(String? data, double fontSize, double height,
      {String? fontFamily,
      FontWeight? fontWeight,
      double? textScale,
      TTextPaddingConfig? paddingConfig}) {
    var supperPadding = super.getPadding(data, fontSize, height,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        textScale: textScale,
        paddingConfig: paddingConfig);
    return EdgeInsets.only(left: 30, top: supperPadding.vertical.toDouble());
  }
}
