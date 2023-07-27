import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 所有选择器的子项组件

class TDItemWidget extends StatefulWidget {
  final String content;
  final FixedExtentScrollController fixedExtentScrollController;
  final int index;
  final double itemHeight;
  final ItemDistanceCalculator? itemDistanceCalculator;


  const TDItemWidget(
      {required this.fixedExtentScrollController,
      required this.index,
      required this.content,
      required this.itemHeight,
      this.itemDistanceCalculator,
      Key? key})
      : super(key: key);

  @override
  _TDItemWidgetState createState() => _TDItemWidgetState();
}

class _TDItemWidgetState extends State<TDItemWidget> {
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
    /// 不要使用widget.fixedExtentScrollController.selectedItem
    /// 其中selectedItem会报错，原因是一开始minScrollExtent为空
    var distance =
        (widget.fixedExtentScrollController.offset / widget.itemHeight -
                widget.index)
            .abs()
            .toDouble();
    _itemDistanceCalculator ??= ItemDistanceCalculator();
    return TDText(widget.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: _itemDistanceCalculator!.calculateFontWeight(context, distance),
          fontSize: _itemDistanceCalculator!.calculateFont(context, distance),
          color: _itemDistanceCalculator!.calculateColor(context, distance)
        ));
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

  Color calculateColor(BuildContext context, double distance) {
    /// 线性插值
    if (distance < 0.5) {
      return TDTheme.of(context).fontGyColor1;
    } else {
      return TDTheme.of(context).fontGyColor4;
    }
  }

  FontWeight calculateFontWeight(BuildContext context, double distance) {
    if (distance < 0.5) {
      return FontWeight.w600;
    } else {
      return FontWeight.w400;
    }
  }

  double calculateFont(BuildContext context, double distance) {
    return TDTheme.of(context).fontBodyLarge!.size;
  }
}
