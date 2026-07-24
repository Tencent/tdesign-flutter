import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../divider/t_divider.dart';
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
typedef TCheckboxIconBuilder = Widget Function(
  BuildContext context,
  bool? value,
  bool disabled,
);

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

    /// 是否显示底部分割线。
    this.showDivider = false,

    /// 控件与文案排列方向。
    this.contentDirection = TContentDirection.right,

    /// 主标题最大行数。
    this.titleMaxLines = 1,

    /// 副标题最大行数。
    this.subTitleMaxLines = 1,

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

  /// 是否显示底部分割线。
  final bool showDivider;

  /// 控件与文案排列方向。
  final TContentDirection contentDirection;

  /// 主标题最大行数。
  final int titleMaxLines;

  /// 副标题最大行数。
  final int subTitleMaxLines;

  /// 自定义复选框指示器。
  final TCheckboxIconBuilder? customIconBuilder;

  bool get _disabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TCheckboxThemeData>();
    final selected = value == true;
    final indicator = customIconBuilder?.call(context, value, _disabled) ??
        (cardMode ? null : _buildIndicator(context, theme));
    final content = _buildContent(context, theme);
    final hasContent = content != null;
    final children = <Widget>[
      if (indicator != null) indicator,
      if (indicator != null && content != null)
        SizedBox(
          width: cardMode ? 0 : theme?.spacing ?? context.tTheme.spacer8,
        ),
      if (content != null) Expanded(child: content),
    ];

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: contentDirection == TContentDirection.right
          ? children
          : children.reversed.toList(),
    );
    final constraints = hasContent
        ? BoxConstraints(
            minHeight: switch (size) {
              TCheckboxSize.small => 40.0,
              TCheckboxSize.medium => 48.0,
              TCheckboxSize.large => 56.0,
            },
          )
        : _resolveTapTargetConstraints(context);

    final tileContent = Container(
      constraints: cardMode ? null : constraints,
      padding: hasContent
          ? (theme?.customSpace ??
              EdgeInsets.symmetric(
                horizontal: theme?.insetSpacing ?? context.tTheme.spacer16,
                vertical: context.tTheme.spacer8,
              ))
          : EdgeInsets.zero,
      decoration: cardMode
          ? null
          : BoxDecoration(
              color: hasContent
                  ? context.tTheme.bgColorContainer
                  : Colors.transparent,
            ),
      child: row,
    );
    final tile = cardMode
        ? TSelectionCard(
            selected: selected,
            disabled: _disabled,
            selectedColor:
                theme?.selectColor ?? context.tTheme.brandNormalColor,
            disabledColor:
                theme?.disableColor ?? context.tTheme.brandDisabledColor,
            backgroundColor:
                theme?.backgroundColor ?? context.tTheme.bgColorContainer,
            borderRadius: context.tTheme.radiusDefault,
            minHeight: subTitle?.isNotEmpty == true ? 82 : 56,
            child: tileContent,
          )
        : tileContent;

    return Semantics(
      enabled: !_disabled,
      checked: value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _disabled
                ? null
                : () => onChanged!(value == true ? false : true),
            child: tile,
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.only(left: context.tTheme.spacer16),
              child: const TDivider(),
            ),
        ],
      ),
    );
  }

  BoxConstraints _resolveTapTargetConstraints(BuildContext context) {
    final materialTheme = CheckboxTheme.of(context);
    final appTheme = Theme.of(context);
    final visualDensity = materialTheme.visualDensity ?? appTheme.visualDensity;
    final tapTargetSize =
        materialTheme.materialTapTargetSize ?? appTheme.materialTapTargetSize;
    final indicatorSize = switch (size) {
      TCheckboxSize.small => 20.0,
      TCheckboxSize.medium => 24.0,
      TCheckboxSize.large => 28.0,
    };
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
    final variant = theme?.variant ?? TCheckboxVariant.square;
    final selected = value == true;
    final indeterminate = value == null;
    final icon = switch (variant) {
      TCheckboxVariant.circle => indeterminate
          ? TIcons.minus_circle_filled
          : selected
              ? TIcons.check_circle_filled
              : TIcons.circle,
      TCheckboxVariant.square => indeterminate
          ? TIcons.minus_rectangle_filled
          : selected
              ? TIcons.check_rectangle_filled
              : TIcons.rectangle,
      TCheckboxVariant.check => selected || indeterminate
          ? (indeterminate ? TIcons.minus : TIcons.check)
          : null,
    };
    final color = _disabled
        ? (theme?.disableColor ?? context.tTheme.brandDisabledColor)
        : selected || indeterminate
            ? (theme?.selectColor ?? context.tTheme.brandNormalColor)
            : context.tTheme.componentBorderColor;
    final iconSize = switch (size) {
      TCheckboxSize.small => 20.0,
      TCheckboxSize.medium => 24.0,
      TCheckboxSize.large => 28.0,
    };
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: icon == null ? null : Icon(icon, size: iconSize, color: color),
    );
  }

  Widget? _buildContent(BuildContext context, TCheckboxThemeData? theme) {
    if (title == null && subTitle == null) {
      return null;
    }
    final titleColor = _disabled
        ? context.tTheme.textDisabledColor
        : (theme?.titleColor ?? context.tTheme.textColorPrimary);
    final subTitleColor = _disabled
        ? context.tTheme.textDisabledColor
        : (theme?.subTitleColor ?? context.tTheme.textColorPlaceholder);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontSize: context.tTheme.fontBodyLarge?.size,
            ),
          ),
        if (title != null && subTitle != null)
          SizedBox(height: context.tTheme.spacer4),
        if (subTitle != null)
          Text(
            subTitle!,
            maxLines: subTitleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: subTitleColor,
              fontSize: context.tTheme.fontBodyMedium?.size,
            ),
          ),
      ],
    );
  }
}
