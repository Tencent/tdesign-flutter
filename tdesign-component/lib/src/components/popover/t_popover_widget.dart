import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_popover_theme_data.dart';

/// 气泡弹层定位方向
enum TPopoverPlacement {
  /// 上左
  topLeft,

  /// 上
  top,

  /// 上右
  topRight,

  /// 右上
  rightTop,

  /// 右
  right,

  /// 右下
  rightBottom,

  /// 下右
  bottomRight,

  /// 下
  bottom,

  /// 下左
  bottomLeft,

  /// 左下
  leftBottom,

  /// 左
  left,

  /// 左上
  leftTop,
}

/// 点击事件回调
typedef TPopoverTapCallback = void Function(String? content);

/// 长按事件回调
typedef TPopoverLongPressCallback = void Function(String? content);

/// 气泡弹层 Widget
class TPopoverWidget extends StatefulWidget {
  const TPopoverWidget({
    super.key,
    required this.context,
    this.content,
    this.contentWidget,
    this.offset,
    this.colorScheme,
    this.placement,
    this.showArrow,
    this.arrowSize,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.onLongTap,
    this.radius,
  });

  /// 上下文
  final BuildContext context;

  /// 显示内容
  final String? content;

  /// 自定义内容
  final Widget? contentWidget;

  /// 偏移
  final double? offset;

  /// 弹出气泡主题
  final TPopoverColorScheme? colorScheme;

  /// 浮层出现位置
  final TPopoverPlacement? placement;

  /// 是否显示浮层箭头
  final bool? showArrow;

  /// 箭头大小
  final double? arrowSize;

  /// 内容内边距
  final EdgeInsetsGeometry? padding;

  /// 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight）
  final double? width;

  /// 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom）
  final double? height;

  /// 点击事件
  final TPopoverTapCallback? onTap;

  /// 长按事件
  final TPopoverLongPressCallback? onLongTap;

  /// 圆角
  final BorderRadius? radius;

  @override
  State<TPopoverWidget> createState() => _TPopoverWidgetState();
}

class _TPopoverWidgetState extends State<TPopoverWidget> {
  TPopoverThemeData get _theme =>
      Theme.of(context).extension<TPopoverThemeData>() ??
      const TPopoverThemeData();

  double get _effectiveOffset => widget.offset ?? _theme.offset ?? 4;

  bool get _effectiveShowArrow => widget.showArrow ?? _theme.showArrow ?? true;

  double get _effectiveArrowSize => widget.arrowSize ?? _theme.arrowSize ?? 8;

  EdgeInsetsGeometry? get _effectivePadding => widget.padding ?? _theme.padding;

  double? get _effectiveWidth => widget.width ?? _theme.minWidth;

  double? get _effectiveHeight => widget.height ?? _theme.maxHeight;

  BorderRadius? get _effectiveRadius =>
      widget.radius ??
      (_theme.borderRadius == null
          ? null
          : BorderRadius.circular(_theme.borderRadius!));

