import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

typedef OnCellTap = void Function(int rowIndex, dynamic row, TTableCol col);
typedef OnScroll = void Function(ScrollController controller);
typedef OnSelect = void Function(List<dynamic>? data);
typedef OnRowSelect = void Function(int index, bool checked);

class TTable extends StatefulWidget {
  const TTable({
    super.key,
    this.bordered,
    required this.columns,
    this.data,
    this.empty,
    this.height,
    this.rowHeight,
    this.loading = false,
    this.loadingWidget,
    this.showHeader = true,
    this.footerWidget,
    this.stripe = false,
    this.backgroundColor,
    this.width,
    this.defaultSort,
    this.onCellTap,
    this.onScroll,
    this.onSelect,
    this.onRowSelect,
  });

  /// 是否显示表格边框
  final bool? bordered;

  /// 列配置
  final List<TTableCol> columns;

  /// 数据源
  final List<dynamic>? data;

  /// 空表格呈现样式
  final TTableEmpty? empty;

  /// 表格高度，超出后会出现滚动条
  final double? height;

  /// 行高
  final double? rowHeight;

  /// 加载中状态
  final bool? loading;

  /// 自定义加载中状态
  final Widget? loadingWidget;

  /// 是否显示表头
  final bool? showHeader;

  /// 自定义表尾
  final Widget? footerWidget;

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

  /// 选中行事件
  final OnSelect? onSelect;

  /// 行选择事件
  final OnRowSelect? onRowSelect;

  @override
  State<TTable> createState() => TTableState();
}

class TTableState extends State<TTable> {
  bool? _sortable;
  String? _sortKey;
  int _hasChecked = 0;
  int _totalSelectable = 0;
  bool _checkAll = false;
  late TTableCol _selectableCol;
  late List<bool> _checkedList;
  final _scrollController = ScrollController();
  final _headerHScrollController = ScrollController();
  final _dataHScrollController = ScrollController();
  bool _isSyncingScroll = false;

  /// 获取单元格对齐方式
  Alignment _getVerticalAlign(TTableColAlign x) {
    var xPos = 0.0;
    switch (x) {
      case TTableColAlign.left:
        xPos = -1;
        break;
      case TTableColAlign.center:
        xPos = 0;
        break;
      case TTableColAlign.right:
        xPos = 1;
        break;
    }
    return Alignment(xPos, 0);
  }

  /// 过滤列配置
  List<TTableCol> _getCol(TTableColFixed fixed) {
    return widget.columns.where((col) => col.fixed == fixed).toList();
  }

