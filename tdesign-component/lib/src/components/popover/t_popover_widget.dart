import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import 't_popover_theme_data.dart';
import 't_popover_types.dart';

const double _kDefaultPopoverMaxWidth = 300;
const EdgeInsets _kDefaultPopoverPadding = EdgeInsets.all(12);

/// 气泡弹层 Widget
class TPopoverWidget extends StatefulWidget {
  const TPopoverWidget({
    super.key,
    required this.context,
    required this.content,
    this.offset,
    this.colorScheme = TPopoverColorScheme.defaultTheme,
    this.placement = TPopoverPlacement.top,
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

  /// 气泡内容。
  final Widget content;

  /// 偏移
  final double? offset;

  /// 弹出气泡预设配色。
  final TPopoverColorScheme colorScheme;

  /// 浮层出现位置
  final TPopoverPlacement placement;

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
  final VoidCallback? onTap;

  /// 长按事件
  final VoidCallback? onLongTap;

  /// 圆角
  final BorderRadius? radius;

  @override
  State<TPopoverWidget> createState() => _TPopoverWidgetState();
}

class _TPopoverWidgetState extends State<TPopoverWidget> {
  TPopoverPlacement _resolvedPlacement = TPopoverPlacement.top;
  Offset _arrowTranslation = Offset.zero;
  bool _layoutReady = false;

  @override
  void initState() {
    super.initState();
    _resolvedPlacement = widget.placement;
  }

  @override
  void didUpdateWidget(TPopoverWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placement != widget.placement ||
        oldWidget.content != widget.content ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height) {
      _resolvedPlacement = widget.placement;
      _arrowTranslation = Offset.zero;
      _layoutReady = false;
    }
  }

  TPopoverThemeData get _theme =>
      Theme.of(context).extension<TPopoverThemeData>() ??
      const TPopoverThemeData();

  double get _effectiveOffset => widget.offset ?? _theme.offset ?? 4;

  bool get _effectiveShowArrow => widget.showArrow ?? _theme.showArrow ?? true;

  double get _effectiveArrowSize => widget.arrowSize ?? _theme.arrowSize ?? 8;

  EdgeInsetsGeometry? get _effectivePadding => widget.padding ?? _theme.padding;

  double get _effectiveMaxWidth => _theme.maxWidth ?? _kDefaultPopoverMaxWidth;

  EdgeInsetsGeometry get _resolvedPadding =>
      _effectivePadding ?? _kDefaultPopoverPadding;

  BorderRadius? get _effectiveRadius =>
      widget.radius ??
      (_theme.borderRadius == null
          ? null
          : BorderRadius.circular(_theme.borderRadius!));

  TextStyle get _defaultContentTextStyle => TextStyle(
    color: _color,
    letterSpacing: 0,
    fontSize: context.tTheme.fontBodyLarge?.size ?? 16,
    height: context.tTheme.fontBodyLarge?.height ?? 1.5,
  );

  late Color _color;

  late Color _backgroundColor;

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
      case TPopoverColorScheme.primary:
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
      case TPopoverColorScheme.danger:
        _color = widget.context.tTheme.errorNormalColor;
        _backgroundColor = widget.context.tTheme.errorLightColor;
        break;
      case TPopoverColorScheme.light:
        _color = widget.context.tTheme.grayColor14;
        _backgroundColor = widget.context.tTheme.whiteColor1;
        break;
      case TPopoverColorScheme.defaultTheme:
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

  /// 获取箭头Widget
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

  Widget _getContainerWidget() {
    final plainTextSize = _resolvedPlainTextSize();
    final minWidth =
        plainTextSize?.width ?? widget.width ?? _theme.minWidth ?? 0;
    final maxWidth = plainTextSize?.width ?? widget.width ?? _effectiveMaxWidth;
    final minHeight = plainTextSize?.height ?? widget.height ?? 0;
    final maxHeight =
        plainTextSize?.height ??
        widget.height ??
        _theme.maxHeight ??
        double.infinity;
    final content = widget.content;
    final styledContent = content is Text
        ? DefaultTextStyle.merge(
            style: _defaultContentTextStyle,
            child: content,
          )
        : content;
    return Container(
      key: const Key('t-popover-content'),
      constraints: BoxConstraints(
        minWidth: math.min(minWidth, maxWidth),
        maxWidth: maxWidth,
        minHeight: math.min(minHeight, maxHeight),
        maxHeight: maxHeight,
      ),
      padding: _resolvedPadding,
      decoration: BoxDecoration(
        borderRadius:
            _effectiveRadius ??
            BorderRadius.circular(context.tTheme.radiusDefault),
        color: _backgroundColor,
        boxShadow: _theme.boxShadow ?? context.tTheme.shadowsTop ?? const [],
      ),
      child: styledContent,
    );
  }

  Size? _resolvedPlainTextSize() {
    final content = widget.content;
    if (content is! Text ||
        content.data == null ||
        content.style != null ||
        content.textSpan != null) {
      return null;
    }
    final contentMaxWidth =
        (widget.width ?? _effectiveMaxWidth) - _resolvedPadding.horizontal;
    final textPainter = TextPainter(
      text: TextSpan(text: content.data, style: _defaultContentTextStyle),
      locale: content.locale ?? Localizations.localeOf(context),
      textDirection: content.textDirection ?? Directionality.of(context),
      textAlign: content.textAlign ?? TextAlign.start,
      maxLines: content.maxLines,
      ellipsis: content.overflow == TextOverflow.ellipsis ? '\u2026' : null,
      textScaler: content.textScaler ?? MediaQuery.textScalerOf(context),
      textWidthBasis: content.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: content.textHeightBehavior,
    )..layout(maxWidth: contentMaxWidth.clamp(0, double.infinity));
    final naturalWidth = textPainter.width + _resolvedPadding.horizontal;
    final resolvedWidth =
        widget.width ??
        math.min(
          _effectiveMaxWidth,
          math.max(_theme.minWidth ?? 0, naturalWidth),
        );
    final naturalHeight = textPainter.height + _resolvedPadding.vertical;
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
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: axis,
        children: children,
      );
    }

