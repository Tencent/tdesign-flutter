import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../loading/t_circle_indicator.dart';
import 't_cupertino_switch.dart';
import 't_switch_resolve.dart';
import 't_switch_theme_data.dart';
import 't_switch_types.dart';

export 't_switch_types.dart';

/// 严格受控的开关组件。
///
/// [value] 由父级持有；[onChanged] 为 null 时禁用。文字、图标和加载形态
/// 无法由 Material Switch 完整表达，因此底层保留 TDesign 自定义开关实现。
class TSwitch extends StatelessWidget {
  const TSwitch({
    super.key,

    /// 受控开关状态。
    required this.value,

    /// 开关状态变更回调；为 null 时禁用。
    this.onChanged,

    /// 开关尺寸；未传时读取 [TSwitchThemeData.defaultSize]。
    this.size,

    /// 开关内容形态；未传时读取 [TSwitchThemeData.defaultVariant]。
    this.variant,

    /// text 形态的开启文案。
    this.openText,

    /// text 形态的关闭文案。
    this.closeText,
  });

  /// 受控开关状态。
  final bool value;

  /// 开关状态变更回调；为 null 时禁用。
  final ValueChanged<bool>? onChanged;

  /// 开关尺寸。
  final TSwitchSize? size;

  /// 开关内容形态。
  final TSwitchVariant? variant;

  /// text 形态的开启文案。
  final String? openText;

  /// text 形态的关闭文案。
  final String? closeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TSwitchThemeData>();
    final resolvedSize = size ?? theme?.defaultSize ?? TSwitchSize.medium;
    final resolvedVariant =
        variant ?? theme?.defaultVariant ?? TSwitchVariant.filled;
    final enabled =
        onChanged != null && resolvedVariant != TSwitchVariant.loading;
    final resolved = TSwitchResolve.resolve(
      context: context,
      enabled: enabled,
      theme: theme,
    );

    Widget current = TCupertinoSwitch(
      value: value,
      activeColor: resolved.trackOnColor,
      trackColor: resolved.trackOffColor,
      onChanged: enabled ? onChanged : null,
      // TSwitch owns its disabled appearance below. Avoid multiplying it by
      // TCupertinoSwitch's standalone disabled opacity.
      disabledOpacity: 1,
      thumbView: _buildThumb(
        resolved: resolved,
        variant: resolvedVariant,
        openText: openText,
        closeText: closeText,
      ),
    );

    if (!enabled) {
      current = Opacity(
        opacity: 0.4,
        child: IgnorePointer(ignoring: true, child: current),
      );
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
    required String? openText,
    required String? closeText,
  }) {
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
                          ? resolved.thumbContentOnColor
                          : resolved.thumbContentOffColor,
                      height: 1,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
          ),
        ),
      ),
      TSwitchVariant.loading => TCircleIndicator(
        color: resolved.thumbContentOnColor,
        size: 16,
        lineWidth: 3,
      ),
      TSwitchVariant.icon => Icon(
        value ? TIcons.check : TIcons.close,
        size: 16,
        color: value
            ? resolved.thumbContentOnColor
            : resolved.thumbContentOffColor,
      ),
      TSwitchVariant.filled => null,
    };
  }
}
