import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/list_ext.dart';
import '../typography/t_text.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_item_widget.dart';
import 't_action_sheet_types.dart';

/// 分组类型动作面板
///
/// 按项目 [TActionSheetItem.group] 字段分组展示，
/// 每组横向滚动。通常不直接使用，由 `TActionSheet.showGroup` 创建。
class TActionSheetGroup extends StatelessWidget {
  /// 动作面板的项目列表
  final List<TActionSheetItem> items;

  /// 对齐方式
  final TActionSheetAlign align;

  /// 取消按钮的文本
  final String? cancelText;

  /// 是否显示取消按钮
  final bool showCancel;

  /// 取消按钮的回调函数
  final VoidCallback? onCancel;

  /// 选择项目时的回调函数
  final TActionSheetOnChanged? onChanged;

  /// 项目的行高
  final double itemHeight;

  /// 项目的最小宽度
  final double itemMinWidth;

  /// 是否使用安全区域
  final bool useSafeArea;

  const TActionSheetGroup({
    super.key,
    required this.items,
    this.align = TActionSheetAlign.left,
    this.cancelText,
    this.showCancel = true,
    this.onCancel,
    this.onChanged,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(context.tTheme.radiusExtraLarge);
    final groupItems = items.groupBy((item) => item.group);
    final groupKeys = groupItems.keys
        .where((k) => k != null && groupItems[k]?.isNotEmpty == true);
    final groupSections = groupKeys.mapIndexed((i, k) {
      final list = groupItems[k]!;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.tTheme.spacer16,
              context.tTheme.spacer12,
              context.tTheme.spacer16,
              0,
            ),
            child: Row(
              mainAxisAlignment: getMainAxisAlignment(align),
              children: [
                Flexible(
                  child: TText(
                    k!,
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
          ),
          SizedBox(
            height: itemHeight,
            child: ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, row) {
                return SizedBox(
                  width: itemMinWidth,
                  child: TActionSheetItemWidget(
                    item: list[row],
                    onChanged: onChanged,
                    index: items.indexOf(list[row]),
                  ),
                );
              },
            ),
          ),
          if (i != groupKeys.length - 1)
            Container(
              decoration: BoxDecoration(
                color: context.tTheme.fontWhColor1,
                border: Border(
                  top: BorderSide(
                    color: context.tTheme.componentStrokeColor,
                    width: 0.5,
                  ),
                ),
              ),
            ),
        ],
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: context.tTheme.bgColorContainer,
      ),
      clipBehavior: Clip.antiAlias,
      padding: useSafeArea
          ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
          : EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: groupSections,
              ),
            ),
            if (showCancel)
              buildCancelButton(context, false, cancelText, onCancel),
          ],
        ),
      ),
    );
  }
}
