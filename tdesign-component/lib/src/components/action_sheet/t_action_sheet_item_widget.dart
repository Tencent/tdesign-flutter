import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../badge/t_badge.dart';
import '../text/t_text.dart';
import 't_action_sheet.dart';

class TActionSheetItemWidget extends StatelessWidget {
  const TActionSheetItemWidget({
    super.key,
    this.item,
    required this.index,
    this.onSelected,
  });

  final TActionSheetItem? item;
  final int index;
  final TActionSheetItemCallback? onSelected;

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
            SizedBox(height: TTheme.of(context).spacer8),
          ],
          TText(
            item!.label,
            font: TTheme.of(context).fontBodySmall,
            textColor: TTheme.of(context).textColorPrimary,
            style: item!.textStyle,
          ),
        ],
      ),
    );
  }

  void _setOffsetValue(GlobalKey<State<StatefulWidget>> offsetKey,
      ValueNotifier<List<double>> offsetValue) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final renderBox =
          offsetKey.currentContext?.findRenderObject() as RenderBox;
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
MainAxisAlignment getMainAxisAlignment(TActionSheetAlign align) {
  switch (align) {
    case TActionSheetAlign.left:
      return MainAxisAlignment.start;
    case TActionSheetAlign.right:
      return MainAxisAlignment.end;
    case TActionSheetAlign.center:
    default:
      return MainAxisAlignment.center;
  }
}

Widget buildCancelButton(
  BuildContext context,
  bool showPagination,
  String? cancelText,
  VoidCallback? onCancel,
) {
  return Padding(
    padding: EdgeInsets.only(
        top: showPagination
            ? TTheme.of(context).spacer16
            : TTheme.of(context).spacer8),
    child: GestureDetector(
      onTap: () {
        onCancel?.call();
        Navigator.maybePop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: TTheme.of(context).bgColorContainer,
          border: Border(
            top: BorderSide(
              color: TTheme.of(context).componentStrokeColor,
              width: 0.5,
            ),
          ),
        ),
        height: 48,
        child: Center(
          child: TText(
            cancelText ?? context.resource.cancel,
            font: TTheme.of(context).fontBodyLarge,
            textColor: TTheme.of(context).textColorPrimary,
          ),
        ),
      ),
    ),
  );
}
