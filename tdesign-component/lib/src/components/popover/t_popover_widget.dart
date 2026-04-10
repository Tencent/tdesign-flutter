import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum TPopoverTheme {
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
  leftTop
}

typedef OnTap = Function(String? content);
typedef OnLongTap = Function(String? content);

class TPopoverWidget extends StatefulWidget {
  const TPopoverWidget({
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
    this.radius,
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
  final TPopoverTheme? theme;

  /// 浮层出现位置
  final TPopoverPlacement? placement;

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
  State<TPopoverWidget> createState() => _TPopoverWidgetState();
}

class _TPopoverWidgetState extends State<TPopoverWidget> {
  late Color _color;

  late Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _initTheme();
    if (widget.contentWidget != null) {
      if (widget.width == null) {
        throw FlutterError(
            'width must not be null when contentWidget is not null');
      }
      if (widget.height == null) {
        throw FlutterError(
            'height must not be null when contentWidget is not null');
      }
    }
  }

  /// 绘制箭头
  Widget _drawArrow() {
    var border = Border(
        right: BorderSide(
          width: widget.arrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
        bottom: BorderSide(
          width: widget.arrowSize,
          color: _backgroundColor,
          style: BorderStyle.solid,
        ),
        left: BorderSide(
          width: widget.arrowSize,
          color: Colors.transparent,
          style: BorderStyle.solid,
        ));
    if (widget.placement == TPopoverPlacement.bottom ||
        widget.placement == TPopoverPlacement.bottomLeft ||
        widget.placement == TPopoverPlacement.bottomRight) {
      border = Border(
          top: BorderSide(
            width: widget.arrowSize,
            color: _backgroundColor,
            style: BorderStyle.solid,
          ),
          right: BorderSide(
            width: widget.arrowSize,
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
          left: BorderSide(
            width: widget.arrowSize,
            color: Colors.transparent,
            style: BorderStyle.solid,
          ));
    } else if (widget.placement == TPopoverPlacement.left ||
        widget.placement == TPopoverPlacement.leftTop ||
        widget.placement == TPopoverPlacement.leftBottom) {
      border = Border(
          top: BorderSide(
            width: widget.arrowSize,
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
          bottom: BorderSide(
            width: widget.arrowSize,
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
          right: BorderSide(
            width: widget.arrowSize,
            color: _backgroundColor,
            style: BorderStyle.solid,
          ));
    } else if (widget.placement == TPopoverPlacement.right ||
        widget.placement == TPopoverPlacement.rightTop ||
        widget.placement == TPopoverPlacement.rightBottom) {
      border = Border(
          top: BorderSide(
            width: widget.arrowSize,
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
          bottom: BorderSide(
            width: widget.arrowSize,
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
          left: BorderSide(
            width: widget.arrowSize,
            color: _backgroundColor,
            style: BorderStyle.solid,
          ));
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
      case TPopoverTheme.info:
        _color = TTheme.of(widget.context).brandNormalColor;
        _backgroundColor = TTheme.of(widget.context).brandLightColor;
        break;
      case TPopoverTheme.success:
        _color = TTheme.of(widget.context).successNormalColor;
        _backgroundColor = TTheme.of(widget.context).successLightColor;
        break;
      case TPopoverTheme.warning:
        _color = TTheme.of(widget.context).warningNormalColor;
        _backgroundColor = TTheme.of(widget.context).warningLightColor;
        break;
      case TPopoverTheme.error:
        _color = TTheme.of(widget.context).errorNormalColor;
        _backgroundColor = TTheme.of(widget.context).errorLightColor;
        break;
      case TPopoverTheme.light:
        _color = TTheme.of(widget.context).grayColor14;
        _backgroundColor = TTheme.of(widget.context).whiteColor1;
        break;
      default:
        _color = TTheme.of(widget.context).whiteColor1;
        _backgroundColor = TTheme.of(widget.context).grayColor14;
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
    var popoverHeight = widget.height ??
        (widget.padding != null ? widget.padding!.vertical : 24) +
            (widget.height ?? contentSize.height);
    switch (widget.placement) {
      case TPopoverPlacement.bottomLeft:
      case TPopoverPlacement.bottom:
      case TPopoverPlacement.bottomRight:
        return dy + (widgetBounds?.height ?? 0) + widget.offset;
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
        return dy - popoverHeight - widget.offset - arrowSize;
    }
  }

  /// 获取X坐标
  double _getOffsetLeft(Offset? widgetLocalToGlobal) {
    var widgetBounds = _getWidgetBounds(widget.context);
    var widgetWidth = widgetBounds?.width ?? 0;
    var contentSize = _getContentSize();
    var popoverWidth = widget.width ??
        (widget.padding != null ? widget.padding!.horizontal : 24) +
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
        return dx + widgetWidth + widget.offset;
      case TPopoverPlacement.leftTop:
      case TPopoverPlacement.left:
      case TPopoverPlacement.leftBottom:
        return dx - popoverWidth - widget.arrowSize - widget.offset;
      default:
        return dx - (popoverWidth - widgetWidth) / 2;
    }
  }

  /// 获取箭头Widget
  /// todo 通过 CustomPainter 绘制箭头进行优化
  Widget _getArrowWidget() {
    var margin = EdgeInsets.only(top: widget.arrowSize);
    switch (widget.placement) {
      case TPopoverPlacement.topLeft:
        margin =
            EdgeInsets.only(top: widget.arrowSize, left: widget.arrowSize + 12);
        break;
      case TPopoverPlacement.topRight:
        margin = EdgeInsets.only(
            top: widget.arrowSize, right: widget.arrowSize + 12);
        break;
      case TPopoverPlacement.bottomLeft:
        margin = EdgeInsets.only(
            bottom: widget.arrowSize, left: widget.arrowSize + 12);
        break;
      case TPopoverPlacement.bottom:
        margin = EdgeInsets.only(bottom: widget.arrowSize);
        break;
      case TPopoverPlacement.bottomRight:
        margin = EdgeInsets.only(
            bottom: widget.arrowSize, right: widget.arrowSize + 12);
        break;
      case TPopoverPlacement.rightTop:
        margin =
            EdgeInsets.only(top: widget.arrowSize + 6, right: widget.arrowSize);
        break;
      case TPopoverPlacement.right:
        margin = EdgeInsets.only(right: widget.arrowSize);
        break;
      case TPopoverPlacement.rightBottom:
        margin = EdgeInsets.only(
            bottom: widget.arrowSize + 6, right: widget.arrowSize);
        break;
      case TPopoverPlacement.leftTop:
        margin =
            EdgeInsets.only(top: widget.arrowSize + 6, left: widget.arrowSize);
        break;
      case TPopoverPlacement.left:
        margin = EdgeInsets.only(left: widget.arrowSize);
        break;
      case TPopoverPlacement.leftBottom:
        margin = EdgeInsets.only(
            bottom: widget.arrowSize + 6, left: widget.arrowSize);
        break;
      default:
        margin = EdgeInsets.only(top: widget.arrowSize);
    }
    return Container(
      margin: margin,
      child: _drawArrow(),
    );
  }

  /// 获取弹出内容大小
  Size _getContentSize() {
    if (widget.contentWidget != null) {
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
    )..layout(
        maxWidth: (widget.width ?? 300) -
            (widget.padding != null ? widget.padding!.horizontal : 24));
    return textPainter.size;
  }

  Widget _getContainerWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: widget.radius ??
              BorderRadius.circular(TTheme.of(context).radiusDefault),
          color: _backgroundColor,
          boxShadow: const [
            BoxShadow(
                color: Color(0x0d000000),
                offset: Offset(0, 6),
                blurRadius: 30,
                spreadRadius: 5),
            BoxShadow(
                color: Color(0x0a000000),
                offset: Offset(0, 16),
                blurRadius: 24,
                spreadRadius: 2),
            BoxShadow(
                color: Color(0x14000000),
                offset: Offset(0, 8),
                blurRadius: 10,
                spreadRadius: -5),
          ]),
      child: widget.contentWidget != null
          ? widget.contentWidget!
          : TText(widget.content,
              style: TextStyle(
                color: _color,
                letterSpacing: 0,
                fontSize: 16,
                height: 1.5,
              )),
    );
  }

  /// 获取子Widget
  Widget _getChild() {
    var children = [
      _getContainerWidget(),
      Visibility(
        visible: widget.showArrow ?? false,
        child: _getArrowWidget(),
      )
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
          Visibility(
            visible: widget.showArrow ?? false,
            child: _getArrowWidget(),
          ),
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
