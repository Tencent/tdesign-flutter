import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/t_token_double_lerp.dart';

import 't_button_defaults.dart';
import 't_button_types.dart';

/// TButton 组件级 ThemeExtension
///
/// 承载按钮子树的分档图标默认值、图文间距与渐变。
/// 实例 ButtonStyle 的显式字段优先于对应组件默认值。
///
/// 分档默认值示例（实例 style 仍可覆盖）：
/// ```dart
/// Theme(
///   data: Theme.of(context).mergeExtension(const TButtonThemeData(smallIconSize: 22)),
///   child: TButton(size: TButtonSize.small, icon: const Icon(Icons.add), onPressed: () {}),
/// )
/// ```
///
/// {@category ComponentTheme}
class TButtonThemeData extends ThemeExtension<TButtonThemeData> {
  /// 图标与文案之间的间距，单位为逻辑像素。
  ///
  /// 仅在按钮同时提供 icon 和 child 时生效；该值控制两者
  /// 之间的实际间隔，不会改变按钮整体内边距。为空时使用组件内置
  /// 默认值 4dp；全局 `spacer4` 对应 32dp，不用于此间距。
  final double? iconTextSpacing;

  /// 渐变背景色（装饰层，非 ButtonStyle 字段）
  final Gradient? gradient;

  /// 大尺寸按钮的图标大小，单位为逻辑像素。
  ///
  /// 未设置时使用独立默认 24dp；实例 ButtonStyle.iconSize 优先。
  /// 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。
  final double? largeIconSize;

  /// 中尺寸按钮的图标大小，单位为逻辑像素。
  ///
  /// 未设置时使用独立默认 20dp；实例 ButtonStyle.iconSize 优先。
  /// 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。
  final double? mediumIconSize;

  /// 小尺寸按钮的图标大小，单位为逻辑像素。
  ///
  /// 未设置时使用独立默认 18dp；实例 ButtonStyle.iconSize 优先。
  /// 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。
  final double? smallIconSize;

  /// 超小尺寸按钮的图标大小，单位为逻辑像素。
  ///
  /// 未设置时使用独立默认 18dp；实例 ButtonStyle.iconSize 优先。
  /// 必须是有限非负数；仅改变内置图标及纯图标按钮的默认居中间距，不改变按钮高度。
  final double? extraSmallIconSize;

  const TButtonThemeData({
    this.iconTextSpacing,
    this.gradient,
    this.largeIconSize,
    this.mediumIconSize,
    this.smallIconSize,
    this.extraSmallIconSize,
  }) : assert(
         iconTextSpacing == null ||
             (iconTextSpacing >= 0 && iconTextSpacing < double.infinity),
         'iconTextSpacing must be finite and non-negative',
       ),
       assert(
         largeIconSize == null ||
             (largeIconSize >= 0 && largeIconSize < double.infinity),
       ),
       assert(
         mediumIconSize == null ||
             (mediumIconSize >= 0 && mediumIconSize < double.infinity),
       ),
       assert(
         smallIconSize == null ||
             (smallIconSize >= 0 && smallIconSize < double.infinity),
       ),
       assert(
         extraSmallIconSize == null ||
             (extraSmallIconSize >= 0 && extraSmallIconSize < double.infinity),
       );

  Map<TButtonSize, TokenDoubleLerp?> get _iconSizeLerps => const {};

