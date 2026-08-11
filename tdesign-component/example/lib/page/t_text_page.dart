import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
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
          ExampleItem(desc: '删除线:', builder: _buildTextThrough),
          ExampleItem(desc: 'Theme 默认:', builder: _buildThemeDemo),
        ]),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildNormalTText(BuildContext context) {
    return TText(
      exampleTxt,
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildSystemText(BuildContext context) {
    return Text(
      exampleTxt,
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildGeneralProp(BuildContext context) {
    return TText(
      exampleTxt,
      font: context.tTheme.fontHeadlineLarge,
      textColor: context.tTheme.brandNormalColor,
      backgroundColor: context.tTheme.brandFocusColor,
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildStyleCoverColor(BuildContext context) {
    return TText(
      exampleTxt,
      font: context.tTheme.fontBodyLarge,
      textColor: context.tTheme.brandNormalColor,
      style: TextStyle(color: context.tTheme.errorNormalColor),
    );
  }

  @ExampleCode(group: 'text')
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

  @ExampleCode(group: 'text')
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

  @ExampleCode(group: 'text')
  Widget _getSystemText(BuildContext context) {
    return TText(
      exampleTxt,
      backgroundColor: context.tTheme.brandFocusColor,
    ).getRawText(context: context);
  }

  @ExampleCode(group: 'text')
  Widget _buildTextThrough(BuildContext context) {
    return TText(exampleTxt, isTextThrough: true);
  }

  @ExampleCode(group: 'text')
  Widget _buildThemeDemo(BuildContext context) {
    // 通过 TTextThemeData 统一控制子树 TText 默认样式
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ...Theme.of(context).extensions.values,
          TTextThemeData(
            defaultTextColor: context.tTheme.brandNormalColor,
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
            '↑ 继承 TTextThemeData 默认颜色',
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
