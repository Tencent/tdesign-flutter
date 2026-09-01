import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../badge/t_badge.dart';
import '../text/t_text.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_item_widget.dart';
import 't_action_sheet_types.dart';

/// 宫格类型动作面板
///
/// 以宫格布局展示可选项，支持分页和横向滚动。
/// 通常不直接使用，由 `TActionSheet.showGrid` 创建。
class TActionSheetGrid extends StatefulWidget {
  static const paginationIndicatorExtent = 8.0;

  /// 动作面板的项目列表
  final List<TActionSheetItem> items;

  /// 描述文本
  final String? subtitle;

  /// 对齐方式
  final TActionSheetAlign align;

  /// 一个可视面板期望容纳的项目数。
  ///
  /// 每行列数由 [count] ~/ [rows] 推导，因此 [count] 必须能被 [rows] 整除。
  final int count;

  /// 显示的行数
  final int rows;

  /// 取消按钮的文本
  final String? cancelText;

  /// 是否显示取消按钮
  final bool showCancel;

  /// 是否显示分页
  final bool showPagination;

  /// 是否可以横向滚动
  final bool scrollable;

  /// 取消按钮的回调函数
  final VoidCallback? onCancel;

  /// 选择项目时的回调函数
  final TActionSheetOnChanged? onChanged;

  /// 项目的行高
  final double itemHeight;

  /// 横向滚动项目的最小宽度。
  ///
  /// 未指定时按面板可用宽度和每行列数自适应；显式值可以扩大项目宽度，
  /// 此时一个视口实际可见的项目数可能少于 [count]。
  final double? itemMinWidth;

  /// 是否使用安全区域
  final bool useSafeArea;

  const TActionSheetGrid({
    super.key,
    required this.items,
    this.subtitle,
    this.align = TActionSheetAlign.center,
    this.count = 8,
    this.rows = 2,
    this.cancelText,
    this.showCancel = true,
    this.showPagination = false,
    this.scrollable = false,
    this.onCancel,
    this.onChanged,
    this.itemHeight = 96.0,
    this.itemMinWidth,
    this.useSafeArea = true,
  }) : assert(count > 0, 'count must be greater than 0'),
       assert(rows > 0, 'rows must be greater than 0'),
       assert(count >= rows, 'count must be greater than or equal to rows'),
       assert(count % rows == 0, 'count must be divisible by rows'),
       assert(
         itemMinWidth == null || itemMinWidth > 0,
         'itemMinWidth must be greater than 0',
       );

  static double preferredPopupHeight(
    BuildContext context, {
    required String? subtitle,
    required int rows,
    required double itemHeight,
    required bool showPagination,
    required bool showCancel,
  }) {
    final token = context.tTheme;
    var height = token.spacer8 + rows * itemHeight;
    if (subtitle != null) {
      final font = token.fontBodyMedium;
      final painter =
          TextPainter(
            text: TextSpan(
              text: subtitle,
              style: TextStyle(
                fontSize: font?.size,
                height: font?.height,
                fontWeight: font?.fontWeight,
              ),
            ),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout(
            maxWidth: math.max(
              0,
              MediaQuery.sizeOf(context).width - token.spacer16 * 2,
            ),
          );
      height += token.spacer4 + painter.height;
      painter.dispose();
    }
    if (showPagination) {
      height += paginationIndicatorExtent;
    }
    if (showCancel) {
      height +=
          (showPagination ? token.spacer16 : token.spacer8) +
          actionSheetCancelButtonHeight;
    }
    return height;
  }

  @override
  _TActionSheetGridState createState() => _TActionSheetGridState();
}

class _TActionSheetGridState extends State<TActionSheetGrid> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(context.tTheme.radiusExtraLarge);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        color: context.tTheme.bgColorContainer,
      ),
      clipBehavior: Clip.antiAlias,
      padding: widget.useSafeArea
          ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
          : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.tTheme.spacer8),
          if (widget.subtitle != null) _buildDescription(context),
          Flexible(fit: FlexFit.loose, child: _buildGridContent(context)),
          if (widget.showCancel)
            buildCancelButton(
              context,
              widget.showPagination,
              widget.cancelText,
              widget.onCancel,
              spacingColor: context.tTheme.bgColorContainer,
            ),
        ],
      ),
    );
  }

  Widget _buildGridContent(BuildContext context) {
    if (!widget.showPagination) {
      return widget.scrollable
          ? _buildScrollGrid(context)
          : _buildGrid(context);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(fit: FlexFit.loose, child: _buildPaginationGrid(context)),
        _buildPaginationDots(context),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.tTheme.spacer16,
        right: context.tTheme.spacer16,
        top: context.tTheme.spacer4,
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(widget.align),
        children: [
          Flexible(
            child: TText(
              widget.subtitle!,
              font: context.tTheme.fontBodyMedium,
              textAlign: switch (widget.align) {
                TActionSheetAlign.left => TextAlign.left,
                TActionSheetAlign.right => TextAlign.right,
                TActionSheetAlign.center => TextAlign.center,
              },
              textColor: context.tTheme.textColorPlaceholder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridWrap(Widget child) {
    return SizedBox(height: widget.rows * widget.itemHeight, child: child);
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
    if (widget.items.isEmpty) {
      return _gridWrap(const SizedBox.shrink());
    }
    final columnsPerPanel = widget.count ~/ widget.rows;
    final panelCount = (widget.items.length / widget.count).ceil();
    return _gridWrap(
      LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final fittedItemWidth = availableWidth / columnsPerPanel;
          final itemWidth = math.max(fittedItemWidth, widget.itemMinWidth ?? 0);
          final panelWidth = itemWidth * columnsPerPanel;
          return ListView.builder(
            itemCount: panelCount,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, panel) {
              return SizedBox(
                width: panelWidth,
                child: Column(
                  children: List.generate(widget.rows, (row) {
                    return Row(
                      children: List.generate(columnsPerPanel, (column) {
                        final index =
                            panel * widget.count +
                            row * columnsPerPanel +
                            column;
                        return SizedBox(
                          width: itemWidth,
                          height: widget.itemHeight,
                          child: TActionSheetItemWidget(
                            item: index < widget.items.length
                                ? widget.items[index]
                                : null,
                            index: index,
                            onChanged: widget.onChanged,
                          ),
                        );
                      }),
                    );
                  }),
                ),
              );
            },
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
    return _gridWrap(
      LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final childAspectRatio = width / itemsPerRow / widget.itemHeight;
          final needsVerticalScroll =
              (items ?? widget.items).length > widget.count ||
              constraints.maxHeight < widget.rows * widget.itemHeight;
          return GridView.builder(
            physics: needsVerticalScroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
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
                onChanged: widget.onChanged,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPaginationDots(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate((widget.items.length / widget.count).ceil(), (
        index,
      ) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: context.tTheme.spacer4),
          width: TActionSheetGrid.paginationIndicatorExtent,
          height: TActionSheetGrid.paginationIndicatorExtent,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? context.tTheme.brandNormalColor
                : context.tTheme.textDisabledColor,
          ),
        );
      }),
    );
  }
}
