import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_indexes_theme_data.dart';

/// 索引锚点
class TIndexesAnchor extends StatelessWidget {
  const TIndexesAnchor({
    Key? key,
    required this.sticky,
    required this.text,
    required this.capsuleTheme,
    this.builderAnchor,
    required this.activeIndex,
  }) : super(key: key);

  /// 索引是否吸顶
  final bool sticky;

  /// 锚点文本
  final String text;

  /// 是否为胶囊式样式
  final bool capsuleTheme;

  /// 选中索引
  final ValueNotifier<String> activeIndex;

  /// 索引锚点构建
  final Widget? Function(
    BuildContext context,
    String index,
    bool isPinnedToTop,
  )?
  builderAnchor;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<TIndexesThemeData>() ??
        const TIndexesThemeData();
    return ValueListenableBuilder(
      valueListenable: activeIndex,
      builder: (context, value, child) {
        final isPinned = value == text;
        final customAnchor = builderAnchor?.call(context, text, isPinned);
        return customAnchor ??
            Container(
              padding: EdgeInsets.symmetric(
                vertical: theme.anchorVerticalPadding ?? context.tTheme.spacer4,
                horizontal:
                    theme.anchorHorizontalPadding ?? context.tTheme.spacer16,
              ),
              margin: capsuleTheme
                  ? EdgeInsets.symmetric(
                      horizontal: theme.capsuleMargin ?? context.tTheme.spacer8,
                    )
                  : null,
              decoration: BoxDecoration(
                color: isPinned
                    ? theme.activeAnchorBackgroundColor ??
                          context.tTheme.bgColorContainer
                    : theme.anchorBackgroundColor ??
                          context.tTheme.bgColorSecondaryContainer,
                borderRadius: capsuleTheme
                    ? BorderRadius.circular(context.tTheme.radiusCircle)
                    : null,
                border: isPinned
                    ? capsuleTheme
                          ? Border.all(
                              color:
                                  theme.anchorBorderColor ??
                                  context.tTheme.componentStrokeColor,
                            )
                          : Border(
                              bottom: BorderSide(
                                color:
                                    theme.anchorBorderColor ??
                                    context.tTheme.componentStrokeColor,
                                width: 0.5,
                              ),
                            )
                    : null,
              ),
              child: TText(
                text,
                font: isPinned
                    ? theme.activeAnchorFont ?? context.tTheme.fontMarkMedium
                    : theme.anchorFont ?? context.tTheme.fontBodyMedium,
                textColor: isPinned
                    ? theme.activeAnchorColor ?? context.tTheme.brandNormalColor
                    : theme.anchorColor ?? context.tTheme.textColorPrimary,
              ),
            );
      },
    );
  }
}
