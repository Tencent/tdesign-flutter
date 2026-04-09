import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

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
      BuildContext context, String index, bool isPinnedToTop)? builderAnchor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeIndex,
      builder: (context, value, child) {
        final isPinned = value == text;
        final customAnchor = builderAnchor?.call(context, text, isPinned);
        return customAnchor ??
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: TTheme.of(context).spacer4,
                  horizontal: TTheme.of(context).spacer16),
              margin: capsuleTheme
                  ? EdgeInsets.symmetric(
                      horizontal: TTheme.of(context).spacer8)
                  : null,
              decoration: BoxDecoration(
                color: isPinned
                    ? TTheme.of(context).bgColorContainer
                    : TTheme.of(context).bgColorSecondaryContainer,
                borderRadius: capsuleTheme
                    ? BorderRadius.circular(TTheme.of(context).radiusCircle)
                    : null,
                border: isPinned
                    ? capsuleTheme
                        ? Border.all(
                            color: TTheme.of(context).componentStrokeColor)
                        : Border(
                            bottom: BorderSide(
                                color: TTheme.of(context).componentStrokeColor,
                                width: 0.5))
                    : null,
              ),
              child: TText(
                text,
                forceVerticalCenter: true,
                font: isPinned
                    ? TTheme.of(context).fontMarkMedium
                    : TTheme.of(context).fontTitleSmall,
                textColor: isPinned
                    ? TTheme.of(context).brandNormalColor
                    : TTheme.of(context).textColorPrimary,
              ),
            );
      },
    );
  }
}
