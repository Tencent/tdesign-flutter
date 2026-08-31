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
            ExampleItem(desc: '标题 Title', builder: _buildTitle),
            ExampleItem(desc: '段落 Paragraph', builder: _buildParagraph),
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
          title: '可复制',
          children: [
            ExampleItem(desc: '可复制文本', builder: _buildCopyable),
            ExampleItem(desc: '可复制并展开收起', builder: _buildCopyableExpandable),
          ],
        ),
        ExampleModule(
          title: '文本省略（展开/收起）',
          children: [
            ExampleItem(desc: '可展开收起', builder: _buildExpandable),
            ExampleItem(desc: '标题省略', builder: _buildTitleExpandable),
            ExampleItem(desc: '段落省略', builder: _buildParagraphExpandable),
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
  Widget _buildTitle(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TTitle('一级标题', level: TTitleLevel.h1),
        TTitle('二级标题', level: TTitleLevel.h2),
        TTitle('三级标题', level: TTitleLevel.h3),
      ],
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildParagraph(BuildContext context) {
    return const TParagraph(
      '这是 TDesign 段落组件，使用语义化多行正文排版，'
      '默认字号为 14，用于展示正文内容。',
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
  Widget _buildCopyable(BuildContext context) {
    return const TText(
      '点击右侧图标复制这段文本',
      copyable: true,
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildCopyableExpandable(BuildContext context) {
    return const SizedBox(
      width: 260,
      child: TText(
        '这是一段可复制且可展开收起的较长文本，'
        '超出两行时显示展开操作，展开后可复制整段内容。',
        maxLines: 2,
        copyable: true,
        expandable: true,
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildExpandable(BuildContext context) {
    return const SizedBox(
      width: 260,
      child: TText(
        '这是一段用于展示展开收起能力的较长文本，'
        '默认只显示两行，点击「展开」查看完整内容，'
        '展开后可点击「收起」恢复两行显示。',
        maxLines: 2,
        expandable: true,
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildTitleExpandable(BuildContext context) {
    return const SizedBox(
      width: 260,
      child: TTitle(
        '这是一段支持省略展开的标题内容，超出单行后显示展开操作',
        level: TTitleLevel.h4,
        maxLines: 1,
        expandable: true,
      ),
    );
  }

  @ExampleCode(group: 'text')
  Widget _buildParagraphExpandable(BuildContext context) {
    return const SizedBox(
      width: 260,
      child: TParagraph(
        '这是一段支持省略展开的段落内容，默认显示两行，'
        '点击「展开」可查看完整段落，展开后可点击「收起」恢复。',
        maxLines: 2,
        expandable: true,
      ),
    );
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
