import 'package:flutter/material.dart';

import '../../../td_export.dart';

enum TDButtonSize { large, medium, small, extraSmall }

enum TDButtonType { fill, stroke, text }

enum TDButtonShape { rectangle, round, square, circle, filled }

enum TDButtonTheme { defaultTheme, primary, danger, light }

enum TDButtonState { defaultState, active, disable }

typedef TDButtonEvent = void Function();

/// TD常规按钮
class TDButton extends StatefulWidget {
  const TDButton(
      {Key? key,
      this.content,
      this.size = TDButtonSize.medium,
      this.type = TDButtonType.fill,
      this.shape,
      this.theme,
      this.child,
      this.disabled = false,
      this.style,
      this.textStyle,
      this.disableTextStyle,
      this.width,
      this.height,
      this.onTap,
      this.icon,
      this.onLongPress,
      this.padding})
      : super(key: key);

  /// 自控件
  final Widget? child;

  /// 文本内容
  final String? content;

  /// 禁止点击
  final bool disabled;

  /// 自定义宽度
  final double? width;

  /// 自定义高度
  final double? height;

  /// 尺寸
  final TDButtonSize size;

  /// 类型：填充，描边，文字
  final TDButtonType type;

  /// 形状：圆角，胶囊，方形，圆形，填充
  final TDButtonShape? shape;

  /// 主题
  final TDButtonTheme? theme;

  /// 自定义样式，有则优先用他，没有则根据shape和theme选取
  final TDButtonStyle? style;

  /// 自定义可点击状态文本样式
  final TextStyle? textStyle;

  /// 自定义不可点击状态文本样式
  final TextStyle? disableTextStyle;

  /// 点击事件
  final TDButtonEvent? onTap;

  /// 长按事件
  final TDButtonEvent? onLongPress;

  /// 图标icon
  final IconData? icon;

  /// 自定义padding
  final EdgeInsetsGeometry? padding;

  @override
  State<StatefulWidget> createState() => _TDButtonState();
}

class _TDButtonState extends State<TDButton> {
  TDButtonStyle? _innerStyle;

  TDButtonStyle get style {
    if (_innerStyle != null) {
      return _innerStyle!;
    }
    _innerStyle = widget.style ?? _generateInnerStyle();
    return _innerStyle!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget display = Container(
      width: _getWidth(),
      height: _getHeight(),
      alignment: widget.shape == TDButtonShape.filled ? Alignment.center : null,
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: style.getBackgroundColor(
            context: context, disable: widget.disabled),
        border: _getBorder(context),
        borderRadius: BorderRadius.all(_getRadius()),
      ),
      child: widget.child ?? _getChild(),
    );

    if (widget.disabled) {
      return display;
    }
    return GestureDetector(
      child: display,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }

  Border? _getBorder(BuildContext context) {
    if (style.frameWidth != null && style.frameWidth != 0) {
      return Border.all(
          color:
              style.getFrameColor(context: context, disable: widget.disabled),
          width: style.frameWidth!);
    }
    return null;
  }

