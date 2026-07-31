import 'package:flutter/material.dart';

/// 步骤条组件 ThemeExtension
///
/// 管理 TSteps 的子树级默认布局和交互模式。
/// 构造器参数优先级高于 ThemeData。
class TStepsThemeData extends ThemeExtension<TStepsThemeData> {
  /// 默认 simple 模式
  final bool? simple;

  /// 默认 readOnly 模式
  final bool? readOnly;

  /// 默认垂直自定义步骤条选择模式
  final bool? verticalSelect;

  const TStepsThemeData({this.simple, this.readOnly, this.verticalSelect});

  @override
  TStepsThemeData copyWith({
    bool? simple,
    bool? readOnly,
    bool? verticalSelect,
  }) {
    return TStepsThemeData(
      simple: simple ?? this.simple,
      readOnly: readOnly ?? this.readOnly,
      verticalSelect: verticalSelect ?? this.verticalSelect,
    );
  }

  @override
  TStepsThemeData lerp(ThemeExtension<TStepsThemeData>? other, double t) {
    if (other is! TStepsThemeData) {
      return this;
    }
    return TStepsThemeData(
      simple: t < 0.5 ? simple : other.simple,
      readOnly: t < 0.5 ? readOnly : other.readOnly,
      verticalSelect: t < 0.5 ? verticalSelect : other.verticalSelect,
    );
  }
}
