import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

enum TDTableColFixed { left, right, none }

enum TDTableColAlign { left, center, right }

typedef OnCellTap = void Function(int rowIndex, dynamic row, TDTableCol col);
typedef OnScroll = void Function(ScrollController controller);

/// 表格列配置
class TDTableCol {
  TDTableCol({
    this.title,
    this.colKey,
    this.width,
    this.fixed = TDTableColFixed.none,
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

  /// 固定列
  TDTableColFixed? fixed;

  /// 列内容超出时是否省略
  bool? ellipsis;

  /// 列标题超出时显示省略内容
  bool? ellipsisTitle;

  /// 自定义列
  IndexedWidgetBuilder? cellBuilder;

  /// 列内容横向对齐方式
  TDTableColAlign? align;

  /// 是否可排序
  bool? sortable;

  double? get widthPx => width;
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
    required this.columns,
    this.data,
    this.empty,
    this.height,
    this.loading = false,
    this.loadingWidget,
    this.showHeader = true,
    this.stripe = false,
    this.backgroundColor,
    this.width,
    this.defaultSort,
    this.onCellTap,
    this.onScroll,
  });

  /// 是否显示表格边框
  final bool? bordered;

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
  final Widget? loadingWidget;

  /// 是否显示表头
  final bool? showHeader;

  /// 斑马纹
  final bool? stripe;

  /// 表格背景色
  final Color? backgroundColor;

  /// 表格宽度
  final double? width;

  /// 默认排序
  final String? defaultSort;

  /// 单元格点击事件
  final OnCellTap? onCellTap;

  /// 表格滚动事件
  final OnScroll? onScroll;

  @override
  State<TDTable> createState() => TDTableState();
}

class TDTableState extends State<TDTable> {
  bool? _sortable;
  String? _sortKey;
  final _scrollController = ScrollController();

  /// 获取单元格对齐方式
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

  /// 过滤列配置
  List<TDTableCol> _getCol(TDTableColFixed fixed) {
    return widget.columns.where((col) => col.fixed == fixed).toList();
  }

  /// 生成表头
  Widget _getTableHeader(BuildContext context) {
    var fixedLeftCol = _getCol(TDTableColFixed.left);
    var fixedNonCol = _getCol(TDTableColFixed.none);
    var fixedRightCol = _getCol(TDTableColFixed.right);
    var start = 0;
    var fixedLeftCells = <Widget>[],
        cells = <Widget>[],
        fixedRightCells = <Widget>[];
    for (var i = 0; i < fixedLeftCol.length; i++) {
      var cell = _getCell(fixedLeftCol[i], true, null, start, i == 0);
      if (fixedLeftCol[i].width != null) {
        fixedLeftCells.add(SizedBox(width: fixedLeftCol[i].width, child: cell));
      } else {
        fixedLeftCells.add(Expanded(flex: 1, child: cell));
      }
      start++;
    }
    start = fixedLeftCol.length;
    for (var i = 0; i < fixedNonCol.length; i++) {
      var cell = _getCell(fixedNonCol[i], true, null, start, i == 0);
      if (fixedNonCol[i].width != null) {
        cells.add(SizedBox(width: fixedNonCol[i].width, child: cell));
      } else {
        cells.add(Expanded(flex: 1, child: cell));
      }
      start++;
    }
    for (var i = 0; i < fixedRightCol.length; i++) {
      var cell = _getCell(fixedRightCol[i], true, null, start, i == 0);
      if (fixedRightCol[i].width != null) {
        fixedRightCells
            .add(SizedBox(width: fixedRightCol[i].width, child: cell));
      } else {
        fixedRightCells.add(Expanded(flex: 1, child: cell));
      }
      start++;
    }
    return Row(children: [...fixedLeftCells, ...cells, ...fixedRightCells]);
  }

