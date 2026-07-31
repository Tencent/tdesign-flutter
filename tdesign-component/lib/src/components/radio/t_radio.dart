import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../checkbox/t_check_box.dart' show TContentDirection;
import '../checkbox/t_selection_card.dart';
import '../divider/t_divider.dart';
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

/// 自定义单选框组数据项构建器。
typedef TRadioOptionBuilder<T> =
    Widget Function(
      BuildContext context,
      TRadioOption<T> option,
      bool selected,
      bool disabled,
    );

/// 遵循 Material value/groupValue 语义的严格受控单选框。
class TRadio<T> extends StatelessWidget {
  const TRadio({
    super.key,

    /// 当前选项值。
    required this.value,

    /// 组内受控选中值。
    required this.groupValue,

    /// 选中值变更回调；为 null 时禁用。
    this.onChanged,

    /// 主标题文案。
    this.title,

    /// 副标题文案。
    this.subTitle,

    /// 单选框尺寸。
    this.size = TRadioSize.medium,

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

    /// 自定义单选框指示器。
    this.customIconBuilder,
  });

  /// 当前选项值。
  final T value;

  /// 组内受控选中值。
  final T? groupValue;

  /// 选中值变更回调；为 null 时禁用。
  final ValueChanged<T>? onChanged;

  /// 主标题文案。
  final String? title;

  /// 副标题文案。
  final String? subTitle;

  /// 单选框尺寸。
  final TRadioSize size;

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

  /// 自定义单选框指示器。
  final TRadioIconBuilder? customIconBuilder;

  bool get _selected => value == groupValue;
  bool get _disabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TRadioThemeData>();
    final indicator =
        customIconBuilder?.call(context, _selected, _disabled) ??
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
              ? EdgeInsets.symmetric(
                  horizontal: theme?.insetSpacing ?? context.tTheme.spacer16,
                  vertical: context.tTheme.spacer8,
                )
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
            selected: _selected,
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
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _disabled ? null : () => onChanged!(value),
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

  double get _contentMinHeight => switch (size) {
    TRadioSize.small => 40.0,
    TRadioSize.medium => 48.0,
    TRadioSize.large => 56.0,
  };

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
    final indicatorSize = _indicatorSize;
    final baseSize = tapTargetSize == MaterialTapTargetSize.padded
        ? kMinInteractiveDimension
        : indicatorSize;
    final adjustment = visualDensity.baseSizeAdjustment;
    return BoxConstraints(
      minWidth: math.max(indicatorSize, baseSize + adjustment.dx),
      minHeight: math.max(indicatorSize, baseSize + adjustment.dy),
    );
  }

  double get _indicatorSize => switch (size) {
    TRadioSize.small => 20.0,
    TRadioSize.medium => 24.0,
    TRadioSize.large => 28.0,
  };

  Widget _buildIndicator(BuildContext context, TRadioThemeData? theme) {
    final materialTheme = RadioTheme.of(context);
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    final states = <WidgetState>{
      if (_selected) WidgetState.selected,
      if (_disabled) WidgetState.disabled,
    };
    final color = _disabled
        ? (theme?.disableColor ??
              materialTheme.fillColor?.resolve(states) ??
              colorScheme?.onSurface.withValues(alpha: 0.38) ??
              context.tTheme.brandDisabledColor)
        : _selected
        ? (theme?.selectColor ??
              materialTheme.fillColor?.resolve(states) ??
              colorScheme?.primary ??
              context.tTheme.brandNormalColor)
        : (materialTheme.fillColor?.resolve(states) ??
              colorScheme?.outline ??
              context.tTheme.componentBorderColor);
    final iconSize = _indicatorSize;
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _TRadioIndicatorPainter(selected: _selected, color: color),
      ),
    );
  }

  Widget? _buildContent(BuildContext context, TRadioThemeData? theme) {
    if (title == null && subTitle == null) {
      return null;
    }
    final materialTextTheme = Theme.of(context).tExplicitTextTheme;
    final titleFont = context.tTheme.fontBodyLarge;
    final titleStyle = TextStyle(
      fontSize: titleFont?.size ?? 16,
      height: titleFont?.height,
      fontWeight: titleFont?.fontWeight,
    ).merge(materialTextTheme?.bodyLarge ?? materialTextTheme?.bodyMedium);
    final subtitleFont = context.tTheme.fontBodyMedium;
    final subTitleStyle = TextStyle(
      fontSize: subtitleFont?.size ?? 14,
      height: subtitleFont?.height,
      fontWeight: subtitleFont?.fontWeight,
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
                  : (theme?.titleColor ??
                        titleStyle.color ??
                        context.tTheme.textColorPrimary),
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
                  : (theme?.subTitleColor ??
                        subTitleStyle.color ??
                        context.tTheme.textColorPlaceholder),
            ),
          ),
      ],
    );
  }
}

class _TRadioIndicatorPainter extends CustomPainter {
  const _TRadioIndicatorPainter({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = size.shortestSide / 16;
    final outerRadius = size.shortestSide * 7 / 16;
    final paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, outerRadius, paint);
    if (selected) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(center, outerRadius * 4 / 7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TRadioIndicatorPainter oldDelegate) {
    return selected != oldDelegate.selected || color != oldDelegate.color;
  }
}

/// 数据驱动且严格受控的单选框组。
class TRadioGroup<T> extends StatelessWidget {
  const TRadioGroup({
    super.key,

    /// 受控选中值。
    required this.value,

    /// 单选框数据项。
    required this.options,

    /// 选中值变更回调；为 null 时整组禁用。
    this.onChanged,

    /// 排列方向。
    this.direction = Axis.vertical,

    /// 每行列数，必须大于 0。
    this.columns = 1,

    /// 是否使用卡片模式。
    this.cardMode = false,

    /// 是否显示项间分割线。
    this.showDivider = false,

    /// 控件与文案排列方向。
    this.contentDirection = TContentDirection.right,

    /// 单选框尺寸。
    this.size = TRadioSize.medium,

    /// 自定义数据项视觉；交互仍由组接管。
    this.itemBuilder,
  }) : assert(columns > 0);

  /// 受控选中值。
  final T? value;

  /// 单选框数据项。
  final List<TRadioOption<T>> options;

  /// 选中值变更回调；为 null 时整组禁用。
  final ValueChanged<T>? onChanged;

  /// 排列方向。
  final Axis direction;

  /// 每行列数。
  final int columns;

  /// 是否使用卡片模式。
  final bool cardMode;

  /// 是否显示项间分割线。
  final bool showDivider;

  /// 控件与文案排列方向。
  final TContentDirection contentDirection;

  /// 单选框尺寸。
  final TRadioSize size;

  /// 自定义数据项视觉；交互仍由组接管。
  final TRadioOptionBuilder<T>? itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (cardMode) {
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
    final selected = value == option.value;
    final disabled = onChanged == null || option.disabled;
    if (itemBuilder != null) {
      final child = itemBuilder!(context, option, selected, disabled);
      return Semantics(
        enabled: !disabled,
        checked: selected,
        inMutuallyExclusiveGroup: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : () => onChanged!(option.value),
          child: child,
        ),
      );
    }
    return TRadio<T>(
      value: option.value,
      groupValue: value,
      onChanged: disabled ? null : onChanged,
      title: option.label,
      subTitle: option.subTitle,
      cardMode: cardMode,
      showDivider: showDivider && index < options.length - 1,
      contentDirection: contentDirection,
      size: size,
    );
  }
}
