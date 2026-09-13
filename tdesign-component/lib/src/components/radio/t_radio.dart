import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../checkbox/t_check_box.dart' show TContentDirection;
import '../checkbox/t_selection_card.dart';
import '../divider/t_divider.dart';
import '../divider/t_divider_theme_data.dart';
import 't_radio_theme_data.dart';

/// 自定义单选框指示器构建器。
typedef TRadioIconBuilder =
    Widget Function(BuildContext context, bool selected, bool disabled);

/// 单选框指示器尺寸。
enum TRadioSize {
  /// 小尺寸。
  small,

  /// 中尺寸。
  medium,

  /// 大尺寸。
  large,
}

/// 单选框内置指示器样式。
enum TRadioIconType {
  /// 圆环内显示实心圆点。
  dot,

  /// 选中时显示勾选标记。
  check,

  /// 选中时显示带反色勾选标记的实心圆。
  fill,
}

/// 单选框的完整视觉结构。
enum TRadioVariant {
  /// 行内结构，不绘制通栏背景、外围内边距或标准块高。
  inline,

  /// 通栏结构，使用标准块高、容器背景和外围内边距。
  block,

  /// 卡片结构。
  card,
}

@immutable
/// 单选框组的数据项。
class TRadioOption<T> {
  const TRadioOption({
    /// 选项值。
    required this.value,

    /// 主文案。
    required this.label,

    /// 副文案。
    this.subTitle,

    /// 是否禁用该项。
    this.disabled = false,
  });

  /// 选项值。
  final T value;

  /// 主文案。
  final String label;

  /// 副文案。
  final String? subTitle;

  /// 是否禁用该项。
  final bool disabled;
}

/// 由最近的 [TRadioGroup] 控制选中状态的单选框。
class TRadio<T> extends StatelessWidget {
  const TRadio({
    super.key,

    /// 当前选项值。
    required this.value,

    /// 主标题文案。
    this.title,

    /// 副标题文案。
    this.subTitle,

    /// 单选框尺寸。
    this.size = TRadioSize.medium,

    /// 内置指示器样式；[customIconBuilder] 非空时以自定义指示器为准。
    this.iconType = TRadioIconType.fill,

    /// 完整视觉结构，默认使用通栏结构。
    this.variant = TRadioVariant.block,

    /// 是否禁用当前选项。
    this.disabled = false,

    /// 控件与文案排列方向。
    this.contentDirection = TContentDirection.right,

    /// 主标题最大行数，默认 3 行。
    this.titleMaxLines = 3,

    /// 副标题最大行数，默认 5 行。
    this.subTitleMaxLines = 5,

    /// 自定义单选框指示器。
    this.customIconBuilder,
  });

  /// 当前选项值。
  final T value;

  /// 主标题文案。
  final String? title;

  /// 副标题文案。
  final String? subTitle;

  /// 单选框尺寸。
  final TRadioSize size;

  /// 内置指示器样式。
  final TRadioIconType iconType;

  /// 完整视觉结构。
  final TRadioVariant variant;

  /// 是否禁用当前选项。
  final bool disabled;

  /// 控件与文案排列方向。
  final TContentDirection contentDirection;

  /// 主标题最大行数，默认 3 行。
  final int titleMaxLines;

  /// 副标题最大行数，默认 5 行。
  final int subTitleMaxLines;

  /// 自定义单选框指示器。
  final TRadioIconBuilder? customIconBuilder;

