import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum TDPopoverTheme {
  /// 暗色
  dark,

  /// 亮色
  light,

  /// 品牌色
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error
}

enum TDPopoverPlacement {
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
  leftTop
}

typedef OnTap = Function(String? content);
typedef OnLongTap = Function(String? content);

class TDPopoverWidget extends StatefulWidget {
  const TDPopoverWidget({
    super.key,
    required this.context,
    this.content,
    this.contentWidget,
    this.offset = 4,
    this.theme,
    this.placement,
    this.showArrow = true,
    this.arrowSize = 8,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.onLongTap,
    this.radius
  });

  /// 上下文
  final BuildContext context;

  /// 显示内容
  final String? content;

  /// 自定义内容
  final Widget? contentWidget;

  /// 偏移
  final double offset;

  /// 弹出气泡主题
  final TDPopoverTheme? theme;

  /// 浮层出现位置
  final TDPopoverPlacement? placement;

  /// 是否显示浮层箭头
  final bool? showArrow;

  /// 箭头大小
  final double arrowSize;

  /// 内容内边距
  final EdgeInsetsGeometry? padding;

  /// 内容宽度（包含padding，实际高度：height - paddingLeft - paddingRight）
  final double? width;

  /// 内容高度（包含padding，实际高度：height - paddingTop - paddingBottom）
  final double? height;

  /// 点击事件
  final OnTap? onTap;

  /// 长按事件
  final OnLongTap? onLongTap;

  /// 圆角
  final BorderRadius? radius;

  @override
  State<TDPopoverWidget> createState() => _TDPopoverWidgetState();
}