  /// 生成表头
  Widget _getTableHeader(BuildContext context) {
    var fixedLeftCol = _getCol(TTableColFixed.left);
    var fixedNonCol = _getCol(TTableColFixed.none);
    var fixedRightCol = _getCol(TTableColFixed.right);
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
              const TLoading(size: TLoadingSize.large),
        ),
      );
    }
    if (widget.data == null || widget.data!.isEmpty) {
      return _buildEmpty();
    }
    var cells = <Widget>[];
    var fixedLeftCol = _getCol(TTableColFixed.left);
    var fixedNonCol = _getCol(TTableColFixed.none);
    var fixedRightCol = _getCol(TTableColFixed.right);
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
            ? TTheme.of(context).bgColorSecondaryContainer
            : TTheme.of(context).bgColorContainer,
        child: Row(children: row),
      ));
    }
    if (widget.footerWidget != null){
      cells.add(widget.footerWidget!);
    }
    return Column(
      children: cells,
    );
  }

  /// 获取单元格
  Widget _getCell(TTableCol col, bool isHeader, dynamic data, int index,
      bool fixedBorder) {
    var title = isHeader ? (col.title ?? '') : (data[col.colKey] ?? '');
    var ellipsis = (isHeader ? col.ellipsisTitle : col.ellipsis) ?? false;
    var sortable = col.sortable ?? false;

    // 单元格边框
    var halfBorder =
        BorderSide(width: 0.5, color: TTheme.of(context).componentStrokeColor);
    var doubleBorder =
        BorderSide(width: 1, color: TTheme.of(context).componentStrokeColor);
    var topBorder = BorderSide.none,
        rightBorder = BorderSide.none,
        leftBorder = BorderSide.none;
    var bottomBorder = halfBorder;
    if (widget.bordered ?? false) {
      rightBorder = halfBorder;
    }
    if (fixedBorder && col.fixed == TTableColFixed.left) {
      rightBorder = doubleBorder;
    }
    if (fixedBorder && col.fixed == TTableColFixed.right) {
      leftBorder = doubleBorder;
    }

    // 单元格内容
    var text = _getCellText(col, title, ellipsis, isHeader, sortable, index);
    var content = text;
    if ((col.selection ?? false) && col.cellBuilder == null) {
      var checkBox;
      // 行选择框
      if (_notEmptyData() && !isHeader) {
        var enable = col.selectable?.call(index, widget.data?[index]) ?? true;
        checkBox = TCheckbox(
          id: 'index:$index',
          checked: _checkedList[index],
          enable: enable,
          customIconBuilder: (context, checked) {
            if (checked) {
              return Icon(TIcons.check_rectangle_filled,
                  size: 16, color: TTheme.of(context).brandNormalColor);
            }
            return Icon(TIcons.rectangle,
                size: 16,
                color: enable
                    ? TTheme.of(context).textColorPrimary
                    : TTheme.of(context).textColorPlaceholder);
          },
          onCheckBoxChanged: (checked) {
            setState(() {
              _checkedList[index] = checked;
              if (checked) {
                _hasChecked += 1;
              } else {
                _hasChecked -= 1;
              }
              _checkAll = _hasChecked == _totalSelectable;
              var selectList = [];
              for (var i = 0; i < _checkedList.length; i++) {
                if (_checkedList[i]) {
                  selectList.add(widget.data![i]);
                }
              }
              widget.onSelect?.call(selectList);
              widget.onRowSelect?.call(index, checked);
            });
          },
        );
      }

      // 表头选择框
      if (isHeader) {
        checkBox = TCheckbox(
          id: 'header',
          checked: _checkAll,
          customIconBuilder: (context, checked) {
            if (_hasChecked == 0) {
              return Icon(
                TIcons.rectangle,
                size: 16,
                color: TTheme.of(context).textColorPlaceholder,
              );
            }
            var allCheck = _hasChecked >= _totalSelectable;
            var halfSelected =
                _hasChecked > 0 && _hasChecked < _totalSelectable;
            return getAllIcon(allCheck, halfSelected);
          },
          onCheckBoxChanged: (checked) {
            setState(() {
              if (!_notEmptyData() && checked) {
                _hasChecked = _totalSelectable = 1;
              }
              _checkAll = checked;
              _hasChecked = checked ? _totalSelectable : 0;
              for (var i = 0; i < widget.data!.length; i++) {
                // 不选中selectable == false的行
                if (_selectableCol.selectable!(i, widget.data![i])) {
                  _checkedList[i] = checked;
                }
              }
              widget.onSelect?.call(checked ? widget.data : []);
            });
          },
        );
      }

      content = Row(
        children: [
          checkBox,
          text,
        ],
      );
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
              height: widget.rowHeight ?? 22,
              child: Align(
                alignment: _getVerticalAlign(col.align!),
                child: content,
              ),
            ),
          )),
    );
    return cell;
  }

  /// 获取单元格内容
  Widget _getCellText(TTableCol col, String title, bool ellipsis,
      bool isHeader, bool sortable, int index) {
    var overflow = ellipsis ? TextOverflow.ellipsis : TextOverflow.visible;
    var titleWidget = TText(title,
        maxLines: 1,
        overflow: overflow,
        style: TextStyle(
          color: isHeader
              ? TTheme.of(context).textColorPlaceholder
              : TTheme.of(context).textColorPrimary,
          fontSize: 14,
          height: 1,
          letterSpacing: 0,
        ));

    // 表头（需考虑排序模式）
    if (isHeader) {
      var selectColor = TTheme.of(context).brandNormalColor;
      var unSelectColor = TTheme.of(context).textColorPlaceholder;
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

  bool _notEmptyData() {
    return widget.data != null && widget.data!.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _sortKey = widget.defaultSort;
    _sortable = widget.defaultSort != null;
    _scrollController.addListener(() {
      widget.onScroll?.call(_scrollController);
    });
    _headerHScrollController.addListener(() {
      if (!_isSyncingScroll) {
        _isSyncingScroll = true;
        _dataHScrollController.jumpTo(_headerHScrollController.offset);
        _isSyncingScroll = false;
      }
    });
    _dataHScrollController.addListener(() {
      if (!_isSyncingScroll) {
        _isSyncingScroll = true;
        _headerHScrollController.jumpTo(_dataHScrollController.offset);
        _isSyncingScroll = false;
      }
    });
    _initCols();
  }

  @override
  void didUpdateWidget(covariant TTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCols();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerHScrollController.dispose();
    _dataHScrollController.dispose();
    super.dispose();
  }

  void _initCols() {
    _totalSelectable = 0;
    _hasChecked = 0;
    _checkedList = List.generate((widget.data?.length ?? 0), (index) => false);
    var cols = widget.columns.where((col) => col.selection ?? false);
    if (cols.length > 1) {
      throw FlutterError('selectable column must be only one');
    }
    if (widget.data != null && cols.isNotEmpty) {
      _selectableCol = cols.first;
      var data = widget.data!;
      for (var i = 0; i < data.length; i++) {
        var check = _selectableCol.checked?.call(i, data[i]) ?? false;
        _checkedList[i] = check;
        if (check) {
          _hasChecked++;
        }
        if (_selectableCol.selectable?.call(i, data[i]) ?? false) {
          _totalSelectable++;
        }
      }
    }
  }

  /// 生成固定列的表头单元格
  List<Widget> _getFixedHeaderCells(
      List<TTableCol> cols, double cellWidth) {
    var headers = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      var col = cols[i];
      var cell = _getCell(col, true, null, 0, i == cols.length - 1);
      headers.add(SizedBox(width: col.width ?? cellWidth, child: cell));
    }
    return headers;
  }

  /// 生成固定列的单行数据单元格（按列返回一行中各列的Widget）
  List<Widget> _getFixedRowCells(
      List<TTableCol> cols, double cellWidth, int rowIndex) {
    var cells = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      var col = cols[i];
      var cell = _getCell(
          col, false, widget.data?[rowIndex], rowIndex, i == cols.length - 1);
      cells.add(SizedBox(width: col.width ?? cellWidth, child: cell));
    }
    return cells;
  }

  /// 生成固定列的数据单元格（按列组织，每列一个Column，无height时使用）
  List<Widget> _getFixedDataCols(
      List<TTableCol> cols, double cellWidth) {
    var colWidgets = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      var col = cols[i];
      var cells = <Widget>[];
      for (var j = 0; j < (widget.data?.length ?? 0); j++) {
        var cell = _getCell(
            col, false, widget.data?[j], j, i == cols.length - 1);
        cells.add(SizedBox(width: col.width ?? cellWidth, child: cell));
      }
      colWidgets
          .add(Column(mainAxisSize: MainAxisSize.min, children: cells));
    }
    return colWidgets;
  }

  /// 生成固定列表格
  Widget _getFixedTable(BuildContext context) {
    // 对列进行分类
    var fixedLeftCol = _getCol(TTableColFixed.left);
    var fixedNonCol = _getCol(TTableColFixed.none);
    var fixedRightCol = _getCol(TTableColFixed.right);

    // 计算单元格宽度（单元格默认平分）
    var width = widget.width ?? MediaQuery.of(context).size.width;
    var cellWidth = width / widget.columns.length;

    // 固定列宽度
    var fixedCellsWidth = 0.0;
    for (var tableCol in widget.columns) {
      if (tableCol.fixed == TTableColFixed.left ||
          tableCol.fixed == TTableColFixed.right) {
        fixedCellsWidth += (tableCol.width ?? cellWidth);
      }
    }

    // 计算非固定列宽度
    var fixedNonCellsWidth = 0.0;
    for (var col in fixedNonCol) {
      fixedNonCellsWidth += col.width ?? cellWidth;
    }

    // 是否需要横向滚动
    var needHorizontalScroll =
        (width - fixedCellsWidth) < fixedNonCellsWidth;

    // 生成表头
    var headerLeftCells = _getFixedHeaderCells(fixedLeftCol, cellWidth);
    var headerNonCells = _getFixedHeaderCells(fixedNonCol, cellWidth);
    var headerRightCells = _getFixedHeaderCells(fixedRightCol, cellWidth);

    // 构建表头行
    Widget headerRow;
    if (needHorizontalScroll) {
      headerRow = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...headerLeftCells,
          SizedBox(
            width: width - fixedCellsWidth,
            child: SingleChildScrollView(
              controller: _headerHScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(children: headerNonCells),
            ),
          ),
          ...headerRightCells,
        ],
      );
    } else {
      headerRow = Row(
        children: [
          ...headerLeftCells,
          ...headerNonCells,
          ...headerRightCells,
        ],
      );
    }

    // 构建数据体
    Widget dataBody;
    if (widget.loading ?? false) {
      dataBody = Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: widget.loadingWidget ??
              const TLoading(size: TLoadingSize.large),
        ),
      );
    } else if (widget.data == null || widget.data!.isEmpty) {
      dataBody = _buildEmpty();
    } else {
      // 按列组织数据（每列一个Column），然后整体做纵向滚动
      var dataLeftCols = _getFixedDataCols(fixedLeftCol, cellWidth);
      var dataNonCols = _getFixedDataCols(fixedNonCol, cellWidth);
      var dataRightCols = _getFixedDataCols(fixedRightCol, cellWidth);

      Widget dataRow;
      if (needHorizontalScroll) {
        dataRow = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...dataLeftCols,
            SizedBox(
              width: width - fixedCellsWidth,
              child: SingleChildScrollView(
                controller: _dataHScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(children: dataNonCols),
              ),
            ),
            ...dataRightCols,
          ],
        );
      } else {
        dataRow = Row(
          children: [
            ...dataLeftCols,
            ...dataNonCols,
            ...dataRightCols,
          ],
        );
      }

      if (widget.height != null) {
        // 有height时，整个数据区域做纵向滚动
        dataBody = SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: dataRow,
        );
      } else {
        dataBody = dataRow;
      }
    }

    // 组装最终表格
    if (widget.height != null) {
      return Container(
        width: width,
        color: widget.backgroundColor ?? TTheme.of(context).bgColorContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showHeader == true) headerRow,
            SizedBox(
              height: widget.height,
              child: dataBody,
            ),
          ],
        ),
      );
    }

    // 无height时，表头+数据体直接展示
    return Container(
      width: width,
      color: widget.backgroundColor ?? TTheme.of(context).bgColorContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showHeader == true) headerRow,
          dataBody,
        ],
      ),
    );
  }

  /// 空数据内容
  Widget _buildEmpty() {
    return Visibility(
      visible: widget.data == null || widget.data!.isEmpty,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 38),
          child: TEmpty(
            image: Visibility(
              visible: widget.empty?.assetUrl != null,
              child: _buildEmptyImage(),
            ),
            emptyText: widget.empty?.text ?? context.resource.emptyData,
          ),
        ),
      ),
    );
  }

  TImage _buildEmptyImage() {
    var url = widget.empty?.assetUrl ?? '';
    if (url.startsWith('http')) {
      return TImage(imgUrl: url);
    }
    return TImage(assetUrl: url);
  }

  /// 半选图标
  Widget getAllIcon(bool checked, bool halfSelected) {
    return Icon(
        checked
            ? TIcons.check_rectangle_filled
            : halfSelected
                ? TIcons.minus_rectangle_filled
                : TIcons.check_rectangle,
        size: 16,
        color: (checked || halfSelected)
            ? TTheme.of(context).brandNormalColor
            : TTheme.of(context).textDisabledColor);
  }

  @override
  Widget build(BuildContext context) {
    // 固定列  按列生成
    // 非固定列  按行生成

    // 自定义表格宽度 默认屏幕宽度
    var width = widget.width ?? MediaQuery.of(context).size.width;
    var fixedCols = [
      ..._getCol(TTableColFixed.left),
      ..._getCol(TTableColFixed.right)
    ];

    // 存在固定列
    if (fixedCols.isNotEmpty) {
      return _getFixedTable(context);
    }

    // 表格超宽
    if (width < _getColsWidth()) {
      return Container(
        width: width,
        color: widget.backgroundColor ?? TTheme.of(context).bgColorContainer,
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
      color: widget.backgroundColor ?? TTheme.of(context).bgColorContainer,
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

  /// 线条颜色（向上）
  final Color upColor;

  /// 线条颜色（向下）
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
    upPath.close();

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
    downPath.close();

    canvas.drawPath(upPath, upPaint);
    canvas.drawPath(downPath, downPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
