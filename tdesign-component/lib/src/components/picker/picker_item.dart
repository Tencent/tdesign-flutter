import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
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
          final explicit = material.tExplicitTextTheme?.bodyLarge;
          // 字体回退列表等局部配置会使 Flutter 返回完整 TextStyle。
          // 普通正文的自动补全值不能抹去滚轮的选中/禁用语义。
          final typographyOnly =
              explicit != null &&
              explicit.fontSize == theme.fontBodyLarge?.size &&
              explicit.height == theme.fontBodyLarge?.height &&
              explicit.fontWeight == theme.fontBodyLarge?.fontWeight &&
              explicit.color == material.colorScheme.onSurface;
          final textTheme = material.extension<TTextThemeData>();
          final themeFont = textTheme?.font;
          final inherited = context.tExplicitDefaultTextStyle;
          final defaultStyle =
              inherited == material.textTheme.bodyMedium ||
                  (inherited?.debugLabel?.contains('fallback style;') ?? false)
              ? null
              : inherited;
          // 状态样式是默认值；调用方的文字主题仍有更高优先级。
          final style =
              TextStyle(
                    fontSize: font?.size ?? 16,
                    height: font?.height,
                    fontWeight: font?.fontWeight,
                    color: disabled
                        ? theme.textDisabledColor
                        : selected
                        ? theme.textColorPrimary
                        : theme.textColorSecondary,
                  )
                  .merge(
                    typographyOnly
                        ? explicit.copyWith(
                            fontSize: font?.size,
                            height: font?.height,
                            fontWeight: font?.fontWeight,
                            color: disabled
                                ? theme.textDisabledColor
                                : selected
                                ? theme.textColorPrimary
                                : theme.textColorSecondary,
                          )
                        : explicit,
                  )
                  .merge(defaultStyle)
                  .merge(
                    themeFont == null
                        ? null
                        : TextStyle(
                            fontSize: themeFont.size,
                            height: themeFont.height,
                            fontWeight: themeFont.fontWeight,
                          ),
                  )
                  .merge(textTheme?.textStyle);
          return Center(
            child:
                itemBuilder?.call(context, option, colIndex, index, distance) ??
                TText(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style,
                ),
          );
        },
      ),
    );
  }
}
