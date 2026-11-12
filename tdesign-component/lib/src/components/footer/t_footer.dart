import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text_styled.dart';
import 't_footer_theme_data.dart';

class TFooter extends StatelessWidget {
  const TFooter({Key? key, this.logo, this.text = '', this.links = const []})
    : super(key: key);

  /// 品牌内容；可与 [text] 组合展示，非空时不展示 [links]。
  final Widget? logo;

  /// 版权或说明文字；可与 links 或 logo 组合展示。
  final String text;

  /// 链接内容；仅在 logo 为空时展示，并与 text 组合。
  /// 空间不足时换行，分隔线仅绘制于同一行的相邻链接之间。
  final List<Widget> links;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TFooterThemeData>();
    final children = logo != null
        ? <Widget>[
            if (text.isNotEmpty) _renderText(context),
            if (text.isNotEmpty) SizedBox(height: context.tTheme.spacer),
            _renderLogo(),
          ]
        : <Widget>[
            if (links.isNotEmpty)
              _renderLinks(context)
            else
              _renderText(context),
          ];

    return Container(
      height: theme?.height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _renderLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: logo!,
        ),
      ],
    );
  }

  Widget _renderLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: _FooterLinks(
            dividerColor: context.tTheme.componentStroke,
            children: [
              for (final link in links)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.tTheme.spacer1,
                  ),
                  child: links.length == 1
                      ? link
                      : ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 22),
                          child: link,
                        ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Flexible(child: _renderText(context))],
          ),
        ),
      ],
    );
  }

  Widget _renderText(BuildContext context) {
    return TTextStyled(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(
        fontSize: context.tTheme.fontBodySmall?.size ?? 12,
        height: context.tTheme.fontBodySmall?.height,
        color: context.tTheme.textColorPlaceholder,
      ),
    );
  }
}

// Let Wrap lay out each link once. Dividers follow the resulting runs instead of
// participating in wrapping as separate children.
class _FooterLinks extends Wrap {
  const _FooterLinks({required this.dividerColor, required super.children})
    : super(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 1,
        runSpacing: 4,
      );

  final Color dividerColor;

  @override
  RenderWrap createRenderObject(BuildContext context) {
    final renderObject = _RenderFooterLinks(dividerColor);
    super.updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderFooterLinks renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.dividerColor = dividerColor;
  }
}

class _RenderFooterLinks extends RenderWrap {
  _RenderFooterLinks(this._dividerColor);

  Color _dividerColor;

  Color get dividerColor => _dividerColor;

  set dividerColor(Color value) {
    if (_dividerColor == value) {
      return;
    }
    _dividerColor = value;
    markNeedsPaint();
  }

  @override
  double computeMaxIntrinsicWidth(double height) =>
      super.computeMaxIntrinsicWidth(height) + spacing * (childCount - 1);

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final paint = Paint()..color = dividerColor;
    var previous = firstChild!;
    var child = childAfter(previous);
    while (child != null) {
      final previousOffset = (previous.parentData! as WrapParentData).offset;
      final childOffset = (child.parentData! as WrapParentData).offset;
      // Center-aligned children in a run overlap vertically; separate runs do not.
      if (previousOffset.dy < childOffset.dy + child.size.height &&
          childOffset.dy < previousOffset.dy + previous.size.height) {
        final x = textDirection == TextDirection.rtl
            ? childOffset.dx + child.size.width
            : previousOffset.dx + previous.size.width;
        context.canvas.drawRect(
          offset + Offset(x, childOffset.dy + (child.size.height - 22) / 2) &
              const Size(1, 22),
          paint,
        );
      }
      previous = child;
      child = childAfter(child);
    }
  }
}
