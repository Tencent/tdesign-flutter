import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/list_ext.dart';
import '../text/t_text.dart';
import 't_action_sheet.dart';
import 't_action_sheet_item_widget.dart';

class TActionSheetGroup extends StatelessWidget {
  final List<TActionSheetItem> items;
  final TActionSheetAlign align;
  final String? cancelText;
  final bool showCancel;
  final VoidCallback? onCancel;
  final TActionSheetItemCallback? onSelected;
  final double itemHeight;
  final double itemMinWidth;
  final bool useSafeArea;

  const TActionSheetGroup({
    super.key,
    required this.items,
    this.align = TActionSheetAlign.left,
    this.cancelText,
    this.showCancel = true,
    this.onCancel,
    this.onSelected,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(TTheme.of(context).radiusExtraLarge);
    final groupItems = items.groupBy((item) => item.group);
    final groupKeys = groupItems.keys
        .where((k) => k != null && groupItems[k]?.isNotEmpty == true);

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
        color: TTheme.of(context).bgColorContainer,
      ),
      clipBehavior: Clip.antiAlias,
      padding: useSafeArea
          ? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)
          : EdgeInsets.zero,
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
                    TTheme.of(context).spacer16,
                    TTheme.of(context).spacer12,
                    TTheme.of(context).spacer16,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: getMainAxisAlignment(align),
                    children: [
                      TText(
                        k!,
                        font: TTheme.of(context).fontBodyMedium,
                        textColor: TTheme.of(context).textColorPlaceholder,
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
                      color: TTheme.of(context).fontWhColor1,
                      border: Border(
                        top: BorderSide(
                          color: TTheme.of(context).componentStrokeColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          if (showCancel)
            buildCancelButton(context, false, cancelText, onCancel),
        ],
      ),
    );
  }
}
