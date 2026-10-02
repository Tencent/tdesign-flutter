import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../divider/t_divider.dart';
import '../divider/t_divider_theme_data.dart';
import 't_checkbox_theme_data.dart';
import 't_selection_card.dart';

/// 选择控件相对于文案的排列方向。
enum TContentDirection {
  /// 控件位于文案右侧。
  left,

  /// 控件位于文案左侧。
  right,
}

/// 复选框指示器尺寸。
enum TCheckboxSize {
  /// 小尺寸。
  small,

  /// 中尺寸。
  medium,

  /// 大尺寸。
  large,
}

/// 自定义复选框指示器构建器。
typedef TCheckboxIconBuilder =
    Widget Function(BuildContext context, bool? value, bool disabled);

/// 严格受控的复选框；[onChanged] 为 null 时禁用。
class TCheckbox extends StatelessWidget {
  const TCheckbox({
    super.key,

    /// 受控选中态；null 表示半选。
    required this.value,

    /// 选中态变更回调；为 null 时禁用。
    this.onChanged,

    /// 主标题文案。
    this.title,

    /// 副标题文案。
    this.subTitle,

    /// 复选框尺寸。
    this.size = TCheckboxSize.medium,

    /// 是否使用卡片模式。
    this.cardMode = false,

    /// 普通模式是否显示底部分割线，默认显示；卡片模式不显示。
    this.showDivider = true,

    /// 控件与文案排列方向。
    this.contentDirection = TContentDirection.right,

    /// 主标题最大行数，默认 3 行。
    this.titleMaxLines = 3,

    /// 副标题最大行数，默认 5 行。
    this.subTitleMaxLines = 5,

    /// 自定义复选框指示器。
    this.customIconBuilder,
  });

  /// 受控选中态；null 表示半选。
  final bool? value;

  /// 选中态变更回调；为 null 时禁用。
  final ValueChanged<bool?>? onChanged;

  /// 主标题文案。
  final String? title;

  /// 副标题文案。
  final String? subTitle;

  /// 复选框尺寸。
  final TCheckboxSize size;

  /// 是否使用卡片模式。
  final bool cardMode;

  /// 普通模式是否显示底部分割线，默认显示；卡片模式不显示。
  final bool showDivider;

  /// 控件与文案排列方向。
  final TContentDirection contentDirection;

  /// 主标题最大行数，默认 3 行。
  final int titleMaxLines;

  /// 副标题最大行数，默认 5 行。
  final int subTitleMaxLines;

  /// 自定义复选框指示器。
  final TCheckboxIconBuilder? customIconBuilder;

  bool get _disabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TCheckboxThemeData>();
    final selected = value == true;
    final indicator =
        customIconBuilder?.call(context, value, _disabled) ??
        (cardMode ? null : _buildIndicator(context, theme));
    final content = _buildContent(context, theme);
    final hasContent = content != null;

    final tileContent = LayoutBuilder(
      builder: (context, layoutConstraints) {
        final preferredConstraints = hasContent
            ? BoxConstraints(minHeight: _contentMinHeight(context))
            : _resolveTapTargetConstraints(context);
        // 表格等紧凑容器可限制外盒，但不能让默认独立 Checkbox
        // 再从外部 Material CheckboxTheme 读取触控尺寸。
        final constraints = BoxConstraints(
          minWidth: math.min(
            preferredConstraints.minWidth,
            layoutConstraints.maxWidth,
          ),
          minHeight: math.min(
            preferredConstraints.minHeight,
            layoutConstraints.maxHeight,
          ),
        );
        final hasBoundedWidth = layoutConstraints.hasBoundedWidth;
        final padding = hasContent
            ? (theme?.customSpace ??
                  EdgeInsets.symmetric(
                    horizontal: theme?.insetSpacing ?? context.tTheme.spacer2,
                    vertical: cardMode
                        ? context.tTheme.spacer2 -
                              selectionCardBorderWidth(context)
                        : context.tTheme.spacer,
                  ))
            : EdgeInsets.zero;
        final spacing = cardMode
            ? 0.0
            : theme?.spacing ?? context.tTheme.spacer;
        final availableContentWidth = hasBoundedWidth && indicator != null
            ? math
                  .max(
                    0,
                    layoutConstraints.maxWidth -
                        padding.resolve(Directionality.of(context)).horizontal -
                        _indicatorSize(context) -
                        spacing,
                  )
                  .toDouble()
            : double.infinity;
        final alignContentToTop =
            hasContent &&
            _contentUsesMultipleLines(context, availableContentWidth);
        final children = <Widget>[
          if (indicator != null) indicator,
          if (indicator != null && content != null) SizedBox(width: spacing),
          if (content != null)
            if (hasBoundedWidth) Expanded(child: content) else content,
        ];
        return Container(
          constraints: cardMode ? null : constraints,
          padding: padding,
          decoration: cardMode
              ? null
              : BoxDecoration(
                  color: hasContent
                      ? context.tTheme.bgColorContainer
                      : Colors.transparent,
                ),
          child: Row(
            mainAxisSize: hasContent && hasBoundedWidth
                ? MainAxisSize.max
                : MainAxisSize.min,
            mainAxisAlignment: hasContent
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            crossAxisAlignment: alignContentToTop
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: contentDirection == TContentDirection.right
                ? children
                : children.reversed.toList(),
          ),
        );
      },
    );
    final tile = cardMode
        ? TSelectionCard(
            selected: selected,
            disabled: _disabled,
            selectedColor: theme?.selectColor ?? context.tTheme.brandColor,
            disabledColor:
                theme?.disableColor ?? context.tTheme.brandColorDisabled,
            backgroundColor:
                theme?.backgroundColor ?? context.tTheme.bgColorContainer,
            borderRadius: context.tTheme.radiusDefault,
            minHeight: _cardMinHeight(context),
            child: tileContent,
          )
        : tileContent;

