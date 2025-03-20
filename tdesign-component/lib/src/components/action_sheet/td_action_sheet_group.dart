import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_radius.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../../util/list_ext.dart';
import '../text/td_text.dart';
import 'td_action_sheet.dart';
import 'td_action_sheet_item_widget.dart';

class TDActionSheetGroup extends StatelessWidget {
  final List<TDActionSheetItem> items;
  final TDActionSheetAlign align;
  final String cancelText;
  final bool showCancel;
  final VoidCallback? onCancel;
  final TDActionSheetItemCallback? onSelected;
  final double itemHeight;
  final double itemMinWidth;
  final bool useSafeArea;

  const TDActionSheetGroup({
    super.key,
    required this.items,
    this.align = TDActionSheetAlign.left,
    this.cancelText = '取消',
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(TDTheme.of(context).radiusExtraLarge);
    final groupItems = items.groupBy((item) => item.group);
    final groupKeys = groupItems.keys.where((k) => k != null && groupItems[k]?.isNotEmpty == true);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: TDTheme.of(context).whiteColor1,
      ),
      clipBehavior: Clip.antiAlias,
      padding: useSafeArea ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom) : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...groupKeys.mapIndexed((i, k) {
            final list = groupItems[k]!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    TDTheme.of(context).spacer16,
                    TDTheme.of(context).spacer12,
                    TDTheme.of(context).spacer16,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: getMainAxisAlignment(align),
                    children: [
                      TDText(
                        k!,
                        font: TDTheme.of(context).fontBodyMedium,
                        textColor: TDTheme.of(context).fontGyColor3,
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
                        child: TDActionSheetItemWidget(
                          item: list[row],
                          onSelected: onSelected,
                          index: items.indexOf(list[row]),
                        ),
                      );
                    },
                  ),
                ),
                if (i != groupKeys.length - 1)
                  Container(
                    decoration: BoxDecoration(
                      color: TDTheme.of(context).fontWhColor1,
                      border: Border(
                        top: BorderSide(
                          color: TDTheme.of(context).grayColor3,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          if (showCancel) buildCancelButton(context, false, cancelText, onCancel),
        ],
      ),
    );
  }
}
