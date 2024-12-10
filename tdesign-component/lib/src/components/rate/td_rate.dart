import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';
import '../../util/throttle.dart';
import 'td_rate_overlay.dart';
import 'td_rate_tips.dart';

enum PlacementEnum {
  none,
  top,
  bottom,
}

/// 评分组件
class TDRate extends StatefulWidget {
  const TDRate({
    super.key,
    this.allowHalf = false,
    this.color,
    this.count = 5,
    this.disabled = false,
    this.gap,
    this.icon,
    this.placement = PlacementEnum.top,
    this.showText = false,
    this.size = 24.0,
    this.texts = const ['极差', '失望', '一般', '满意', '惊喜'],
    this.textWidth = 48.0,
    this.builderText,
    this.value = 0,
    this.onChange,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.iconTextGap,
  });

  /// 是否允许半选
  final bool? allowHalf;

  /// 评分图标的颜色，示例：[选中颜色] / [选中颜色，未选中颜色]，默认：[TDTheme.of(context).warningColor5, TDTheme.of(context).grayColor4]
  final List<Color>? color;

  /// 评分的数量
  final int? count;

  /// 是否禁用评分
  final bool? disabled;

  /// 评分图标的间距，默认：TDTheme.of(context).spacer8
  final double? gap;

  /// 自定义评分图标，[选中和未选中图标] / [选中图标，未选中图标]，默认：[TDIcons.star_filled]
  final List<IconData>? icon;

  /// 选择评分弹框的位置，值为[PlacementEnum.none]表示不显示评分弹框。
  final PlacementEnum? placement;

  /// 是否显示对应的辅助文字
  final bool? showText;

  /// 评分图标的大小
  final double? size;

  /// 评分等级对应的辅助文字，
  /// 当[allowHalf]为false时长度应与[count]一致，
  /// 当[allowHalf]为true时长度应为[count]的两倍，
  /// 自定义值示例：['1分', '2分', '3分', '4分', '5分']。
  final List<String>? texts;

  /// 评分等级对应的辅助文字宽度
  final double? textWidth;

  /// 评分等级对应的辅助文字自定义构建，优先级高于[texts]
  /// 配置后，会忽略[texts],[textWidth],[iconTextGap]
  final Widget Function(BuildContext context, double value)? builderText;

  /// 选择评分的值
  final double? value;

  /// 评分数改变时触发
  final void Function(double value)? onChange;

  /// 评分图标与辅助文字的布局方向
  final Axis? direction;

  /// 评分图标与辅助文字的主轴对齐方式
  final MainAxisAlignment? mainAxisAlignment;

  /// 评分图标与辅助文字的交叉轴对齐方式
  final CrossAxisAlignment? crossAxisAlignment;

  /// 评分图标与辅助文字主轴方向上如何占用空间
  final MainAxisSize? mainAxisSize;

  /// 评分图标与辅助文字的间距，默认：[TDTheme.of(context).spacer16]
  final double? iconTextGap;

  @override
  _TDRateState createState() => _TDRateState();
}

class _TDRateState extends State<TDRate> with TickerProviderStateMixin {
  /// 节流
  final _throttle = Throttle(delay: const Duration(milliseconds: 100));

  /// 当前选中的评分值
  late double _activeValue;

  /// 根据评分值，获取所在评分的索引
  int _index([double? value]) => ((value ?? _activeValue) - 0.5).floor();

  /// 每半个评分的GlobalKey
  late Map<double, GlobalKey> _globalKeys;

  /// 弹框
  late TDRateOverlay _overlay;

  /// 动画
  late List<AnimationController> _controller;
  late List<Animation<double>> _animation;

  /// 隐藏弹框的定时器
  Timer? _hideTipTimer;

  /// 控制显示弹框
  var _showTip = false;

  /// 弹框的尺寸
  var _tipSize = Size.zero;

  /// 每个评分(Row)的Size:<索引, Size>
  final _rateSize = <int, Size>{};

  /// 每个评分(Row)的Offset:<索引, Offset>
  final _rateOffset = <int, Offset>{};

