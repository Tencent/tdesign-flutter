import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import '../text/t_text_styled.dart';
import '../text/t_text_theme_data.dart';
import 't_picker_types.dart';

/// 选择器的子项组件（包内复用，不对外暴露）
class PickerItemWidget extends StatelessWidget {
  const PickerItemWidget({
    required this.fixedExtentScrollController,
    required this.colIndex,
    required this.index,
    required this.option,
    required this.itemHeight,
    this.disabled = false,
    this.itemBuilder,
    super.key,
  });

  /// 选项。
  final TPickerOption option;

  /// 所属滚轮的滚动控制器，用于计算离中心的距离
  final FixedExtentScrollController fixedExtentScrollController;

  /// 所在列索引
  final int colIndex;

  /// 所在行索引
  final int index;

  /// 单项高度
  final double itemHeight;

  /// 是否禁用（置灰且不响应选中）
  final bool disabled;

  /// 自定义子项构建器，null 时使用默认 [TText] 渲染
  final TPickerItemBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;
    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: fixedExtentScrollController,
        builder: (context, _) {
          final offset = fixedExtentScrollController.hasClients
              ? fixedExtentScrollController.offset / itemHeight
              : fixedExtentScrollController.initialItem.toDouble();
          final distance = (offset - index).abs();
          final selected = distance < 0.5;
          final font = selected && !disabled
              ? theme.fontMarkLarge
              : theme.fontBodyLarge;
          final material = Theme.of(context);
          final textTheme = material.extension<TTextThemeData>();
          // 状态样式是默认值；组件文字主题仍有更高优先级。
          final style = TextStyle(
            fontSize: font?.size ?? 16,
            height: font?.height,
            fontWeight: font?.fontWeight,
            color: disabled
                ? theme.textColorDisabled
                : selected
                ? theme.textColorPrimary
                : theme.textColorSecondary,
          ).merge(textTheme?.textStyle);
          final centeredStyle = style.copyWith(
            // Figma 使用 16/24 文字行盒并在 40px 选项内上下各留 8px。
            // 等分额外行高可避免 Android 字体按 ascent/descent 比例分配后
            // 字形视觉中心偏离选中条，同时保留调用方显式配置。
            leadingDistribution:
                style.leadingDistribution ?? TextLeadingDistribution.even,
          );
          return Center(
            child:
                itemBuilder?.call(context, option, colIndex, index, distance) ??
                TTextStyled(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: centeredStyle,
                ),
          );
        },
      ),
    );
  }
}
