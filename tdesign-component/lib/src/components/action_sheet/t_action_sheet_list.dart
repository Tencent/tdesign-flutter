import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../badge/t_badge.dart';
import '../badge/t_badge_internal.dart';
import '../badge/t_badge_layout.dart';
import '../badge/t_badge_resolved_style.dart';
import '../text/t_text.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_item_widget.dart';
import 't_action_sheet_theme_data.dart';
import 't_action_sheet_types.dart';

/// 列表类型动作面板
///
/// 以列表布局展示可选项，支持描述文本。
/// 通常不直接使用，由 `TActionSheet.showList` 创建。
class TActionSheetList<T> extends StatelessWidget {
  static const double _itemExtent = 56;
  static const double _itemWithSubtitleExtent = 84;

  /// 动作面板的项目列表
  final List<TActionSheetItem<T>> items;

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
  final TActionSheetOnSelected<T>? onSelected;

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
    this.onSelected,
    this.useSafeArea = true,
  });

  static double preferredPopupHeight<V>(
    BuildContext context, {
    required List<TActionSheetItem<V>> items,
    required String? subtitle,
    required bool showCancel,
  }) {
    final token = context.tTheme;
    var height = items.fold<double>(
      0,
      (sum, item) =>
          sum +
          (item.subtitle == null || item.subtitle!.isEmpty
              ? _itemExtent
              : _itemWithSubtitleExtent),
    );
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
      height += token.spacer12 * 2 + painter.height;
      painter.dispose();
    }
    if (showCancel) {
      height += token.spacer8 + actionSheetCancelButtonHeight;
    }
    return height;
  }

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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subtitle?.isNotEmpty ?? false) _buildDescription(context),
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
        mainAxisAlignment: getMainAxisAlignment(
          align,
          Directionality.of(context),
        ),
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
              textColor: context.tTheme.textColorPlaceholder,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建选项列表
  Widget _buildOptionsList(BuildContext context) {
    final actionSheetTheme = Theme.of(
      context,
    ).extension<TActionSheetThemeData>();
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
                    onSelected?.call(item); // 触发选中回调
                    Navigator.maybePop(context); // 关闭当前页面
                  },
            child: Container(
              height: item.subtitle == null || item.subtitle!.isEmpty
                  ? _itemExtent
                  : _itemWithSubtitleExtent,
              padding: EdgeInsets.symmetric(
                horizontal: context.tTheme.spacer16,
              ),
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
                    mainAxisAlignment: getMainAxisAlignment(
                      align,
                      Directionality.of(context),
                    ),
                    children: [
                      if (item.icon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: item.disabled
                                ? context.tTheme.textDisabledColor
                                : (actionSheetTheme?.iconColor ??
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
                      Flexible(child: _buildLabel(context, item)),
                    ],
                  ),
                  if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                    SizedBox(height: context.tTheme.spacer4),
                    Row(
                      mainAxisAlignment: getMainAxisAlignment(
                        align,
                        Directionality.of(context),
                      ),
                      children: [
                        Flexible(
                          child: TText(
                            item.subtitle!,
                            font: context.tTheme.fontBodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textColor: context.tTheme.textColorPlaceholder,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(BuildContext context, TActionSheetItem<T> item) {
    final label = TText(
      item.label,
      font: context.tTheme.fontBodyLarge,
      textColor: item.disabled
          ? context.tTheme.textDisabledColor
          : context.tTheme.textColorPrimary,
      style: item.textStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final badge = item.badge;
    if (badge == null) {
      return label;
    }
    final offset = _badgeOffset(context, badge);
    final badgeLabel = TBadgeFromConfig(
      config: badge,
      child: label,
      fallbackAlignment: AlignmentDirectional.topEnd,
      fallbackOffset: offset,
    );
    final overflow = _badgeHorizontalOverflow(context, badge, offset);
    if (overflow == 0) {
      return badgeLabel;
    }
    return Padding(
      padding: switch (align) {
        TActionSheetAlign.center => EdgeInsets.symmetric(horizontal: overflow),
        TActionSheetAlign.left ||
        TActionSheetAlign.right => EdgeInsetsDirectional.only(end: overflow),
      },
      child: badgeLabel,
    );
  }

  double _badgeHorizontalOverflow(
    BuildContext context,
    TBadgeConfig badge,
    Offset fallbackOffset,
  ) {
    if (badge.isCustom || _isCornerBadge(badge.variant)) {
      return 0;
    }
    if (badge.variant != TBadgeVariant.dot &&
        (badge.label == null || (!badge.showZero && badge.label == '0'))) {
      return 0;
    }
    final style = TBadgeResolvedStyle.resolve(
      context,
      large: badge.size == TBadgeSize.large,
      alignment: badge.alignment,
      offset: badge.offset,
      fallbackAlignment: AlignmentDirectional.topEnd,
      fallbackOffset: fallbackOffset,
    );
    final textDirection = Directionality.of(context);
    if (style.alignment.resolve(textDirection) !=
        AlignmentDirectional.topEnd.resolve(textDirection)) {
      return 0;
    }
    final width = badge.variant == TBadgeVariant.dot
        ? style.smallSize
        : badge.label == null
        ? 0
        : style.measureLabel(context, badge.label!).width;
    if (width == 0) {
      return 0;
    }
    final outwardOffset = textDirection == TextDirection.ltr
        ? style.offset.dx
        : -style.offset.dx;
    return math.max(0, width / 2 + outwardOffset);
  }

  Offset _badgeOffset(BuildContext context, TBadgeConfig badge) {
    final ltrOffset = _ltrBadgeOffset(context, badge);
    return resolveBadgeFallbackOffset(
      context,
      ltrOffset,
      alignment: badge.alignment,
      fallbackAlignment: AlignmentDirectional.topEnd,
    );
  }

  Offset _ltrBadgeOffset(BuildContext context, TBadgeConfig badge) {
    if (badge.isCustom) {
      return Offset.zero;
    }
    if (badge.variant == TBadgeVariant.dot) {
      return const Offset(2, 0);
    }
    if (badge.variant != TBadgeVariant.circle || badge.label == null) {
      return Offset.zero;
    }
    if (isSingleBadgeCharacter(badge.label!) &&
        badge.size == TBadgeSize.medium) {
      return const Offset(6, 4);
    }
    final badgeSize = _badgeSize(context, badge);
    final horizontalInset = badge.size == TBadgeSize.medium ? 6.0 : 2.0;
    return Offset(
      badgeSize.width / 2 - horizontalInset,
      badgeSize.height / 2 - 4,
    );
  }

  Size _badgeSize(BuildContext context, TBadgeConfig badge) {
    final style = TBadgeResolvedStyle.resolve(
      context,
      large: badge.size == TBadgeSize.large,
    );
    return style.measureLabel(context, badge.label ?? '');
  }

  bool _isCornerBadge(TBadgeVariant variant) => switch (variant) {
    TBadgeVariant.ribbonLeft ||
    TBadgeVariant.ribbonRight ||
    TBadgeVariant.triangleLeft ||
    TBadgeVariant.triangleRight => true,
    _ => false,
  };

  /// 构建取消按钮
  Widget _buildCancelButton(BuildContext context) {
    return Column(
      children: [
        buildCancelButton(context, false, cancelText, onCancel),
        if (useSafeArea)
          Container(
            color: context.tTheme.bgColorContainer,
            height: MediaQuery.of(context).padding.bottom,
          ),
      ],
    );
  }
}
