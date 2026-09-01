import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_rate_theme_data.dart';

/// 自定义评分图标构建器。
///
/// [filled] 表示构建选中或未选中图标；半星由组件裁剪选中图标实现。
typedef TRateIconBuilder = Widget Function(bool filled);

/// 严格受控的评分组件。
class TRate extends StatefulWidget {
  const TRate({
    super.key,

    /// 受控评分值。
    required this.value,

    /// 评分变更回调；为 null 时禁用。
    this.onChanged,

    /// 开始交互时触发；同一次指针或语义交互只触发一次。
    this.onChangeStart,

    /// 结束交互时触发；指针取消时以当前受控值结束。
    this.onChangeEnd,

    /// 评分项数量。
    this.count = 5,

    /// 是否允许半星。
    this.allowHalf = false,

    /// 是否在整星点击、长按以及拖动评分时显示当前值提示。
    ///
    /// 默认为 true。半星点击的精确选择浮层不受此参数控制。
    this.showValueIndicator = true,

    /// 自定义评分图标。
    this.icon,

    /// 各评分对应的辅助文案。
    ///
    /// 为 null 时不显示辅助文案；非 null 时显示。当当前评分
    /// 没有对应文案时，显示本地化的“未评分”。
    this.texts,
  }) : assert(count > 0),
       assert(value >= 0 && value <= count);

  /// 受控评分值。
  final double value;

  /// 评分变更回调；为 null 时禁用。
  final ValueChanged<double>? onChanged;

  /// 开始交互时触发；同一次指针或语义交互只触发一次。
  final ValueChanged<double>? onChangeStart;

  /// 结束交互时触发；指针取消时以当前受控值结束。
  final ValueChanged<double>? onChangeEnd;

  /// 评分项数量。
  final int count;

  /// 是否允许半星。
  final bool allowHalf;

  /// 是否在整星点击、长按以及拖动评分时显示当前值提示。
  ///
  /// 默认为 true。半星点击的精确选择浮层不受此参数控制。
  final bool showValueIndicator;

  /// 自定义评分图标。
  final TRateIconBuilder? icon;

  /// 各评分对应的辅助文案。
  ///
  /// 为 null 时不显示辅助文案；非 null 时显示。当当前评分
  /// 没有对应文案时，显示本地化的“未评分”。
  final List<String>? texts;

  @override
  State<TRate> createState() => _TRateState();
}

class _TRateState extends State<TRate> {
  static const _halfChoiceKey = ValueKey<String>('t-rate-half-choice');
  static const _valueIndicatorKey = ValueKey<String>('t-rate-value-indicator');
  static const _valueIndicatorDuration = Duration(milliseconds: 300);

  double? _lastInteractionValue;
  OverlayEntry? _valueIndicatorEntry;
  Timer? _valueIndicatorTimer;
  double? _pendingHalfChoiceValue;
  Offset _valueIndicatorPosition = Offset.zero;
  double _valueIndicatorValue = 0;
  double _valueIndicatorIconSize = 0;
  bool _valueIndicatorShowsHalfChoices = false;
  bool _interactionStarted = false;

  bool get _enabled => widget.onChanged != null;
  int get _effectiveCount => widget.count < 1 ? 1 : widget.count;
  double get _effectiveValue {
    if (!widget.value.isFinite) {
      return 0;
    }
    final value = widget.value.clamp(0, _effectiveCount).toDouble();
    return widget.allowHalf ? value : value.floorToDouble();
  }

