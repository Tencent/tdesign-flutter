import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

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
    this.iconWidget,
    this.placement = PlacementEnum.top,
    this.showText = false,
    this.size = 24.0,
    this.texts = const ['极差', '失望', '一般', '满意', '惊喜'],
    this.defaultValue = 0,
    this.onChange,
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

  /// 自定义评分图标组件，[选中和未选中图标] / [选中图标，未选中图标]，设置此值会忽略[color]/[icon]/[size]
  final List<Icon>? iconWidget;

  /// 选择评分弹框的位置，值为[PlacementEnum.none]表示不显示评分弹框。
  final PlacementEnum? placement;

  /// 是否显示对应的辅助文字
  final bool? showText;

  /// 评分图标的大小
  final double? size;

  /// 评分等级对应的辅助文字，长度应与[count]一致。自定义值示例：['1分', '2分', '3分', '4分', '5分']。
  final List<String>? texts;

  /// 选择评分的默认值
  final double? defaultValue;

  /// 评分数改变时触发
  final void Function(double value)? onChange;

  @override
  _TDRateState createState() => _TDRateState();
}

class _TDRateState extends State<TDRate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
