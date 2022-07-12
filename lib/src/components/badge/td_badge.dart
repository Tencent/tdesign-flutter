import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../td_export.dart';

enum TDBadgeType {
  /// 红点样式
  redPoint,

  /// 提醒样式
  remind,

  /// 消息样式
  message,

  /// 角标样式
  subscript
}

enum TDBadgeBorder {
  /// 大圆角 8px
  large,

  /// 小圆角 4px
  small
}

class TDBadge extends StatefulWidget {
  /// 红点数量
  final int? count;

  /// 红点样式
  final TDBadgeType type;

  /// 红点圆角大小
  final TDBadgeBorder border;

  /// 红点颜色
  final Color? color;

  /// 文字颜色
  final Color? textColor;

  /// 红点大小
  final double redPointSize;

  /// 消息内容
  final String? message;

  /// 角标大三角形宽
  final double widthLarge;

  /// 角标小三角形宽
  final double widthSmall;

  /// 角标自定义padding
  final EdgeInsetsGeometry? padding;

  @override
  const TDBadge(
    this.type, {
    Key? key,
    this.count,
    this.border = TDBadgeBorder.large,
    this.color,
    this.textColor,
    this.redPointSize = 10,
    this.message,
    this.widthLarge = 32,
    this.widthSmall = 12,
    this.padding
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDBadgeState();
}

class _TDBadgeState extends State<TDBadge> {
  String badgeNum = '';

  void updateBadgeNum(int? newCount) {
    if (newCount == null) {
      return;
    }
    setState(() {
      badgeNum = newCount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    updateBadgeNum(widget.count);
    switch (widget.type) {
      case TDBadgeType.redPoint:
        return Container(
          alignment: Alignment.center,
          height: widget.redPointSize,
          width: widget.redPointSize,
          decoration: BoxDecoration(
              color: widget.color ?? TDTheme.of(context).errorColor6,
              borderRadius: BorderRadius.circular(widget.redPointSize / 2)),
        );
      case TDBadgeType.remind:
        return Container(
            alignment: Alignment.center,
            height: 16,
            width: 20,
            decoration: BoxDecoration(
                color: widget.color ?? TDTheme.of(context).errorColor6,
                borderRadius: BorderRadius.circular(8)),
            child: Icon(
              TDIcons.ellipsis,
              color: widget.textColor ?? TDTheme.of(context).whiteColor1,
              size: 12,
            ));
      case TDBadgeType.message:
        return Container(
            height: 16,
            padding: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: widget.color ?? TDTheme.of(context).errorColor6,
              borderRadius: widget.border == TDBadgeBorder.large
                  ? BorderRadius.circular(8)
                  : BorderRadius.circular(4),
            ),
            child: TDText(
              widget.message ?? '$badgeNum',
              forceVerticalCenter: true,
              font: Font(size: 10, lineHeight: 16),
              fontWeight: FontWeight.w500,
              textColor: widget.textColor ?? TDTheme.of(context).whiteColor1,
              textAlign: TextAlign.center,
            ));
      case TDBadgeType.subscript:
        return ClipPath(
          clipper: TrapezoidPath(widget.widthLarge, widget.widthSmall),
          child: Container(
            alignment: Alignment.topRight,
            color: widget.color ?? TDTheme.of(context).errorColor6,
            height: 32,
            width: 32,
            child: Transform.rotate(
              angle: pi / 4,
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.only(left: 4, bottom: 8),
                child: TDText(
                  widget.message ?? '$badgeNum',
                  font: Font(size: 10, lineHeight: 16),
                  fontWeight: FontWeight.w500,
                  textColor: widget.textColor ?? TDTheme.of(context).whiteColor1,
                  textAlign: TextAlign.center,
                ),
              )
            ),
          ),
        );
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
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}