import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

enum TDTabSize { large, small }

enum TDTabOutlineType {
  // 填充样式
  filled,
  // 胶囊样式
  capsule,
  // 卡片
  card
}

class TDTab extends Tab {
  /// 文字内容
  @override
  final String? text;

  /// 子widget
  @override
  final Widget? child;

  /// 图标
  @override
  final Widget? icon;

  /// 图标
  final TDBadge? badge;

  /// 图标间距
  @override
  final EdgeInsetsGeometry iconMargin;

  /// tab高度
  @override
  final double? height;

  /// 中间内容高度
  final double? contentHeight;

  /// 中间内容宽度
  final EdgeInsetsGeometry? textMargin;

  /// 是否可用，默认true
  final bool enable;

  /// 选项卡尺寸
  final TDTabSize size;

  ///选项卡样式
  final TDTabOutlineType outlineType;

  @override
  const TDTab(
      {Key? key,
      this.text,
      this.child,
      this.icon,
      this.badge,
      this.height,
      this.contentHeight,
      this.textMargin,
      this.size = TDTabSize.small,
      this.outlineType = TDTabOutlineType.filled,
      this.enable = true,
      this.iconMargin = const EdgeInsets.only(bottom: 4.0, right: 4.0)})
      : super(
            key: key,
            text: text,
            child: child,
            icon: icon,
            height: height,
            iconMargin: iconMargin);

  final double _kTabHeight = 48.0;
  final double _kTextAndIconTabHeight = 72.0;

  @override
  Widget build(BuildContext context) {
    final double calculatedHeight;
    Widget label;
    if (icon == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon!;
    } else {
      calculatedHeight = _kTextAndIconTabHeight;
      label = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon ?? Container(),
          SizedBox(
            width: iconMargin.horizontal,
            height: iconMargin.vertical,
          ),
          _buildLabelText(),
        ],
      );
    }
    if (badge != null) {
      label = Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(margin: textMargin, child: label),
          Positioned(
            child: badge!,
            right: 0,
            top: 0,
          ),
        ],
      );
    }
    var isCapsuleOutlineType = outlineType == TDTabOutlineType.capsule;

    return IgnorePointer(
      ignoring: !enable,
      child: Container(
        alignment: Alignment.center,
        margin: isCapsuleOutlineType
            ? const EdgeInsets.symmetric(horizontal: 16)
            : null,
        height: height ?? calculatedHeight,
        child: Center(
          widthFactor: 1.0,
          child: label,
        ),
      ),
    );
  }

  Widget _buildLabelText() {
    return child ??
        Text(
          text!,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: TextStyle(fontSize: _getFontSize()),
        );
  }

  double _getFontSize() {
    if (size == TDTabSize.large) {
      return 16.0;
    } else {
      return 14.0;
    }
  }
}