  /// 生成表格内容
  Widget _getTableContent(BuildContext context) {
    if (widget.loading ?? false) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: widget.loadingWidget ??
              const TDLoading(size: TDLoadingSize.large),
        ),
      );
    }
    if (widget.data == null || widget.data!.isEmpty) {
      return _getEmpty('暂无数据');
    }
    var cells = <Widget>[];
    var fixedLeftCol = _getCol(TDTableColFixed.left);
    var fixedNonCol = _getCol(TDTableColFixed.none);
    var fixedRightCol = _getCol(TDTableColFixed.right);
    var headerCol = [...fixedLeftCol, ...fixedNonCol, ...fixedRightCol];
    for (var i = 0; i < widget.data!.length; i++) {
      var data = widget.data![i];
      var row = <Widget>[];
      for (var j = 0; j < headerCol.length; j++) {
        var cell = _getCell(
          headerCol[j],
          false,
          data,
          i,
          j == (fixedLeftCol.length - 1) ||
              j == (fixedLeftCol.length + fixedNonCol.length),
        );
        if (headerCol[j].width != null) {
          row.add(SizedBox(width: headerCol[j].width, child: cell));
        } else {
          row.add(Expanded(flex: 1, child: cell));
        }
      }
      cells.add(Container(
        color: (widget.stripe ?? false) && i % 2 == 0
            ? const Color(0xffF3F3F3)
            : Colors.white,
        child: Row(children: row),
      ));
    }
    return Column(
      children: cells,
    );
  }

  /// 获取单元格
  Widget _getCell(TDTableCol col, bool isHeader, dynamic data, int index,
      bool fixedBorder) {
    var title = isHeader ? (col.title ?? '') : (data[col.colKey] ?? '');
    var ellipsis = (isHeader ? col.ellipsisTitle : col.ellipsis) ?? false;
    var sortable = col.sortable ?? false;

    // 单元格边框
    var halfBorder = const BorderSide(width: 0.5, color: Color(0xffE7E7E7));
    var doubleBorder = const BorderSide(width: 2, color: Color(0xffE7E7E7));
    var topBorder = BorderSide.none,
        rightBorder = BorderSide.none,
        leftBorder = BorderSide.none;
    var bottomBorder = halfBorder;
    if (widget.bordered ?? false) {
      rightBorder = halfBorder;
    }
    if (fixedBorder && col.fixed == TDTableColFixed.left) {
      rightBorder = doubleBorder;
    }
    if (fixedBorder && col.fixed == TDTableColFixed.right) {
      leftBorder = doubleBorder;
    }

    // 单元格构建
    var cell = GestureDetector(
      onTap: () {
        if (isHeader == false) {
          widget.onCellTap?.call(index, data, col);
        }
      },
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: topBorder,
              right: rightBorder,
              bottom: bottomBorder,
              left: leftBorder,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SizedBox(
              height: 22,
              child: Align(
                alignment: _getVerticalAlign(col.align!),
                child: _getCellText(
                    col, title, ellipsis, isHeader, sortable, index),
              ),
            ),
          )),
    );
    return cell;
  }

  /// 获取单元格内容
  Widget _getCellText(TDTableCol col, String title, bool ellipsis,
      bool isHeader, bool sortable, int index) {
    var overflow = ellipsis ? TextOverflow.ellipsis : TextOverflow.visible;
    var titleWidget = TDText(title,
        maxLines: 1,
        overflow: overflow,
        style: TextStyle(
          color: isHeader
              ? TDTheme.of(context).fontGyColor3
              : TDTheme.of(context).fontGyColor1,
          fontSize: 14,
          height: 1,
          letterSpacing: 0,
        ));

    // 表头（需考虑排序模式）
    if (isHeader) {
      var selectColor = TDTheme.of(context).brandNormalColor;
      var unSelectColor = TDTheme.of(context).fontGyColor3;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget,
          Visibility(
            visible: isHeader && sortable,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_sortKey != col.colKey) {
                      _sortable = true;
                    } else {
                      if (_sortable == false) {
                        _sortable = null;
                      } else {
                        _sortable = !(_sortable ?? false);
                      }
                    }
                    _sortKey = col.colKey;
                    widget.data?.sort((a, b) {
                      if (_sortable == false) {
                        return b[col.colKey].compareTo(a[col.colKey]);
                      }
                      return a[col.colKey].compareTo(b[col.colKey]);
                    });
                  });
                },
                // 绘制双向箭头
                child: CustomPaint(
                  size: const Size(16, 16),
                  painter: ChevronPainter(
                    upColor: (_sortable == true) && (_sortKey == col.colKey)
                        ? selectColor
                        : unSelectColor,
                    downColor: (_sortable == false) && (_sortKey == col.colKey)
                        ? selectColor
                        : unSelectColor,
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
    // 自定义单元格内容
    if (col.cellBuilder != null) {
      return Builder(builder: (_) => col.cellBuilder!(_, index));
    }
    return titleWidget;
  }

  /// 获取表格宽度
  double _getColsWidth() {
    var width = 0.0;
    widget.columns.forEach((col) {
      width += (col.width ?? 0);
    });
    return width;
  }

  @override
  void initState() {
    super.initState();
    _sortKey = widget.defaultSort;
    _sortable = widget.defaultSort != null;
    _scrollController.addListener(() {
      widget.onScroll?.call(_scrollController);
    });
  }

  /// 生成固定列表格
  Widget _getFixedTable(BuildContext context) {
    // 对列进行分类
    var fixedLeftCol = _getCol(TDTableColFixed.left);
    var fixedNonCol = _getCol(TDTableColFixed.none);
    var fixedRightCol = _getCol(TDTableColFixed.right);

    // 获取竖向单元格内容
    var fixedLeftTitle = _getCellsText(fixedLeftCol);
    var fixedNonTitle = _getCellsText(fixedNonCol);
    var fixedRightTitle = _getCellsText(fixedRightCol);

    // 计算单元格宽度（单元格默认平分）
    var width = widget.width ?? MediaQuery.of(context).size.width;
    var cellWidth = width / widget.columns.length;

    // 生成左侧固定列
    var fixedLeftCols =
        _getVerticalCell(fixedLeftCol, fixedLeftTitle, cellWidth);
    // 生成非固定列
    var fixedNonCols = _getVerticalCell(fixedNonCol, fixedNonTitle, cellWidth);
    // 生成右侧固定列
    var fixedRightCols =
        _getVerticalCell(fixedRightCol, fixedRightTitle, cellWidth);

    // 固定列宽度
    var fixedCellsWidth = 0.0;
    for(var tableCol in widget.columns) {
      if(tableCol.fixed == TDTableColFixed.left || tableCol.fixed == TDTableColFixed.right) {
        fixedCellsWidth += (tableCol.width ?? cellWidth);
      }
    }

    // 计算非固定列宽度
    var fixedNonCellsWidth = 0.0;
    for (var col in fixedNonCol) {
      // 存在用户自定义宽度  否则使用默认宽度
      fixedNonCellsWidth += col.width ?? cellWidth;
    }

    // 非固定列宽度超过剩余宽度 需要开启滚动
    if ((width - fixedCellsWidth) < fixedNonCellsWidth) {
      var content = [Row(children: fixedNonCols), _getEmpty('暂无数据')];
      if (widget.loading ?? false) {
        content = [
          Row(children: fixedNonCols),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: widget.loadingWidget ??
                  const TDLoading(size: TDLoadingSize.large),
            ),
          ),
        ];
      }
      return Container(
        width: width,
        color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [...fixedLeftCols]),
            SizedBox(
              width: width - fixedCellsWidth,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(children: content),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [...fixedRightCols],
            )
          ],
        ),
      );
    }
    var child = Container(
      width: width,
      color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
      child: Row(
        children: [
          ...fixedLeftCols,
          ...fixedNonCols,
          ...fixedRightCols,
        ],
      ),
    );
    var placeholder = _getEmpty('暂无数据');
    if (widget.loading ?? false) {
      placeholder = Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: widget.loadingWidget ??
              const TDLoading(size: TDLoadingSize.large),
        ),
      );
    }
    return Container(
      color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
      child: Column(children: [child, placeholder]),
    );
  }

  /// 空数据内容
  Widget _getEmpty(String defaultText) {
    return Visibility(
      visible: widget.data == null || widget.data!.isEmpty,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 38),
          child: TDEmpty(
            image: Visibility(
              visible: widget.empty?.assetUrl != null,
              child: _getEmptyImage(),
            ),
            emptyText: widget.empty?.text ?? defaultText,
          ),
        ),
      ),
    );
  }

  TDImage _getEmptyImage() {
    var url = widget.empty?.assetUrl ?? '';
    if (url.startsWith('http')) {
      return TDImage(imgUrl: url);
    }
    return TDImage(assetUrl: url);
  }

  /// 竖向生成单元格
  List<Widget> _getVerticalCell(
      List<TDTableCol> cols, List<List<String>> titles, double cellWidth) {
    var rows = <Widget>[];
    for (var i = 0; i < titles.length; i++) {
      var cells = <Widget>[];
      for (var j = 0; j < titles[i].length; j++) {
        var col = cols[i];
        var cell = _getCell(col, j == 0, j == 0 ? '' : widget.data?[j - 1], i,
            i == titles.length - 1);
        cells.add(SizedBox(width: col.width ?? cellWidth, child: cell));
      }
      rows.add(Column(children: cells));
    }
    return rows;
  }

  /// 获取每列单元格内容
  List<List<String>> _getCellsText(List<TDTableCol> cols) {
    var list = <List<String>>[];
    for (var col in cols) {
      var titles = <String>[];
      titles.add(col.title ?? '');
      if (widget.loading == false) {
        var dataList = <String>[];
        for (var i = 0; i < (widget.data?.length ?? 0); i++) {
          var data = widget.data![i];
          dataList.add(data[col.colKey] ?? '');
        }
        titles..addAll(dataList);
      }
      list.add(titles);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // 固定列  按列生成
    // 非固定列  按行生成

    // 自定义表格宽度 默认屏幕宽度
    var width = widget.width ?? MediaQuery.of(context).size.width;
    var fixedCols = [
      ..._getCol(TDTableColFixed.left),
      ..._getCol(TDTableColFixed.right)
    ];

    // 存在固定列
    if (fixedCols.isNotEmpty) {
      return _getFixedTable(context);
    }

    // 表格超宽
    if (width < _getColsWidth()) {
      return Container(
        width: width,
        color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Visibility(
                visible: widget.showHeader == true,
                child: _getTableHeader(context),
              ),
              SizedBox(
                height: widget.height,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: _getTableContent(context),
                ),
              )
            ],
          ),
        ),
      );
    }
    return Container(
      width: width,
      color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
      child: Column(
        children: [
          Visibility(
            visible: widget.showHeader == true,
            child: _getTableHeader(context),
          ),
          SizedBox(
            height: widget.height,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: _getTableContent(context),
            ),
          )
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

    // 向上箭头
    final upPath = Path();
    upPath.moveTo(3.6, centerY - 1.8);
    upPath.lineTo(centerX, 2);
    upPath.lineTo(clientX - 3.6, centerY - 1.8);

    // 向下箭头
    final downPaint = Paint()
      ..color = downColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final downPath = Path();
    downPath.moveTo(3.6, centerY + 1.8);
    downPath.lineTo(centerX, clientY - 2);
    downPath.lineTo(clientX - 3.6, centerY + 1.8);

    canvas.drawPath(upPath, upPaint);
    canvas.drawPath(downPath, downPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
