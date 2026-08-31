import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../badge/t_badge.dart';
import '../typography/t_text.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_item_widget.dart';
import 't_action_sheet_theme_data.dart';
import 't_action_sheet_types.dart';

/// 列表类型动作面板
///
/// 以列表布局展示可选项，支持描述文本。
/// 通常不直接使用，由 `TActionSheet.showList` 创建。
class TActionSheetList extends StatelessWidget {
  /// 动作面板的项目列表
  final List<TActionSheetItem> items;

  /// 对齐方式
  final TActionSheetAlign align;

  /// 取消按钮的文本
  final String? cancelText;

  /// 描述文本
  final String? subtitle;

  /// 是否显示取消按钮
  final bool showCancel;

  /// 取消按钮的回调函数
  final VoidCallback? onCancel;

  /// 选择项目时的回调函数
  final TActionSheetOnChanged? onChanged;

  /// 是否使用安全区域
  final bool useSafeArea;

  const TActionSheetList({
    super.key,
    required this.items,
    this.align = TActionSheetAlign.center,
    this.cancelText,
    this.subtitle,
    this.showCancel = true,
    this.onCancel,
    this.onChanged,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(context.tTheme.radiusExtraLarge);
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: context.tTheme.bgColorContainer,
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle != null) _buildDescription(context),
            Flexible(child: _buildOptionsList(context)),
            if (showCancel) _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  /// 构建描述文本
  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tTheme.spacer16,
        vertical: context.tTheme.spacer12,
      ),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        border: Border(
          bottom: BorderSide(
            color: context.tTheme.componentStrokeColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(align),
        children: [
          Flexible(
            child: TText(
              subtitle!,
              font: context.tTheme.fontBodyMedium,
              textAlign: switch (align) {
                TActionSheetAlign.left => TextAlign.left,
                TActionSheetAlign.right => TextAlign.right,
                TActionSheetAlign.center => TextAlign.center,
              },
              textColor: context.tTheme.textColorSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建选项列表
  Widget _buildOptionsList(BuildContext context) {
    final actionSheetTheme =
        Theme.of(context).extension<TActionSheetThemeData>();
    final iconSize = actionSheetTheme?.iconSize ?? 24;
    return Container(
      color: context.tTheme.bgColorContainer,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: item.disabled
                ? null // 如果项被禁用，则不设置点击事件
                : () {
                    onChanged?.call(item, index); // 触发选中回调
                    Navigator.maybePop(context); // 关闭当前页面
                  },
            child: Container(
              height: item.subtitle == null || item.subtitle!.isEmpty ? 56 : 78,
              padding:
                  EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.tTheme.componentStrokeColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: getMainAxisAlignment(align),
                    children: [
                      if (item.icon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: item.disabled
                                ? context.tTheme.textDisabledColor
                                : (item.textStyle?.color ??
                                    actionSheetTheme?.iconColor ??
                                    context.tTheme.textColorPrimary),
                            size: iconSize,
                          ),
                          child: SizedBox(
                            width: iconSize,
                            height: iconSize,
                            child: Center(child: item.icon!),
                          ),
                        ),
                        SizedBox(width: context.tTheme.spacer8),
                      ],
                      TText(
                        item.label,
                        font: context.tTheme.fontBodyLarge,
                        textColor: item.disabled
                            ? context.tTheme.textDisabledColor // 禁用状态下的文本颜色
                            : context.tTheme.textColorPrimary, // 正常状态下的文本颜色
                        style: item.textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // TODO(#991): Position the badge at the item's top right.
                      if (item.badge != null) ...[
                        SizedBox(width: context.tTheme.spacer8),
                        item.badge!,
                      ],
                    ],
                  ),
                  if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                    SizedBox(height: context.tTheme.spacer4),
                    Row(
                        mainAxisAlignment: getMainAxisAlignment(align),
                        children: [
                          Flexible(
                              child: TText(item.subtitle!,
                                  font: context.tTheme.fontBodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textColor: context.tTheme.textDisabledColor))
                        ])
                  ]
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
    return GestureDetector(
        onTap: () {
          onCancel?.call();
          Navigator.maybePop(context);
        },
        child: Column(
          children: [
            Container(
              color: context.tTheme.bgColorContainer,
              height: 48,
              margin: EdgeInsets.only(top: context.tTheme.spacer8),
              child: Center(
                child: TText(
                  cancelText ?? context.resource.cancel,
                  font: context.tTheme.fontBodyLarge,
                  textColor: context.tTheme.textColorPrimary,
                ),
              ),
            ),
            useSafeArea
                ? Container(
                    color: context.tTheme.bgColorContainer,
                    height: MediaQuery.of(context).padding.bottom,
                  )
                : const SizedBox.shrink(),
          ],
        ));
  }
}
