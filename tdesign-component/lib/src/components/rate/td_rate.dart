import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';
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
  late double _activeValue;
  late Map<double, GlobalKey> _globalKeys;
  Timer? _hideTipTimer;

  /// 控制显示弹框
  var _showTip = false;

  /// 组件高度
  var _height = 0.0;

  /// 当前弹框宽度
  var _tipWidth = 0.0;

  /// 当前选中的评分宽度
  var _rateWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _activeValue = widget.value ?? 0;
    _globalKeys = List.generate((widget.count ?? 5) * 2, (index) => index / 2 + 0.5)
        .asMap()
        .map((index, e) => MapEntry(e, GlobalKey()));
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
        Listener(
          behavior: HitTestBehavior.opaque,
          onPointerMove: (details) {
            _changeSelect(details.position);
          },
          onPointerUp: (details) {
            _changeSelect(details.position);
            _hideTip();
          },
          onPointerCancel: (details) {
            _hideTip();
          },
          child: Row(
            children: List.generate(widget.count ?? 5, (index) {
              final isLast = index == (widget.count ?? 5) - 1;
              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : widget.gap ?? TDTheme.of(context).spacer8),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Row(
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
                    if (widget.placement != PlacementEnum.none &&
                        _showTip &&
                        (index + 0.5 == _activeValue || index + 1 == _activeValue))
                      Positioned(
                        bottom: widget.placement == PlacementEnum.top ? _height + TDTheme.of(context).spacer8 : null,
                        top: widget.placement == PlacementEnum.bottom ? _height + TDTheme.of(context).spacer8 : null,
                        left: -(_tipWidth - _rateWidth) / 2,
                        child: TDRateTips(
                          allowHalf: widget.allowHalf,
                          index: index,
                          activeValue: _activeValue,
                          icon: _getIcon(isActive: true),
                          size: widget.size,
                          getIconColor: _getIconColor,
                          withCall: (width) {
                            if (_tipWidth != width) {
                              setState(() {
                                _tipWidth = width;
                              });
                            }
                          },
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

  void _changeSelect(Offset globalPosition) {
    final newIndex = _fingerInsideContainer(globalPosition);
    if (newIndex != null && newIndex != _activeValue) {
      setState(() {
        _activeValue = newIndex;
        _showTip = newIndex == 0 ? false : true;
      });
      widget.onChange?.call(newIndex);
    }
  }

  double? _fingerInsideContainer(Offset globalPosition) {
    final rateBox = context.findRenderObject() as RenderBox?;
    _height = rateBox?.size.height ?? 0;
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
          _rateWidth = renderBox.size.width * 2;
          return (widget.allowHalf ?? false) ? entry.key : entry.key.ceil().toDouble();
        }
      }
    }
    return null;
  }

  void _hideTip() {
    _hideTipTimer?.cancel();
    _hideTipTimer = Timer(
      const Duration(seconds: 1),
      () {
        setState(() {
          _showTip = false;
        });
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
}
