import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../badge/t_badge.dart';
import '../text/t_text.dart';
import 't_action_sheet_item.dart';
import 't_action_sheet_theme_data.dart';
import 't_action_sheet_types.dart';

const actionSheetCancelButtonHeight = 48.0;

/// 动作面板单个项目组件
///
/// 在宫格/分组模式下渲染单个可点击项目，含图标、标签和角标。
class TActionSheetItemWidget extends StatelessWidget {
  const TActionSheetItemWidget({
    super.key,
    this.item,
    required this.index,
    this.onChanged,
  });

  /// 项目数据
  final TActionSheetItem? item;

  /// 项目索引
  final int index;

  /// 选择项目时的回调函数
  final TActionSheetOnChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const SizedBox.shrink();
    }
    final actionSheetTheme =
        Theme.of(context).extension<TActionSheetThemeData>();
    final iconSize = actionSheetTheme?.iconSize ?? 24;
    final iconExtent = actionSheetTheme?.gridIconExtent ?? 48;
    final iconColor = item!.disabled
        ? context.tTheme.textDisabledColor
        : (item!.textStyle?.color ??
            actionSheetTheme?.iconColor ??
            context.tTheme.textColorPrimary);
    late ValueNotifier<List<double>> _offsetValue;
    late GlobalKey _offsetKey;
    if (item!.badge != null) {
      _offsetValue = ValueNotifier(const [0.0, 0.0]);
      _offsetKey = GlobalKey();
    }
    final content = GestureDetector(
      onTap: item!.disabled
          ? null
          : () {
              onChanged?.call(item!, index);
              Navigator.maybePop(context);
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item!.icon != null) ...[
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: iconColor,
                    size: iconSize,
                  ),
                  child: SizedBox(
                    width: iconExtent,
                    height: iconExtent,
                    child: Center(child: item!.icon!),
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
            SizedBox(height: context.tTheme.spacer8),
          ],
          TText(
            item!.label,
            font: context.tTheme.fontBodySmall,
            textColor: context.tTheme.textColorPrimary,
            style: item!.textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    if (!item!.disabled) {
      return content;
    }
    return Semantics(
      enabled: false,
      child: Opacity(opacity: 0.4, child: content),
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
      return MainAxisAlignment.center;
  }
}

/// 构建取消按钮
///
/// [showPagination] 是否显示分页（影响上方间距），
/// [cancelText] 取消按钮文本，[onCancel] 点击回调。
Widget buildCancelButton(
  BuildContext context,
  bool showPagination,
  String? cancelText,
  VoidCallback? onCancel,
) {
  return Container(
    color: context.tTheme.bgColorPage,
    padding: EdgeInsets.only(
      top: showPagination ? context.tTheme.spacer16 : context.tTheme.spacer8,
    ),
    child: GestureDetector(
      onTap: () {
        onCancel?.call();
        Navigator.maybePop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.tTheme.bgColorContainer,
          border: Border(
            top: BorderSide(
              color: context.tTheme.componentStrokeColor,
              width: 0.5,
            ),
          ),
        ),
        height: actionSheetCancelButtonHeight,
        child: Center(
          child: TText(
            cancelText ?? context.resource.cancel,
            font: context.tTheme.fontBodyLarge,
            textColor: context.tTheme.textColorPrimary,
          ),
        ),
      ),
    ),
  );
}
