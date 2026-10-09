import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_footer_theme_data.dart';

class TFooter extends StatelessWidget {
  const TFooter({Key? key, this.logo, this.text = '', this.links = const []})
    : super(key: key);

  /// 品牌内容；可与 [text] 组合展示，非空时不展示 [links]。
  final Widget? logo;

  /// 版权或说明文字；可与 links 或 logo 组合展示。
  final String text;

  /// 链接内容；仅在 logo 为空时展示，并与 text 组合。多个链接之间自动绘制分隔线。
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
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (var index = 0; index < links.length; index++) ...[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.tTheme.spacer1,
                  ),
                  child: IntrinsicWidth(child: links[index]),
                ),
                if (index < links.length - 1)
                  SizedBox(
                    width: 1,
                    height: 22,
                    child: ColoredBox(color: context.tTheme.componentStroke),
                  ),
              ],
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
    return Text(
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