  @override
  Widget build(BuildContext context) {
    final group = _TRadioGroupScope.maybeOf<T>(context);
    if (group == null) {
      throw FlutterError.fromParts([
        ErrorSummary('TRadio<$T> requires a TRadioGroup<$T> ancestor.'),
        ErrorDescription(
          'TRadio no longer owns groupValue or onChanged. Wrap it with '
          'TRadioGroup<$T>, or use TRadioGroup<$T>.options.',
        ),
      ]);
    }
    final selected = value == group.value;
    final effectiveDisabled = disabled || group.onChanged == null;
    final theme = Theme.of(context).extension<TRadioThemeData>();
    final indicator =
        customIconBuilder?.call(context, selected, effectiveDisabled) ??
        (variant == TRadioVariant.card
            ? null
            : _buildIndicator(context, theme, selected, effectiveDisabled));
    final titleStyle = _resolveTitleStyle(context);
    final content = _buildContent(
      context,
      theme,
      titleStyle,
      effectiveDisabled,
    );
    final hasContent = content != null;
    final indicatorSize = _indicatorSize(context);
    final constraints = switch (variant) {
      TRadioVariant.inline => BoxConstraints(minHeight: indicatorSize),
      TRadioVariant.block =>
        hasContent
            ? BoxConstraints(minHeight: _contentMinHeight(context))
            : _resolveTapTargetConstraints(context),
      TRadioVariant.card => const BoxConstraints(),
    };
    final tileContent = LayoutBuilder(
      builder: (context, layoutConstraints) {
        final hasBoundedWidth = layoutConstraints.hasBoundedWidth;
        final indicatorOffset =
            (_titleLineHeight(titleStyle) - indicatorSize) / 2;
        final children = <Widget>[
          if (indicator != null)
            if (hasContent && customIconBuilder == null)
              Transform.translate(
                offset: Offset(0, indicatorOffset),
                child: indicator,
              )
            else
              indicator,
          if (indicator != null && content != null)
            SizedBox(
              width: variant == TRadioVariant.card
                  ? 0
                  : theme?.spacing ?? context.tTheme.spacer8,
            ),
          if (content != null)
            if (hasBoundedWidth && variant != TRadioVariant.inline)
              Expanded(child: content)
            else
              Flexible(fit: FlexFit.loose, child: content),
        ];
        return Container(
          constraints: constraints,
          padding: switch (variant) {
            TRadioVariant.inline => EdgeInsets.zero,
            TRadioVariant.block =>
              hasContent
                  ? EdgeInsets.symmetric(
                      horizontal:
                          theme?.insetSpacing ?? context.tTheme.spacer16,
                      vertical: _contentVerticalPadding(context, titleStyle),
                    )
                  : EdgeInsets.zero,
            TRadioVariant.card =>
              hasContent
                  ? EdgeInsets.symmetric(vertical: context.tTheme.spacer8)
                  : EdgeInsets.zero,
          },
          decoration: variant == TRadioVariant.block
              ? BoxDecoration(
                  color: hasContent
                      ? context.tTheme.bgColorContainer
                      : Colors.transparent,
                )
              : null,
          child: Row(
            mainAxisSize:
                hasContent && hasBoundedWidth && variant != TRadioVariant.inline
                ? MainAxisSize.max
                : MainAxisSize.min,
            mainAxisAlignment: hasContent
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            crossAxisAlignment: hasContent
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: contentDirection == TContentDirection.right
                ? children
                : children.reversed.toList(),
          ),
        );
      },
    );
    final tile = variant == TRadioVariant.card
        ? TSelectionCard(
            selected: selected,
            disabled: effectiveDisabled,
            selectedColor:
                theme?.selectColor ?? context.tTheme.brandNormalColor,
            disabledColor:
                theme?.disableColor ?? context.tTheme.brandDisabledColor,
            backgroundColor:
                theme?.backgroundColor ?? context.tTheme.bgColorContainer,
            borderRadius: context.tTheme.radiusDefault,
            minHeight: _cardMinHeight(context, titleStyle),
            child: tileContent,
          )
        : tileContent;
    return Semantics(
      enabled: !effectiveDisabled,
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: effectiveDisabled ? null : () => group.onChanged!(value),
        child: tile,
      ),
    );
  }

  double _contentMinHeight(BuildContext context) => switch (size) {
    TRadioSize.small => context.tTheme.spacer48,
    TRadioSize.medium => context.tTheme.spacer48 + context.tTheme.spacer8,
    TRadioSize.large => context.tTheme.spacer64,
  };

  double _contentVerticalPadding(BuildContext context, TextStyle titleStyle) {
    final titleLineHeight = _titleLineHeight(titleStyle);
    final leadingHeight = math.max(titleLineHeight, _indicatorSize(context));
    return math.max(0, (_contentMinHeight(context) - leadingHeight) / 2);
  }

  double _cardMinHeight(BuildContext context, TextStyle titleStyle) {
    final titleHeight = _titleLineHeight(titleStyle);
    final contentHeight = subTitle?.isNotEmpty == true
        ? titleHeight +
              context.tTheme.spacer4 +
              _titleLineHeight(_resolveSubTitleStyle(context))
        : titleHeight;
    return contentHeight + context.tTheme.spacer16 * 2;
  }

  double _titleLineHeight(TextStyle titleStyle) =>
      titleStyle.fontSize! * (titleStyle.height ?? 1);

  BoxConstraints _resolveTapTargetConstraints(BuildContext context) {
    final materialTheme = RadioTheme.of(context);
    final appTheme = Theme.of(context);
    final visualDensity =
        materialTheme.visualDensity ??
        appTheme.tExplicitVisualDensity ??
        VisualDensity.standard;
    final tapTargetSize =
        materialTheme.materialTapTargetSize ??
        appTheme.tExplicitMaterialTapTargetSize ??
        MaterialTapTargetSize.padded;
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

  double _indicatorSize(BuildContext context) => switch (size) {
    TRadioSize.small => context.tTheme.spacer16 + context.tTheme.spacer4,
    TRadioSize.medium => context.tTheme.spacer24,
    TRadioSize.large => context.tTheme.spacer24 + context.tTheme.spacer4,
  };

  Widget _buildIndicator(
    BuildContext context,
    TRadioThemeData? theme,
    bool selected,
    bool disabled,
  ) {
    final materialTheme = RadioTheme.of(context);
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    final states = <WidgetState>{
      if (selected) WidgetState.selected,
      if (disabled) WidgetState.disabled,
    };
    final color = disabled
        ? (theme?.disableColor ??
              materialTheme.fillColor?.resolve(states) ??
              colorScheme?.onSurface.withValues(alpha: 0.38) ??
              context.tTheme.brandDisabledColor)
        : selected
        ? (theme?.selectColor ??
              materialTheme.fillColor?.resolve(states) ??
              colorScheme?.primary ??
              context.tTheme.brandNormalColor)
        : (materialTheme.fillColor?.resolve(states) ??
              colorScheme?.outline ??
              context.tTheme.componentBorderColor);
    final iconSize = _indicatorSize(context);
    final selectedIcon = selected
        ? switch (iconType) {
            TRadioIconType.check => TIcons.check,
            TRadioIconType.fill => TIcons.check_circle_filled,
            TRadioIconType.dot => null,
          }
        : null;
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: selectedIcon != null
          ? Icon(selectedIcon, size: iconSize, color: color)
          : iconType == TRadioIconType.check
          ? null
          : CustomPaint(
              painter: _TRadioIndicatorPainter(
                selected: selected,
                color: color,
                iconType: iconType,
              ),
            ),
    );
  }

  TextStyle _resolveTitleStyle(BuildContext context) {
    final materialTextTheme = Theme.of(context).tExplicitTextTheme;
    final titleFont = context.tTheme.fontBodyLarge;
    return TextStyle(
      fontSize: titleFont?.size ?? 16,
      height: titleFont?.height,
      fontWeight: titleFont?.fontWeight,
    ).merge(materialTextTheme?.bodyLarge ?? materialTextTheme?.bodyMedium);
  }

  TextStyle _resolveSubTitleStyle(BuildContext context) {
    final materialTextTheme = Theme.of(context).tExplicitTextTheme;
    final subtitleFont = context.tTheme.fontBodyMedium;
    return TextStyle(
      fontSize: subtitleFont?.size ?? 14,
      height: subtitleFont?.height,
      fontWeight: subtitleFont?.fontWeight,
    ).merge(materialTextTheme?.bodyMedium ?? materialTextTheme?.bodySmall);
  }

  Widget? _buildContent(
    BuildContext context,
    TRadioThemeData? theme,
    TextStyle titleStyle,
    bool disabled,
  ) {
    if (title == null && subTitle == null) {
      return null;
    }
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
              color: disabled
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
              color: disabled
                  ? context.tTheme.textDisabledColor
                  : (theme?.subTitleColor ?? context.tTheme.textColorSecondary),
            ),
          ),
      ],
    );
  }
}

