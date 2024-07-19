import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

enum TDTableColFixed { left, right, none }

enum TDTableColAlign { left, center, right }

typedef OnCellTap = void Function();
typedef OnRowTap = void Function();
typedef OnScroll = void Function();

class TDTableCol {
  TDTableCol({
    this.title,
    this.colKey,
    this.width,
    this.minWidth,
    this.fixed,
    this.ellipsis,
    this.ellipsisTitle,
    this.cellBuilder,
    this.align = TDTableColAlign.left,
    this.sortable = false,
  });

  /// 表头标题
  String? title;

  /// 列取值字段
  String? colKey;

  /// 列宽
  double? width;

  /// 最小列宽
  double? minWidth;

  /// 固定列
  TDTableColFixed? fixed;

  /// 列内容超出时是否省略
  bool? ellipsis;

  /// 列标题超出时显示省略内容
  bool? ellipsisTitle;

  /// 自定义列
  Builder? cellBuilder;

  /// 列内容横向对齐方式
  TDTableColAlign? align;

  /// 是否可排序
  bool? sortable;

  double? get widthPx => width;

  double? get minWidthPx => minWidth;
}

class TDTableEmpty {
  TDTableEmpty({
    this.assetUrl,
    this.text,
  });

  /// 空状态图片
  String? assetUrl;

  /// 空状态文字
  String? text;
}

class TDTable extends StatefulWidget {
  const TDTable({
    super.key,
    this.bordered,
    this.emptyBuilder,
    required this.columns,
    this.data,
    this.empty,
    this.height,
    this.loading = false,
    this.loadingBuilder,
    this.showHeader = true,
    this.stripe = false,
    this.onCellTap,
    this.onRowTap,
    this.onScroll,
  });

  /// 是否显示表格边框
  final bool? bordered;

  /// 自定义空表格呈现样式
  final Builder? emptyBuilder;

  /// 列配置
  final List<TDTableCol> columns;

  /// 数据源
  final List<dynamic>? data;

  /// 空表格呈现样式
  final TDTableEmpty? empty;

  /// 表格高度，超出后会出现滚动条
  final double? height;

  /// 加载中状态
  final bool? loading;

  /// 自定义加载中状态
  final Builder? loadingBuilder;

  /// 是否显示表头
  final bool? showHeader;

  /// 斑马纹
  final bool? stripe;

  /// 单元格点击事件
  final OnCellTap? onCellTap;

  /// 行点击事件
  final OnRowTap? onRowTap;

  /// 表格滚动事件
  final OnScroll? onScroll;

  @override
  State<TDTable> createState() => TDTableState();
}

class TDTableState extends State<TDTable> {
  bool? _sortable;

  Alignment _getVerticalAlign(TDTableColAlign x) {
    var xPos = 0.0;
    switch (x) {
      case TDTableColAlign.left:
        xPos = -1;
        break;
      case TDTableColAlign.center:
        xPos = 0;
        break;
      case TDTableColAlign.right:
        xPos = 1;
        break;
    }
    return Alignment(xPos, 0);
  }

  /// 生成表头
  Widget _getTableHeader(BuildContext context) {
    return _getRow(context, null, isHeader: true);
  }

  /// 生成表格内容
  Widget _getTableContent(BuildContext context) {
    if (widget.data == null || widget.data!.isEmpty) {
      return Container(
        padding: const EdgeInsets.only(top: 16, bottom: 38),
        child: Column(
          children: [
            TDEmpty(
              image: Visibility(
                visible: widget.empty != null &&
                    (widget.empty!.assetUrl ?? '') != '',
                child: SizedBox(
                  child: TDImage(assetUrl: widget.empty?.assetUrl ?? ''),
                ),
              ),
              emptyText: widget.empty?.text ?? '暂无数据',
            )
          ],
        ),
      );
    }
    var rows = <Widget>[];
    for (var row in widget.data!) {
      rows.add(_getRow(context, row, isHeader: false));
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: rows,
      ),
    );
  }

  /// 获取行内容
  Widget _getRow(BuildContext context, dynamic data, {bool isHeader = false}) {
    var cells = <Widget>[];
    for (var col in widget.columns) {
      cells.add(
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: widget.bordered == true
                  ? Border.all(color: const Color(0xffE7E7E7), width: 0.5)
                  : null,
            ),
            child: SizedBox(
              height: 22,
              child: Align(
                alignment: _getVerticalAlign(col.align!),
                child: _getCellText(
                  context,
                  isHeader ? (col.title ?? '') : (data[col.colKey] ?? ''),
                  isHeader,
                  isHeader
                      ? (col.ellipsisTitle ?? false)
                      : (col.ellipsis ?? false),
                  (col.sortable ?? false),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffE7E7E7), width: 0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: cells,
      ),
    );
  }

  /// 单元格显示内容
  Widget _getCellText(
    BuildContext context,
    String title,
    bool isHeader,
    bool ellipsis,
    bool sortable,
  ) {
    var overflow = ellipsis ? TextOverflow.ellipsis : TextOverflow.visible;
    if (isHeader) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TDText(
            title,
            maxLines: 1,
            overflow: overflow,
            style: TextStyle(
              color: isHeader
                  ? TDTheme.of(context).fontGyColor3
                  : TDTheme.of(context).fontGyColor1,
              fontSize: 14,
              height: 1,
            ),
          ),
          Visibility(
            visible: isHeader && sortable,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: () {},
                child: CustomPaint(
                  size: const Size(16, 16),
                  painter: ChevronPainter(
                    upColor: TDTheme.of(context).brandNormalColor,
                    downColor: TDTheme.of(context).fontGyColor3,
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
    return TDText(
      title,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: isHeader
            ? TDTheme.of(context).fontGyColor3
            : TDTheme.of(context).fontGyColor1,
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      child: Column(
        children: [
          Visibility(
            visible: widget.showHeader == true,
            child: _getTableHeader(context),
          ),
          _getTableContent(context),
        ],
      ),
    );
  }
}

class ChevronPainter extends CustomPainter {
  ChevronPainter({
    required this.upColor,
    required this.downColor,
  });

  /// 线条颜色(向上)
  final Color upColor;

  /// 线条颜色(向下)
  final Color downColor;

  @override
  void paint(Canvas canvas, Size size) {
    final upPaint = Paint()
      ..color = upColor
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final clientX = size.width;
    final clientY = size.height;
    final centerX = clientX / 2;
    final centerY = clientY / 2;

    // 绘制向上部分
    final upPath = Path();
    upPath.moveTo(3.6, centerY - 1.5);
    upPath.lineTo(centerX, 2);
    upPath.lineTo(clientX - 3.6, centerY - 1.5);

    final downPaint = Paint()
      ..color = downColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final downPath = Path();
    downPath.moveTo(3.6, centerY + 1.5);
    downPath.lineTo(centerX, clientY - 2);
    downPath.lineTo(clientX - 3.6, centerY + 1.5);

    canvas.drawPath(upPath, upPaint);
    canvas.drawPath(downPath, downPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
