import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../loading/t_circle_indicator.dart';
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

  /// 开关尺寸；未传时为 [TSwitchSize.medium]。
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

    return Semantics(
      enabled: enabled,
      toggled: value,
      child: SizedBox(
        width: TSwitchResolve.width(resolvedSize),
        height: TSwitchResolve.height(resolvedSize),
        child: FittedBox(child: current),
      ),
    );
  }

  Widget? _buildThumb({
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
        child: Center(
          child: Text(
            value ? (openText ?? '开') : (closeText ?? '关'),
            maxLines: 1,
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
                      height: 1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
          ),
        ),
      ),
      TSwitchVariant.icon => Icon(
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
