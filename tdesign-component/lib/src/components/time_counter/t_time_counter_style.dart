part of 't_time_counter.dart';

// Figma CountDown highlight variant uses an 18dp number in a 24dp line box.
const _highlightLineHeight = 24.0;

/// 计时组件样式
class _TTimeCounterStyle {
  /// 时间容器宽度
  double? timeWidth;

  /// 时间容器高度
  double? timeHeight;

  /// 时间容器内边距
  EdgeInsets? timePadding;

  /// 时间容器外边距
  EdgeInsets? timeMargin;

  /// 时间容器装饰
  BoxDecoration? timeBox;

  /// 时间字体
  FontFamily? timeFontFamily;

  /// 时间字体尺寸
  double? timeFontSize;

  /// 时间字体行高
  double? timeFontHeight;

  /// 时间字体粗细
  FontWeight? timeFontWeight;

  /// 时间字体颜色
  Color? timeColor;

  /// 分隔符字体尺寸
  double? splitFontSize;

  /// 分隔符字体行高
  double? splitFontHeight;

  /// 分隔符字体粗细
  FontWeight? splitFontWeight;

  /// 分隔符字体颜色
  Color? splitColor;

  /// 时间与分隔符的间隔
  double? space;

  /// 生成默认样式
  _TTimeCounterStyle.generateStyle(
    BuildContext context, {
    TTimeCounterSize? size,
    TTimeCounterVariant? variant,
    bool? splitWithUnit,
  }) {
    timeFontFamily = context.tTheme.numberFontFamily;
    final effectiveSize = size ?? TTimeCounterSize.medium;
    final effectiveVariant = variant ?? TTimeCounterVariant.plain;
    final hasUnit = splitWithUnit ?? false;
    late Font? defaultFont;
    late Font? blockFont;
    late Font? unitFont;
    late double blockExtent;
    late double unitSpace;
    late double dotSpace;
    switch (effectiveSize) {
      case TTimeCounterSize.small:
        defaultFont = context.tTheme.fontBodyMedium;
        blockFont = context.tTheme.fontBodySmall;
        unitFont = context.tTheme.fontBodyExtraSmall;
        blockExtent = 20;
        unitSpace = 4;
        dotSpace = 2;
        break;
      case TTimeCounterSize.medium:
        defaultFont = context.tTheme.fontBodyLarge;
        blockFont = context.tTheme.fontBodyMedium;
        unitFont = context.tTheme.fontBodySmall;
        blockExtent = 24;
        unitSpace = 5;
        dotSpace = 3;
        break;
      case TTimeCounterSize.large:
        defaultFont = context.tTheme.fontBodyExtraLarge;
        blockFont = context.tTheme.fontBodyLarge;
        unitFont = context.tTheme.fontBodyMedium;
        blockExtent = 28;
        unitSpace = 6;
        dotSpace = 6;
    }

    final timeFont = switch (effectiveVariant) {
      TTimeCounterVariant.plain => defaultFont,
      TTimeCounterVariant.highlight => context.tTheme.fontBodyExtraLarge,
      TTimeCounterVariant.round || TTimeCounterVariant.square => blockFont,
    };
    final splitFont = hasUnit
        ? effectiveVariant == TTimeCounterVariant.highlight
              ? context.tTheme.fontBodyExtraSmall
              : unitFont
        : defaultFont;
    timeFontSize = timeFont?.size;
    timeFontWeight = timeFont?.fontWeight;
    timeFontHeight = switch (effectiveVariant) {
      TTimeCounterVariant.plain => timeFont?.height,
      TTimeCounterVariant.highlight =>
        timeFont?.size == null ? null : _highlightLineHeight / timeFont!.size,
      TTimeCounterVariant.round || TTimeCounterVariant.square => null,
    };
    splitFontSize = splitFont?.size;
    splitFontWeight = splitFont?.fontWeight;
    splitFontHeight = hasUnit ? splitFont?.height : timeFontHeight;
    final hasBlock =
        effectiveVariant == TTimeCounterVariant.round ||
        effectiveVariant == TTimeCounterVariant.square;
    timeWidth = timeHeight = hasBlock ? blockExtent : null;
    space = hasUnit
        ? unitSpace
        : !hasBlock
        ? 0
        : dotSpace;

    switch (effectiveVariant) {
      case TTimeCounterVariant.round:
        timeBox = BoxDecoration(
          shape: BoxShape.circle,
          color: context.tTheme.errorNormalColor,
        );
        timeColor = context.tTheme.textColorAnti;
        splitColor = context.tTheme.errorNormalColor;
        break;
      case TTimeCounterVariant.square:
        timeBox = BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
          color: context.tTheme.errorNormalColor,
        );
        timeColor = context.tTheme.textColorAnti;
        splitColor = context.tTheme.errorNormalColor;
        break;
      case TTimeCounterVariant.plain:
        timeBox = null;
        timeColor = splitColor = context.tTheme.textColorPrimary;
        timeWidth = null;
        timeHeight = null;
        break;
      case TTimeCounterVariant.highlight:
        timeBox = null;
        timeColor = context.tTheme.errorNormalColor;
        splitColor = context.tTheme.textColorPrimary;
        timeWidth = null;
        timeHeight = null;
        break;
    }

    if (hasUnit) {
      // 单位是正文标签，不沿用数字块或标点的强调色。
      splitColor = context.tTheme.textColorPrimary;
    }
  }
}
