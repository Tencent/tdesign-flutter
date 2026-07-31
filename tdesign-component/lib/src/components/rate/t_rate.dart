import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
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

    /// 开始交互时触发。
    this.onChangeStart,

    /// 结束交互时触发。
    this.onChangeEnd,

    /// 评分项数量。
    this.count = 5,

    /// 是否允许半星。
    this.allowHalf = false,

    /// 自定义评分图标。
    this.icon,

    /// 各评分对应的文案。
    this.texts,
  }) : assert(count > 0),
       assert(value >= 0 && value <= count);

  /// 受控评分值。
  final double value;

  /// 评分变更回调；为 null 时禁用。
  final ValueChanged<double>? onChanged;

  /// 开始交互时触发。
  final ValueChanged<double>? onChangeStart;

  /// 结束交互时触发。
  final ValueChanged<double>? onChangeEnd;

  /// 评分项数量。
  final int count;

  /// 是否允许半星。
  final bool allowHalf;

  /// 自定义评分图标。
  final TRateIconBuilder? icon;

  /// 各评分对应的文案。
  final List<String>? texts;

  @override
  State<TRate> createState() => _TRateState();
}

class _TRateState extends State<TRate> {
  static const _halfChoiceKey = ValueKey<String>('t-rate-half-choice');

  double? _lastInteractionValue;
  OverlayEntry? _halfChoiceEntry;
  double? _pendingHalfChoiceValue;

  bool get _enabled => widget.onChanged != null;
  int get _effectiveCount => widget.count < 1 ? 1 : widget.count;
  double get _effectiveValue {
    if (!widget.value.isFinite) {
      return 0;
    }
    return widget.value.clamp(0, _effectiveCount).toDouble();
  }