    final interactiveTile = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _disabled ? null : () => onChanged!(value == true ? false : true),
      child: tile,
    );
    return Semantics(
      enabled: !_disabled,
      checked: value,
      child: !showDivider && !cardMode
          ? interactiveTile
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                interactiveTile,
                if (showDivider && !cardMode)
                  ColoredBox(
                    color: hasContent
                        ? context.tTheme.bgColorContainer
                        : Colors.transparent,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start:
                            contentDirection == TContentDirection.right &&
                                hasContent
                            ? (theme?.insetSpacing ?? context.tTheme.spacer2) +
                                  _indicatorSize(context) +
                                  (theme?.spacing ?? context.tTheme.spacer)
                            : theme?.insetSpacing ?? context.tTheme.spacer2,
                      ),
                      child: Theme(
                        data: Theme.of(context).mergeExtension(
                          const TDividerThemeData(margin: EdgeInsets.zero),
                        ),
                        child: const TDivider(),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  double _contentMinHeight(BuildContext context) => switch (size) {
    TCheckboxSize.small => context.tTheme.spacer5,
    TCheckboxSize.medium => context.tTheme.spacer5 + context.tTheme.spacer,
    TCheckboxSize.large => 64.0,
  };

  double _indicatorSize(BuildContext context) => switch (size) {
    TCheckboxSize.small => context.tTheme.spacer2 + 4.0,
    TCheckboxSize.medium => context.tTheme.spacer3,
    TCheckboxSize.large => context.tTheme.spacer3 + 4.0,
  };

  double _cardMinHeight(BuildContext context) {
    final titleHeight = _textLineHeight(_resolveTitleStyle(context));
    final contentHeight = subTitle?.isNotEmpty == true
        ? titleHeight + 4.0 + _textLineHeight(_resolveSubTitleStyle(context))
        : titleHeight;
    return contentHeight + context.tTheme.spacer2 * 2;
  }

  double _textLineHeight(TextStyle style) =>
      style.fontSize! * (style.height ?? 1);

  BoxConstraints _resolveTapTargetConstraints(BuildContext context) {
    const visualDensity = VisualDensity.standard;
    const tapTargetSize = MaterialTapTargetSize.padded;
    final indicatorSize = _indicatorSize(context);
    final baseSize = tapTargetSize == MaterialTapTargetSize.padded
        ? kMinInteractiveDimension
        : indicatorSize;
    final adjustment = visualDensity.baseSizeAdjustment;
    return BoxConstraints(
      minWidth: math.max(indicatorSize, baseSize + adjustment.dx),
      minHeight: math.max(indicatorSize, baseSize + adjustment.dy),
    );
  }

  Widget _buildIndicator(BuildContext context, TCheckboxThemeData? theme) {
    final variant = theme?.variant ?? TCheckboxVariant.circle;
    final selected = value == true;
    final indeterminate = value == null;
    final icon = switch (variant) {
      TCheckboxVariant.circle =>
        indeterminate
            ? TIcons.minus_circle_filled
            : selected
            ? TIcons.check_circle_filled
            : TIcons.circle,
      TCheckboxVariant.square => null,
      TCheckboxVariant.check =>
        selected || indeterminate
            ? (indeterminate ? TIcons.minus : TIcons.check)
            : null,
    };
    final color = _disabled
        ? (theme?.disableColor ?? context.tTheme.brandColorDisabled)
        : selected || indeterminate
        ? (theme?.selectColor ?? context.tTheme.brandColor)
        : context.tTheme.componentBorder;
    final indicatorSize = _indicatorSize(context);
    if (variant == TCheckboxVariant.square) {
      return _buildSquareIndicator(
        context,
        indicatorSize: indicatorSize,
        selected: selected,
        indeterminate: indeterminate,
        color: color,
        theme: theme,
      );
    }
    if (_disabled &&
        !selected &&
        !indeterminate &&
        variant != TCheckboxVariant.check) {
      final borderColor = theme?.disableColor ?? context.tTheme.componentBorder;
      return Container(
        width: indicatorSize,
        height: indicatorSize,
        decoration: BoxDecoration(
          color: context.tTheme.bgColorComponentDisabled,
          border: Border.all(color: borderColor),
          shape: variant == TCheckboxVariant.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: variant == TCheckboxVariant.square
              ? BorderRadius.circular(context.tTheme.radiusSmall)
              : null,
        ),
      );
    }
    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: icon == null
          ? null
          : Icon(icon, size: indicatorSize, color: color),
    );
  }

  Widget _buildSquareIndicator(
    BuildContext context, {
    required double indicatorSize,
    required bool selected,
    required bool indeterminate,
    required Color color,
    required TCheckboxThemeData? theme,
  }) {
    const radius = BorderRadius.all(Radius.circular(1.5));
    final active = selected || indeterminate;
    final fillColor = _disabled && !active
        ? context.tTheme.bgColorComponentDisabled
        : active
        ? color
        : Colors.transparent;
    final borderColor = _disabled && !active
        ? theme?.disableColor ?? context.tTheme.componentBorder
        : active
        ? color
        : context.tTheme.componentBorder;
    final mark = indeterminate
        ? TIcons.minus
        : selected
        ? TIcons.check
        : null;
    return Container(
      key: const ValueKey('checkbox-square-indicator'),
      width: indicatorSize,
      height: indicatorSize,
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor),
        borderRadius: radius,
      ),
      alignment: Alignment.center,
      child: mark == null
          ? null
          : Icon(
              mark,
              size: indicatorSize * 0.75,
              color: context.tTheme.textColorAnti,
            ),
    );
  }

  bool _contentUsesMultipleLines(BuildContext context, double maxWidth) {
    if (title != null && subTitle != null) {
      return true;
    }
    final text = title ?? subTitle;
    if (text == null || text.isEmpty) {
      return false;
    }
    final style = title != null
        ? _resolveTitleStyle(context)
        : _resolveSubTitleStyle(context);
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: title != null ? titleMaxLines : subTitleMaxLines,
    )..layout(maxWidth: maxWidth);
    final multipleLines = painter.computeLineMetrics().length > 1;
    painter.dispose();
    return multipleLines;
  }

  TextStyle _resolveTitleStyle(BuildContext context) {
    final titleFont = context.tTheme.fontBodyLarge;
    return TextStyle(
      fontSize: titleFont?.size ?? 16,
      height: titleFont?.height,
      fontWeight: titleFont?.fontWeight,
    );
  }

  TextStyle _resolveSubTitleStyle(BuildContext context) {
    final subtitleFont = context.tTheme.fontBodyMedium;
    return TextStyle(
      fontSize: subtitleFont?.size ?? 14,
      height: subtitleFont?.height,
      fontWeight: subtitleFont?.fontWeight,
    );
  }

  Widget? _buildContent(BuildContext context, TCheckboxThemeData? theme) {
    if (title == null && subTitle == null) {
      return null;
    }
    final titleStyle = _resolveTitleStyle(context);
    final subTitleStyle = _resolveSubTitleStyle(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: titleStyle.copyWith(
              color: _disabled
                  ? context.tTheme.textColorDisabled
                  : (theme?.titleColor ?? context.tTheme.textColorPrimary),
            ),
          ),
        if (title != null && subTitle != null) const SizedBox(height: 4.0),
        if (subTitle != null)
          Text(
            subTitle!,
            maxLines: subTitleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: subTitleStyle.copyWith(
              color: _disabled
                  ? context.tTheme.textColorDisabled
                  : (theme?.subTitleColor ?? context.tTheme.textColorSecondary),
            ),
          ),
      ],
    );
  }
}
