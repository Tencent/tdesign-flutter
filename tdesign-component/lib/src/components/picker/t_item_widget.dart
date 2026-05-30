import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 自定义子项构建器类型
///
/// [context] 上下文
/// [content] 文字内容
/// [colIndex] 列号
/// [index] 行号
/// [calculator] 默认距离样式计算器，可在自定义渲染中复用
/// [distance] 子项此时离中心的距离
typedef ItemBuilderType = Widget? Function(
  BuildContext context,
  String content,
  int colIndex,
  int index,
  ItemDistanceCalculator itemDistanceCalculator,
  double distance,
);

// =============== 样式默认值（可被 ItemDistanceCalculator 继承覆盖） ===============

/// disabled 项透明度
const double _kDisabledItemOpacity = 0.5;

/// 基础字号 fallback（theme.fontBodyLarge.size 为 null 时使用）
const double _kBaseFontSize = 16.0;

/// 选择器的子项组件
class TItemWidget extends StatelessWidget {
  const TItemWidget({
    required this.fixedExtentScrollController,
    required this.colIndex,
    required this.index,
    required this.content,
    required this.itemHeight,
    this.disabled = false,
    this.itemBuilder,
    super.key,
  });

  /// 展示文字内容
  final String content;

  /// 所属滚轮的滚动控制器，用于计算离中心的距离
  final FixedExtentScrollController fixedExtentScrollController;

  /// 所在列索引
  final int colIndex;

  /// 所在行索引
  final int index;

  /// 单项高度
  final double itemHeight;

  /// 是否禁用（置灰且不响应选中）
  final bool disabled;

  /// 自定义子项构建器，null 时使用默认 [TText] 渲染
  final ItemBuilderType? itemBuilder;

  static const _calculator = ItemDistanceCalculator();

  @override
  Widget build(BuildContext context) {
    const calc = _calculator;

    if (disabled) {
      return Center(
        child: Opacity(
          opacity: _kDisabledItemOpacity,
          child: TText(
            content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: calc.calculateFont(context, 0),
              color: TTheme.of(context).textDisabledColor,
            ),
          ),
        ),
      );
    }

    return RepaintBoundary(
      // 语义比 AnimatedBuilder 更准确（后者会让人误以为是补间动画）
      child: ListenableBuilder(
        listenable: fixedExtentScrollController,
        builder: (context, _) {
          final distance =
              (fixedExtentScrollController.offset / itemHeight - index).abs();
          return Center(
            child: Opacity(
              opacity: calc.calculateOpacity(distance),
              child: itemBuilder?.call(
                    context,
                    content,
                    colIndex,
                    index,
                    calc,
                    distance,
                  ) ??
                  TText(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: calc.calculateFontWeight(context, distance),
                      fontSize: calc.calculateFont(context, distance),
                      color: calc.calculateColor(context, distance),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}

/// 距离到样式的映射器（内部默认渲染与 [ItemBuilderType] 回调共用）
///
/// 默认采用 4 档离散赋值（0=选中, 1=紧邻, 2=近边, 3+=远边）。
/// 在 [ItemBuilderType] 中可继承此类自定义颜色/字号/透明度过渡曲线。
class ItemDistanceCalculator {
  const ItemDistanceCalculator();

  /// 4 档粗细：选中 → 最远
  static const List<FontWeight> _fontWeightLevels = <FontWeight>[
    FontWeight.w700,
    FontWeight.w500,
    FontWeight.w400,
    FontWeight.w300,
  ];

  /// 4 档字号缩放因子：选中 → 最远
  static const List<double> _fontSizeScales = <double>[1.00, 0.94, 0.88, 0.82];

  /// 4 档颜色混合比例（主色 → 占位色）：选中 → 最远
  static const List<double> _colorMixLevels = <double>[0.00, 0.55, 0.78, 1.00];

  /// 把连续距离量化为 0~3 的档位
  static int _level(double distance) => distance.round().clamp(0, 3);

  /// 计算指定距离处的文字颜色
  Color calculateColor(BuildContext context, double distance) {
    final theme = TTheme.of(context);
    final primary = theme.textColorPrimary;
    final placeholder = theme.textColorPlaceholder;
    final mix = _colorMixLevels[_level(distance)];
    if (mix == 0) {
      return primary;
    }
    if (mix >= 1) {
      return placeholder;
    }
    return Color.lerp(primary, placeholder, mix) ?? placeholder;
  }

  /// 计算指定距离处的文字粗细
  FontWeight calculateFontWeight(BuildContext context, double distance) =>
      _fontWeightLevels[_level(distance)];

  /// 计算指定距离处的字体大小
  double calculateFont(BuildContext context, double distance) {
    final baseSize = TTheme.of(context).fontBodyLarge?.size ?? _kBaseFontSize;
    return baseSize * _fontSizeScales[_level(distance)];
  }

  /// 计算指定距离处的不透明度（非选中项统一半透明）
  double calculateOpacity(double distance) =>
      _level(distance) == 0 ? 1.00 : 0.75;
}
