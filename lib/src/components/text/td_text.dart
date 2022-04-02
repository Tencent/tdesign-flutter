import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

/// 文本控件
class TDText extends StatelessWidget {
  final String? content;
  final Font? font;
  final FontWeight fontWeight;
  final FontFamily? fontFamily;
  final Color textColor;
  final EdgeInsets? padding;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  /// 是否是横线穿过样式
  final bool? isTextThrough;
  final Color? lineThroughColor;
  final bool showHeight;

  const TDText(this.content,
      {this.font,
      this.fontFamily,
      this.fontWeight = FontWeight.w500,
      this.textColor = Colors.black,
      this.maxLines = 0x7fffffff,
      this.padding = EdgeInsets.zero,
      this.overflow = TextOverflow.ellipsis,
      this.isTextThrough = false,
      this.lineThroughColor = Colors.white,
      this.textAlign,
      this.showHeight = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textFont =
        font ?? TDTheme.of(context).fontM ?? Font(size: 16, lineHeight: 24);
    return Container(
      padding: padding,
      child: Text(
        content ?? '',
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: textFont.size,
          height: showHeight ? textFont.height : null,
          fontWeight: fontWeight,
          package: 'tdesign_flutter',
          fontFamily: fontFamily?.fontFamily,
          decoration:
              isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: lineThroughColor,
          color: textColor,
        ),
      ),
    );
  }
}