  Widget _getChild() {
    if (widget.content == null && widget.icon == null) {
      return Container();
    }
    var children = <Widget>[];
    // 系统Icon会导致不居中，因此自绘icon指定height
    if (widget.icon != null) {
      var icon = RichText(
        overflow: TextOverflow.visible,
        text: TextSpan(
          text: String.fromCharCode(widget.icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color:
                style.getTextColor(context: context, disable: widget.disabled),
            height: 1,
            fontSize: _getIconSize(),
            fontFamily: widget.icon!.fontFamily,
            package: widget.icon!.fontPackage,
          ),
        ),
      );
      children.add(icon);
    }
    if (widget.content != null) {
      var text = TDText(
        widget.content!,
        font: _getTextFont(),
        textColor:
            style.getTextColor(context: context, disable: widget.disabled),
        style: widget.disabled ? widget.disableTextStyle : widget.textStyle,
        forceVerticalCenter: true,
      );
      children.add(text);
    }

    if (children.length == 2) {
      children.insert(
        1,
        const SizedBox(
          width: 8,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Font _getTextFont() {
    switch (widget.size) {
      case TDButtonSize.large:
        return TDTheme.of(context).fontBodyLarge ??
            Font(size: 16, lineHeight: 24);
      case TDButtonSize.medium:
        return TDTheme.of(context).fontBodyLarge ??
            Font(size: 16, lineHeight: 24);
      case TDButtonSize.small:
        return TDTheme.of(context).fontBodyMedium ??
            Font(size: 14, lineHeight: 22);
      case TDButtonSize.extraSmall:
        return TDTheme.of(context).fontBodyMedium ??
            Font(size: 14, lineHeight: 22);
    }
  }

  double? _getWidth() {
    if (widget.width != null) {
      return widget.width;
    }
    if (widget.shape == TDButtonShape.square ||
        widget.shape == TDButtonShape.circle) {
      switch (widget.size) {
        case TDButtonSize.large:
          return 48;
        case TDButtonSize.medium:
          return 40;
        case TDButtonSize.small:
          return 32;
        case TDButtonSize.extraSmall:
          return 28;
      }
    }
    return null;
  }

  double _getHeight() {
    if (widget.height != null) {
      return widget.height!;
    }
    switch (widget.size) {
      case TDButtonSize.large:
        return 48;
      case TDButtonSize.medium:
        return 40;
      case TDButtonSize.small:
        return 32;
      case TDButtonSize.extraSmall:
        return 28;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case TDButtonSize.large:
        return 24;
      case TDButtonSize.medium:
        return 22;
      case TDButtonSize.small:
        return 20;
      case TDButtonSize.extraSmall:
        return 20;
    }
  }

  EdgeInsetsGeometry? _getPadding() {
    if (widget.padding != null) {
      return widget.padding;
    }
    var equalSide = widget.shape == TDButtonShape.square || widget.shape == TDButtonShape.circle;

    double horizontalPadding;
    double verticalPadding;
    switch (widget.size) {
      case TDButtonSize.large:
        horizontalPadding = equalSide ? 12 : 20;
        verticalPadding = 12;
        break;
      case TDButtonSize.medium:
        horizontalPadding = equalSide ? 10 : 16;
        verticalPadding = equalSide ? 10 : 8;
        break;
      case TDButtonSize.small:
        horizontalPadding = equalSide ? 7 : 12;
        verticalPadding = equalSide ? 7 : 5;
        break;
      case TDButtonSize.extraSmall:
        horizontalPadding = equalSide ? 5 : 8;
        verticalPadding = equalSide ? 5 : 3;
        break;
    }
    return EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: verticalPadding,
        top: verticalPadding);

  }

  @override
  void didUpdateWidget(covariant TDButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _innerStyle = widget.style ?? _innerStyle;
  }

  TDButtonStyle _generateInnerStyle() {
    switch (widget.type) {
      case TDButtonType.fill:
        return TDButtonStyle.generateFillStyleByTheme(context, widget.theme);
      case TDButtonType.stroke:
        return TDButtonStyle.generateStrokeStyleByTheme(context, widget.theme);
      case TDButtonType.text:
        return TDButtonStyle.generateTextStyleByTheme(context, widget.theme);
    }
  }

  Radius _getRadius() {
    switch (widget.shape) {
      case TDButtonShape.rectangle:
      case TDButtonShape.square:
      case TDButtonShape.filled:
        return Radius.circular(TDTheme.of(context).radiusDefault);
      case TDButtonShape.round:
      case TDButtonShape.circle:
        return Radius.circular(TDTheme.of(context).radiusRound);
      default:
        return Radius.zero;
    }
  }
}

/// TD文字按钮
class TDTextButton extends StatefulWidget {
  final TDButtonSize size;
  final String? content;
  final bool disabled;
  final double? width;
  final double? height;
  final TextStyle? style;
  final TextStyle? disableStyle;
  final TDButtonEvent? onTap;
  final TDButtonEvent? onLongPress;

  const TDTextButton(this.content,
      {Key? key,
      this.size = TDButtonSize.medium,
      this.disabled = false,
      this.style,
      this.disableStyle,
      this.width,
      this.height,
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  State<TDTextButton> createState() => _TDTextButtonState();
}

class _TDTextButtonState extends State<TDTextButton> {
  late TextStyle? style;
  late TextStyle? disableStyle;

  @override
  void initState() {
    super.initState();
    style = widget.style ?? TextStyle(color: TDTheme.of().brandNormalColor);
    disableStyle = widget.disableStyle ??
        TextStyle(color: TDTheme.of().brandDisabledColor);
  }

  @override
  Widget build(BuildContext context) {
    Widget display = SizedBox(
      width: widget.width,
      height: widget.height,
      child: TDText(
        widget.content!,
        font: _getTextFont(),
        style: widget.disabled ? disableStyle : style,
        forceVerticalCenter: true,
      ),
    );

    if (widget.disabled) {
      return display;
    }
    return GestureDetector(
      child: display,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }

  Font _getTextFont() {
    switch (widget.size) {
      case TDButtonSize.large:
        return TDTheme.of(context).fontBodyLarge ??
            Font(size: 16, lineHeight: 24);
      case TDButtonSize.medium:
        return TDTheme.of(context).fontBodyMedium ??
            Font(size: 14, lineHeight: 22);
      case TDButtonSize.small:
        return TDTheme.of(context).fontBodyMedium ??
            Font(size: 14, lineHeight: 22);
      case TDButtonSize.extraSmall:
        return TDTheme.of(context).fontBodyMedium ??
            Font(size: 14, lineHeight: 22);
    }
  }
}
