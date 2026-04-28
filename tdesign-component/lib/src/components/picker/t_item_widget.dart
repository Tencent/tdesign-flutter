import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

typedef ItemBuilderType = Widget? Function(
  /// 上下文
  BuildContext context,

  /// 文字内容
  String content,

  /// 列号
  int colIndex,

  /// 行号
  int index,

  /// 根据距离计算字体颜色、透明度、粗细
  ItemDistanceCalculator itemDistanceCalculator,

  /// 子项此时离中心的距离
  double distance,
);

/// 所有选择器的子项组件
class TItemWidget extends StatefulWidget {
  final String content;
  final FixedExtentScrollController fixedExtentScrollController;
  final int colIndex;
  final int index;
  final double itemHeight;
  final bool disabled;
  final ItemDistanceCalculator? itemDistanceCalculator;
  final ItemBuilderType? itemBuilder;

  const TItemWidget({
    required this.fixedExtentScrollController,
    required this.colIndex,
    required this.index,
    required this.content,
    required this.itemHeight,
    this.disabled = false,
    this.itemDistanceCalculator,
    this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  _TItemWidgetState createState() => _TItemWidgetState();
}

class _TItemWidgetState extends State<TItemWidget> {
  /// 子项监听滚动，从而刷新自身的颜色
  VoidCallback? listener;
  ItemDistanceCalculator? _itemDistanceCalculator;

  @override
  void initState() {
    super.initState();
    listener = () => setState(() {});
    _itemDistanceCalculator = widget.itemDistanceCalculator;

    /// 子项注册滚动监听
    widget.fixedExtentScrollController.addListener(listener!);
  }

  @override
  Widget build(BuildContext context) {
    /// 子项此时离中心的距离
    var distance =
        (widget.fixedExtentScrollController.offset / widget.itemHeight -
                widget.index)
            .abs()
            .toDouble();
    _itemDistanceCalculator ??= ItemDistanceCalculator();

    // disabled 项：使用默认禁用样式（opacity=0.5, 灰色, w400）
    if (widget.disabled) {
      return Center(
        child: Opacity(
          opacity: 0.5,
          child: TText(
            widget.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: _itemDistanceCalculator!.calculateFont(context, 0),
              color: TTheme.of(context).textDisabledColor,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Opacity(
        opacity: _itemDistanceCalculator!.calculateOpacity(distance),
        child: widget.itemBuilder?.call(
              context,
              widget.content,
              widget.colIndex,
              widget.index,
              _itemDistanceCalculator!,
              distance,
            ) ??
            TText(
              widget.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: _itemDistanceCalculator!
                    .calculateFontWeight(context, distance),
                fontSize: _itemDistanceCalculator!.calculateFont(context, distance),
                color: _itemDistanceCalculator!.calculateColor(context, distance),
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    /// 在销毁前完成监听注销
    widget.fixedExtentScrollController.removeListener(listener!);
    super.dispose();
  }
}

class ItemDistanceCalculator {
  ItemDistanceCalculator();

  /// 距离 → 整数档位（0=选中, 1=紧邻, 2=近边, 3+=远边）
  static int _level(double distance) => distance.round().clamp(0, 3);

  /// 颜色：按档位离散赋值（不用 lerp 渐变）
  Color calculateColor(BuildContext context, double distance) {
    final primary = TTheme.of(context).textColorPrimary;
    final placeholder = TTheme.of(context).textColorPlaceholder;
    switch (_level(distance)) {
      case 0: return primary;                                    // 选中：纯主色
      case 1: return Color.lerp(primary, placeholder, 0.55) ?? primary;   // 紧邻：55%占位色
      case 2: return Color.lerp(primary, placeholder, 0.78) ?? placeholder; // 近边：78%占位色
      default: return placeholder;                               // 远边/边缘：纯占位色
    }
  }

  /// 粗细：按档位离散赋值
  FontWeight calculateFontWeight(BuildContext context, double distance) {
    switch (_level(distance)) {
      case 0: return FontWeight.w700;                            // 选中
      case 1: return FontWeight.w500;                            // 紧邻
      case 2: return FontWeight.w400;                            // 近边
      default: return FontWeight.w300;                           // 远边
    }
  }

  /// 大小：中心最大，边缘缩小（产生远近透视感）
  double calculateFont(BuildContext context, double distance) {
    final baseSize = TTheme.of(context).fontBodyLarge!.size;
    switch (_level(distance)) {
      case 0: return baseSize * 1.00;                            // 100%
      case 1: return baseSize * 0.94;                            // 94%
      case 2: return baseSize * 0.88;                            // 88%
      default: return baseSize * 0.82;                           // ~82%
    }
  }

  /// 透明度：选中=1.0，其余统一 0.6（仅区分选中与非选中）
  double calculateOpacity(double distance) {
    switch (_level(distance)) {
      case 0: return 1.00;                                       // 选中
      default: return 0.75;                                      // 非选中（统一）
    }
  }
}
