import 'package:flutter/material.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_radius.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../../util/iterable_ext.dart';
import '../../util/list_ext.dart';
import '../badge/td_badge.dart';
import '../text/td_text.dart';
import 'td_action_sheet.dart';
import 'td_action_sheet_item_widget.dart';

class TDActionSheetGrid extends StatefulWidget {
  final List<TDActionSheetItem> items;
  final String? description;
  final TDActionSheetAlign align;
  final int count;
  final int rows;
  final String cancelText;
  final bool showCancel;
  final bool showPagination;
  final bool scrollable;
  final VoidCallback? onCancel;
  final TDActionSheetItemCallback? onSelected;
  final double itemHeight;
  final double itemMinWidth;
  final bool useSafeArea;

  const TDActionSheetGrid({
    super.key,
    required this.items,
    this.description,
    this.align = TDActionSheetAlign.center,
    this.count = 8,
    this.rows = 2,
    this.cancelText = '取消',
    this.showCancel = true,
    this.showPagination = false,
    this.scrollable = false,
    this.onCancel,
    this.onSelected,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.useSafeArea = true,
  });

  @override
  _TDActionSheetGridState createState() => _TDActionSheetGridState();
}

class _TDActionSheetGridState extends State<TDActionSheetGrid> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(TDTheme.of(context).radiusExtraLarge);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: TDTheme.of(context).whiteColor1,
      ),
      clipBehavior: Clip.antiAlias,
      padding: widget.useSafeArea ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom) : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: TDTheme.of(context).spacer8),
          // 如果有描述，则显示描述
          if (widget.description != null) _buildDescription(context),
          // 如果显示分页，则显示分页点
          if (widget.showPagination) ...[
            _buildPaginationGrid(context),
            _buildPaginationDots(context),
            // 横向滚动
          ] else if (widget.scrollable)
            _buildScrollGrid(context)
          else
            _buildGrid(context),
          // 如果显示取消按钮，则显示取消按钮
          if (widget.showCancel) buildCancelButton(context, widget.showPagination, widget.cancelText, widget.onCancel),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: TDTheme.of(context).spacer16,
        right: TDTheme.of(context).spacer16,
        top: TDTheme.of(context).spacer4,
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(widget.align),
        children: [
          TDText(
            widget.description!,
            font: TDTheme.of(context).fontBodyMedium,
            textColor: TDTheme.of(context).fontGyColor3,
          ),
        ],
      ),
    );
  }

  Widget _gridWrap(Widget child) {
    return SizedBox(
      height: widget.rows * widget.itemHeight,
      child: child,
    );
  }

  Widget _buildPaginationGrid(BuildContext context) {
    return _gridWrap(
      PageView.builder(
        itemCount: (widget.items.length / widget.count).ceil(),
        // 当页面改变时更新当前页码
        onPageChanged: widget.showPagination
            ? (index) {
                setState(() {
                  currentPage = index;
                });
              }
            : null,
        itemBuilder: (context, pageIndex) {
          // 获取当前页面的项目
          final pageItems = widget.items.skip(pageIndex * widget.count).take(widget.count).toList();
          return _buildGrid(context, items: pageItems, pageIndex: pageIndex);
        },
      ),
    );
  }

  Widget _buildScrollGrid(BuildContext context) {
    final chunks = widget.items.chunk((widget.items.length / widget.rows).ceil());
    final itemCount = chunks[0].length;
    return _gridWrap(
      ListView.builder(
        itemCount: itemCount,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, col) {
          return Column(
            children: List.generate(chunks.length, (row) {
              final index = itemCount * row + col;
              return SizedBox(
                width: widget.itemMinWidth,
                height: widget.itemHeight,
                child: TDActionSheetItemWidget(
                  item: chunks[row].getOrNull(col),
                  index: index,
                  onSelected: widget.onSelected,
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context, {
    List<TDActionSheetItem>? items,
    int pageIndex = 0,
  }) {
    // 计算每行的项目数
    final itemsPerRow = widget.count ~/ widget.rows;
    // 获取屏幕宽度
    final screenWidth = MediaQuery.of(context).size.width;
    // 计算子项的宽高比
    final childAspectRatio = screenWidth / itemsPerRow / widget.itemHeight;
    return _gridWrap(
      GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: (items ?? widget.items).length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemsPerRow,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          final item = (items ?? widget.items)[index];
          return TDActionSheetItemWidget(
            item: item,
            index: pageIndex * widget.count + index,
            onSelected: widget.onSelected,
          );
        },
      ),
    );
  }

  Widget _buildPaginationDots(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate((widget.items.length / widget.count).ceil(), (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: TDTheme.of(context).spacer4),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? TDTheme.of(context).brandColor7 : TDTheme.of(context).grayColor4,
          ),
        );
      }),
    );
  }
}
