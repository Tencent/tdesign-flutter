import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../badge/t_badge.dart';
import '../text/t_text.dart';
import 't_action_sheet.dart';
import 't_action_sheet_item_widget.dart';

/// 徽标相对列表项内容的右上角偏移量（参考宫格模式实现）
final _badgeOffsetValue = ValueNotifier<List<double>>(const [0.0, 0.0]);

void _updateBadgeOffset(BuildContext context, TActionSheetItem item) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    // 徽标贴标题文本右上角：向右外扩徽标宽度的一半，向上外扩徽标高度的一半
    // 红点类型尺寸为常规徽标的一半
    final badgeHeight =
        item.badge?.type == TBadgeType.redPoint ? 8.0 : 16.0;
    final right = -item.badge!.widthLarge / 4;
    final top = -badgeHeight / 2;
    if (_badgeOffsetValue.value[0] != right ||
        _badgeOffsetValue.value[1] != top) {
      _badgeOffsetValue.value = [right, top];
    }
  });
}

class TActionSheetList extends StatelessWidget {
  final List<TActionSheetItem> items;
  final TActionSheetAlign align;
  final String? cancelText;
  final String? description;
  final bool showCancel;
  final VoidCallback? onCancel;
  final TActionSheetItemCallback? onSelected;
  final bool useSafeArea;

  const TActionSheetList({
    super.key,
    required this.items,
    this.align = TActionSheetAlign.center,
    this.cancelText,
    this.description,
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(TTheme.of(context).radiusExtraLarge);
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: TTheme.of(context).bgColorPage,
      ),
      clipBehavior: Clip.antiAlias,
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
        horizontal: TTheme.of(context).spacer16,
        vertical: TTheme.of(context).spacer12,
      ),
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        border: Border(
          bottom: BorderSide(
            color: TTheme.of(context).componentStrokeColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: getMainAxisAlignment(align),
        children: [
          TText(
            description!,
            font: TTheme.of(context).fontBodyMedium,
            textColor: TTheme.of(context).textColorSecondary,
          ),
        ],
      ),
    );
  }

  /// 构建选项列表
  Widget _buildOptionsList(BuildContext context) {
    return Container(
      color: TTheme.of(context).bgColorContainer,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // 禁用滚动
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
              height: item.description == null || item.description!.isEmpty
                  ? 56
                  : 78,
              padding: EdgeInsets.symmetric(
                  horizontal: TTheme.of(context).spacer16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TTheme.of(context).componentStrokeColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: getMainAxisAlignment(align),
                        children: [
                          if (item.icon != null) ...[
                            IconTheme(
                              data: IconThemeData(
                                color: item.disabled
                                    // 禁用状态下的图标颜色
                                    ? TTheme.of(context).textDisabledColor
                                    : (item.textStyle?.color ??
                                        // 正常状态下的图标颜色
                                        TTheme.of(context)
                                            .textColorPrimary),
                                size: item.textStyle?.fontSize,
                              ),
                              child: SizedBox(
                                width: item.iconSize ?? 24,
                                height: item.iconSize ?? 24,
                                child: item.icon!,
                              ),
                            ),
                            SizedBox(
                                width: TTheme.of(context).spacer8),
                          ],
                          TText(
                            item.label,
                            font: TTheme.of(context).fontBodyLarge,
                            textColor: item.disabled
                                ? TTheme.of(context)
                                    .textDisabledColor // 禁用状态下的文本颜色
                                : TTheme.of(context)
                                    .textColorPrimary, // 正常状态下的文本颜色
                            style: item.textStyle,
                          ),
                        ],
                      ),
                      if (item.description != null &&
                          item.description!.isNotEmpty) ...[
                        SizedBox(
                            height: TTheme.of(context).spacer4),
                        Row(
                            mainAxisAlignment:
                                getMainAxisAlignment(align),
                            children: [
                              Flexible(
                                  child: TText(item.description,
                                      font: TTheme.of(context)
                                          .fontBodyMedium,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textColor: TTheme.of(context)
                                          .textDisabledColor))
                            ])
                      ]
                    ],
                  ),
                  // 徽标位于标题文本右上角（与宫格模式保持一致）
                  if (item.badge != null)
                    ValueListenableBuilder<List<double>>(
                      valueListenable: _badgeOffsetValue,
                      builder: (context, value, child) {
                        _updateBadgeOffset(context, item);
                        return Positioned(
                          top: value[1],
                          right: value[0],
                          child: item.badge!,
                        );
                      },
                    ),
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
              color: TTheme.of(context).bgColorContainer,
              height: 48,
              margin: EdgeInsets.only(top: TTheme.of(context).spacer8),
              child: Center(
                child: TText(
                  cancelText ?? context.resource.cancel,
                  font: TTheme.of(context).fontBodyLarge,
                  textColor: TTheme.of(context).textColorPrimary,
                ),
              ),
            ),
            useSafeArea
                ? Container(
                    color: TTheme.of(context).bgColorContainer,
                    height: MediaQuery.of(context).padding.bottom,
                  )
                : const SizedBox.shrink(),
          ],
        ));
  }
}