  @override
  void didUpdateWidget(TRate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allowHalf != oldWidget.allowHalf || !_enabled) {
      _dismissValueIndicator();
      _resetInteraction();
    } else if (!widget.showValueIndicator &&
        oldWidget.showValueIndicator &&
        !_valueIndicatorShowsHalfChoices) {
      _dismissValueIndicator();
    }
  }

  @override
  void dispose() {
    _dismissValueIndicator();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final material = Theme.of(context);
    final theme = material.extension<TRateThemeData>();
    final explicitColorScheme = material.tExplicitColorScheme;
    final iconSize = theme?.iconSize ?? context.tTheme.spacer24;
    final iconGap = theme?.iconGap ?? context.tTheme.spacer8;
    final texts = widget.texts;
    final step = widget.allowHalf ? 0.5 : 1.0;
    final increasedValue = (_effectiveValue + step)
        .clamp(0, _effectiveCount)
        .toDouble();
    final decreasedValue = (_effectiveValue - step)
        .clamp(0, _effectiveCount)
        .toDouble();

    return Semantics(
      slider: true,
      enabled: _enabled,
      value: _semanticText(context, _effectiveValue),
      increasedValue: _enabled && increasedValue != _effectiveValue
          ? _semanticText(context, increasedValue)
          : null,
      decreasedValue: _enabled && decreasedValue != _effectiveValue
          ? _semanticText(context, decreasedValue)
          : null,
      onIncrease: _enabled && increasedValue != _effectiveValue
          ? () => _changeFromSemantics(increasedValue)
          : null,
      onDecrease: _enabled && decreasedValue != _effectiveValue
          ? () => _changeFromSemantics(decreasedValue)
          : null,
      child: LayoutBuilder(
        builder: (context, constraints) => Listener(
          onPointerCancel: (_) {
            _finishInteraction(_effectiveValue);
            _dismissValueIndicator();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: _enabled
                    ? (details) {
                        _lastInteractionValue = _valueAt(
                          details.localPosition.dx,
                          iconSize,
                          iconGap,
                          Directionality.of(context),
                        );
                      }
                    : null,
                onTapUp: _enabled
                    ? (details) {
                        final next = _valueAt(
                          details.localPosition.dx,
                          iconSize,
                          iconGap,
                          Directionality.of(context),
                        );
                        _lastInteractionValue = next;
                        _startInteraction();
                        widget.onChanged?.call(next);
                        if (widget.allowHalf) {
                          _showValueIndicator(
                            context,
                            globalPosition: details.globalPosition,
                            localPosition: details.localPosition,
                            value: next,
                            iconSize: iconSize,
                            iconGap: iconGap,
                            showHalfChoices: true,
                          );
                          _pendingHalfChoiceValue = next;
                        } else {
                          if (widget.showValueIndicator) {
                            _showValueIndicator(
                              context,
                              globalPosition: details.globalPosition,
                              localPosition: details.localPosition,
                              value: next,
                              iconSize: iconSize,
                              iconGap: iconGap,
                              showHalfChoices: false,
                            );
                            _scheduleValueIndicatorDismissal();
                          }
                          _finishInteraction(next);
                        }
                      }
                    : null,
                onLongPressStart: _enabled
                    ? (details) {
                        _startInteraction();
                        _updateContinuousInteraction(
                          context,
                          globalPosition: details.globalPosition,
                          localPosition: details.localPosition,
                          iconSize: iconSize,
                          iconGap: iconGap,
                        );
                      }
                    : null,
                onLongPressMoveUpdate: _enabled
                    ? (details) {
                        _updateContinuousInteraction(
                          context,
                          globalPosition: details.globalPosition,
                          localPosition: details.localPosition,
                          iconSize: iconSize,
                          iconGap: iconGap,
                        );
                      }
                    : null,
                onLongPressEnd: _enabled
                    ? (_) {
                        _dismissValueIndicator();
                        _finishInteraction(
                          _lastInteractionValue ?? _effectiveValue,
                        );
                      }
                    : null,
                onHorizontalDragStart: _enabled
                    ? (_) {
                        _lastInteractionValue = _effectiveValue;
                        _startInteraction();
                      }
                    : null,
                onHorizontalDragUpdate: _enabled
                    ? (details) {
                        _updateContinuousInteraction(
                          context,
                          globalPosition: details.globalPosition,
                          localPosition: details.localPosition,
                          iconSize: iconSize,
                          iconGap: iconGap,
                        );
                      }
                    : null,
                onHorizontalDragEnd: _enabled
                    ? (_) {
                        _dismissValueIndicator();
                        _finishInteraction(
                          _lastInteractionValue ?? _effectiveValue,
                        );
                      }
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var index = 0; index < _effectiveCount; index++) ...[
                      _buildItem(context, index, iconSize, theme),
                      if (index < _effectiveCount - 1) SizedBox(width: iconGap),
                    ],
                  ],
                ),
              ),
              if (texts != null) ...[
                SizedBox(width: theme?.textGap ?? context.tTheme.spacer16),
                if (constraints.hasBoundedWidth)
                  Flexible(
                    child: SizedBox(
                      width: theme?.textWidth,
                      child: TText(
                        _resolveText(context, texts: texts),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _resolveTextStyle(
                          context,
                          theme,
                          explicitColorScheme,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: theme?.textWidth,
                    child: TText(
                      _resolveText(context, texts: texts),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _resolveTextStyle(
                        context,
                        theme,
                        explicitColorScheme,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _resolveTextStyle(
    BuildContext context,
    TRateThemeData? theme,
    ColorScheme? explicitColorScheme,
  ) {
    final font = context.tTheme.fontBodyLarge;
    final defaultStyle = TextStyle(
      color: _enabled
          ? explicitColorScheme?.onSurface ?? context.tTheme.textColorPrimary
          : explicitColorScheme?.onSurface.withValues(alpha: 0.38) ??
                context.tTheme.textDisabledColor,
      fontSize: font?.size ?? 16,
      height: font?.height ?? 1.5,
      fontWeight: font?.fontWeight ?? FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    );
    return defaultStyle.merge(theme?.textStyle);
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    double iconSize,
    TRateThemeData? theme,
  ) {
    final fill = (_effectiveValue - index).clamp(0, 1).toDouble();
    final selectedColor = _enabled
        ? (theme?.starColor ?? context.tTheme.warningColor5)
        : context.tTheme.textDisabledColor;
    final inactiveColor = _enabled
        ? (theme?.inactiveStarColor ?? context.tTheme.bgColorComponent)
        : context.tTheme.bgColorComponentDisabled;
    final unselected = _buildIcon(false, iconSize, inactiveColor);
    final selected = _buildIcon(true, iconSize, selectedColor);
    final fillAlignment = Directionality.of(context) == TextDirection.rtl
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return SizedBox.square(
      dimension: iconSize,
      child: Stack(
        children: [
          Positioned.fill(child: unselected),
          if (fill > 0)
            ClipRect(
              child: Align(
                alignment: fillAlignment,
                widthFactor: fill,
                child: SizedBox.square(dimension: iconSize, child: selected),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIcon(bool filled, double iconSize, Color color) {
    final icon = widget.icon?.call(filled);
    if (icon == null) {
      return Icon(TIcons.star_filled, size: iconSize, color: color);
    }
    return IconTheme.merge(
      data: IconThemeData(size: iconSize, color: color),
      child: icon,
    );
  }

  double _valueAt(
    double dx,
    double iconSize,
    double iconGap,
    TextDirection textDirection,
  ) {
    final itemExtent = iconSize + iconGap;
    final width = itemExtent * _effectiveCount - iconGap;
    final directionalDx = textDirection == TextDirection.rtl ? width - dx : dx;
    if (directionalDx <= -(itemExtent + iconGap)) {
      return 0;
    }
    final clamped = directionalDx.clamp(0, width);
    final index = (clamped / itemExtent).floor().clamp(0, _effectiveCount - 1);
    final local = clamped - index * itemExtent;
    final fraction = widget.allowHalf && local <= iconSize / 2 ? 0.5 : 1.0;
    return index + fraction;
  }

  void _updateContinuousInteraction(
    BuildContext context, {
    required Offset globalPosition,
    required Offset localPosition,
    required double iconSize,
    required double iconGap,
  }) {
    final next = _valueAt(
      localPosition.dx,
      iconSize,
      iconGap,
      Directionality.of(context),
    );
    _lastInteractionValue = next;
    widget.onChanged?.call(next);
    if (widget.showValueIndicator) {
      _showValueIndicator(
        context,
        globalPosition: globalPosition,
        localPosition: localPosition,
        value: next,
        iconSize: iconSize,
        iconGap: iconGap,
        showHalfChoices: false,
      );
    }
  }

  void _showValueIndicator(
    BuildContext context, {
    required Offset globalPosition,
    required Offset localPosition,
    required double value,
    required double iconSize,
    required double iconGap,
    required bool showHalfChoices,
  }) {
    _valueIndicatorTimer?.cancel();
    _valueIndicatorPosition = _valueIndicatorAnchor(
      globalPosition: globalPosition,
      localPosition: localPosition,
      value: value,
      iconSize: iconSize,
      iconGap: iconGap,
      textDirection: Directionality.of(context),
    );
    _valueIndicatorValue = value;
    _valueIndicatorIconSize = iconSize;
    _valueIndicatorShowsHalfChoices = showHalfChoices;

    if (_valueIndicatorEntry != null) {
      _valueIndicatorEntry!.markNeedsBuild();
      return;
    }

    _valueIndicatorEntry = OverlayEntry(builder: _buildValueIndicatorOverlay);
    Overlay.of(context, rootOverlay: true).insert(_valueIndicatorEntry!);
  }

  Offset _valueIndicatorAnchor({
    required Offset globalPosition,
    required Offset localPosition,
    required double value,
    required double iconSize,
    required double iconGap,
    required TextDirection textDirection,
  }) {
    final itemExtent = iconSize + iconGap;
    final width = itemExtent * _effectiveCount - iconGap;
    final index = value <= 0
        ? 0
        : (value.ceil() - 1).clamp(0, _effectiveCount - 1).toInt();
    final centerX = textDirection == TextDirection.rtl
        ? width - index * itemExtent - iconSize / 2
        : index * itemExtent + iconSize / 2;
    final wrapperOrigin = globalPosition - localPosition;
    return wrapperOrigin + Offset(centerX, iconSize / 2);
  }

  Widget _buildValueIndicatorOverlay(BuildContext overlayContext) {
    final context = this.context;
    final mediaQuery = MediaQuery.of(context);
    final material = Theme.of(context);
    final theme = material.extension<TRateThemeData>();
    final token = context.tTheme;
    final iconSize = _valueIndicatorIconSize;
    final selectedColor = theme?.starColor ?? token.warningColor5;
    final inactiveColor = theme?.inactiveStarColor ?? token.bgColorComponent;
    final naturalPopupWidth = _valueIndicatorShowsHalfChoices
        ? iconSize * 2 + token.spacer40
        : iconSize + token.spacer24;
    final popupHeight = iconSize + token.spacer32 + token.spacer4;
    final horizontalInset = token.spacer8;
    final popupWidth = naturalPopupWidth.clamp(
      0.0,
      (mediaQuery.size.width - horizontalInset * 2).clamp(0.0, double.infinity),
    );
    final maxLeft = (mediaQuery.size.width - popupWidth - horizontalInset)
        .clamp(horizontalInset, double.infinity);
    final left = (_valueIndicatorPosition.dx - popupWidth / 2)
        .clamp(horizontalInset, maxLeft)
        .toDouble();
    final preferredTop =
        _valueIndicatorPosition.dy - popupHeight - token.spacer12;
    final rawTop = preferredTop >= mediaQuery.padding.top
        ? preferredTop
        : _valueIndicatorPosition.dy + token.spacer12;
    final verticalInset = mediaQuery.padding.top + token.spacer8;
    final maxTop =
        (mediaQuery.size.height -
                mediaQuery.padding.bottom -
                popupHeight -
                token.spacer8)
            .clamp(verticalInset, double.infinity);
    final top = rawTop.clamp(verticalInset, maxTop).toDouble();

    Widget buildContent() {
      final Widget choices;
      if (_valueIndicatorShowsHalfChoices) {
        final wholeValue = _valueIndicatorValue.ceilToDouble();
        choices = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildValueIndicatorItem(
              overlayContext,
              value: wholeValue - 0.5,
              iconSize: iconSize,
              isHalf: true,
              selectedColor: selectedColor,
              inactiveColor: inactiveColor,
              onTap: () => _selectHalfChoice(wholeValue - 0.5),
            ),
            SizedBox(width: token.spacer4),
            _buildValueIndicatorItem(
              overlayContext,
              value: wholeValue,
              iconSize: iconSize,
              isHalf: false,
              selectedColor: selectedColor,
              inactiveColor: inactiveColor,
              onTap: () => _selectHalfChoice(wholeValue),
            ),
          ],
        );
      } else {
        final value = _valueIndicatorValue;
        choices = _buildValueIndicatorItem(
          overlayContext,
          value: value,
          iconSize: iconSize,
          isHalf: value != value.truncateToDouble(),
          selectedColor: selectedColor,
          inactiveColor: inactiveColor,
        );
      }
      if (popupWidth == naturalPopupWidth) {
        return choices;
      }
      return SizedBox(
        width: (popupWidth - token.spacer8).clamp(0, double.infinity),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: choices,
        ),
      );
    }

    return Stack(
      children: [
        if (_valueIndicatorShowsHalfChoices)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _completeHalfChoice,
            ),
          ),
        Positioned(
          left: left,
          top: top,
          child: Material(
            color: Colors.transparent,
            child: Container(
              key: _valueIndicatorShowsHalfChoices
                  ? _halfChoiceKey
                  : _valueIndicatorKey,
              padding: EdgeInsets.all(token.spacer4),
              decoration: BoxDecoration(
                color:
                    material.tExplicitColorScheme?.surface ??
                    token.bgColorContainer,
                borderRadius: BorderRadius.circular(token.radiusDefault),
                boxShadow:
                    theme?.overlayBoxShadow ?? token.shadowsBase ?? const [],
              ),
              child: buildContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValueIndicatorItem(
    BuildContext context, {
    required double value,
    required double iconSize,
    required bool isHalf,
    required Color selectedColor,
    required Color inactiveColor,
    VoidCallback? onTap,
  }) {
    final token = context.tTheme;
    final fillAlignment = Directionality.of(context) == TextDirection.rtl
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: token.spacer4,
          vertical: token.spacer4 / 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: iconSize,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildIcon(false, iconSize, inactiveColor),
                  ),
                  if (isHalf)
                    ClipRect(
                      child: Align(
                        alignment: fillAlignment,
                        widthFactor: 0.5,
                        child: SizedBox.square(
                          dimension: iconSize,
                          child: _buildIcon(true, iconSize, selectedColor),
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: _buildIcon(true, iconSize, selectedColor),
                    ),
                ],
              ),
            ),
            Text(
              _formatValue(value),
              style: TextStyle(fontSize: token.fontBodyMedium?.size),
            ),
          ],
        ),
      ),
    );
  }

  void _selectHalfChoice(double value) {
    if (_pendingHalfChoiceValue != value) {
      widget.onChanged?.call(value);
    }
    _completeHalfChoice(value);
  }

  void _scheduleValueIndicatorDismissal() {
    _valueIndicatorTimer?.cancel();
    _valueIndicatorTimer = Timer(
      _valueIndicatorDuration,
      _dismissValueIndicator,
    );
  }

  void _dismissValueIndicator() {
    _valueIndicatorTimer?.cancel();
    _valueIndicatorTimer = null;
    _valueIndicatorEntry?.remove();
    _valueIndicatorEntry = null;
    _pendingHalfChoiceValue = null;
    _valueIndicatorShowsHalfChoices = false;
  }

  void _completeHalfChoice([double? value]) {
    final completedValue = value ?? _pendingHalfChoiceValue;
    _dismissValueIndicator();
    if (completedValue != null) {
      _finishInteraction(completedValue);
    }
  }

  void _startInteraction() {
    if (_interactionStarted) {
      return;
    }
    _interactionStarted = true;
    widget.onChangeStart?.call(_effectiveValue);
  }

  void _finishInteraction(double value) {
    if (!_interactionStarted) {
      return;
    }
    _resetInteraction();
    widget.onChangeEnd?.call(value);
  }

  void _resetInteraction() {
    _interactionStarted = false;
    _lastInteractionValue = null;
  }

  void _changeFromSemantics(double next) {
    widget.onChangeStart?.call(_effectiveValue);
    widget.onChanged?.call(next);
    widget.onChangeEnd?.call(next);
  }

  String _semanticText(BuildContext context, double value) {
    final texts = widget.texts;
    if (texts == null) {
      return _formatValue(value);
    }
    final description = _resolveText(context, texts: texts, value: value);
    return '${_formatValue(value)} $description';
  }

  String _resolveText(
    BuildContext context, {
    required List<String> texts,
    double? value,
  }) {
    final effectiveValue = value ?? _effectiveValue;
    if (effectiveValue <= 0) {
      return context.resource.notRated;
    }
    final index = (effectiveValue - 1).floor();
    return index >= 0 && index < texts.length
        ? texts[index]
        : context.resource.notRated;
  }

  String _formatValue(double value) => value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();
}
