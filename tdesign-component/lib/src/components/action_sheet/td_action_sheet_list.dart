import 'package:flutter/material.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_radius.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../badge/td_badge.dart';
import '../text/td_text.dart';
import 'td_action_sheet.dart';
import 'td_action_sheet_item_widget.dart';

class TDActionSheetList extends StatelessWidget {
  final List<TDActionSheetItem> items;
  final TDActionSheetAlign align;
  final String cancelText;
  final String? description;
  final bool showCancel;
  final VoidCallback? onCancel;
  final TDActionSheetItemCallback? onSelected;
  final bool useSafeArea;

  const TDActionSheetList({
    super.key,
    required this.items,
    this.align = TDActionSheetAlign.center,
    this.cancelText = '取消',
    this.description,
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(TDTheme.of(context).radiusExtraLarge);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: TDTheme.of(context).grayColor1,
      ),
      clipBehavior: Clip.antiAlias,
      padding: useSafeArea ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom) : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (description != null) _buildDescription(context),
          _buildOptionsList(context),
          if (showCancel) _buildCancelButton(context),
        ],
      ),
    );
  }

  /// 构建描述文本
  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TDTheme.of(context).spacer16,
        vertical: TDTheme.of(context).spacer12,
      ),
      decoration: BoxDecoration(
        color: TDTheme.of(context).fontWhColor1,
        border: Border(
          bottom: BorderSide(
            color: TDTheme.of(context).grayColor1,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(align),
        children: [
          TDText(
            description!,
            font: TDTheme.of(context).fontBodyMedium,
            textColor: TDTheme.of(context).fontGyColor3,
          ),
        ],
      ),
    );
  }

  /// 构建选项列表
  Widget _buildOptionsList(BuildContext context) {
    return Container(
      color: TDTheme.of(context).fontWhColor1,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: item.disabled
                ? null // 如果项被禁用，则不设置点击事件
                : () {
                    onSelected?.call(item, index); // 触发选中回调
                    Navigator.maybePop(context); // 关闭当前页面
                  },
            child: Container(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: TDTheme.of(context).spacer16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TDTheme.of(context).grayColor1,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: getMainAxisAlignment(align),
                children: [
                  if (item.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: item.disabled
                            ? TDTheme.of(context).fontGyColor4 // 禁用状态下的图标颜色
                            : (item.textStyle?.color ?? TDTheme.of(context).fontGyColor1), // 正常状态下的图标颜色
                        size: item.textStyle?.fontSize,
                      ),
                      child: SizedBox(
                        width: item.iconSize ?? 24,
                        height: item.iconSize ?? 24,
                        child: item.icon!,
                      ),
                    ),
                    SizedBox(width: TDTheme.of(context).spacer8),
                  ],
                  TDText(
                    item.label,
                    font: TDTheme.of(context).fontBodyLarge,
                    textColor: item.disabled
                        ? TDTheme.of(context).fontGyColor4 // 禁用状态下的文本颜色
                        : TDTheme.of(context).fontGyColor1, // 正常状态下的文本颜色
                    style: item.textStyle,
                  ),
                  if (item.badge != null) ...[
                    SizedBox(width: TDTheme.of(context).spacer8),
                    item.badge!,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建取消按钮
  Widget _buildCancelButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: TDTheme.of(context).spacer8),
        GestureDetector(
          onTap: () {
            onCancel?.call();
            Navigator.maybePop(context);
          },
          child: Container(
            color: TDTheme.of(context).fontWhColor1,
            height: 48,
            child: Center(
              child: TDText(
                cancelText,
                font: TDTheme.of(context).fontBodyLarge,
                textColor: TDTheme.of(context).fontGyColor1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
