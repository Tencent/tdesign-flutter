import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

class TTextPage extends StatelessWidget {
  const TTextPage({Key? key}) : super(key: key);

  static const exampleText = '文本 Text';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc:
          '用于展示文本，支持普通文本和富文本两种模式，并复用 Flutter '
          '原生排版、缩放、语义与选择能力。',
      exampleCodeGroup: 'text',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '普通文本', builder: _buildPlainText),
            ExampleItem(desc: '富文本', builder: _buildRichText),
          ],
        ),
        ExampleModule(
          title: '文本样式',
          children: [
            ExampleItem(desc: '字体 Token 与颜色', builder: _buildTokenStyle),
            ExampleItem(desc: '字重与删除线', builder: _buildDecoration),
            ExampleItem(desc: '字形背景与行盒背景', builder: _buildBackground),
            ExampleItem(desc: '字体族与资源 package', builder: _buildFontFamily),
          ],
        ),
        ExampleModule(
          title: '段落与辅助能力',
          children: [
            ExampleItem(desc: '多行省略', builder: _buildOverflow),
            ExampleItem(desc: '对齐与文字缩放', builder: _buildLayout),
            ExampleItem(desc: '文字选择与语义', builder: _buildAccessibleText),
            ExampleItem(desc: '获取 Flutter 原生 Text', builder: _buildRawText),
          ],
        ),
        ExampleModule(
          title: '组件主题',
          children: [ExampleItem(desc: '子树默认样式', builder: _buildThemeDemo)],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildPlainText(BuildContext context) {
    return const TText(exampleText);
  }

  @ExampleCode(group: 'text')
  Widget _buildRichText(BuildContext context) {
    return TText.rich(
      TextSpan(
        children: [
          const TextSpan(text: '使用 '),
          TTextSpan(
            text: 'TTextSpan',
            fontWeight: FontWeight.w600,
            textColor: context.tTheme.brandNormalColor,
          ),
          const TextSpan(text: ' 组合局部样式 '),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(TIcons.check_circle, size: 20),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildTokenStyle(BuildContext context) {
    return TText(
      exampleText,
      font: context.tTheme.fontHeadlineSmall,
      textColor: context.tTheme.brandNormalColor,
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildDecoration(BuildContext context) {
    return TText(
      '已失效文本',
      fontWeight: FontWeight.w600,
      isTextThrough: true,
      lineThroughColor: context.tTheme.errorNormalColor,
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildBackground(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TText(
          '字形背景',
          style: TextStyle(backgroundColor: context.tTheme.brandFocusColor),
        ),
        const SizedBox(height: 12),
        ColoredBox(
          color: context.tTheme.brandFocusColor,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TText('行盒背景'),
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildFontFamily(BuildContext context) {
    return TText(
      '0123456789',
      fontFamily: FontFamily(
        fontFamily: 'TCloudNumber',
        package: 'tdesign_flutter',
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildOverflow(BuildContext context) {
    return const SizedBox(
      width: 240,
      child: TText(
        '这是一段用于展示多行省略的较长文本，超出两行后使用省略号。',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildLayout(BuildContext context) {
    return const SizedBox(
      width: 240,
      child: TText(
        '居中文本 Text',
        textAlign: TextAlign.center,
        textScaler: TextScaler.linear(1.25),
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildAccessibleText(BuildContext context) {
    return SelectionArea(
      child: TText(
        '长按或拖拽选择这段文本',
        semanticsLabel: '可选择的示例文本',
        semanticsIdentifier: 't-text-selection-example',
        selectionColor: context.tTheme.brandFocusColor,
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildRawText(BuildContext context) {
    return const TText(exampleText).getRawText(context: context);
  }

  @ExampleCode(group: 'text')
  Widget _buildThemeDemo(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ...Theme.of(context).extensions.values,
          TTextThemeData(
            font: context.tTheme.fontTitleLarge,
            textStyle: TextStyle(color: context.tTheme.brandNormalColor),
          ),
        ],
      ),
      child: const TText('继承 TTextThemeData 的默认样式'),
    );
  }
}
