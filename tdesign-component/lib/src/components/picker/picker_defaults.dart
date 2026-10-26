import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text_styled.dart';
import '../text/t_text_theme_data.dart';
import 't_picker_theme_data.dart';

const double defaultPickerHeight = 200;
const int defaultPickerItemCount = 5;

/// 默认视窗为内置文字的自然行高预留空间；显式高度仍由调用方控制。
/// 自定义 Widget 的尺寸契约由构建器负责，不推测其内容高度。
double resolvePickerHeight(BuildContext context, {bool customContent = false}) {
  final theme = Theme.of(context).extension<TPickerThemeData>();
  if (theme?.height != null) {
    return theme!.height!;
  }
  if (customContent) {
    return defaultPickerHeight;
  }
  final token = context.tTheme;
  var lineHeight = 0.0;
  for (final font in [token.fontBodyLarge, token.fontMarkLarge]) {
    final defaults = TextStyle(
      fontSize: font?.size ?? 16,
      height: font?.height,
      fontWeight: font?.fontWeight,
    );
    final size = TTextStyled(
      '国Ag',
      style: defaults.merge(
        Theme.of(context).extension<TTextThemeData>()?.textStyle,
      ),
      maxLines: 1,
    ).naturalSize(context);
    lineHeight = math.max(lineHeight, size.height);
  }
  return math.max(
    defaultPickerHeight,
    lineHeight * (theme?.itemCount ?? defaultPickerItemCount),
  );
}
