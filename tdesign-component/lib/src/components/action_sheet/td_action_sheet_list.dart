import 'package:flutter/material.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_theme.dart';
import '../badge/td_badge.dart';
import '../text/td_text.dart';
import 'td_action_sheet.dart';

class TDActionSheetList extends StatelessWidget {
  final List<TDActionSheetItem> items;
  final TDActionSheetAlign align;
  final String cancelText;
  final String? description;
  final bool showCancel;
  final VoidCallback? onCancel;
  final TDActionSheetItemCallback? onSelected;

  TDActionSheetList({
    required this.items,
    this.align = TDActionSheetAlign.center,
    this.cancelText = '取消',
    this.description,
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
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
    return Column(
      children: [
        Container(
          color: TDTheme.of(context).fontWhColor1,
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDText(
                description!,
                font: TDTheme.of(context).fontBodyMedium,
                textColor: TDTheme.of(context).fontGyColor3,
              ),
            ],
          ),
        ),
      ],
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
                    if (onSelected != null) {
                      onSelected!(item, index); // 触发选中回调
                    }
                    Navigator.maybePop(context); // 关闭当前页面
                  },
            child: Container(
              height: 56,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TDTheme.of(context).grayColor1,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: _getMainAxisAlignment(),
                children: [
                  if (item.icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: item.disabled
                            ? TDTheme.of(context).fontGyColor4 // 禁用状态下的图标颜色
                            : (item.textStyle?.color ??
                                TDTheme.of(context).fontGyColor1), // 正常状态下的图标颜色
                        size: item.textStyle?.fontSize,
                      ),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: item.icon!,
                      ),
                    ),
                    SizedBox(width: 8),
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
                    SizedBox(width: 8),
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
        Container(
          color: TDTheme.of(context).grayColor1,
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            if (onCancel != null) {
              onCancel!();
            }
            Navigator.maybePop(context);
          },
          child: Container(
            color: TDTheme.of(context).fontWhColor1,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TDText(
                  cancelText,
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

  /// 获取主轴对齐方式
  MainAxisAlignment _getMainAxisAlignment() {
    switch (align) {
      case TDActionSheetAlign.left:
        return MainAxisAlignment.start;
      case TDActionSheetAlign.right:
        return MainAxisAlignment.end;
      case TDActionSheetAlign.center:
      default:
        return MainAxisAlignment.center;
    }
  }
}
