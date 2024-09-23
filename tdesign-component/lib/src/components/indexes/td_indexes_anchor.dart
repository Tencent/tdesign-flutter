import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 索引锚点
class TDIndexesAnchor extends StatelessWidget {
  const TDIndexesAnchor({
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
  final Widget? Function(BuildContext context, String index, bool isPinnedToTop)? builderAnchor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeIndex,
      builder: (context, value, child) {
        final isPinned = value == text;
        final customAnchor = builderAnchor?.call(context, text, isPinned);
        return customAnchor ??
            Container(
              padding:
                  EdgeInsets.symmetric(vertical: TDTheme.of(context).spacer4, horizontal: TDTheme.of(context).spacer16),
              margin: capsuleTheme ? EdgeInsets.symmetric(horizontal: TDTheme.of(context).spacer8) : null,
              decoration: BoxDecoration(
                color: isPinned ? TDTheme.of(context).whiteColor1 : TDTheme.of(context).grayColor1,
                borderRadius: capsuleTheme ? BorderRadius.circular(TDTheme.of(context).radiusCircle) : null,
                border: isPinned
                    ? capsuleTheme
                        ? Border.all(color: TDTheme.of(context).grayColor1)
                        : Border(bottom: BorderSide(color: TDTheme.of(context).grayColor1))
                    : null,
              ),
              child: TDText(
                text,
                forceVerticalCenter: true,
                font: isPinned ? TDTheme.of(context).fontMarkMedium : TDTheme.of(context).fontTitleSmall,
                textColor: isPinned ? TDTheme.of(context).brandColor7 : TDTheme.of(context).fontGyColor1,
              ),
            );
      },
    );
  }
}
