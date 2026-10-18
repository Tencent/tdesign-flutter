import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_internal_material.dart';
import '../loading/t_circle_indicator.dart';
import '../text/t_text_styled.dart';
import 't_cupertino_switch.dart';
import 't_switch_resolve.dart';
import 't_switch_theme_data.dart';
import 't_switch_types.dart';

export 't_switch_types.dart';

class TSwitch extends StatelessWidget {
  const TSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.size,
    this.variant,
    this.loading = false,
    this.openText,
    this.closeText,
  });

  /// 受控开关状态。
  final bool value;

  /// 开关状态变更回调；为 null 时禁用。
  final ValueChanged<bool>? onChanged;

  /// 开关尺寸；未传时以 [TSwitchSize.medium] 为最小尺寸，文字形态可随内容增长。
  /// 显式预设尺寸保持固定，滑块文字适配其内容槽。
  final TSwitchSize? size;

  /// 开关内容形态；未传时为 [TSwitchVariant.filled]。
  final TSwitchVariant? variant;

  /// 是否处于加载状态；加载时显示指示器并禁用交互。
  final bool loading;

  /// text 形态的开启文案。
  /// null 时显示“开”；仅开启态文本内容形态使用。
  final String? openText;

  /// text 形态的关闭文案。
  /// null 时显示“关”；仅关闭态文本内容形态使用。
  final String? closeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TSwitchThemeData>();
    final resolvedSize = size ?? TSwitchSize.medium;
    final resolvedVariant = variant ?? TSwitchVariant.filled;
    final enabled = onChanged != null && !loading;
    final resolved = TSwitchResolve.resolve(context: context, theme: theme);
    final textGrowth = resolvedVariant == TSwitchVariant.text
        ? _textGrowth(context, resolved)
        : 1.0;

    Widget current = TCupertinoSwitch(
      value: value,
      activeColor: enabled
          ? resolved.trackOnColor
          : resolved.disabledTrackOnColor,
      trackColor: enabled
          ? resolved.trackOffColor
          : resolved.disabledTrackOffColor,
      thumbColor: enabled ? resolved.thumbColor : resolved.disabledThumbColor,
      onChanged: enabled ? onChanged : null,
      // State colors are resolved independently; never dim the whole switch.
      disabledOpacity: 1,
      thumbView: _buildThumb(
        textGrowth: textGrowth,
        resolved: resolved,
        variant: resolvedVariant,
        loading: loading,
        disabled: onChanged == null,
        openText: openText,
        closeText: closeText,
      ),
    );

    if (!enabled) {
      current = IgnorePointer(ignoring: true, child: current);
    }

    // 默认文字开关随内容增长；显式预设尺寸仍保持固定几何。
    final growth = size == null ? textGrowth : 1.0;
    return Semantics(
      enabled: enabled,
      toggled: value,
      child: SizedBox(
        width: TSwitchResolve.width(resolvedSize) * growth,
        height: TSwitchResolve.height(resolvedSize) * growth,
        child: FittedBox(child: current),
      ),
    );
  }

  double _textGrowth(BuildContext context, TSwitchResolvedStyle resolved) {
    var extent = 16.0;
    for (final (configured, label) in [
      (resolved.thumbContentOnFont, openText ?? '开'),
      (resolved.thumbContentOffFont, closeText ?? '关'),
    ]) {
      final size = TTextStyled(
        label,
        maxLines: 1,
        style: configured.copyWith(height: configured.height ?? 1),
      ).naturalSize(context);
      extent = math.max(extent, size.height);
      if (label.characters.length <= 1) {
        extent = math.max(extent, size.width);
      } else {
        final abbreviatedWidth = [label.characters.first, '…'].fold<double>(
          0,
          (width, part) =>
              width +
              TTextStyled(
                part,
                maxLines: 1,
                style: configured.copyWith(height: configured.height ?? 1),
              ).naturalSize(context).width,
        );
        // Measure separately: prefix/ellipsis kerning differs from the source label.
        extent = math.max(
          extent,
          math.min(size.width, abbreviatedWidth).ceilToDouble(),
        );
      }
    }
    return extent / 16;
  }

  Widget? _buildThumb({
    required double textGrowth,
    required TSwitchResolvedStyle resolved,
    required TSwitchVariant variant,
    required bool loading,
    required bool disabled,
    required String? openText,
    required String? closeText,
  }) {
    if (loading) {
      return TCircleIndicator(
        color: resolved.loadingColor,
        size: 16,
        lineWidth: 3,
      );
    }
    return switch (variant) {
      TSwitchVariant.text => SizedBox(
        width: 16,
        height: 16,
        // 滑块是固定几何；先让文字完成自然纵向布局，再按内容槽缩小。
        // 两个状态使用同一自然内容槽，抵消外层几何缩放，保留各自实际字号。
        // 单字符完整展示；多字符沿用槽内省略。
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 16 * textGrowth,
            child: TTextStyled(
              value ? (openText ?? '开') : (closeText ?? '关'),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style:
                  (value
                          ? resolved.thumbContentOnFont
                          : resolved.thumbContentOffFont)
                      .copyWith(
                        color: value
                            ? (disabled
                                  ? resolved.disabledTrackOnColor
                                  : resolved.thumbContentOnColor)
                            : (disabled
                                  ? resolved.disabledTrackOffColor
                                  : resolved.thumbContentOffColor),
                        height:
                            (value
                                    ? resolved.thumbContentOnFont
                                    : resolved.thumbContentOffFont)
                                .height ??
                            1,
                      ),
            ),
          ),
        ),
      ),
      TSwitchVariant.icon => TInternalIcon(
        value ? TIcons.check : TIcons.close,
        size: 16,
        color: value
            ? (disabled
                  ? resolved.disabledTrackOnColor
                  : resolved.thumbContentOnColor)
            : (disabled
                  ? resolved.disabledTrackOffColor
                  : resolved.thumbContentOffColor),
      ),
      TSwitchVariant.filled => null,
    };
  }
}
