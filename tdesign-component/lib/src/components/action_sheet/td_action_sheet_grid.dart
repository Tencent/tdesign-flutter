import 'package:flutter/material.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_theme.dart';
import '../badge/td_badge.dart';
import '../text/td_text.dart';
import 'td_action_sheet.dart';

class TDActionSheetGrid extends StatefulWidget {
  final List<TDActionSheetItem> items;
  final String? description;
  final int count;
  final String cancelText;
  final bool showCancel;
  final bool showPagination;
  final VoidCallback? onCancel;
  final TDActionSheetItemCallback? onSelected;

  TDActionSheetGrid({
    required this.items,
    this.description,
    this.count = 8,
    this.cancelText = '取消',
    this.showCancel = true,
    this.showPagination = false,
    this.onCancel,
    this.onSelected,
  });

  @override
  _TDActionSheetGridState createState() => _TDActionSheetGridState();
}

class _TDActionSheetGridState extends State<TDActionSheetGrid> {
  int currentPage = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    // 如果显示分页，则初始化 PageController
    if (widget.showPagination) {
      _pageController = PageController();
    }
  }

  @override
  void dispose() {
    // 释放 PageController 资源
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 计算每行的项目数
    final int itemsPerRow = widget.count ~/ 2;
    // 计算总页数
    final int pageCount = (widget.items.length / widget.count).ceil();
    // 获取屏幕宽度
    final double screenWidth = MediaQuery.of(context).size.width;
    // 计算子项的宽高比
    final double childAspectRatio = (screenWidth / itemsPerRow) / 100.0;

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 如果有描述，则显示描述
          if (widget.description != null) _buildDescription(context),
          // 构建网格视图
          _buildGrid(context, pageCount, itemsPerRow, childAspectRatio),
          // 如果显示分页，则显示分页点
          if (widget.showPagination) _buildPaginationDots(context, pageCount),
          // 如果显示取消按钮，则显示取消按钮
          if (widget.showCancel) _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      children: [
        Container(
          color: TDTheme.of(context).fontWhColor1,
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDText(
                widget.description!,
                font: TDTheme.of(context).fontBodyMedium,
                textColor: TDTheme.of(context).fontGyColor3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, int pageCount, int itemsPerRow,
      double childAspectRatio) {
    return Container(
      color: TDTheme.of(context).fontWhColor1,
      child: Column(
        children: [
          Container(
            height: 208,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
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
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: pageItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: itemsPerRow,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final item = pageItems[index];
                    return _buildGridItem(
                        context, item, pageIndex * widget.count + index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, TDActionSheetItem item, int index) {
    return GestureDetector(
      onTap: item.disabled
          ? null
          : () {
              if (widget.onSelected != null) {
                widget.onSelected!(item, index);
              }
              Navigator.maybePop(context);
            },
      child: Container(
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item.icon != null) ...[
              Stack(
                children: [
                  SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: item.icon!,
                    ),
                  ),
                  if (item.badge != null)
                    Positioned(
                      child: item.badge!,
                      right: 0,
                      top: 0,
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            TDText(
              item.label,
              font: TDTheme.of(context).fontBodyLarge,
              textColor: TDTheme.of(context).fontGyColor1,
              style: item.textStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationDots(BuildContext context, int pageCount) {
    return Container(
        height: 16,
        color: TDTheme.of(context).fontWhColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(pageCount, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index
                    ? TDTheme.of(context).brandColor7
                    : TDTheme.of(context).grayColor4,
              ),
            );
          }),
        ));
  }

  Widget _buildCancelButton(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onCancel != null) {
              widget.onCancel!();
            }
            Navigator.maybePop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: TDTheme.of(context).fontWhColor1,
              border: Border(
                top: BorderSide(
                  color: TDTheme.of(context).grayColor1,
                  width: 1.0,
                ),
              ),
            ),
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDText(
                  widget.cancelText,
                  font: TDTheme.of(context).fontBodyLarge,
                  textColor: TDTheme.of(context).fontGyColor1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
