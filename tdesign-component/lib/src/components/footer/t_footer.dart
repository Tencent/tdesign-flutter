import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_footer_theme_data.dart';

/// 页面底部的版权、链接和品牌信息区域。
class TFooter extends StatelessWidget {
  const TFooter({Key? key, this.logo, this.text = '', this.links = const []})
    : super(key: key);

  /// 品牌内容；非空时优先展示，不再展示 [links] 和 [text]。
  final Widget? logo;

  /// 文字
  final String text;

  /// 链接内容；多个链接之间自动绘制分隔线。
  final List<Widget> links;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TFooterThemeData>();
    final children = logo != null
        ? <Widget>[_renderLogo()]
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
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: IntrinsicWidth(child: links[index]),
                ),
                if (index < links.length - 1)
                  SizedBox(
                    width: 1,
                    height: 22,
                    child: ColoredBox(
                      color: context.tTheme.textColorPlaceholder,
                    ),
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
