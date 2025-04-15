import 'package:flutter/material.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../badge/td_badge.dart';
import '../text/td_text.dart';
import 'td_action_sheet.dart';

class TDActionSheetItemWidget extends StatelessWidget {
  const TDActionSheetItemWidget({
    super.key,
    this.item,
    required this.index,
    this.onSelected,
  });

  final TDActionSheetItem? item;
  final int index;
  final TDActionSheetItemCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const SizedBox.shrink();
    }
    late ValueNotifier<List<double>> _offsetValue;
    late GlobalKey _offsetKey;
    if (item!.badge != null) {
      _offsetValue = ValueNotifier(const [0.0, 0.0]);
      _offsetKey = GlobalKey();
    }
    return GestureDetector(
      onTap: item!.disabled
          ? null
          : () {
              onSelected?.call(item!, index);
              Navigator.maybePop(context);
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item!.icon != null) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: item!.iconSize ?? 40,
                  height: item!.iconSize ?? 40,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: item!.icon!,
                  ),
                ),
                if (item!.badge != null)
                  ValueListenableBuilder(
                    valueListenable: _offsetValue,
                    builder: (context, value, child) {
                      _setOffsetValue(_offsetKey, _offsetValue);
                      return Positioned(
                        key: _offsetKey,
                        child: item!.badge!,
                        right: value[0],
                        top: value[1],
                      );
                    },
                  ),
              ],
            ),
            SizedBox(height: TDTheme.of(context).spacer8),
          ],
          TDText(
            item!.label,
            font: TDTheme.of(context).fontBodySmall,
            textColor: TDTheme.of(context).fontGyColor1,
            style: item!.textStyle,
          ),
        ],
      ),
    );
  }

  void _setOffsetValue(GlobalKey<State<StatefulWidget>> offsetKey, ValueNotifier<List<double>> offsetValue) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final renderBox = offsetKey.currentContext?.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final right = -size.width / 2;
      final top = -size.height / 2;
      if (offsetValue.value[0] != right || offsetValue.value[1] != top) {
        offsetValue.value = [right, top];
      }
    });
  }
}

/// 获取主轴对齐方式
MainAxisAlignment getMainAxisAlignment(TDActionSheetAlign align) {
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

Widget buildCancelButton(BuildContext context, bool showPagination, String cancelText, VoidCallback? onCancel) {
  return Padding(
    padding: EdgeInsets.only(top: showPagination ? TDTheme.of(context).spacer16 : TDTheme.of(context).spacer8),
    child: GestureDetector(
      onTap: () {
        onCancel?.call();
        Navigator.maybePop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: TDTheme.of(context).fontWhColor1,
          border: Border(
            top: BorderSide(
              color: TDTheme.of(context).grayColor3,
              width: 0.5,
            ),
          ),
        ),
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
  );
}
