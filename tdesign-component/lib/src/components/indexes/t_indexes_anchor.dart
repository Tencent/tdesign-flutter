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
        final backgroundColor = isPinned
            ? theme.activeAnchorBackgroundColor ??
                  context.tTheme.bgColorContainer
            : theme.anchorBackgroundColor ??
                  context.tTheme.bgColorSecondaryContainer;
        final borderColor =
            theme.anchorBorderColor ?? context.tTheme.componentStroke;
        return customAnchor ??
            Container(
              padding: EdgeInsets.symmetric(
                vertical: theme.anchorVerticalPadding ?? 4.0,
                horizontal:
                    theme.anchorHorizontalPadding ?? context.tTheme.spacer2,
              ),
              margin: capsuleTheme
                  ? EdgeInsets.symmetric(
                      horizontal: theme.capsuleMargin ?? context.tTheme.spacer,
                    )
                  : null,
              decoration: capsuleTheme
                  ? ShapeDecoration(
                      color: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          context.tTheme.radiusRound,
                        ),
                        side: isPinned
                            ? BorderSide(color: borderColor)
                            : BorderSide.none,
                      ),
                    )
                  : BoxDecoration(
                      color: backgroundColor,
                      border: isPinned
                          ? Border(
                              bottom: BorderSide(
                                color: borderColor,
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
                    ? theme.activeAnchorColor ?? context.tTheme.brandColor
                    : theme.anchorColor ?? context.tTheme.textColorPrimary,
              ),
            );
      },
    );
  }
}
