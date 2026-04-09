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

class TActionSheetGrid extends StatefulWidget {
  final List<TActionSheetItem> items;
  final String? description;
  final TActionSheetAlign align;
  final int count;
  final int rows;
  final String? cancelText;
  final bool showCancel;
  final bool showPagination;
  final bool scrollable;
  final VoidCallback? onCancel;
  final TActionSheetItemCallback? onSelected;
  final double itemHeight;
  final double itemMinWidth;
  final bool useSafeArea;

  const TActionSheetGrid({
    super.key,
    required this.items,
    this.description,
    this.align = TActionSheetAlign.center,
    this.count = 8,
    this.rows = 2,
    this.cancelText,
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
  _TActionSheetGridState createState() => _TActionSheetGridState();
}

class _TActionSheetGridState extends State<TActionSheetGrid> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(TTheme.of(context).radiusExtraLarge);
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: TTheme.of(context).bgColorContainer,
      ),
      clipBehavior: Clip.antiAlias,
      padding: widget.useSafeArea
          ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
          : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: TTheme.of(context).spacer8),
          if (widget.description != null) _buildDescription(context),
          if (widget.showPagination) ...[
            _buildPaginationGrid(context),
            _buildPaginationDots(context),
            // 横向滚动
          ] else if (widget.scrollable)
            _buildScrollGrid(context)
          else
            _buildGrid(context),
          if (widget.showCancel)
            buildCancelButton(
              context,
              widget.showPagination,
              widget.cancelText,
              widget.onCancel,
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: TTheme.of(context).spacer16,
        right: TTheme.of(context).spacer16,
        top: TTheme.of(context).spacer4,
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(widget.align),
        children: [
          TText(
            widget.description!,
            font: TTheme.of(context).fontBodyMedium,
            textColor: TTheme.of(context).textColorPlaceholder,
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
          final pageItems = widget.items
              .skip(pageIndex * widget.count)
              .take(widget.count)
              .toList();
          return _buildGrid(context, items: pageItems, pageIndex: pageIndex);
        },
      ),
    );
  }

  Widget _buildScrollGrid(BuildContext context) {
    final chunks =
        widget.items.chunk((widget.items.length / widget.rows).ceil());
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
                child: TActionSheetItemWidget(
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
    List<TActionSheetItem>? items,
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
          return TActionSheetItemWidget(
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
      children:
          List.generate((widget.items.length / widget.count).ceil(), (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: TTheme.of(context).spacer4),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? TTheme.of(context).brandNormalColor
                : TTheme.of(context).bgColorSecondaryContainerActive,
          ),
        );
      }),
    );
  }
}