class _TRadioIndicatorPainter extends CustomPainter {
  const _TRadioIndicatorPainter({
    required this.selected,
    required this.color,
    required this.iconType,
  });

  final bool selected;
  final Color color;
  final TRadioIconType iconType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = size.shortestSide / 16;
    final outerRadius = size.shortestSide * 7 / 16;
    final paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    switch (iconType) {
      case TRadioIconType.dot:
        canvas.drawCircle(center, outerRadius, paint);
        if (selected) {
          paint.style = PaintingStyle.fill;
          canvas.drawCircle(center, outerRadius * 4 / 7, paint);
        }
      case TRadioIconType.check:
        break;
      case TRadioIconType.fill:
        canvas.drawCircle(center, outerRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TRadioIndicatorPainter oldDelegate) {
    return selected != oldDelegate.selected ||
        color != oldDelegate.color ||
        iconType != oldDelegate.iconType;
  }
}

/// 严格受控的单选框组。
///
/// 默认构造通过 `child` 接收调用方布局；标准数据列表使用
/// `TRadioGroup.options`。组内的 [TRadio] 从该组件读取选中值和变更回调。
class TRadioGroup<T> extends StatelessWidget {
  const TRadioGroup({
    super.key,

    /// 受控选中值。
    required this.value,

    /// 选中值变更回调；为 null 时整组禁用。
    this.onChanged,

    /// 包含 [TRadio] 的自定义布局。
    required this.child,
  });

