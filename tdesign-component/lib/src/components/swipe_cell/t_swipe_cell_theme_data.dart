import 'package:flutter/material.dart';

/// TSwipeCell 组件级 ThemeExtension
///
/// 通过 Theme 子树注入操作项共享内边距；逐项图文样式由操作项实例控制。
///
/// {@category ComponentTheme}
class TSwipeCellThemeData extends ThemeExtension<TSwipeCellThemeData> {
  /// 操作项左右内边距。
  final EdgeInsetsGeometry? actionPadding;

  const TSwipeCellThemeData({this.actionPadding});

  /// 合并主题配置。
  ///
  /// ## 返回值
  /// other 的非空字段优先的合并主题；other 为 null 时返回当前主题。
  TSwipeCellThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TSwipeCellThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return TSwipeCellThemeData(
      actionPadding: other.actionPadding ?? actionPadding,
    );
  }

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TSwipeCellThemeData copyWith({EdgeInsetsGeometry? actionPadding}) {
    return TSwipeCellThemeData(
      actionPadding: actionPadding ?? this.actionPadding,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TSwipeCellThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TSwipeCellThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TSwipeCellThemeData) {
      return this;
    }
    return TSwipeCellThemeData(
      actionPadding: EdgeInsetsGeometry.lerp(
        actionPadding,
        other.actionPadding,
        t,
      ),
    );
  }
}
