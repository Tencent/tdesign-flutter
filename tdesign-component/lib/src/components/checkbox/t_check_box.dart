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

    final constraints = hasContent
        ? BoxConstraints(minHeight: _contentMinHeight)
        : _resolveTapTargetConstraints(context);

    final tileContent = LayoutBuilder(
      builder: (context, layoutConstraints) {
        final hasBoundedWidth = layoutConstraints.hasBoundedWidth;
        final children = <Widget>[
          if (indicator != null) indicator,
          if (indicator != null && content != null)
            SizedBox(
              width: cardMode ? 0 : theme?.spacing ?? context.tTheme.spacer8,
            ),
          if (content != null)
            if (hasBoundedWidth) Expanded(child: content) else content,
        ];
        return Container(
          constraints: cardMode ? null : constraints,
          padding: hasContent
              ? (theme?.customSpace ??
                    EdgeInsets.symmetric(
                      horizontal:
                          theme?.insetSpacing ?? context.tTheme.spacer16,
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
          child: Row(
            mainAxisSize: hasContent && hasBoundedWidth
                ? MainAxisSize.max
                : MainAxisSize.min,
            mainAxisAlignment: hasContent
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
          if (showDivider && !cardMode)
            Padding(
              padding: EdgeInsets.only(left: context.tTheme.spacer16),
              child: Theme(
                data: Theme.of(context).mergeExtension(
                  const TDividerThemeData(margin: EdgeInsets.zero),
                ),
                child: const TDivider(),
              ),
            ),
        ],
      ),
    );
  }

  double get _contentMinHeight => switch (size) {
    TCheckboxSize.small => 48.0,
    TCheckboxSize.medium => 56.0,
    TCheckboxSize.large => 64.0,
  };

  double get _indicatorSize => switch (size) {
    TCheckboxSize.small => 20.0,
    TCheckboxSize.medium => 24.0,
    TCheckboxSize.large => 28.0,
  };

  BoxConstraints _resolveTapTargetConstraints(BuildContext context) {
    final materialTheme = CheckboxTheme.of(context);
    final appTheme = Theme.of(context);
    final visualDensity =
        materialTheme.visualDensity ??
        appTheme.tExplicitVisualDensity ??
        VisualDensity.standard;
    final tapTargetSize =
        materialTheme.materialTapTargetSize ??
        appTheme.tExplicitMaterialTapTargetSize ??
        MaterialTapTargetSize.padded;
    final baseSize = tapTargetSize == MaterialTapTargetSize.padded
        ? kMinInteractiveDimension
        : _indicatorSize;
    final adjustment = visualDensity.baseSizeAdjustment;
    return BoxConstraints(
      minWidth: math.max(_indicatorSize, baseSize + adjustment.dx),
      minHeight: math.max(_indicatorSize, baseSize + adjustment.dy),
    );
  }

  Widget _buildIndicator(BuildContext context, TCheckboxThemeData? theme) {
    final materialTheme = CheckboxTheme.of(context);
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    final variant = theme?.variant ?? TCheckboxVariant.circle;
    final selected = value == true;
    final indeterminate = value == null;
    final states = <WidgetState>{
      if (selected || indeterminate) WidgetState.selected,
      if (_disabled) WidgetState.disabled,
    };
    final icon = switch (variant) {
      TCheckboxVariant.circle =>
        indeterminate
            ? TIcons.minus_circle_filled
            : selected
            ? TIcons.check_circle_filled
            : TIcons.circle,
      TCheckboxVariant.square =>
        indeterminate
            ? TIcons.minus_rectangle_filled
            : selected
            ? TIcons.check_rectangle_filled
            : TIcons.rectangle,
      TCheckboxVariant.check =>
        selected || indeterminate
            ? (indeterminate ? TIcons.minus : TIcons.check)
            : null,
    };
    final color = _disabled
        ? (theme?.disableColor ??
              materialTheme.fillColor?.resolve(states) ??
              colorScheme?.onSurface.withValues(alpha: 0.38) ??
              context.tTheme.brandDisabledColor)
        : selected || indeterminate
        ? (theme?.selectColor ??
              materialTheme.fillColor?.resolve(states) ??
              colorScheme?.primary ??
              context.tTheme.brandNormalColor)
        : (materialTheme.side?.color ??
              colorScheme?.outline ??
              context.tTheme.componentBorderColor);
    return SizedBox(
      width: _indicatorSize,
      height: _indicatorSize,
      child: icon == null
          ? null
          : Icon(icon, size: _indicatorSize, color: color),
    );
  }

  Widget? _buildContent(BuildContext context, TCheckboxThemeData? theme) {
    if (title == null && subTitle == null) {
      return null;
    }
    final materialTextTheme = Theme.of(context).tExplicitTextTheme;
    final titleFont = context.tTheme.fontBodyLarge;
    final titleStyle = TextStyle(
      fontSize: titleFont?.size ?? 16,
      height: titleFont?.height,
      fontWeight: titleFont?.fontWeight ?? FontWeight.w400,
    ).merge(materialTextTheme?.bodyLarge ?? materialTextTheme?.bodyMedium);
    final subtitleFont = context.tTheme.fontBodyMedium;
    final subTitleStyle = TextStyle(
      fontSize: subtitleFont?.size ?? 14,
      height: subtitleFont?.height,
      fontWeight: subtitleFont?.fontWeight ?? FontWeight.w400,
    ).merge(materialTextTheme?.bodyMedium ?? materialTextTheme?.bodySmall);
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
                  ? context.tTheme.textDisabledColor
                  : (theme?.titleColor ?? context.tTheme.textColorPrimary),
            ),
          ),
        if (title != null && subTitle != null)
          SizedBox(height: context.tTheme.spacer4),
        if (subTitle != null)
          Text(
            subTitle!,
            maxLines: subTitleMaxLines,
            overflow: TextOverflow.ellipsis,
            style: subTitleStyle.copyWith(
              color: _disabled
                  ? context.tTheme.textDisabledColor
                  : (theme?.subTitleColor ?? context.tTheme.textColorSecondary),
            ),
          ),
      ],
    );
  }
}
