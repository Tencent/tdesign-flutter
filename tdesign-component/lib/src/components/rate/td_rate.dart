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

  /// 评分图标与辅助文字的间距，默认：[TDTheme.of(context).spacer16]
  final double? iconTextGap;

  @override
  _TDRateState createState() => _TDRateState();
}

class _TDRateState extends State<TDRate> {
  final _throttle = Throttle(delay: const Duration(milliseconds: 100));
  late double _activeValue;
  late Map<double, GlobalKey> _globalKeys;
  late TDRateOverlay _overlay;
  Timer? _hideTipTimer;

  /// 控制显示弹框
  var _showTip = false;

  /// 弹框的尺寸
  var _tipSize = Size.zero;

  /// 当前选中的评分的位置
  var _rateOffset = Offset.zero;

  /// 当前选中的评分的大小
  var _rateSize = Size.zero;

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
  }

  @override
  void dispose() {
    _overlay.hide();
    _hideTipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: widget.direction ?? Axis.horizontal,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTapDown: (event) {
            _isClick = true;
          },
          onTapUp: (details) {
            _changeSelect(details.globalPosition, true);
            _hideTip();
          },
          onHorizontalDragUpdate: (details) {
            _isClick = false;
            _changeSelect(details.globalPosition);
          },
          onHorizontalDragEnd: (details) {
            _hideTip();
          },
          child: Row(
            children: List.generate(widget.count ?? 5, (index) {
              final isLast = index == (widget.count ?? 5) - 1;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : widget.gap ?? TDTheme.of(context).spacer8),
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
        _overlay.update();
        if (diff) {
          setState(() {});
          widget.onChange?.call(newIndex);
        }
      }
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
          final parentRenderBox = renderBox.parent as RenderBox;
          _rateOffset = parentRenderBox.localToGlobal(Offset.zero);
          _rateSize = parentRenderBox.size;
          return widget.allowHalf == true ? entry.key : entry.key.ceil().toDouble();
        }
      }
    }
    return null;
  }

  void _hideTip() {
    _hideTipTimer?.cancel();
    _hideTipTimer = Timer(
      Duration(seconds: _isClick && widget.allowHalf == true ? 3 : 1),
      () {
        _showTip = false;
        _isClick = true;
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
    return widget.placement != PlacementEnum.none && _showTip
        ? Positioned(
            top: widget.placement == PlacementEnum.top
                ? _rateOffset.dy - TDTheme.of(context).spacer8 - _tipSize.height
                : _rateOffset.dy + TDTheme.of(context).spacer8 + _rateSize.height,
            left: _rateOffset.dx - (_tipSize.width - _rateSize.width) / 2,
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
                _overlay.update();
                if (value != _activeValue) {
                  _activeValue = value;
                  setState(() {});
                }
              },
            ),
          )
        : const SizedBox.shrink();
  }
}
