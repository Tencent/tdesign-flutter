import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 悬浮按钮主题
enum TFabTheme { primary, defaultTheme, light, danger }

/// 悬浮按钮形状
enum TFabShape {
  /// 圆形
  circle,

  /// 矩形
  square
}

/// 悬浮按钮尺寸
enum TFabSize {
  /// 大
  large,

  /// 中
  medium,

  /// 小
  small,

  /// 特小
  extraSmall
}

/// 悬浮按钮
class TFab extends StatelessWidget {
  const TFab({
    Key? key,
    this.theme = TFabTheme.defaultTheme,
    this.shape = TFabShape.circle,
    this.size = TFabSize.large,
    this.text,
    this.onClick,
    this.onLongPress,
    this.icon,
  }) : super(key: key);

  /// 主题
  final TFabTheme theme;

  /// 形状
  final TFabShape shape;

  /// 大小
  final TFabSize size;

  /// 文本
  final String? text;

  /// 图标
  final Icon? icon;

  /// 点击事件
  final VoidCallback? onClick;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;

  bool get showText => text?.isNotEmpty ?? false;

  EdgeInsets getPadding() {
    switch (size) {
      case TFabSize.large:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
            : const EdgeInsets.all(12);
      case TFabSize.medium:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            : const EdgeInsets.all(10);
      case TFabSize.small:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 5)
            : const EdgeInsets.all(7);
      case TFabSize.extraSmall:
        return showText
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
            : const EdgeInsets.all(5);
    }
  }

  double getMinWidthOrHeight() {
    switch (size) {
      case TFabSize.large:
        return 48.0;
      case TFabSize.medium:
        return 40.0;
      case TFabSize.small:
        return 32.0;
      case TFabSize.extraSmall:
        return 28.0;
    }
  }

  Color getBackgroundColor(BuildContext context) {
    switch (theme) {
      case TFabTheme.primary:
        return TTheme.of(context).brandColor7;
      case TFabTheme.defaultTheme:
        return TTheme.of(context).grayColor3;
      case TFabTheme.light:
        return TTheme.of(context).brandColor1;
      case TFabTheme.danger:
        return TTheme.of(context).errorColor6;
    }
  }

  Color getIconColor(BuildContext context) {
    switch (theme) {
      case TFabTheme.primary:
        return TTheme.of(context).fontWhColor1;
      case TFabTheme.defaultTheme:
        return TTheme.of(context).fontGyColor1;
      case TFabTheme.light:
        return TTheme.of(context).brandNormalColor;
      case TFabTheme.danger:
        return TTheme.of(context).fontWhColor1;
    }
  }

  double getIconSize() {
    switch (size) {
      case TFabSize.large:
        return 24.0;
      case TFabSize.medium:
        return 20.0;
      case TFabSize.small:
        return 18.0;
      case TFabSize.extraSmall:
        return 18.0;
    }
  }

  double getFontSize() {
    switch (size) {
      case TFabSize.large:
        return 16.0;
      case TFabSize.medium:
        return 16.0;
      case TFabSize.small:
        return 14.0;
      case TFabSize.extraSmall:
        return 14.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      onLongPress: onLongPress,
      child: Container(
        padding: getPadding(),
        decoration: BoxDecoration(
            color: getBackgroundColor(context),
            boxShadow: TTheme.of(context).shadowsMiddle,
            borderRadius: shape == TFabShape.circle
                ? BorderRadius.circular(TTheme.of(context).radiusCircle)
                : BorderRadius.circular(TTheme.of(context).radiusDefault)),
        height: getMinWidthOrHeight(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ??
                Icon(
                  TIcons.add,
                  size: getIconSize(),
                  color: getIconColor(context),
                ),
            if (showText) const SizedBox(width: 4),
            if (showText)
              TText(
                text ?? '',
                style: TextStyle(
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  fontSize: getFontSize(),
                  color: getIconColor(context),
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