  /// 使用数据项生成标准布局的单选框组。
  const factory TRadioGroup.options({
    Key? key,

    /// 受控选中值。
    required T? value,

    /// 单选框数据项。
    required List<TRadioOption<T>> options,

    /// 选中值变更回调；为 null 时整组禁用。
    ValueChanged<T>? onChanged,

    /// 排列方向，默认纵向。
    Axis direction,

    /// 每行列数，默认 1，必须大于 0。
    int columns,

    /// 生成项的完整视觉结构，默认 [TRadioVariant.block]。
    TRadioVariant variant,

    /// 是否显示项间分割线。
    ///
    /// 为空时仅 [TRadioVariant.block] 默认显示；非 block 结构不能设为 true。
    bool? showDivider,

    /// 控件与文案排列方向，默认文案在指示器右侧。
    TContentDirection contentDirection,

    /// 单选框尺寸，默认 [TRadioSize.medium]。
    TRadioSize size,

    /// 内置指示器样式，默认 [TRadioIconType.fill]。
    TRadioIconType iconType,

    /// 主标题最大行数，默认 3 行。
    int titleMaxLines,

    /// 副标题最大行数，默认 5 行。
    int subTitleMaxLines,
  }) = _TRadioOptionsGroup<T>;

  /// 受控选中值。
  final T? value;

  /// 选中值变更回调；为 null 时整组禁用。
  final ValueChanged<T>? onChanged;

  /// 包含 [TRadio] 的自定义布局。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _TRadioGroupScope<T>(
      value: value,
      onChanged: onChanged,
      child: child,
    );
  }
}