class _TDPopoverWidgetState extends State<TDPopoverWidget> {
  late Color _color;

  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _initTheme();
    if(widget.contentWidget != null) {
      if(widget.width == null) {
        throw FlutterError('width must not be null when contentWidget is not null');
      }
      if(widget.height == null) {
        throw FlutterError('height must not be null when contentWidget is not null');
      }
    }
  }

  /// 绘制箭头
  Widget _drawArrow() {
    var border = Border(
        right: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid),
        bottom: BorderSide(width: widget.arrowSize, color: _backgroundColor, style: BorderStyle.solid),
        left: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid)
    );
    if(widget.placement == TDPopoverPlacement.bottom || widget.placement == TDPopoverPlacement.bottomLeft || widget.placement == TDPopoverPlacement.bottomRight) {
      border = Border(
          top: BorderSide(width: widget.arrowSize, color: _backgroundColor, style: BorderStyle.solid),
          right: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid),
          left: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid)
      );
    } else if(widget.placement == TDPopoverPlacement.left || widget.placement == TDPopoverPlacement.leftTop || widget.placement == TDPopoverPlacement.leftBottom) {
      border = Border(
          top: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid),
          bottom: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid),
          right: BorderSide(width: widget.arrowSize, color: _backgroundColor, style: BorderStyle.solid)
      );
    } else if(widget.placement == TDPopoverPlacement.right || widget.placement == TDPopoverPlacement.rightTop || widget.placement == TDPopoverPlacement.rightBottom) {
      border = Border(
          top: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid),
          bottom: BorderSide(width: widget.arrowSize, color: Colors.transparent, style: BorderStyle.solid),
          left: BorderSide(width: widget.arrowSize, color: _backgroundColor, style: BorderStyle.solid)
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
    switch (widget.theme) {
      case TDPopoverTheme.info:
        _color = TDTheme.of(widget.context).brandNormalColor;
        _backgroundColor = TDTheme.of(widget.context).brandLightColor;
        break;
      case TDPopoverTheme.success:
        _color = TDTheme.of(widget.context).successNormalColor;
        _backgroundColor = TDTheme.of(widget.context).successLightColor;
        break;
      case TDPopoverTheme.warning:
        _color = TDTheme.of(widget.context).warningNormalColor;
        _backgroundColor = TDTheme.of(widget.context).warningLightColor;
        break;
      case TDPopoverTheme.error:
        _color = TDTheme.of(widget.context).errorNormalColor;
        _backgroundColor = TDTheme.of(widget.context).errorLightColor;
        break;
      case TDPopoverTheme.light:
        _color = TDTheme.of(widget.context).grayColor14;
        _backgroundColor = TDTheme.of(widget.context).whiteColor1;
        break;
      default :
        _color = TDTheme.of(widget.context).whiteColor1;
        _backgroundColor = TDTheme.of(widget.context).grayColor14;
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
    var arrowSize = widget.showArrow ?? false ? widget.arrowSize : 0;
    var contentSize = _getContentSize();
    var popoverHeight = widget.height ?? (widget.padding != null ? widget.padding!.vertical : 24) + (widget.height ?? contentSize.height);
    switch (widget.placement) {
      case TDPopoverPlacement.bottomLeft:
      case TDPopoverPlacement.bottom:
      case TDPopoverPlacement.bottomRight:
        return dy + (widgetBounds?.height ?? 0) + widget.offset;
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.leftTop:
        return dy;
      case TDPopoverPlacement.rightBottom:
      case TDPopoverPlacement.leftBottom:
        return dy - (popoverHeight - (widgetBounds?.height ?? 0));
      case TDPopoverPlacement.right:
      case TDPopoverPlacement.left:
        return dy - (popoverHeight - (widgetBounds?.height ?? 0)) / 2;
      default:
        return dy - popoverHeight - widget.offset - arrowSize;
    }
  }

  /// 获取X坐标
  double _getOffsetLeft(Offset? widgetLocalToGlobal) {
    var widgetBounds = _getWidgetBounds(widget.context);
    var widgetWidth = widgetBounds?.width ?? 0;
    var contentSize = _getContentSize();
    var popoverWidth = widget.width ?? (widget.padding != null ? widget.padding!.horizontal : 24) + contentSize.width;
    var dx = widgetLocalToGlobal?.dx ?? 0;
    switch (widget.placement) {
      case TDPopoverPlacement.topLeft:
      case TDPopoverPlacement.bottomLeft:
        return dx;
      case TDPopoverPlacement.topRight:
      case TDPopoverPlacement.bottomRight:
          return dx + widgetWidth - popoverWidth;
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.right:
      case TDPopoverPlacement.rightBottom:
        return dx + widgetWidth + widget.offset + 8;
      case TDPopoverPlacement.leftTop:
      case TDPopoverPlacement.left:
      case TDPopoverPlacement.leftBottom:
        return dx - popoverWidth - widget.arrowSize - widget.offset - 8;
      default :
        return dx - (popoverWidth - widgetWidth) / 2;
    }
  }

  /// 获取箭头Widget
  Widget _getArrowWidget() {
    var margin = EdgeInsets.only(top: widget.arrowSize);
    switch (widget.placement) {
      case TDPopoverPlacement.topLeft:
       margin = EdgeInsets.only(top: widget.arrowSize, left: widget.arrowSize + 12);
       break;
      case TDPopoverPlacement.topRight:
       margin = EdgeInsets.only(top: widget.arrowSize, right: widget.arrowSize + 12);
       break;
      case TDPopoverPlacement.bottomLeft:
       margin = EdgeInsets.only(bottom: widget.arrowSize, left: widget.arrowSize + 12);
       break;
      case TDPopoverPlacement.bottom:
       margin = EdgeInsets.only(bottom: widget.arrowSize);
       break;
      case TDPopoverPlacement.bottomRight:
       margin = EdgeInsets.only(bottom: widget.arrowSize, right: widget.arrowSize + 12);
       break;
      case TDPopoverPlacement.rightTop:
        margin = EdgeInsets.only(top: widget.arrowSize + 6, right: widget.arrowSize);
        break;
      case TDPopoverPlacement.right:
       margin = EdgeInsets.only(right: widget.arrowSize);
       break;
      case TDPopoverPlacement.rightBottom:
       margin = EdgeInsets.only(bottom: widget.arrowSize + 6, right: widget.arrowSize);
       break;
      case TDPopoverPlacement.leftTop:
        margin = EdgeInsets.only(top: widget.arrowSize + 6, left: widget.arrowSize);
        break;
      case TDPopoverPlacement.left:
        margin = EdgeInsets.only(left: widget.arrowSize);
        break;
      case TDPopoverPlacement.leftBottom:
        margin = EdgeInsets.only(bottom: widget.arrowSize + 6, left: widget.arrowSize);
        break;
      default :
        margin = EdgeInsets.only(top: widget.arrowSize);
    }
    return Container(
      margin: margin,
      child: _drawArrow(),
    );
  }

  /// 获取弹出内容大小
  Size _getContentSize() {
    if(widget.contentWidget != null) {
      return Size(widget.width!, widget.height!);
    }
    return _getTextSize();
  }

  /// 获取文本内容大小
  Size _getTextSize() {
    var textPainter = TextPainter(
      text: TextSpan(
        text: widget.content,
        style: TextStyle(
          color: _color,
          letterSpacing: 0,
          fontSize: 16,
          height: 1.5,
        ),
      ),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (widget.width ?? 300) - (widget.padding != null ? widget.padding!.horizontal : 24));
    return textPainter.size;
  }

  /// 获取子Widget
  Widget _getChild() {
    var children = [
      Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: widget.radius ?? BorderRadius.circular(6),
            color: _backgroundColor,
            boxShadow: const [
              BoxShadow(color: Color(0x0d000000), offset: Offset(0, 6), blurRadius: 30, spreadRadius: 5),
              BoxShadow(color: Color(0x0a000000), offset: Offset(0, 16), blurRadius: 24, spreadRadius: 2),
              BoxShadow(color: Color(0x14000000), offset: Offset(0, 8), blurRadius: 10, spreadRadius: -5),
            ]
        ),
        child: widget.contentWidget != null ? widget.contentWidget! : TDText(
            widget.content,
            style: TextStyle(
              color: _color,
              letterSpacing: 0,
              fontSize: 16,
              height: 1.5,
            )
        ),
      ),
      Visibility(
        visible: widget.showArrow ?? false,
        child: _getArrowWidget(),
      )
    ];
    var axis = CrossAxisAlignment.center;
    var direction = VerticalDirection.down;

    /// 设置子Widget垂直排列顺序
    switch (widget.placement) {
      case TDPopoverPlacement.bottom:
      case TDPopoverPlacement.bottomLeft:
      case TDPopoverPlacement.bottomRight:
        direction = VerticalDirection.up;
        break;
      case TDPopoverPlacement.right:
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.rightBottom:
        /// 反转内容和箭头
        children = [
          Visibility(
            visible: widget.showArrow ?? false,
            child: Container(
              child: _getArrowWidget(),
            ),
          ),
          Container(
            padding: widget.padding ?? const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: _backgroundColor,
              boxShadow: [
                BoxShadow(color: TDTheme.of(context).grayColor7, offset: const Offset(6, 3), blurRadius: 6)
              ]
            ),
            child: widget.contentWidget != null ? widget.contentWidget! : TDText(
              widget.content,
              style: TextStyle(
                color: _color,
                letterSpacing: 0,
                fontSize: 16,
                height: 1.5,
                overflow: TextOverflow.ellipsis,
              )
            ),
          ),
        ];
        break;
      default :
        direction = VerticalDirection.down;
        break;
    }

    /// 改变Row和Column交叉轴对齐位置，从而实现箭头位置
    switch (widget.placement) {
      case TDPopoverPlacement.topLeft:
      case TDPopoverPlacement.bottomLeft:
        axis = CrossAxisAlignment.start;
        break;
      case TDPopoverPlacement.topRight:
      case TDPopoverPlacement.bottomRight:
        axis =  CrossAxisAlignment.end;
        break;
      case TDPopoverPlacement.rightTop:
      case TDPopoverPlacement.leftTop:
        axis = CrossAxisAlignment.start;
        break;
      case TDPopoverPlacement.rightBottom:
      case TDPopoverPlacement.leftBottom:
        axis = CrossAxisAlignment.end;
        break;
      default :
        axis = CrossAxisAlignment.center;
    }

    /// 横向布局
    if(widget.placement == TDPopoverPlacement.right ||
      widget.placement == TDPopoverPlacement.rightTop ||
      widget.placement == TDPopoverPlacement.rightBottom ||
      widget.placement == TDPopoverPlacement.left ||
      widget.placement == TDPopoverPlacement.leftBottom ||
      widget.placement == TDPopoverPlacement.leftTop) {
      return Row(
        crossAxisAlignment: axis,
        children: children,
      );
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
      children: [
        Positioned(
          top: top,
          left: left,
          child: _getChild(),
        ),
      ],
    );
  }
}