  @internal
  double resolveIconSize(TButtonSize size, double fallback) {
    final explicit = switch (size) {
      TButtonSize.large => largeIconSize,
      TButtonSize.medium => mediumIconSize,
      TButtonSize.small => smallIconSize,
      TButtonSize.extraSmall => extraSmallIconSize,
    };
    return _iconSizeLerps[size]?.resolve(fallback) ?? explicit ?? fallback;
  }

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TButtonThemeData copyWith({
    double? iconTextSpacing,
    Gradient? gradient,
    double? largeIconSize,
    double? mediumIconSize,
    double? smallIconSize,
    double? extraSmallIconSize,
  }) {
    return _InterpolatedButtonThemeData(
      TButtonThemeData(
        iconTextSpacing: iconTextSpacing ?? this.iconTextSpacing,
        gradient: gradient ?? this.gradient,
        largeIconSize: largeIconSize ?? this.largeIconSize,
        mediumIconSize: mediumIconSize ?? this.mediumIconSize,
        smallIconSize: smallIconSize ?? this.smallIconSize,
        extraSmallIconSize: extraSmallIconSize ?? this.extraSmallIconSize,
      ),
      {
        if (largeIconSize == null && _iconSizeLerps[TButtonSize.large] != null)
          TButtonSize.large: _iconSizeLerps[TButtonSize.large]!,
        if (mediumIconSize == null &&
            _iconSizeLerps[TButtonSize.medium] != null)
          TButtonSize.medium: _iconSizeLerps[TButtonSize.medium]!,
        if (smallIconSize == null && _iconSizeLerps[TButtonSize.small] != null)
          TButtonSize.small: _iconSizeLerps[TButtonSize.small]!,
        if (extraSmallIconSize == null &&
            _iconSizeLerps[TButtonSize.extraSmall] != null)
          TButtonSize.extraSmall: _iconSizeLerps[TButtonSize.extraSmall]!,
      },
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TButtonThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TButtonThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TButtonThemeData) {
      return this;
    }
    return _InterpolatedButtonThemeData(
      TButtonThemeData(
        iconTextSpacing:
            iconTextSpacing == null && other.iconTextSpacing == null
            ? null
            : lerpDouble(
                iconTextSpacing ?? TButtonDefaults.iconTextSpacing,
                other.iconTextSpacing ?? TButtonDefaults.iconTextSpacing,
                t,
              ),
        gradient: t < 0.5 ? gradient : other.gradient,
        largeIconSize: largeIconSize == null || other.largeIconSize == null
            ? null
            : lerpDouble(largeIconSize, other.largeIconSize, t),
        mediumIconSize: mediumIconSize == null || other.mediumIconSize == null
            ? null
            : lerpDouble(mediumIconSize, other.mediumIconSize, t),
        smallIconSize: smallIconSize == null || other.smallIconSize == null
            ? null
            : lerpDouble(smallIconSize, other.smallIconSize, t),
        extraSmallIconSize:
            extraSmallIconSize == null || other.extraSmallIconSize == null
            ? null
            : lerpDouble(extraSmallIconSize, other.extraSmallIconSize, t),
      ),
      {
        TButtonSize.large: TokenDoubleLerp.between(
          largeIconSize,
          _iconSizeLerps[TButtonSize.large],
          other.largeIconSize,
          other._iconSizeLerps[TButtonSize.large],
          t,
        ),
        TButtonSize.medium: TokenDoubleLerp.between(
          mediumIconSize,
          _iconSizeLerps[TButtonSize.medium],
          other.mediumIconSize,
          other._iconSizeLerps[TButtonSize.medium],
          t,
        ),
        TButtonSize.small: TokenDoubleLerp.between(
          smallIconSize,
          _iconSizeLerps[TButtonSize.small],
          other.smallIconSize,
          other._iconSizeLerps[TButtonSize.small],
          t,
        ),
        TButtonSize.extraSmall: TokenDoubleLerp.between(
          extraSmallIconSize,
          _iconSizeLerps[TButtonSize.extraSmall],
          other.extraSmallIconSize,
          other._iconSizeLerps[TButtonSize.extraSmall],
          t,
        ),
      },
    );
  }
}

class _InterpolatedButtonThemeData extends TButtonThemeData {
  _InterpolatedButtonThemeData(TButtonThemeData data, this._iconSizeLerps)
    : super(
        iconTextSpacing: data.iconTextSpacing,
        gradient: data.gradient,
        largeIconSize: data.largeIconSize,
        mediumIconSize: data.mediumIconSize,
        smallIconSize: data.smallIconSize,
        extraSmallIconSize: data.extraSmallIconSize,
      );

  @override
  final Map<TButtonSize, TokenDoubleLerp?> _iconSizeLerps;
}
