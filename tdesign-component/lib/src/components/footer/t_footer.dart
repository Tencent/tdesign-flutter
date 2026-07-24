import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../image/t_image.dart';
import '../link/t_link.dart';
import 't_footer_theme_data.dart';

/// 页脚形态
enum TFooterVariant {
  /// 文字样式
  text,

  /// 链接样式
  link,

  /// 品牌样式
  brand,
}

class TFooter extends StatelessWidget {
  const TFooter(
    this.variant, {
    Key? key,
    this.logo,
    this.text = '',
    this.links = const [],
    this.width,
  }) : super(key: key);

  /// 品牌图片
  final String? logo;

  /// 页脚形态
  final TFooterVariant variant;

  /// 文字
  final String text;

  /// 自定义图片宽
  final double? width;

  /// 链接
  final List<TLink> links;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TFooterThemeData>();
    var children = <Widget>[];

    switch (variant) {
      case TFooterVariant.text:
        children = [_renderText(context)];
        break;
      case TFooterVariant.link:
        children = [
          if (links.isNotEmpty) _renderLinks(context) else _renderText(context)
        ];
        break;
      case TFooterVariant.brand:
        children = [if (logo != null) _renderLogo() else _renderText(context)];
        break;
    }

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
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: TImage(
          src: logo,
          variant: TImageVariant.fitWidth,
          width: width,
        ),
      )
    ]);
  }

  Widget _renderLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(links.length, (index) {
              var link = links[index];
              return Container(
                decoration: index < (links.length - 1)
                    ? BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: context.tTheme.textColorPlaceholder)))
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: link,
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Flexible(child: _renderText(context))]),
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