    /// 纵向布局
    return Column(
      mainAxisSize: MainAxisSize.min,
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

  double _arrowSafeInset(Size popoverSize, TPopoverPlacement placement) {
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
    final extent = _isLeftPlacement(placement) || _isRightPlacement(placement)
        ? popoverSize.height
        : popoverSize.width;
    return math.min(extent / 2, largestRadius + _effectiveArrowSize);
  }

  double _baseArrowCenter(Size popoverSize, TPopoverPlacement placement) {
    final edgeInset = _effectiveArrowSize * 2;
    return switch (placement) {
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

  Offset _resolveArrowTranslation({
    required TPopoverPlacement placement,
    required Rect anchorRect,
    required Size popoverSize,
    required double left,
    required double top,
  }) {
    if (!_effectiveShowArrow) {
      return Offset.zero;
    }
    final horizontal =
        _isLeftPlacement(placement) || _isRightPlacement(placement);
    final extent = horizontal ? popoverSize.height : popoverSize.width;
    final desiredCenter = horizontal
        ? anchorRect.center.dy - top
        : anchorRect.center.dx - left;
    final safeInset = _arrowSafeInset(popoverSize, placement);
    final targetCenter = desiredCenter
        .clamp(safeInset, math.max(safeInset, extent - safeInset))
        .toDouble();
    final translation = targetCenter - _baseArrowCenter(popoverSize, placement);
    return horizontal ? Offset(0, translation) : Offset(translation, 0);
  }

  double _rawTop({
    required TPopoverPlacement placement,
    required Rect anchorRect,
    required Size popoverSize,
    required double arrowSize,
  }) {
    return switch (placement) {
      TPopoverPlacement.bottomLeft ||
      TPopoverPlacement.bottom ||
      TPopoverPlacement.bottomRight => anchorRect.bottom + _effectiveOffset,
      TPopoverPlacement.rightTop || TPopoverPlacement.leftTop => anchorRect.top,
      TPopoverPlacement.rightBottom ||
      TPopoverPlacement.leftBottom => anchorRect.bottom - popoverSize.height,
      TPopoverPlacement.right ||
      TPopoverPlacement.left => anchorRect.center.dy - popoverSize.height / 2,
      _ => anchorRect.top - popoverSize.height - _effectiveOffset - arrowSize,
    };
  }

  double _rawLeft({
    required TPopoverPlacement placement,
    required Rect anchorRect,
    required Size popoverSize,
    required double arrowSize,
  }) {
    return switch (placement) {
      TPopoverPlacement.topLeft ||
      TPopoverPlacement.bottomLeft => anchorRect.left,
      TPopoverPlacement.topRight ||
      TPopoverPlacement.bottomRight => anchorRect.right - popoverSize.width,
      TPopoverPlacement.rightTop ||
      TPopoverPlacement.right ||
      TPopoverPlacement.rightBottom => anchorRect.right + _effectiveOffset,
      TPopoverPlacement.leftTop ||
      TPopoverPlacement.left ||
      TPopoverPlacement.leftBottom =>
        anchorRect.left - popoverSize.width - arrowSize - _effectiveOffset,
      _ => anchorRect.center.dx - popoverSize.width / 2,
    };
  }

  Offset _positionPopover(
    Size overlaySize,
    Size childSize,
    Rect anchorRect,
    MediaQueryData mediaQuery,
  ) {
    final arrowSize = _effectiveShowArrow ? _effectiveArrowSize : 0.0;
    final requestedIsHorizontal =
        _isLeftPlacement(widget.placement) ||
        _isRightPlacement(widget.placement);
    final popoverSize = requestedIsHorizontal
        ? Size(math.max(0.0, childSize.width - arrowSize), childSize.height)
        : Size(childSize.width, math.max(0.0, childSize.height - arrowSize));
    final minLeft = mediaQuery.padding.left;
    final minTop = mediaQuery.padding.top;
    final bottomInset = math.max(
      mediaQuery.padding.bottom,
      mediaQuery.viewInsets.bottom,
    );
    final viewport = Rect.fromLTRB(
      minLeft,
      minTop,
      overlaySize.width - mediaQuery.padding.right,
      overlaySize.height - bottomInset,
    );
    final resolvedPlacement = _resolvePlacement(
      requested: widget.placement,
      anchorRect: anchorRect,
      viewport: viewport,
      totalSize: childSize,
    );
    final rawTop = _rawTop(
      placement: resolvedPlacement,
      anchorRect: anchorRect,
      popoverSize: popoverSize,
      arrowSize: arrowSize,
    );
    final rawLeft = _rawLeft(
      placement: resolvedPlacement,
      anchorRect: anchorRect,
      popoverSize: popoverSize,
      arrowSize: arrowSize,
    );
    final maxLeft = math.max(
      minLeft,
      overlaySize.width - mediaQuery.padding.right - childSize.width,
    );
    final maxTop = math.max(
      minTop,
      overlaySize.height - bottomInset - childSize.height,
    );
    final left = rawLeft.clamp(minLeft, maxLeft).toDouble();
    final top = rawTop.clamp(minTop, maxTop).toDouble();
    final arrowTranslation = _resolveArrowTranslation(
      placement: resolvedPlacement,
      anchorRect: anchorRect,
      popoverSize: popoverSize,
      left: left,
      top: top,
    );
    _scheduleLayoutResult(resolvedPlacement, arrowTranslation);
    return Offset(left, top);
  }

  void _scheduleLayoutResult(
    TPopoverPlacement placement,
    Offset arrowTranslation,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_layoutReady &&
          _resolvedPlacement == placement &&
          _arrowTranslation == arrowTranslation) {
        return;
      }
      setState(() {
        _layoutReady = true;
        _resolvedPlacement = placement;
        _arrowTranslation = arrowTranslation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _initTheme();
    if (widget.context case final Element element when !element.mounted) {
      return const SizedBox.shrink();
    }
    final anchorOffset = _getWidgetLocalToGlobal(widget.context) ?? Offset.zero;
    final anchorBounds = _getWidgetBounds(widget.context) ?? Rect.zero;
    final anchorRect = anchorOffset & anchorBounds.size;
    final mediaQuery = MediaQuery.of(context);
    var popover = _getChild();
    if (widget.onTap != null || widget.onLongTap != null) {
      popover = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onLongPress: widget.onLongTap,
        child: popover,
      );
    }
    return IgnorePointer(
      ignoring: !_layoutReady,
      child: Opacity(
        opacity: _layoutReady ? 1 : 0,
        child: CustomSingleChildLayout(
          delegate: _PopoverLayoutDelegate(
            positionChild: (overlaySize, childSize) => _positionPopover(
              overlaySize,
              childSize,
              anchorRect,
              mediaQuery,
            ),
          ),
          child: popover,
        ),
      ),
    );
  }
}

class _PopoverLayoutDelegate extends SingleChildLayoutDelegate {
  const _PopoverLayoutDelegate({required this.positionChild});

  final Offset Function(Size overlaySize, Size childSize) positionChild;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      positionChild(size, childSize);

  @override
  bool shouldRelayout(_PopoverLayoutDelegate oldDelegate) => true;
}
