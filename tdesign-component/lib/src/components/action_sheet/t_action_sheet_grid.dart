import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_item_widget.dart';
import 't_action_sheet_types.dart';

/// 宫格类型动作面板
///
/// 以宫格布局展示可选项，支持分页和横向滚动。
/// 通常不直接使用，由 `TActionSheet.showGrid` 创建。
class TActionSheetGrid<T> extends StatefulWidget {
  static const paginationIndicatorExtent = 8.0;

  /// 动作面板的项目列表
  final List<TActionSheetItem<T>> items;

  /// 描述文本
  final String? subtitle;

  /// 普通、分页或横向滚动宫格布局
  final TActionSheetGridLayout layout;

  /// 取消按钮的文本
  final String? cancelText;

  /// 是否显示取消按钮
  final bool showCancel;

  /// 取消按钮的回调函数
  final VoidCallback? onCancel;

  /// 选择项目时的回调函数
  final TActionSheetOnSelected<T>? onSelected;

  /// 项目的行高
  final double itemHeight;

  /// 是否使用安全区域
  final bool useSafeArea;

  const TActionSheetGrid({
    super.key,
    required this.items,
    this.subtitle,
    this.layout = const TActionSheetGridLayout.fixed(),
    this.cancelText,
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
    this.itemHeight = 96.0,
    this.useSafeArea = true,
  });

  static double preferredPopupHeight(
    BuildContext context, {
    required String? subtitle,
    required TActionSheetGridLayout layout,
    required double itemHeight,
    required bool showCancel,
  }) {
    final token = context.tTheme;
    final showPagination = layout.mode == TActionSheetGridMode.paged;
    var height = token.spacer8 + layout.rows * itemHeight;
    if (subtitle?.isNotEmpty ?? false) {
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
  State<TActionSheetGrid<T>> createState() => _TActionSheetGridState<T>();
}

class _TActionSheetGridState<T> extends State<TActionSheetGrid<T>> {
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
          if (widget.subtitle?.isNotEmpty ?? false) _buildDescription(context),
          Flexible(fit: FlexFit.loose, child: _buildGridContent(context)),
          if (widget.showCancel)
            buildCancelButton(
              context,
              widget.layout.mode == TActionSheetGridMode.paged,
              widget.cancelText,
              widget.onCancel,
              spacingColor: context.tTheme.bgColorContainer,
            ),
        ],
      ),
    );
  }

  Widget _buildGridContent(BuildContext context) {
    return switch (widget.layout.mode) {
      TActionSheetGridMode.fixed => _buildGrid(context),
      TActionSheetGridMode.scroll => _buildScrollGrid(context),
      TActionSheetGridMode.paged => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(fit: FlexFit.loose, child: _buildPaginationGrid(context)),
          _buildPaginationDots(context),
        ],
      ),
    };
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.tTheme.spacer16,
        right: context.tTheme.spacer16,
        top: context.tTheme.spacer4,
      ),
      child: Center(
        child: TText(
          widget.subtitle!,
          font: context.tTheme.fontBodyMedium,
          textAlign: TextAlign.center,
          textColor: context.tTheme.textColorPlaceholder,
        ),
      ),
    );
  }

  Widget _gridWrap(Widget child) {
    return SizedBox(
      height: widget.layout.rows * widget.itemHeight,
      child: child,
    );
  }

  Widget _buildPaginationGrid(BuildContext context) {
    return _gridWrap(
      PageView.builder(
        itemCount: (widget.items.length / widget.layout.count).ceil(),
        // 当页面改变时更新当前页码
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemBuilder: (context, pageIndex) {
          // 获取当前页面的项目
          final pageItems = widget.items
              .skip(pageIndex * widget.layout.count)
              .take(widget.layout.count)
              .toList();
          return _buildGrid(context, items: pageItems);
        },
      ),
    );
  }

  Widget _buildScrollGrid(BuildContext context) {
    if (widget.items.isEmpty) {
      return _gridWrap(const SizedBox.shrink());
    }
    final columnsPerPanel = widget.layout.count ~/ widget.layout.rows;
    final panelCount = (widget.items.length / widget.layout.count).ceil();
    return _gridWrap(
      LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final fittedItemWidth = availableWidth / columnsPerPanel;
          final itemWidth = math.max(
            fittedItemWidth,
            widget.layout.itemMinWidth ?? 0,
          );
          final panelWidth = itemWidth * columnsPerPanel;
          return ListView.builder(
            itemCount: panelCount,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, panel) {
              return SizedBox(
                width: panelWidth,
                child: Column(
                  children: List.generate(widget.layout.rows, (row) {
                    return Row(
                      children: List.generate(columnsPerPanel, (column) {
                        final index =
                            panel * widget.layout.count +
                            row * columnsPerPanel +
                            column;
                        return SizedBox(
                          width: itemWidth,
                          height: widget.itemHeight,
                          child: index < widget.items.length
                              ? TActionSheetItemWidget<T>(
                                  item: widget.items[index],
                                  onSelected: widget.onSelected,
                                )
                              : const SizedBox.shrink(),
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

  Widget _buildGrid(BuildContext context, {List<TActionSheetItem<T>>? items}) {
    // 计算每行的项目数
    final itemsPerRow = widget.layout.count ~/ widget.layout.rows;
    return _gridWrap(
      LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final childAspectRatio = width / itemsPerRow / widget.itemHeight;
          final needsVerticalScroll =
              (items ?? widget.items).length > widget.layout.count ||
              constraints.maxHeight < widget.layout.rows * widget.itemHeight;
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
              return TActionSheetItemWidget<T>(
                item: item,
                onSelected: widget.onSelected,
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
      children: List.generate(
        (widget.items.length / widget.layout.count).ceil(),
        (index) {
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
        },
      ),
    );
  }
}
