import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

enum TFabTheme { primary, defaultTheme, light, danger }

enum TFabShape {
  circle, // 圆形
  square // 矩形
}

enum TFabSize {
  large, // 大
  medium, // 中
  small, // 小
  extraSmall // 特小
}

/// 长按态下在底色上叠一层半透明压暗，避免使用 Ink 水波纹带来的矩形裁切问题。
Color _fabLongPressOverlay(BuildContext context, Color base) {
  final overlay = TTheme.of(context).fontGyColor1.withOpacity(0.15);
  return Color.alphaBlend(overlay, base);
}

class TFab extends StatefulWidget {
  const TFab({
    Key? key,
    this.theme = TFabTheme.defaultTheme,
    this.shape = TFabShape.circle,
    this.size = TFabSize.large,
    this.text,
    this.icon,
    this.onClick,
    this.onLongPress,
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

  /// 长按回调
  final VoidCallback? onLongPress;

  @override
  State<TFab> createState() => _TFabState();
}

class _TFabState extends State<TFab> {
  bool _longPressHeld = false;

  bool get showText => widget.text?.isNotEmpty ?? false;

  EdgeInsets getPadding() {
    switch (widget.size) {
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
    switch (widget.size) {
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
    switch (widget.theme) {
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
    switch (widget.theme) {
      case TFabTheme.primary:
        return TTheme.of(context).textColorAnti;
      case TFabTheme.defaultTheme:
        return TTheme.of(context).fontGyColor1;
      case TFabTheme.light:
        return TTheme.of(context).brandNormalColor;
      case TFabTheme.danger:
        return TTheme.of(context).textColorAnti;
    }
  }

  double getIconSize() {
    switch (widget.size) {
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
    switch (widget.size) {
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

  BorderRadius _borderRadius(BuildContext context) {
    return widget.shape == TFabShape.circle
        ? BorderRadius.circular(TTheme.of(context).radiusCircle)
        : BorderRadius.circular(TTheme.of(context).radiusDefault);
  }

  @override
  Widget build(BuildContext context) {
    final baseBg = getBackgroundColor(context);
    final displayBg =
        _longPressHeld ? _fabLongPressOverlay(context, baseBg) : baseBg;

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onClick,
        onLongPress: widget.onLongPress,
        onLongPressStart: (_) {
          if (widget.onLongPress != null) {
            setState(() => _longPressHeld = true);
          }
        },
        onLongPressEnd: (_) {
          setState(() => _longPressHeld = false);
        },
        onLongPressCancel: () {
          setState(() => _longPressHeld = false);
        },
        child: Container(
          padding: getPadding(),
          decoration: BoxDecoration(
            color: displayBg,
            boxShadow: TTheme.of(context).shadowsMiddle ??
                TTheme.of(context).shadowsBase ??
                const <BoxShadow>[],
            borderRadius: _borderRadius(context),
          ),
          height: getMinWidthOrHeight(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.icon ??
                  Icon(
                    TIcons.add,
                    size: getIconSize(),
                    color: getIconColor(context),
                  ),
              if (showText) const SizedBox(width: 4),
              if (showText)
                TText(
                  widget.text ?? '',
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
      ),
    );
  }
}