class _TRadioOptionsGroup<T> extends TRadioGroup<T> {
  const _TRadioOptionsGroup({
    super.key,
    required T? value,
    required this.options,
    ValueChanged<T>? onChanged,
    this.direction = Axis.vertical,
    this.columns = 1,
    this.variant = TRadioVariant.block,
    this.showDivider,
    this.contentDirection = TContentDirection.right,
    this.size = TRadioSize.medium,
    this.iconType = TRadioIconType.fill,
    this.titleMaxLines = 3,
    this.subTitleMaxLines = 5,
  }) : assert(columns > 0),
       assert(
         variant == TRadioVariant.block || showDivider != true,
         'showDivider can only be enabled for TRadioVariant.block.',
       ),
       super(
         value: value,
         onChanged: onChanged,
         child: const SizedBox.shrink(),
       );

  final List<TRadioOption<T>> options;
  final Axis direction;
  final int columns;
  final TRadioVariant variant;
  final bool? showDivider;
  final TContentDirection contentDirection;
  final TRadioSize size;
  final TRadioIconType iconType;
  final int titleMaxLines;
  final int subTitleMaxLines;

  @override
  Widget build(BuildContext context) {
    return _TRadioGroupScope<T>(
      value: value,
      onChanged: onChanged,
      child: _buildOptions(context),
    );
  }

  Widget _buildOptions(BuildContext context) {
    if (variant == TRadioVariant.card) {
      return TSelectionCardGroupLayout(
        direction: direction,
        columns: columns,
        children: List.generate(options.length, (index) {
          return _buildItem(context, options[index], index);
        }),
        itemHasSubtitles: [
          for (final option in options) option.subTitle?.isNotEmpty == true,
        ],
      );
    }
    if (direction == Axis.vertical && columns == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          return _buildItem(context, options[index], index);
        }),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth / columns
            : null;
        return Wrap(
          children: List.generate(options.length, (index) {
            final child = _buildItem(context, options[index], index);
            return width == null ? child : SizedBox(width: width, child: child);
          }),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, TRadioOption<T> option, int index) {
    final radio = TRadio<T>(
      value: option.value,
      title: option.label,
      subTitle: option.subTitle,
      disabled: option.disabled,
      variant: variant,
      contentDirection: contentDirection,
      size: size,
      iconType: iconType,
      titleMaxLines: titleMaxLines,
      subTitleMaxLines: subTitleMaxLines,
    );
    final effectiveShowDivider = showDivider ?? true;
    if (variant != TRadioVariant.block ||
        !effectiveShowDivider ||
        index == options.length - 1) {
      return radio;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        radio,
        _TRadioDivider(size: size, contentDirection: contentDirection),
      ],
    );
  }
}

class _TRadioGroupScope<T> extends InheritedWidget {
  const _TRadioGroupScope({
    required this.value,
    required this.onChanged,
    required super.child,
  });

  final T? value;
  final ValueChanged<T>? onChanged;

  static _TRadioGroupScope<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TRadioGroupScope<T>>();
  }

  @override
  bool updateShouldNotify(_TRadioGroupScope<T> oldWidget) {
    return value != oldWidget.value || onChanged != oldWidget.onChanged;
  }
}

class _TRadioDivider extends StatelessWidget {
  const _TRadioDivider({required this.size, required this.contentDirection});

  final TRadioSize size;
  final TContentDirection contentDirection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radioTheme = theme.extension<TRadioThemeData>();
    final dividerTheme =
        theme.extension<TDividerThemeData>()?.copyWith(
          margin: EdgeInsets.zero,
        ) ??
        const TDividerThemeData(margin: EdgeInsets.zero);
    final insetSpacing = radioTheme?.insetSpacing ?? context.tTheme.spacer16;
    final contentSpacing = radioTheme?.spacing ?? context.tTheme.spacer8;
    final indicatorSize = switch (size) {
      TRadioSize.small => context.tTheme.spacer16 + context.tTheme.spacer4,
      TRadioSize.medium => context.tTheme.spacer24,
      TRadioSize.large => context.tTheme.spacer24 + context.tTheme.spacer4,
    };
    final start = contentDirection == TContentDirection.right
        ? insetSpacing + indicatorSize + contentSpacing
        : insetSpacing;
    return Theme(
      data: theme.mergeExtension(dividerTheme),
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: start),
        child: const TDivider(),
      ),
    );
  }
}
