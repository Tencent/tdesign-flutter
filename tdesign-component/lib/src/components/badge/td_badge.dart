import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

enum TBadgeType {
  /// 红点样式
  redPoint,

  /// 消息样式
  message,

  /// 气泡样式
  bubble,

  /// 方形样式
  square,

  /// 角标样式
  subscript
}

enum TBadgeBorder {
  /// 大圆角 8px
  large,

  /// 小圆角 2px
  small
}

enum TBadgeSize {
  /// 宽 20px
  large,

  /// 宽 16px
  small,
}

class TBadge extends StatefulWidget {
  const TBadge(
    this.type, {
    Key? key,
    this.count,
    this.maxCount = '99',
    this.border = TBadgeBorder.large,
    this.size = TBadgeSize.small,
    this.color,
    this.textColor,
    this.message,
    this.widthLarge = 32,
    this.widthSmall = 12,
    this.padding,
    this.showZero = true,
  }) : super(key: key);

  /// 红点数量
  final String? count;

  /// 最大红点数量
  final String? maxCount;

  /// 红点样式
  final TBadgeType type;

  /// 红点尺寸
  final TBadgeSize size;

  /// 红点圆角大小
  final TBadgeBorder border;

  /// 红点颜色
  final Color? color;

  /// 文字颜色
  final Color? textColor;

  /// 消息内容
  final String? message;

  /// 角标大三角形宽
  final double widthLarge;

  /// 角标小三角形宽
  final double widthSmall;

  /// 角标自定义padding
  final EdgeInsetsGeometry? padding;

  /// 值为0是否显示
  final bool showZero;

  @override
  State<StatefulWidget> createState() => _TBadgeState();
}

class _TBadgeState extends State<TBadge> {
  String badgeNum = '';

  void updateBadgeNum(String? newCount) {
    if (newCount == null) {
      return;
    }
    setState(() {
      // 如果 newCount 超过了 maxCount，则显示 `${maxCount}+`
      final countValue = int.tryParse(newCount) ?? 0;
      final maxCountValue = int.tryParse(widget.maxCount ?? '') ?? 0;
      if (maxCountValue > 0 && countValue > maxCountValue) {
        badgeNum = '${maxCountValue}+';
      } else {
        badgeNum = newCount;
      }
    });
  }

  double getBadgeSize() {
    switch (widget.size) {
      case TBadgeSize.large:
        return 20;
      case TBadgeSize.small:
        return 16;
    }
  }

  Font? getBadgeFont(BuildContext context) {
    switch (widget.size) {
      case TBadgeSize.large:
        return TTheme.of(context).fontMarkSmall;
      case TBadgeSize.small:
        return TTheme.of(context).fontMarkExtraSmall;
    }
  }

  bool get visible {
    final parsedValue = double.tryParse(value);
    return widget.showZero ||
        (parsedValue != null && parsedValue != 0) ||
        parsedValue == null;
  }

  String get value {
    return widget.message ?? widget.count ?? context.resource.badgeZero;
  }

  @override
  void initState() {
    super.initState();
    updateBadgeNum(widget.count);
  }

  @override
  void didUpdateWidget(covariant TBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      updateBadgeNum(widget.count);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case TBadgeType.redPoint:
        return Container(
          alignment: Alignment.center,
          height: getBadgeSize() / 2,
          width: getBadgeSize() / 2,
          decoration: BoxDecoration(
              color: widget.color ?? TTheme.of(context).errorNormalColor,
              borderRadius: BorderRadius.circular(getBadgeSize() / 4)),
        );
      case TBadgeType.message:
        return Visibility(
            visible: visible,
            child: badgeNum.length == 1
                ? Container(
                    height: getBadgeSize(),
                    width: getBadgeSize(),
                    decoration: BoxDecoration(
                      color:
                          widget.color ?? TTheme.of(context).errorNormalColor,
                      borderRadius: BorderRadius.circular(getBadgeSize() / 2),
                    ),
                    child: Center(
                      child: TText(
                        widget.message ?? '$badgeNum',
                        forceVerticalCenter: true,
                        font: getBadgeFont(context),
                        fontWeight: FontWeight.w500,
                        textColor: widget.textColor ??
                            TTheme.of(context).textColorAnti,
                        textAlign: TextAlign.center,
                      ),
                    ))
                : Container(
                    height: getBadgeSize(),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color:
                          widget.color ?? TTheme.of(context).errorNormalColor,
                      borderRadius: BorderRadius.circular(getBadgeSize() / 2),
                    ),
                    child: Center(
                      child: TText(
                        widget.message ?? '$badgeNum',
                        forceVerticalCenter: true,
                        font: getBadgeFont(context),
                        fontWeight: FontWeight.w500,
                        textColor: widget.textColor ??
                            TTheme.of(context).textColorAnti,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ));
      case TBadgeType.subscript:
        return ClipPath(
          clipper: TrapezoidPath(widget.widthLarge, widget.widthSmall),
          child: Container(
            alignment: Alignment.topRight,
            color: widget.color ?? TTheme.of(context).errorNormalColor,
            height: 32,
            width: 32,
            child: Transform.rotate(
                angle: pi / 4,
                child: Padding(
                  padding: widget.padding ??
                      const EdgeInsets.only(left: 4, bottom: 8),
                  child: TText(
                    widget.message ?? '$badgeNum',
                    font: getBadgeFont(context),
                    fontWeight: FontWeight.w500,
                    textColor:
                        widget.textColor ?? TTheme.of(context).textColorAnti,
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        );
      case TBadgeType.bubble:
        return Visibility(
            visible: visible,
            child: Container(
              height: 16,
              padding: const EdgeInsets.only(left: 4, right: 4),
              decoration: BoxDecoration(
                color: widget.color ?? TTheme.of(context).errorNormalColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(1)),
              ),
              child: Center(
                child: TText(
                  widget.message ?? '$badgeNum',
                  forceVerticalCenter: true,
                  font: getBadgeFont(context),
                  fontWeight: FontWeight.w500,
                  textColor:
                      widget.textColor ?? TTheme.of(context).textColorAnti,
                  textAlign: TextAlign.center,
                ),
              ),
            ));
      case TBadgeType.square:
        return Visibility(
            visible: visible,
            child: IntrinsicWidth(
                child: Container(
              height: getBadgeSize(),
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: widget.color ?? TTheme.of(context).errorNormalColor,
                borderRadius: widget.border == TBadgeBorder.large
                    ? BorderRadius.circular(8)
                    : BorderRadius.circular(2),
              ),
              child: Center(
                child: TText(
                  widget.message ?? '$badgeNum',
                  forceVerticalCenter: true,
                  font: getBadgeFont(context),
                  fontWeight: FontWeight.w500,
                  textColor:
                      widget.textColor ?? TTheme.of(context).textColorAnti,
                  textAlign: TextAlign.center,
                ),
              ),
            )));
    }
  }
}

class TrapezoidPath extends CustomClipper<Path> {
  final double widthLarge;
  final double widthSmall;

  TrapezoidPath(this.widthLarge, this.widthSmall);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(widthLarge - widthSmall, 0);
    path.lineTo(widthLarge, widthSmall);
    path.lineTo(widthLarge, widthLarge);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
