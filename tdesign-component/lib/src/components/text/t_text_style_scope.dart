import 'package:flutter/material.dart';

import '../../theme/t_theme.dart';
import 't_text_theme_data.dart';

/// 给组合组件的文字插槽同时提供 TDesign 与原生 Text 默认样式。
class TTextStyleScope extends StatelessWidget {
  const TTextStyleScope({
    required this.style,
    required this.child,
    this.maxLines,
    this.overflow,
    this.softWrap,
    super.key,
  });

  final TextStyle style;
  final Widget child;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final inherited = materialTheme.extension<TTextThemeData>();
    final textTheme = (inherited ?? const TTextThemeData()).copyWith(
      textStyle: inherited?.textStyle?.merge(style) ?? style,
    );

    return Theme(
      data: materialTheme.mergeExtension(textTheme),
      child: DefaultTextStyle.merge(
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        child: child,
      ),
    );
  }
}
