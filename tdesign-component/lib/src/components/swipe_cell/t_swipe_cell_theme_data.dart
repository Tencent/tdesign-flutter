import 'package:flutter/material.dart';

/// TSwipeCell 组件级 ThemeExtension
///
/// 通过 Theme 子树注入操作项共享内边距；逐项图文样式由操作项实例控制。
class TSwipeCellThemeData extends ThemeExtension<TSwipeCellThemeData> {
  /// 操作项左右内边距。
  final EdgeInsetsGeometry? actionPadding;

  const TSwipeCellThemeData({this.actionPadding});

  /// 合并两个 ThemeExtension，[other] 优先于 this
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

  @override
  TSwipeCellThemeData copyWith({EdgeInsetsGeometry? actionPadding}) {
    return TSwipeCellThemeData(
      actionPadding: actionPadding ?? this.actionPadding,
    );
  }

  @override
  TSwipeCellThemeData lerp(
    ThemeExtension<TSwipeCellThemeData>? other,
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