  @override
  void didUpdateWidget(TRate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allowHalf != oldWidget.allowHalf || !_enabled) {
      _dismissHalfChoice();
    }
  }

  @override
  void dispose() {
    _dismissHalfChoice();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TRateThemeData>();
    final iconSize = theme?.iconSize ?? 24;
    final iconGap = theme?.iconGap ?? context.tTheme.spacer8;
    final showText = theme?.showText ?? false;

    return Semantics(
      enabled: _enabled,
      value: _effectiveValue.toString(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled
                ? (details) {
                    _lastInteractionValue = _valueAt(
                      details.localPosition.dx,
                      iconSize,
                      iconGap,
                    );
                    widget.onChangeStart?.call(_effectiveValue);
                  }
                : null,
            onTapUp: _enabled
                ? (details) {
                    final next = _valueAt(
                      details.localPosition.dx,
                      iconSize,
                      iconGap,
                    );
                    _lastInteractionValue = next;
                    widget.onChanged?.call(next);
                    if (widget.allowHalf) {
                      _showHalfChoice(
                        context,
                        details.globalPosition,
                        next.ceilToDouble(),
                        iconSize,
                      );
                      _pendingHalfChoiceValue = next;
                    } else {
                      widget.onChangeEnd?.call(next);
                    }
                  }
                : null,
            onHorizontalDragStart: _enabled
                ? (_) {
                    _lastInteractionValue = _effectiveValue;
                    widget.onChangeStart?.call(_effectiveValue);
                  }
                : null,
            onHorizontalDragUpdate: _enabled
                ? (details) {
                    final next = _valueAt(
                      details.localPosition.dx,
                      iconSize,
                      iconGap,
                    );
                    _lastInteractionValue = next;
                    widget.onChanged?.call(next);
                  }
                : null,
            onHorizontalDragEnd: _enabled
                ? (_) => widget.onChangeEnd?.call(
                    _lastInteractionValue ?? _effectiveValue,
                  )
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
          if (showText) ...[
            SizedBox(width: theme?.textGap ?? context.tTheme.spacer16),
            SizedBox(
              width: theme?.textWidth,
              child: Text(
                _resolveText(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    theme?.textStyle ??
                    TextStyle(
                      color: _enabled
                          ? context.tTheme.textColorPrimary
                          : context.tTheme.textDisabledColor,
                      fontSize: context.tTheme.fontBodyLarge?.size,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
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
    final unselected =
        widget.icon?.call(false) ??
        Icon(TIcons.star_filled, size: iconSize, color: inactiveColor);
    final selected =
        widget.icon?.call(true) ??
        Icon(TIcons.star_filled, size: iconSize, color: selectedColor);

    return SizedBox.square(
      dimension: iconSize,
      child: Stack(
        children: [
          Positioned.fill(child: unselected),
          if (fill > 0)
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: fill,
                child: SizedBox.square(dimension: iconSize, child: selected),
              ),
            ),
        ],
      ),
    );
  }

  double _valueAt(double dx, double iconSize, double iconGap) {
    final itemExtent = iconSize + iconGap;
    final clamped = dx.clamp(0, itemExtent * _effectiveCount - iconGap);
    final index = (clamped / itemExtent).floor().clamp(0, _effectiveCount - 1);
    final local = clamped - index * itemExtent;
    final fraction = widget.allowHalf && local <= iconSize / 2 ? 0.5 : 1.0;
    return index + fraction;
  }

  void _showHalfChoice(
    BuildContext context,
    Offset globalPosition,
    double wholeValue,
    double iconSize,
  ) {
    _dismissHalfChoice();
    final overlay = Overlay.of(context, rootOverlay: true);
    final mediaQuery = MediaQuery.of(context);
    final material = Theme.of(context);
    final theme = material.extension<TRateThemeData>();
    final token = context.tTheme;
    final selectedColor = theme?.starColor ?? token.warningColor5;
    final inactiveColor = theme?.inactiveStarColor ?? token.bgColorComponent;
    final popupWidth = iconSize * 2 + 40;
    final popupHeight = iconSize + 36;
    final left = (globalPosition.dx - popupWidth / 2)
        .clamp(8.0, mediaQuery.size.width - popupWidth - 8.0)
        .toDouble();
    final preferredTop = globalPosition.dy - popupHeight - 12;
    final top = preferredTop >= mediaQuery.padding.top
        ? preferredTop
        : globalPosition.dy + 12;

    _halfChoiceEntry = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: [
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
                key: _halfChoiceKey,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color:
                      material.tExplicitColorScheme?.surface ??
                      token.bgColorContainer,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow:
                      theme?.overlayBoxShadow ?? token.shadowsBase ?? const [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHalfChoiceButton(
                      overlayContext,
                      value: wholeValue - 0.5,
                      iconSize: iconSize,
                      isHalf: true,
                      selectedColor: selectedColor,
                      inactiveColor: inactiveColor,
                    ),
                    const SizedBox(width: 4),
                    _buildHalfChoiceButton(
                      overlayContext,
                      value: wholeValue,
                      iconSize: iconSize,
                      isHalf: false,
                      selectedColor: selectedColor,
                      inactiveColor: inactiveColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_halfChoiceEntry!);
  }

  Widget _buildHalfChoiceButton(
    BuildContext context, {
    required double value,
    required double iconSize,
    required bool isHalf,
    required Color selectedColor,
    required Color inactiveColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_pendingHalfChoiceValue != value) {
          widget.onChanged?.call(value);
        }
        _completeHalfChoice(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: iconSize,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Icon(
                      TIcons.star_filled,
                      size: iconSize,
                      color: inactiveColor,
                    ),
                  ),
                  if (isHalf)
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.5,
                        child: Icon(
                          TIcons.star_filled,
                          size: iconSize,
                          color: selectedColor,
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: Icon(
                        TIcons.star_filled,
                        size: iconSize,
                        color: selectedColor,
                      ),
                    ),
                ],
              ),
            ),
            Text(value.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }

  void _dismissHalfChoice() {
    _halfChoiceEntry?.remove();
    _halfChoiceEntry = null;
    _pendingHalfChoiceValue = null;
  }

  void _completeHalfChoice([double? value]) {
    final completedValue = value ?? _pendingHalfChoiceValue;
    _dismissHalfChoice();
    if (completedValue != null) {
      widget.onChangeEnd?.call(completedValue);
    }
  }

  String _resolveText() {
    final texts = widget.texts;
    final value = _effectiveValue;
    if (value <= 0 || texts == null || texts.isEmpty) {
      return value.toString();
    }
    final halfIndex = (value * 2).ceil() - 1;
    final wholeIndex = value.ceil() - 1;
    final index = texts.length >= _effectiveCount * 2 ? halfIndex : wholeIndex;
    return index >= 0 && index < texts.length ? texts[index] : value.toString();
  }
}