  late Color _color;

  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _initTheme();
    if (widget.contentWidget != null) {
      if (_effectiveWidth == null) {
        throw FlutterError(
          'width must not be null when contentWidget is not null',
        );
      }
      if (_effectiveHeight == null) {
        throw FlutterError(
          'height must not be null when contentWidget is not null',
        );
      }
    }
  }

  /// 绘制箭头
  Widget _drawArrow() {
    var border = Border(
      right: BorderSide(
        width: _effectiveArrowSize,
        color: Colors.transparent,
        style: BorderStyle.solid,
      ),
      bottom: BorderSide(
        width: _effectiveArrowSize,
        color: _backgroundColor,
        style: BorderStyle.solid,
      ),
      left: BorderSide(
        width: _effectiveArrowSize,
        color: Colors.transparent,
        style: BorderStyle.solid,
      ),
    );
    if (widget.placement == TPopoverPlacement.bottom ||
        widget.placement == TPopoverPlacement.bottomLeft ||
        widget.placement == TPopoverPlacement.bottomRight) {
      border = Border(
        top: BorderSide(
          width: _effectiveArrowSize,
          color: _backgroundColor,
          style: BorderStyle.solid,
        ),
        right: BorderSide(
          width: _effectiveArrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
        left: BorderSide(
          width: _effectiveArrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
      );
    } else if (widget.placement == TPopoverPlacement.left ||
        widget.placement == TPopoverPlacement.leftTop ||
        widget.placement == TPopoverPlacement.leftBottom) {
      border = Border(
        top: BorderSide(
          width: _effectiveArrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
        bottom: BorderSide(
          width: _effectiveArrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
        right: BorderSide(
          width: _effectiveArrowSize,
          color: _backgroundColor,
          style: BorderStyle.solid,
        ),
      );
    } else if (widget.placement == TPopoverPlacement.right ||
        widget.placement == TPopoverPlacement.rightTop ||
        widget.placement == TPopoverPlacement.rightBottom) {
      border = Border(
        top: BorderSide(
          width: _effectiveArrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
        bottom: BorderSide(
          width: _effectiveArrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
        left: BorderSide(
          width: _effectiveArrowSize,
          color: _backgroundColor,
          style: BorderStyle.solid,
        ),
      );
    }
    return Container(
      width: 0,
      height: 0,
      decoration: BoxDecoration(border: border),
    );
  }

  /// 初始化主题
  void _initTheme() {
    switch (widget.colorScheme) {
      case TPopoverColorScheme.info:
        _color = widget.context.tTheme.brandNormalColor;
        _backgroundColor = widget.context.tTheme.brandLightColor;
        break;
      case TPopoverColorScheme.success:
        _color = widget.context.tTheme.successNormalColor;
        _backgroundColor = widget.context.tTheme.successLightColor;
        break;
      case TPopoverColorScheme.warning:
        _color = widget.context.tTheme.warningNormalColor;
        _backgroundColor = widget.context.tTheme.warningLightColor;
        break;
      case TPopoverColorScheme.error:
        _color = widget.context.tTheme.errorNormalColor;
        _backgroundColor = widget.context.tTheme.errorLightColor;
        break;
      case TPopoverColorScheme.light:
        _color = widget.context.tTheme.grayColor14;
        _backgroundColor = widget.context.tTheme.whiteColor1;
        break;
      default:
        _color = widget.context.tTheme.textColorAnti;
        _backgroundColor = widget.context.tTheme.grayColor14;
        break;
    }
  }

  /// 获取触发元素大小
  Rect? _getWidgetBounds(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return box?.semanticBounds;
  }

  /// 获取触发元素坐标
  Offset? _getWidgetLocalToGlobal(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return box?.localToGlobal(Offset.zero);
  }

  /// 获取Y坐标
  double _getOffsetTop(Offset? widgetLocalToGlobal) {
    var widgetBounds = _getWidgetBounds(widget.context);
    var dy = widgetLocalToGlobal?.dy ?? 0;
    var arrowSize = _effectiveShowArrow ? _effectiveArrowSize : 0;
    var contentSize = _getContentSize();
    var popoverHeight =
        _effectiveHeight ??
        (_effectivePadding != null ? _effectivePadding!.vertical : 24) +
            contentSize.height;
    switch (widget.placement) {
      case TPopoverPlacement.bottomLeft:
      case TPopoverPlacement.bottom:
      case TPopoverPlacement.bottomRight:
        return dy + (widgetBounds?.height ?? 0) + _effectiveOffset;
      case TPopoverPlacement.rightTop:
      case TPopoverPlacement.leftTop:
        return dy;
      case TPopoverPlacement.rightBottom:
      case TPopoverPlacement.leftBottom:
        return dy - (popoverHeight - (widgetBounds?.height ?? 0));
      case TPopoverPlacement.right:
      case TPopoverPlacement.left:
        return dy - (popoverHeight - (widgetBounds?.height ?? 0)) / 2;
      default:
        return dy - popoverHeight - _effectiveOffset - arrowSize;
    }
  }

  /// 获取X坐标
  double _getOffsetLeft(Offset? widgetLocalToGlobal) {
    var widgetBounds = _getWidgetBounds(widget.context);
    var widgetWidth = widgetBounds?.width ?? 0;
    var contentSize = _getContentSize();
    var popoverWidth =
        _effectiveWidth ??
        (_effectivePadding != null ? _effectivePadding!.horizontal : 24) +
            contentSize.width;
    var dx = widgetLocalToGlobal?.dx ?? 0;
    switch (widget.placement) {
      case TPopoverPlacement.topLeft:
      case TPopoverPlacement.bottomLeft:
        return dx;
      case TPopoverPlacement.topRight:
      case TPopoverPlacement.bottomRight:
        return dx + widgetWidth - popoverWidth;
      case TPopoverPlacement.rightTop:
      case TPopoverPlacement.right:
      case TPopoverPlacement.rightBottom:
        return dx + widgetWidth + _effectiveOffset;
      case TPopoverPlacement.leftTop:
      case TPopoverPlacement.left:
      case TPopoverPlacement.leftBottom:
        return dx - popoverWidth - _effectiveArrowSize - _effectiveOffset;
      default:
        return dx - (popoverWidth - widgetWidth) / 2;
    }
  }

  /// 获取箭头Widget
  /// todo 通过 CustomPainter 绘制箭头进行优化
  Widget _getArrowWidget() {
    var margin = EdgeInsets.only(top: _effectiveArrowSize);
    switch (widget.placement) {
      case TPopoverPlacement.topLeft:
        margin = EdgeInsets.only(
          top: _effectiveArrowSize,
          left: _effectiveArrowSize + 12,
        );
        break;
      case TPopoverPlacement.topRight:
        margin = EdgeInsets.only(
          top: _effectiveArrowSize,
          right: _effectiveArrowSize + 12,
        );
        break;
      case TPopoverPlacement.bottomLeft:
        margin = EdgeInsets.only(
          bottom: _effectiveArrowSize,
          left: _effectiveArrowSize + 12,
        );
        break;
      case TPopoverPlacement.bottom:
        margin = EdgeInsets.only(bottom: _effectiveArrowSize);
        break;
      case TPopoverPlacement.bottomRight:
        margin = EdgeInsets.only(
          bottom: _effectiveArrowSize,
          right: _effectiveArrowSize + 12,
        );
        break;
      case TPopoverPlacement.rightTop:
        margin = EdgeInsets.only(
          top: _effectiveArrowSize + 6,
          right: _effectiveArrowSize,
        );
        break;
      case TPopoverPlacement.right:
        margin = EdgeInsets.only(right: _effectiveArrowSize);
        break;
      case TPopoverPlacement.rightBottom:
        margin = EdgeInsets.only(
          bottom: _effectiveArrowSize + 6,
          right: _effectiveArrowSize,
        );
        break;
      case TPopoverPlacement.leftTop:
        margin = EdgeInsets.only(
          top: _effectiveArrowSize + 6,
          left: _effectiveArrowSize,
        );
        break;
      case TPopoverPlacement.left:
        margin = EdgeInsets.only(left: _effectiveArrowSize);
        break;
      case TPopoverPlacement.leftBottom:
        margin = EdgeInsets.only(
          bottom: _effectiveArrowSize + 6,
          left: _effectiveArrowSize,
        );
        break;
      default:
        margin = EdgeInsets.only(top: _effectiveArrowSize);
    }
    return Container(margin: margin, child: _drawArrow());
  }

  /// 获取弹出内容大小
  Size _getContentSize() {
    if (widget.contentWidget != null) {
      return Size(_effectiveWidth!, _effectiveHeight!);
    }
    return _getTextSize();
  }

  /// 获取文本内容大小
  Size _getTextSize() {
    final font = context.tTheme.fontBodyLarge;
    var textPainter =
        TextPainter(
          text: TextSpan(
            text: widget.content,
            style: TextStyle(
              color: _color,
              letterSpacing: 0,
              fontSize: font?.size ?? 16,
              height: font?.height ?? 1.5,
            ),
          ),
          locale: Localizations.localeOf(context),
          textDirection: TextDirection.ltr,
        )..layout(
          maxWidth:
              (_effectiveWidth ?? 300) -
              (_effectivePadding != null ? _effectivePadding!.horizontal : 24),
        );
    return textPainter.size;
  }

  Widget _getContainerWidget() {
    // 当未指定 width 且使用纯文本内容时，用 TextPainter 测量的宽度作为约束，
    // 确保长文本能在 maxWidth 范围内换行（否则 Container 无宽度约束，Text 会单行无限延伸）
    var effectiveWidth = _effectiveWidth;
    if (effectiveWidth == null && widget.contentWidget == null) {
      final textWidth = _getTextSize().width;
      final paddingHorizontal = _effectivePadding != null
          ? _effectivePadding!.horizontal
          : 24;
      effectiveWidth = textWidth + paddingHorizontal;
    }
    return Container(
      width: effectiveWidth,
      height: _effectiveHeight,
      padding: _effectivePadding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius:
            _effectiveRadius ??
            BorderRadius.circular(context.tTheme.radiusDefault),
        color: _backgroundColor,
        boxShadow: _theme.boxShadow ?? context.tTheme.shadowsTop ?? const [],
      ),
      child: widget.contentWidget != null
          ? widget.contentWidget!
          : TText(
              widget.content,
              style: TextStyle(
                color: _color,
                letterSpacing: 0,
                fontSize: context.tTheme.fontBodyLarge?.size ?? 16,
                height: context.tTheme.fontBodyLarge?.height ?? 1.5,
              ),
            ),
    );
  }

  /// 获取子Widget
  Widget _getChild() {
    var children = [
      _getContainerWidget(),
      Visibility(visible: _effectiveShowArrow, child: _getArrowWidget()),
    ];
    var axis = CrossAxisAlignment.center;
    var direction = VerticalDirection.down;

    /// 设置子Widget垂直排列顺序
    switch (widget.placement) {
      case TPopoverPlacement.bottom:
      case TPopoverPlacement.bottomLeft:
      case TPopoverPlacement.bottomRight:
        direction = VerticalDirection.up;
        break;
      case TPopoverPlacement.right:
      case TPopoverPlacement.rightTop:
      case TPopoverPlacement.rightBottom:

        /// 反转内容和箭头
        children = [
          Visibility(visible: _effectiveShowArrow, child: _getArrowWidget()),
          _getContainerWidget(),
        ];
        break;
      default:
        direction = VerticalDirection.down;
        break;
    }

    /// 改变Row和Column交叉轴对齐位置，从而实现箭头位置
    switch (widget.placement) {
      case TPopoverPlacement.topLeft:
      case TPopoverPlacement.bottomLeft:
        axis = CrossAxisAlignment.start;
        break;
      case TPopoverPlacement.topRight:
      case TPopoverPlacement.bottomRight:
        axis = CrossAxisAlignment.end;
        break;
      case TPopoverPlacement.rightTop:
      case TPopoverPlacement.leftTop:
        axis = CrossAxisAlignment.start;
        break;
      case TPopoverPlacement.rightBottom:
      case TPopoverPlacement.leftBottom:
        axis = CrossAxisAlignment.end;
        break;
      default:
        axis = CrossAxisAlignment.center;
    }

    /// 横向布局
    if (widget.placement == TPopoverPlacement.right ||
        widget.placement == TPopoverPlacement.rightTop ||
        widget.placement == TPopoverPlacement.rightBottom ||
        widget.placement == TPopoverPlacement.left ||
        widget.placement == TPopoverPlacement.leftBottom ||
        widget.placement == TPopoverPlacement.leftTop) {
      return Row(crossAxisAlignment: axis, children: children);
    }

    /// 纵向布局
    return Column(
      crossAxisAlignment: axis,
      verticalDirection: direction,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    _initTheme();
    var widgetLocalToGlobal = _getWidgetLocalToGlobal(widget.context);
    var top = _getOffsetTop(widgetLocalToGlobal);
    var left = _getOffsetLeft(widgetLocalToGlobal);
    return Stack(
      children: [Positioned(top: top, left: left, child: _getChild())],
    );
  }
}