  /// 是否点击，否则是滑动
  var _isClick = true;

  @override
  void initState() {
    super.initState();
    _activeValue = widget.value ?? 0;
    _globalKeys = List.generate((widget.count ?? 5) * 2, (index) => index / 2 + 0.5)
        .asMap()
        .map((index, e) => MapEntry(e, GlobalKey()));
    _overlay = TDRateOverlay(context: context, builder: (context) => _buildOverlay())..show();
    _tipSize = Size(widget.allowHalf == true ? 76 : 40, 52);
    _controller = List.generate(
        widget.count ?? 5,
        ((index) => AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: this,
            )));
    _animation =
        List.generate(widget.count ?? 5, ((index) => Tween<double>(begin: 1.0, end: 1.33).animate(_controller[index])));
  }

  @override
  void didUpdateWidget(TDRate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _activeValue = widget.value ?? 0;
    }
    if (widget.count != oldWidget.count) {
      _globalKeys = List.generate((widget.count ?? 5) * 2, (index) => index / 2 + 0.5)
          .asMap()
          .map((index, e) => MapEntry(e, GlobalKey()));
    }
    if (widget.allowHalf != oldWidget.allowHalf) {
      _tipSize = Size(widget.allowHalf == true ? 76 : 40, 52);
    }
  }

  @override
  void dispose() {
    _overlay.hide();
    _hideTipTimer?.cancel();
    _controller.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: widget.direction ?? Axis.horizontal,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: widget.mainAxisSize ?? MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (event) {
            if (widget.disabled == true) {
              return;
            }
            _isClick = true;
          },
          onTapUp: (details) {
            if (widget.disabled == true) {
              return;
            }
            _changeSelect(details.globalPosition, true);
            _hideTip();
          },
          onHorizontalDragUpdate: (details) {
            if (widget.disabled == true) {
              return;
            }
            _isClick = false;
            _changeSelect(details.globalPosition);
          },
          onHorizontalDragEnd: (details) {
            if (widget.disabled == true) {
              return;
            }
            _hideTip();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.count ?? 5, (index) {
              final isLast = index == (widget.count ?? 5) - 1;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : widget.gap ?? TDTheme.of(context).spacer8),
                child: AnimatedBuilder(
                  animation: _animation[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation[index].value,
                      child: child,
                    );
                  },
                  child: Row(
                    children: [
                      ClipRect(
                        key: _globalKeys[index + 0.5],
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.5,
                          child: Icon(
                            _getIcon(value: index + 0.5),
                            size: widget.size ?? 24,
                            color: _getIconColor(value: index + 0.5),
                          ),
                        ),
                      ),
                      ClipRect(
                        key: _globalKeys[index + 1.0],
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: 0.5,
                          child: Icon(
                            _getIcon(value: index + 1.0),
                            size: widget.size ?? 24,
                            color: _getIconColor(value: index + 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        if (widget.showText ?? false) widget.builderText?.call(context, _activeValue) ?? _getDefText()
      ],
    );
  }

  void _changeSelect(Offset globalPosition, [bool? isTap]) {
    _throttle.call(() {
      final newIndex = _fingerInsideContainer(globalPosition);
      if (newIndex == null) {
        return;
      }
      final diff = newIndex != _activeValue;
      if (diff || isTap == true) {
        _activeValue = newIndex;
        _showTip = newIndex == 0 ? false : true;
        _forward();
        _overlay.update();
        if (diff) {
          setState(() {});
          widget.onChange?.call(newIndex);
        }
      }
    });
  }

  void _forward() {
    _controller.forEach((element) {
      element.reverse();
    });
    _controller.getOrNull(_index())?.forward();
  }

  void _reverse() {
    _controller.forEach((element) {
      element.reverse();
    });
  }

  double? _fingerInsideContainer(Offset globalPosition) {
    final rateBox = context.findRenderObject() as RenderBox?;
    if (rateBox == null) {
      return null;
    }
    final rateOffset = rateBox.localToGlobal(Offset.zero);
    if (globalPosition.dx < rateOffset.dx) {
      return 0;
    }
    for (var entry in _globalKeys.entries) {
      final renderBox = entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final localPosition = renderBox.globalToLocal(globalPosition);
        final isIn = renderBox.hitTest(BoxHitTestResult(), position: localPosition);
        if (isIn) {
          var value = widget.allowHalf == true ? entry.key : entry.key.ceil().toDouble();
          var index = _index(value);
          if (!_rateSize.containsKey(index) || !_rateOffset.containsKey(index)) {
            final parentRenderBox = renderBox.parent as RenderBox;
            _rateSize[index] = parentRenderBox.size;
            _rateOffset[index] = parentRenderBox.localToGlobal(Offset.zero);
          }
          return value;
        }
      }
    }
    return null;
  }

  void _hideTip() {
    _hideTipTimer?.cancel();
    _hideTipTimer = Timer(
      Duration(milliseconds: _isClick && widget.allowHalf == true ? 3000 : 1000),
      () {
        _showTip = false;
        _isClick = true;
        _reverse();
        _overlay.update();
      },
    );
  }

  Widget _getDefText() {
    final notRated = _activeValue == 0;
    final textIndex = (widget.allowHalf == true ? _activeValue * 2 : _activeValue) - 1;
    return Padding(
      padding: widget.direction == Axis.horizontal
          ? EdgeInsets.only(left: widget.iconTextGap ?? TDTheme.of(context).spacer16)
          : EdgeInsets.only(top: widget.iconTextGap ?? TDTheme.of(context).spacer8),
      child: SizedBox(
        width: widget.textWidth ?? 50,
        child: TDText(
          notRated ? context.resource.notRated : widget.texts?.getOrNull(textIndex.toInt()) ?? '$_activeValue',
          font: notRated ? TDTheme.of(context).fontBodyLarge : TDTheme.of(context).fontTitleMedium,
          textColor: notRated ? TDTheme.of(context).fontGyColor4 : TDTheme.of(context).fontGyColor1,
        ),
      ),
    );
  }

  Color _getIconColor({double? value, bool? isActive}) {
    return (value != null && _activeValue >= value) || (isActive != null && isActive)
        ? widget.color?.getOrNull(0) ?? TDTheme.of(context).warningColor5
        : widget.color?.getOrNull(1) ?? TDTheme.of(context).grayColor4;
  }

  IconData _getIcon({double? value, bool? isActive}) {
    final selectIcon = widget.icon?.getOrNull(0) ?? TDIcons.star_filled;
    final icon = [selectIcon, widget.icon?.getOrNull(1) ?? selectIcon];
    return (value != null && _activeValue >= value) || (isActive != null && isActive) ? icon[0] : icon[1];
  }

  Widget _buildOverlay() {
    if (widget.placement == PlacementEnum.none || !_showTip || _activeValue == 0) {
      return const SizedBox.shrink();
    }
    var index = _index();
    var rateSize = _rateSize[index];
    var rateOffset = _rateOffset[index];
    if (rateSize == null || rateOffset == null) {
      return const SizedBox.shrink();
    }
    return Positioned(
      top: widget.placement == PlacementEnum.top
          ? rateOffset.dy - TDTheme.of(context).spacer8 - _tipSize.height
          : rateOffset.dy + TDTheme.of(context).spacer8 + rateSize.height,
      left: rateOffset.dx - (_tipSize.width - rateSize.width) / 2,
      child: TDRateTips(
        allowHalf: widget.allowHalf,
        activeValue: _activeValue,
        icon: _getIcon(isActive: true),
        size: widget.size,
        getIconColor: _getIconColor,
        isClick: _isClick,
        sizeCall: (size) {
          if (_tipSize.width != size.width || _tipSize.height != size.height) {
            _tipSize = size;
            _overlay.update();
          }
        },
        tipClick: (value) {
          _showTip = false;
          _isClick = true;
          _reverse();
          _overlay.update();
          if (value != _activeValue) {
            _activeValue = value;
            setState(() {});
            widget.onChange?.call(value);
          }
        },
      ),
    );
  }
}
