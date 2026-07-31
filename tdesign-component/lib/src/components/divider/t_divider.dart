import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_divider_painter.dart';
import 't_divider_theme_data.dart';

/// 分割线布局方向
enum TDividerLayout {
  /// 水平分割线
  horizontal,

  /// 垂直分割线
  vertical,
}

/// 中间内容在线条中的位置（仅 [TDividerLayout.horizontal] 生效）
enum TDividerAlign {
  /// 内容靠左
  left,

  /// 内容居中
  center,

  /// 内容靠右
  right,
}

/// 分割线组件
///
/// T3 自绘层级，不包装 Material [Divider]。包含两种绘制模式：
/// - 模式 A（纯线）：[child] 为空，横线可虚线、竖线强制实线
/// - 模式 B（线 + 中间）：[layout] 为 horizontal 且 [child] 非空
///
/// 竖线（[TDividerLayout.vertical]）时强制忽略 [dashed]、[align]、[child]，
/// 对齐 React/Vue Divider 跨端规范。
///
/// 示例：
/// ```dart
/// // 水平分割线
/// TDivider()
///
/// // 带文字的水平分割线
/// TDivider(child: Text('文字信息'))
///
/// // 虚线 + 文字靠左
/// TDivider(dashed: true, align: TDividerAlign.left, child: Text('靠左'))
///
/// // 竖线（定高由父布局控制）
/// SizedBox(height: 56, child: TDivider(layout: TDividerLayout.vertical))
/// ```
class TDivider extends StatelessWidget {
  const TDivider({
    super.key,
    this.layout,
    this.align,
    this.dashed,
    this.child,
  });

  /// 横/竖分割线，默认 [TDividerLayout.horizontal]
  final TDividerLayout? layout;

  /// 中间内容在线条中的位置，默认 [TDividerAlign.center]
  /// 仅 [TDividerLayout.horizontal] 生效
  final TDividerAlign? align;

  /// 是否为虚线，默认 false
  /// 仅 [TDividerLayout.horizontal] 生效
  final bool? dashed;

  /// 中间子元素
  /// 纯文案用 `child: Text('……')`
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // ---- resolve 内联链 ----
    // 优先级：构造器 L1/L2 > TDividerThemeData > Material DividerTheme (P2) > Token (P4)
    final theme = Theme.of(context).extension<TDividerThemeData>();
    final dividerTheme = Theme.of(context).dividerTheme;

    final effectiveLayout = layout ?? TDividerLayout.horizontal;

    // L4 值按优先级 fallback
    final effectiveColor = theme?.color ??
        dividerTheme.color ??
        context.tTheme.componentStrokeColor;
    final effectiveThickness =
        theme?.thickness ?? dividerTheme.thickness ?? 0.5;
    final effectiveIndent = theme?.indent;
    final effectiveEndIndent = theme?.endIndent;
    final effectiveGapPadding =
        theme?.gapPadding ?? const EdgeInsets.symmetric(horizontal: 8);
    final effectiveMargin = theme?.margin;
    final effectiveTextStyle = theme?.textStyle;

    // ---- 按 layout 选模式 ----
    Widget result;

    if (effectiveLayout == TDividerLayout.vertical) {
      // 竖线：仅模式 A，强制忽略 dashed / align / child
      result = _buildVerticalLine(effectiveColor, effectiveThickness);
    } else if (child != null) {
      // 模式 B：横线 + 中间内容
      final effectiveDashed = dashed ?? false;
      final effectiveAlign = align ?? TDividerAlign.center;
      result = _buildLineWithChild(
        effectiveColor,
        effectiveThickness,
        effectiveGapPadding,
        effectiveTextStyle,
        effectiveDashed,
        effectiveAlign,
      );
    } else {
      // 模式 A：纯横线
      final effectiveDashed = dashed ?? false;
      result = _buildHorizontalLine(
        effectiveColor,
        effectiveThickness,
        effectiveDashed,
        effectiveIndent,
        effectiveEndIndent,
      );
    }

    // 外边距
    if (effectiveMargin != null) {
      result = Padding(padding: effectiveMargin, child: result);
    }

    return result;
  }

  /// 模式 A — 纯横线（实线或虚线）
  Widget _buildHorizontalLine(
    Color color,
    double thickness,
    bool isDashed,
    double? indent,
    double? endIndent,
  ) {
    Widget line;
    if (isDashed) {
      line = SizedBox(
        height: thickness,
        child: CustomPaint(
          painter: DashedPainter(color: color, strokeWidth: thickness),
        ),
      );
    } else {
      line = Container(height: thickness, color: color);
    }

    // 缩进
    if (indent != null || endIndent != null) {
      line = Padding(
        padding: EdgeInsetsDirectional.only(
          start: indent ?? 0,
          end: endIndent ?? 0,
        ),
        child: line,
      );
    }

    return line;
  }

  /// 模式 A — 纯竖线（始终实线，高度由父布局决定）
  Widget _buildVerticalLine(Color color, double thickness) {
    return Container(width: thickness, color: color);
  }

  /// 模式 B — 横线 + 中间内容
  Widget _buildLineWithChild(
    Color color,
    double thickness,
    EdgeInsetsGeometry gapPadding,
    TextStyle? effectiveTextStyle,
    bool isDashed,
    TDividerAlign align,
  ) {
    // 给中间内容一个弹性宽度，避免长文案把 Row 撑出屏幕。
    // 不限制行数，让调用方仍可使用多行内容。
    final middleContent = Flexible(
      child: DefaultTextStyle.merge(
        style: effectiveTextStyle ?? const TextStyle(),
        child: Padding(
          padding: gapPadding,
          child: child!,
        ),
      ),
    );

    // 短线（固定 16px）用于 left / right 对齐的短边
    final shortLine = SizedBox(
      width: 16,
      height: thickness,
      child: isDashed
          ? CustomPaint(
              painter: DashedPainter(color: color, strokeWidth: thickness),
            )
          : Container(color: color),
    );

    // 弹性线
    final flexLine = Expanded(
      child: SizedBox(
        height: thickness,
        child: isDashed
            ? CustomPaint(
                painter: DashedPainter(color: color, strokeWidth: thickness),
              )
            : Container(color: color),
      ),
    );

    List<Widget> children;
    switch (align) {
      case TDividerAlign.left:
        children = [shortLine, middleContent, flexLine];
        break;
      case TDividerAlign.center:
        children = [flexLine, middleContent, flexLine];
        break;
      case TDividerAlign.right:
        children = [flexLine, middleContent, shortLine];
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
