import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter/src/util/string_util.dart';

enum TDBadgeSize {
  /// 个位数的样式
  S,

  /// 两位数的样式
  M,

  /// 三位数的样式
  L
}

enum TDBadgeType {
  /// 红点样式
  redPoint,

  /// 提醒样式
  remind,

  /// 消息样式
  message
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

  /// 内容是否是New字样
  final bool isNew;

  /// 红点颜色
  final Color? color;

  /// 文字颜色
  final Color? textColor;

  /// 是否显示红点
  final bool showBadge;

  /// 红点大小
  final double redPointSize;

  @override
  const TDBadge(this.type,
      {Key? key,
      this.count,
      this.border = TDBadgeBorder.large,
      this.isNew = false,
      this.color,
      this.textColor,
      this.redPointSize = 16,
      this.showBadge = true})
      : super(key: key);

  State<StatefulWidget> createState() => _TDBadgeState();
}

class _TDBadgeState extends State<TDBadge> {
  String badgeNum = '';
  TDBadgeSize size = TDBadgeSize.S;

  void updateBadgeNum(int? newCount) {
    if (newCount == null) return;
    setState(() {
      if (newCount <= 0) {
      } else if (newCount > 0 && newCount <= 9) {
        size = TDBadgeSize.S;
        badgeNum = newCount.toString();
      } else if (newCount >= 10 && newCount <= 99) {
        size = TDBadgeSize.M;
        badgeNum = newCount.toString();
      } else if (newCount > 99) {
        size = TDBadgeSize.L;
        badgeNum = '99+';
      }
    });
  }

  double _getBadgeWidth() {
    double width = 0;
    switch (size) {
      case TDBadgeSize.S:
        width = 16;
        break;
      case TDBadgeSize.M:
        width = 21;
        break;
      case TDBadgeSize.L:
        width = 28;
        break;
    }
    return width;
  }

  @override
  Widget build(BuildContext context) {
    updateBadgeNum(widget.count);
    if (widget.showBadge) {
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
              alignment: Alignment.center,
              height: 16,
              width: widget.isNew ? 31 : _getBadgeWidth(),
              decoration: BoxDecoration(
                color: widget.color ?? TDTheme.of(context).errorColor6,
                borderRadius: widget.border == TDBadgeBorder.large
                    ? BorderRadius.circular(8)
                    : BorderRadius.circular(4),
              ),
              child: TDText(
                widget.isNew ? 'New' : '$badgeNum',
                forceVerticalCenter: true,
                font: Font(size: 10, lineHeight: 16),
                fontWeight: FontWeight.w500,
                textColor: widget.textColor ?? TDTheme.of(context).whiteColor1,
                textAlign: TextAlign.center,
              ));
      }
    }
    return const SizedBox(height: 0, width: 0);
  }
}
