import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_popover_theme_data.dart';

const double _kDefaultPopoverMaxWidth = 300;
const EdgeInsets _kDefaultPopoverPadding = EdgeInsets.all(12);

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

  /// 自定义内容。
  ///
  /// 自定义 Widget 无法在首帧定位前可靠测量，使用时必须通过 [width]/[height]
  /// 或组件主题提供确定尺寸。
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

  /// 内容外框宽度（包含 padding）。
  final double? width;

  /// 内容外框高度（包含 padding）。
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
  TPopoverPlacement _resolvedPlacement = TPopoverPlacement.top;
  Offset _arrowTranslation = Offset.zero;

  TPopoverThemeData get _theme =>
      Theme.of(context).extension<TPopoverThemeData>() ??
      const TPopoverThemeData();

  double get _effectiveOffset => widget.offset ?? _theme.offset ?? 4;

  bool get _effectiveShowArrow => widget.showArrow ?? _theme.showArrow ?? true;

  double get _effectiveArrowSize => widget.arrowSize ?? _theme.arrowSize ?? 8;

  EdgeInsetsGeometry? get _effectivePadding => widget.padding ?? _theme.padding;

  double? get _effectiveWidth => widget.width ?? _theme.minWidth;

  double? get _effectiveHeight => widget.height ?? _theme.maxHeight;

  double get _effectiveMaxWidth => _theme.maxWidth ?? _kDefaultPopoverMaxWidth;

  EdgeInsetsGeometry get _resolvedPadding =>
      _effectivePadding ?? _kDefaultPopoverPadding;

  BorderRadius? get _effectiveRadius =>
      widget.radius ??
      (_theme.borderRadius == null
          ? null
          : BorderRadius.circular(_theme.borderRadius!));

  late Color _color;

  late Color _backgroundColor;

  void _validateContentSizeContract() {
    if (widget.contentWidget == null) {
      return;
    }
    if (_effectiveWidth == null || _effectiveHeight == null) {
      throw FlutterError(
        'TPopover custom content requires a deterministic outer size. '
        'Provide both width and height through TPopover or TPopoverThemeData.',
      );
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
    if (_resolvedPlacement == TPopoverPlacement.bottom ||
        _resolvedPlacement == TPopoverPlacement.bottomLeft ||
        _resolvedPlacement == TPopoverPlacement.bottomRight) {
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
    } else if (_resolvedPlacement == TPopoverPlacement.left ||
        _resolvedPlacement == TPopoverPlacement.leftTop ||
        _resolvedPlacement == TPopoverPlacement.leftBottom) {
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
    } else if (_resolvedPlacement == TPopoverPlacement.right ||
        _resolvedPlacement == TPopoverPlacement.rightTop ||
        _resolvedPlacement == TPopoverPlacement.rightBottom) {
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
    _backgroundColor = _theme.backgroundColor ?? _backgroundColor;
  }

  /// 获取触发元素大小
  Rect? _getWidgetBounds(BuildContext context) {
    if (context case final Element element when !element.mounted) {
      return null;
    }
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return null;
    }
    return Offset.zero & renderObject.size;
  }

  /// 获取触发元素坐标
  Offset? _getWidgetLocalToGlobal(BuildContext context) {
    if (context case final Element element when !element.mounted) {
      return null;
    }
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.attached ||
        !renderObject.hasSize) {
      return null;
    }
    return renderObject.localToGlobal(Offset.zero);
  }

  /// 获取Y坐标
  double _getOffsetTop(Offset? widgetLocalToGlobal) {
    var widgetBounds = _getWidgetBounds(widget.context);
    var dy = widgetLocalToGlobal?.dy ?? 0;
    var arrowSize = _effectiveShowArrow ? _effectiveArrowSize : 0;
    final popoverHeight = _resolvedPopoverSize().height;
    switch (_resolvedPlacement) {
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
    final popoverWidth = _resolvedPopoverSize().width;
    var dx = widgetLocalToGlobal?.dx ?? 0;
    switch (_resolvedPlacement) {
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
    switch (_resolvedPlacement) {
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
    return Transform.translate(
      offset: _arrowTranslation,
      child: Container(margin: margin, child: _drawArrow()),
    );
  }

  /// 解析包含 padding 的弹层外框尺寸，供布局和定位共同使用。
  Size _resolvedPopoverSize() {
    if (widget.contentWidget != null) {
      return Size(_effectiveWidth!, _effectiveHeight!);
    }
    final textSize = _getTextSize();
    final naturalWidth = textSize.width + _resolvedPadding.horizontal;
    final maxWidth = _effectiveMaxWidth;
    final resolvedWidth =
        widget.width ??
        math.min(maxWidth, math.max(_theme.minWidth ?? 0, naturalWidth));
    final naturalHeight = textSize.height + _resolvedPadding.vertical;
    final resolvedHeight =
        widget.height ??
        (_theme.maxHeight == null
            ? naturalHeight
            : math.min(
                naturalHeight,
                math.max(_resolvedPadding.vertical, _theme.maxHeight!),
              ));
    return Size(resolvedWidth, resolvedHeight);
  }

  /// 获取文本内容大小
  Size _getTextSize() {
    final font = context.tTheme.fontBodyLarge;
    final contentMaxWidth =
        (widget.width ?? _effectiveMaxWidth) - _resolvedPadding.horizontal;
    var textPainter = TextPainter(
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
      textDirection: Directionality.of(context),
    )..layout(maxWidth: contentMaxWidth.clamp(0, double.infinity));
    return textPainter.size;
  }

  Widget _getContainerWidget() {
    final resolvedSize = _resolvedPopoverSize();
    return Container(
      width: resolvedSize.width,
      height: resolvedSize.height,
      padding: _resolvedPadding,
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
    switch (_resolvedPlacement) {
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
    switch (_resolvedPlacement) {
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
    if (_resolvedPlacement == TPopoverPlacement.right ||
        _resolvedPlacement == TPopoverPlacement.rightTop ||
        _resolvedPlacement == TPopoverPlacement.rightBottom ||
        _resolvedPlacement == TPopoverPlacement.left ||
        _resolvedPlacement == TPopoverPlacement.leftBottom ||
        _resolvedPlacement == TPopoverPlacement.leftTop) {
      return Row(crossAxisAlignment: axis, children: children);
    }

    /// 纵向布局
    return Column(
      crossAxisAlignment: axis,
      verticalDirection: direction,
      children: children,
    );
  }

  TPopoverPlacement _oppositePlacement(TPopoverPlacement placement) {
    return switch (placement) {
      TPopoverPlacement.topLeft => TPopoverPlacement.bottomLeft,
      TPopoverPlacement.top => TPopoverPlacement.bottom,
      TPopoverPlacement.topRight => TPopoverPlacement.bottomRight,
      TPopoverPlacement.bottomLeft => TPopoverPlacement.topLeft,
      TPopoverPlacement.bottom => TPopoverPlacement.top,
      TPopoverPlacement.bottomRight => TPopoverPlacement.topRight,
      TPopoverPlacement.leftTop => TPopoverPlacement.rightTop,
      TPopoverPlacement.left => TPopoverPlacement.right,
      TPopoverPlacement.leftBottom => TPopoverPlacement.rightBottom,
      TPopoverPlacement.rightTop => TPopoverPlacement.leftTop,
      TPopoverPlacement.right => TPopoverPlacement.left,
      TPopoverPlacement.rightBottom => TPopoverPlacement.leftBottom,
    };
  }

  bool _isTopPlacement(TPopoverPlacement placement) =>
      placement == TPopoverPlacement.topLeft ||
      placement == TPopoverPlacement.top ||
      placement == TPopoverPlacement.topRight;

  bool _isBottomPlacement(TPopoverPlacement placement) =>
      placement == TPopoverPlacement.bottomLeft ||
      placement == TPopoverPlacement.bottom ||
      placement == TPopoverPlacement.bottomRight;

  bool _isLeftPlacement(TPopoverPlacement placement) =>
      placement == TPopoverPlacement.leftTop ||
      placement == TPopoverPlacement.left ||
      placement == TPopoverPlacement.leftBottom;

  bool _isRightPlacement(TPopoverPlacement placement) =>
      placement == TPopoverPlacement.rightTop ||
      placement == TPopoverPlacement.right ||
      placement == TPopoverPlacement.rightBottom;

  TPopoverPlacement _resolvePlacement({
    required TPopoverPlacement requested,
    required Rect anchorRect,
    required Rect viewport,
    required Size totalSize,
  }) {
    final requiredVerticalSpace = totalSize.height + _effectiveOffset;
    final requiredHorizontalSpace = totalSize.width + _effectiveOffset;
    final hasTopSpace = anchorRect.top - viewport.top >= requiredVerticalSpace;
    final hasBottomSpace =
        viewport.bottom - anchorRect.bottom >= requiredVerticalSpace;
    final hasLeftSpace =
        anchorRect.left - viewport.left >= requiredHorizontalSpace;
    final hasRightSpace =
        viewport.right - anchorRect.right >= requiredHorizontalSpace;

    if (_isTopPlacement(requested) && !hasTopSpace && hasBottomSpace) {
      return _oppositePlacement(requested);
    }
    if (_isBottomPlacement(requested) && !hasBottomSpace && hasTopSpace) {
      return _oppositePlacement(requested);
    }
    if (_isLeftPlacement(requested) && !hasLeftSpace && hasRightSpace) {
      return _oppositePlacement(requested);
    }
    if (_isRightPlacement(requested) && !hasRightSpace && hasLeftSpace) {
      return _oppositePlacement(requested);
    }
    return requested;
  }

  double _arrowSafeInset(Size popoverSize) {
    final radius =
        (_effectiveRadius ??
                BorderRadius.circular(context.tTheme.radiusDefault))
            .resolve(Directionality.of(context));
    final largestRadius = [
      radius.topLeft.x,
      radius.topRight.x,
      radius.bottomLeft.x,
      radius.bottomRight.x,
    ].reduce(math.max);
    final extent =
        _isLeftPlacement(_resolvedPlacement) ||
            _isRightPlacement(_resolvedPlacement)
        ? popoverSize.height
        : popoverSize.width;
    return math.min(extent / 2, largestRadius + _effectiveArrowSize);
  }

  double _baseArrowCenter(Size popoverSize) {
    final edgeInset = _effectiveArrowSize * 2;
    return switch (_resolvedPlacement) {
      TPopoverPlacement.topLeft ||
      TPopoverPlacement.bottomLeft => edgeInset + 12,
      TPopoverPlacement.topRight ||
      TPopoverPlacement.bottomRight => popoverSize.width - edgeInset - 12,
      TPopoverPlacement.leftTop || TPopoverPlacement.rightTop => edgeInset + 6,
      TPopoverPlacement.leftBottom ||
      TPopoverPlacement.rightBottom => popoverSize.height - edgeInset - 6,
      TPopoverPlacement.top ||
      TPopoverPlacement.bottom => popoverSize.width / 2,
      TPopoverPlacement.left ||
      TPopoverPlacement.right => popoverSize.height / 2,
    };
  }

  void _resolveArrowTranslation({
    required Rect anchorRect,
    required Size popoverSize,
    required double left,
    required double top,
  }) {
    if (!_effectiveShowArrow) {
      _arrowTranslation = Offset.zero;
      return;
    }
    final horizontal =
        _isLeftPlacement(_resolvedPlacement) ||
        _isRightPlacement(_resolvedPlacement);
    final extent = horizontal ? popoverSize.height : popoverSize.width;
    final desiredCenter = horizontal
        ? anchorRect.center.dy - top
        : anchorRect.center.dx - left;
    final safeInset = _arrowSafeInset(popoverSize);
    final targetCenter = desiredCenter
        .clamp(safeInset, math.max(safeInset, extent - safeInset))
        .toDouble();
    final translation = targetCenter - _baseArrowCenter(popoverSize);
    _arrowTranslation = horizontal
        ? Offset(0, translation)
        : Offset(translation, 0);
  }

  @override
  Widget build(BuildContext context) {
    _initTheme();
    _validateContentSizeContract();
    if (widget.context case final Element element when !element.mounted) {
      return const SizedBox.shrink();
    }
    var widgetLocalToGlobal = _getWidgetLocalToGlobal(widget.context);

    final popoverSize = _resolvedPopoverSize();
    final arrowSize = _effectiveShowArrow ? _effectiveArrowSize : 0;
    _resolvedPlacement = widget.placement ?? TPopoverPlacement.top;
    final isHorizontal =
        _isLeftPlacement(_resolvedPlacement) ||
        _isRightPlacement(_resolvedPlacement);
    final totalWidth = popoverSize.width + (isHorizontal ? arrowSize : 0);
    final totalHeight = popoverSize.height + (isHorizontal ? 0 : arrowSize);
    final mediaQuery = MediaQuery.of(context);
    final anchorBounds = _getWidgetBounds(widget.context);
    final shouldClampToViewport =
        widgetLocalToGlobal != null &&
        anchorBounds != null &&
        anchorBounds.width > 0 &&
        anchorBounds.height > 0 &&
        (anchorBounds.width < mediaQuery.size.width ||
            anchorBounds.height < mediaQuery.size.height);
    final minLeft = mediaQuery.padding.left;
    final maxLeft = math.max(
      minLeft,
      mediaQuery.size.width - mediaQuery.padding.right - totalWidth,
    );
    final minTop = mediaQuery.padding.top;
    final bottomInset = math.max(
      mediaQuery.padding.bottom,
      mediaQuery.viewInsets.bottom,
    );
    final viewport = Rect.fromLTRB(
      minLeft,
      minTop,
      mediaQuery.size.width - mediaQuery.padding.right,
      mediaQuery.size.height - bottomInset,
    );
    if (shouldClampToViewport) {
      final anchorRect = widgetLocalToGlobal & anchorBounds.size;
      _resolvedPlacement = _resolvePlacement(
        requested: _resolvedPlacement,
        anchorRect: anchorRect,
        viewport: viewport,
        totalSize: Size(totalWidth, totalHeight),
      );
    }
    final maxTop = math.max(
      minTop,
      mediaQuery.size.height - bottomInset - totalHeight,
    );
    final rawTop = _getOffsetTop(widgetLocalToGlobal);
    final rawLeft = _getOffsetLeft(widgetLocalToGlobal);
    final top = !shouldClampToViewport
        ? rawTop
        : rawTop.clamp(minTop, maxTop).toDouble();
    final left = !shouldClampToViewport
        ? rawLeft
        : rawLeft.clamp(minLeft, maxLeft).toDouble();
    if (shouldClampToViewport) {
      _resolveArrowTranslation(
        anchorRect: widgetLocalToGlobal & anchorBounds.size,
        popoverSize: popoverSize,
        left: left,
        top: top,
      );
    } else {
      _arrowTranslation = Offset.zero;
    }
    var popover = _getChild();
    if (widget.onTap != null || widget.onLongTap != null) {
      popover = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap == null
            ? null
            : () => widget.onTap!.call(widget.content),
        onLongPress: widget.onLongTap == null
            ? null
            : () => widget.onLongTap!.call(widget.content),
        child: popover,
      );
    }
    return Stack(
      children: [Positioned(top: top, left: left, child: popover)],
    );
  }
}
