import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


const double _kTabHeight = 54.0;
const double _kTextAndIconTabHeight = 80.0;

enum TabBarIndicatorSize {
  tab,
  label,
}

class Tab extends StatelessWidget implements PreferredSizeWidget {
  const Tab({
    Key? key,
    this.text,
    this.icon,
    this.iconMargin = const EdgeInsets.only(bottom: 10.0),
    this.height,
    this.child,
  }) : assert(text != null || child != null || icon != null),
        assert(text == null || child == null),
        super(key: key);

  final String? text;
  final Widget? child;
  final Widget? icon;
  final EdgeInsetsGeometry iconMargin;
  final double? height;

  Widget _buildLabelText() {
    return child ?? Text(text!, softWrap: false, overflow: TextOverflow.fade);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    final double calculatedHeight;
    final Widget label;
    if (icon == null) {
      calculatedHeight = _kTabHeight;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      calculatedHeight = _kTabHeight;
      label = icon!;
    } else {
      calculatedHeight = _kTextAndIconTabHeight;
      label = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: iconMargin,
            child: icon,
          ),
          _buildLabelText(),
        ],
      );
    }

    return SizedBox(
      height: height ?? calculatedHeight,
      child: Center(
        widthFactor: 1.0,
        child: label,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('icon', icon, defaultValue: null));
  }

  @override
  Size get preferredSize {
    if (height != null) {
      return Size.fromHeight(height!);
    } else if ((text != null || child != null) && icon != null) {
      return const Size.fromHeight(_kTextAndIconTabHeight);
    } else {
      return const Size.fromHeight(_kTabHeight);
    }
  }
}

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    Key? key,
    required Animation<double> animation,
    required this.selected,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.child,
    required this.selectedBackgroundColor,
    required this.unSelectedBackgroundColor,
  }) : super(key: key, listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool selected;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Widget child;
  final Color? selectedBackgroundColor;
  final Color? unSelectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final tabBarTheme = TabBarTheme.of(context);
    final animation = listenable as Animation<double>;

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final defaultStyle = (labelStyle
        ?? tabBarTheme.labelStyle
        ?? themeData.primaryTextTheme.bodyText1!
    ).copyWith(inherit: true);
    final defaultUnselectedStyle = (unselectedLabelStyle
        ?? tabBarTheme.unselectedLabelStyle
        ?? labelStyle
        ?? themeData.primaryTextTheme.bodyText1!
    ).copyWith(inherit: true);
    final textStyle = selected
        ? TextStyle.lerp(defaultStyle, defaultUnselectedStyle, animation.value)!
        : TextStyle.lerp(defaultUnselectedStyle, defaultStyle, animation.value)!;

    final selectedColor = labelColor
        ?? tabBarTheme.labelColor
        ?? themeData.primaryTextTheme.bodyText1!.color!;
    final unselectedColor = unselectedLabelColor
        ?? tabBarTheme.unselectedLabelColor
        ?? selectedColor.withAlpha(0xB2); // 70% alpha
    final color = selected
        ? Color.lerp(selectedColor, unselectedColor, animation.value)!
        : Color.lerp(unselectedColor, selectedColor, animation.value)!;
    final backgroundColor = selected? selectedBackgroundColor ?? Colors.white : unSelectedBackgroundColor ?? const Color(0xFFF3F3F3);

    return Container(
      color: backgroundColor,
      child: DefaultTextStyle(
        style: textStyle.copyWith(color: color),
        child: IconTheme.merge(
          data: IconThemeData(
            size: 24.0,
            color: color,
          ),
          child: child,
        ),
      ),
    );
  }
}

typedef _LayoutCallback = void Function(List<double> yOffsets, TextDirection textDirection, double width);

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    List<RenderBox>? children,
    required Axis direction,
    required MainAxisSize mainAxisSize,
    required MainAxisAlignment mainAxisAlignment,
    required CrossAxisAlignment crossAxisAlignment,
    required TextDirection textDirection,
    required VerticalDirection verticalDirection,
    required this.onPerformLayout,
  }) : assert(onPerformLayout != null),
        assert(textDirection != null),
        super(
        children: children,
        direction: direction,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
      );

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    var child = firstChild;
    final yOffsets = <double>[];
    while (child != null) {
      final childParentData = child.parentData! as FlexParentData;
      yOffsets.add(childParentData.offset.dy);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection!) {
      case TextDirection.rtl:
        yOffsets.insert(0, size.height);
        break;
      case TextDirection.ltr:
        yOffsets.add(size.height);
        break;
    }
    onPerformLayout(yOffsets, textDirection!, size.height);
  }
}

class _TabLabelBar extends Flex {
  _TabLabelBar({
    Key? key,
    List<Widget> children = const <Widget>[],
    required this.onPerformLayout,
  }) : super(
    key: key,
    children: children,
    direction: Axis.vertical,
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    verticalDirection: VerticalDirection.down,
  );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context)!,
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

double _indexChangeProgress(TabController controller) {
  final controllerValue = controller.animation!.value;
  final previousIndex = controller.previousIndex.toDouble();
  final currentIndex = controller.index.toDouble();

  if (!controller.indexIsChanging) {
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);
  }

  return (controllerValue - currentIndex).abs() / (currentIndex - previousIndex).abs();
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.controller,
    required this.indicator,
    required this.indicatorSize,
    required this.tabKeys,
    required _IndicatorPainter? old,
    required this.indicatorPadding,
  }) : assert(controller != null),
        assert(indicator != null),
        super(repaint: controller.animation) {
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  final TabController controller;
  final Decoration indicator;
  final TabBarIndicatorSize? indicatorSize;
  final EdgeInsetsGeometry indicatorPadding;
  final List<GlobalKey> tabKeys;

  List<double>? _currentTabOffsets;
  TextDirection? _currentTextDirection;

  Rect? _currentRect;
  BoxPainter? _painter;
  bool _needsPaint = false;
  void markNeedsPaint() {
    _needsPaint = true;
  }

  void dispose() {
    _painter?.dispose();
  }

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  int get maxTabIndex => _currentTabOffsets!.length - 2;

  double centerOf(int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    return (_currentTabOffsets![tabIndex] + _currentTabOffsets![tabIndex + 1]) / 2.0;
  }

  Rect indicatorRect(Size tabBarSize, int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTextDirection != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    double tabLeft, tabRight;
    switch (_currentTextDirection!) {
      case TextDirection.rtl:
        tabLeft = _currentTabOffsets![tabIndex + 1];
        tabRight = _currentTabOffsets![tabIndex];
        break;
      case TextDirection.ltr:
        tabLeft = _currentTabOffsets![tabIndex];
        tabRight = _currentTabOffsets![tabIndex + 1];
        break;
    }

    if (indicatorSize == TabBarIndicatorSize.label) {
      final tabHeight = tabKeys[tabIndex].currentContext!.size!.height;
      final delta = ((tabRight - tabLeft) - tabHeight) / 2.0;
      tabLeft += delta;
      tabRight -= delta;
    }

    final insets = indicatorPadding.resolve(_currentTextDirection);
    final rect = Rect.fromLTWH(tabLeft, 0.0, tabRight - tabLeft, tabBarSize.height);

    if (!(rect.size >= insets.collapsedSize)) {
      throw FlutterError(
        'indicatorPadding insets should be less than Tab Size\n'
            'Rect Size : ${rect.size}, Insets: ${insets.toString()}',
      );
    }
    return insets.deflateRect(rect);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _needsPaint = false;
    _painter ??= indicator.createBoxPainter(markNeedsPaint);

    final index = controller.index.toDouble();
    final value = controller.animation!.value;
    final ltr = index > value;
    final from = (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
    final to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex);
    final fromRect = indicatorRect(size, from);
    final toRect = indicatorRect(size, to);
    _currentRect = Rect.lerp(fromRect, toRect, (value - from).abs());
    assert(_currentRect != null);

    final configuration = ImageConfiguration(
      size: _currentRect!.size,
      textDirection: _currentTextDirection,
    );
    _painter!.paint(canvas, _currentRect!.topLeft, configuration);
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) {
    return _needsPaint
        || controller != old.controller
        || indicator != old.indicator
        || tabKeys.length != old.tabKeys.length
        || (!listEquals(_currentTabOffsets, old._currentTabOffsets))
        || _currentTextDirection != old._currentTextDirection;
  }
}

class _ChangeAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value => _indexChangeProgress(controller);
}

class _DragAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final controllerMaxValue = (controller.length - 1).toDouble();
    final controllerValue = controller.animation!.value.clamp(0.0, controllerMaxValue);
    return (controllerValue - index.toDouble()).abs().clamp(0.0, 1.0);
  }
}

class _TabBarScrollPosition extends ScrollPositionWithSingleContext {
  _TabBarScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required ScrollPosition? oldPosition,
    required this.tabBar,
  }) : super(
    physics: physics,
    context: context,
    initialPixels: null,
    oldPosition: oldPosition,
  );

  final _TabBarState tabBar;

  bool? _initialViewportDimensionWasZero;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    var result = true;
    if (_initialViewportDimensionWasZero != true) {
      assert(viewportDimension != null);
      _initialViewportDimensionWasZero = viewportDimension != 0.0;
      correctPixels(tabBar._initialScrollOffset(viewportDimension, minScrollExtent, maxScrollExtent));
      result = false;
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent) && result;
  }
}

class _TabBarScrollController extends ScrollController {
  _TabBarScrollController(this.tabBar);

  final _TabBarState tabBar;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) {
    return _TabBarScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      tabBar: tabBar,
    );
  }
}

class VerticalTabBar extends StatefulWidget implements PreferredSizeWidget {
  const VerticalTabBar({
    Key? key,
    required this.tabs,
    this.selectedBackgroundColor,
    this.unSelectedBackgroundColor,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
  }) : assert(tabs != null),
        assert(isScrollable != null),
        assert(dragStartBehavior != null),
        assert(indicator != null || (indicatorWeight != null && indicatorWeight > 0.0)),
        assert(indicator != null || (indicatorPadding != null)),
        super(key: key);

  final Color? selectedBackgroundColor;

  final Color? unSelectedBackgroundColor;

  final List<Widget> tabs;

  final TabController? controller;

  final bool isScrollable;

  final EdgeInsetsGeometry? padding;

  final Color? indicatorColor;

  final double indicatorWeight;

  final EdgeInsetsGeometry indicatorPadding;

  final Decoration? indicator;

  final bool automaticIndicatorColorAdjustment;

  final TabBarIndicatorSize? indicatorSize;

  final Color? labelColor;

  final Color? unselectedLabelColor;

  final TextStyle? labelStyle;

  final EdgeInsetsGeometry? labelPadding;

  final TextStyle? unselectedLabelStyle;

  final MaterialStateProperty<Color?>? overlayColor;

  final DragStartBehavior dragStartBehavior;

  final MouseCursor? mouseCursor;

  final bool? enableFeedback;

  final ValueChanged<int>? onTap;

  final ScrollPhysics? physics;

  @override
  Size get preferredSize {
    var maxHeight = _kTabHeight;
    for (final item in tabs) {
      if (item is PreferredSizeWidget) {
        final itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight);
  }

  bool get tabHasTextAndIcon {
    for (final item in tabs) {
      if (item is PreferredSizeWidget) {
        if (item.preferredSize.height == _kTextAndIconTabHeight) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  State<VerticalTabBar> createState() => _TabBarState();
}

class _TabBarState extends State<VerticalTabBar> {
  ScrollController? _scrollController;
  TabController? _controller;
  _IndicatorPainter? _indicatorPainter;
  int? _currentIndex;
  late double _tabStripWidth;
  late List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();
    _tabKeys = widget.tabs.map((Widget tab) => GlobalKey()).toList();
  }

  Decoration get _indicator {
    if (widget.indicator != null) {
      return widget.indicator!;
    }
    final tabBarTheme = TabBarTheme.of(context);
    if (tabBarTheme.indicator != null) {
      return tabBarTheme.indicator!;
    }

    var color = widget.indicatorColor ?? Theme.of(context).indicatorColor;
    if (widget.automaticIndicatorColorAdjustment && color.value == Material.of(context)?.color?.value) {
      color = Colors.white;
    }

    return UnderlineTabIndicator(
      borderSide: BorderSide(
        width: widget.indicatorWeight,
        color: color,
      ),
    );
  }

  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final newController = widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
              'When creating a ${widget.runtimeType}, you must either provide an explicit '
              'TabController using the "controller" property, or you must ensure that there '
              'is a DefaultTabController above the ${widget.runtimeType}.\n'
              'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
      _controller!.addListener(_handleTabControllerTick);
      _currentIndex = _controller!.index;
    }
  }

  void _initIndicatorPainter() {
    _indicatorPainter = !_controllerIsValid ? null : _IndicatorPainter(
      controller: _controller!,
      indicator: _indicator,
      indicatorSize: widget.indicatorSize ?? TabBarIndicatorSize.label,
      indicatorPadding: widget.indicatorPadding,
      tabKeys: _tabKeys,
      old: _indicatorPainter,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
    _initIndicatorPainter();
  }

  @override
  void didUpdateWidget(VerticalTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _initIndicatorPainter();
    } else if (widget.indicatorColor != oldWidget.indicatorColor ||
        widget.indicatorWeight != oldWidget.indicatorWeight ||
        widget.indicatorSize != oldWidget.indicatorSize ||
        widget.indicator != oldWidget.indicator) {
      _initIndicatorPainter();
    }

    if (widget.tabs.length > oldWidget.tabs.length) {
      final delta = widget.tabs.length - oldWidget.tabs.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
    } else if (widget.tabs.length < oldWidget.tabs.length) {
      _tabKeys.removeRange(widget.tabs.length, oldWidget.tabs.length);
    }
  }

  @override
  void dispose() {
    _indicatorPainter!.dispose();
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = null;
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  int get maxTabIndex => _indicatorPainter!.maxTabIndex;

  double _tabScrollOffset(int index, double viewportWidth, double minExtent, double maxExtent) {
    if (!widget.isScrollable) {
      return 0.0;
    }
    var tabCenter = _indicatorPainter!.centerOf(index);
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        tabCenter = _tabStripWidth - tabCenter;
        break;
      case TextDirection.ltr:
        break;
    }
    return (tabCenter - viewportWidth / 2.0).clamp(minExtent, maxExtent);
  }

  double _tabCenteredScrollOffset(int index) {
    final position = _scrollController!.position;
    return _tabScrollOffset(index, position.viewportDimension, position.minScrollExtent, position.maxScrollExtent);
  }

  double _initialScrollOffset(double viewportWidth, double minExtent, double maxExtent) {
    return _tabScrollOffset(_currentIndex!, viewportWidth, minExtent, maxExtent);
  }

  void _scrollToCurrentIndex() {
    final offset = _tabCenteredScrollOffset(_currentIndex!);
    _scrollController!.animateTo(offset, duration: kTabScrollDuration, curve: Curves.ease);
  }

  void _scrollToControllerValue() {
    final leadingPosition = _currentIndex! > 0 ? _tabCenteredScrollOffset(_currentIndex! - 1) : null;
    final middlePosition = _tabCenteredScrollOffset(_currentIndex!);
    final trailingPosition = _currentIndex! < maxTabIndex ? _tabCenteredScrollOffset(_currentIndex! + 1) : null;

    final index = _controller!.index.toDouble();
    final value = _controller!.animation!.value;
    final double offset;
    if (value == index - 1.0) {
      offset = leadingPosition ?? middlePosition;
    } else if (value == index + 1.0) {
      offset = trailingPosition ?? middlePosition;
    } else if (value == index) {
      offset = middlePosition;
    } else if (value < index) {
      offset = leadingPosition == null ? middlePosition : lerpDouble(middlePosition, leadingPosition, index - value)!;
    } else {
      offset = trailingPosition == null ? middlePosition : lerpDouble(middlePosition, trailingPosition, value - index)!;
    }

    _scrollController!.jumpTo(offset);
  }

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller!.indexIsChanging && widget.isScrollable) {
      // Sync the TabBar's scroll position with the TabBarView's PageView.
      _currentIndex = _controller!.index;
      _scrollToControllerValue();
    }
  }

  void _handleTabControllerTick() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      if (widget.isScrollable) {
        _scrollToCurrentIndex();
      }
    }
    setState(() {});
  }

  void _saveTabOffsets(List<double> tabOffsets, TextDirection textDirection, double width) {
    _tabStripWidth = width;
    _indicatorPainter?.saveTabOffsets(tabOffsets, textDirection);
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller!.animateTo(index);
    widget.onTap?.call(index);
  }

  Widget _buildStyledTab(Widget child, bool selected, Animation<double> animation) {
    return _TabStyle(
      animation: animation,
      selected: selected,
      selectedBackgroundColor: widget.selectedBackgroundColor,
      unSelectedBackgroundColor: widget.unSelectedBackgroundColor,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (_controller!.length != widget.tabs.length) {
        throw FlutterError(
          "Controller's length property (${_controller!.length}) does not match the "
              "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.",
        );
      }
      return true;
    }());
    final localizations = MaterialLocalizations.of(context);
    if (_controller!.length == 0) {
      return Container(
        height: _kTabHeight,
      );
    }

    final tabBarTheme = TabBarTheme.of(context);

    final wrappedTabs = List<Widget>.generate(widget.tabs.length, (int index) {
      const verticalAdjustment = (_kTextAndIconTabHeight - _kTabHeight)/2.0;
      EdgeInsetsGeometry? adjustedPadding;

      if (widget.tabs[index] is PreferredSizeWidget) {
        final tab = widget.tabs[index] as PreferredSizeWidget;
        if (widget.tabHasTextAndIcon && tab.preferredSize.height == _kTabHeight) {
          if (widget.labelPadding != null || tabBarTheme.labelPadding != null) {
            adjustedPadding = (widget.labelPadding ?? tabBarTheme.labelPadding!).add(const EdgeInsets.symmetric(vertical: verticalAdjustment));
          }
          else {
            adjustedPadding = const EdgeInsets.symmetric(vertical: verticalAdjustment, horizontal: 16.0);
          }
        }
      }

      return Center(
        child: Padding(
          padding: adjustedPadding ?? widget.labelPadding ?? tabBarTheme.labelPadding ?? kTabLabelPadding,
          child: KeyedSubtree(
            key: _tabKeys[index],
            child: widget.tabs[index],
          ),
        ),
      );
    });

    if (_controller != null) {
      final previousIndex = _controller!.previousIndex;

      if (_controller!.indexIsChanging) {
        // The user tapped on a tab, the tab controller's animation is running.
        assert(_currentIndex != previousIndex);
        final Animation<double> animation = _ChangeAnimation(_controller!);
        wrappedTabs[_currentIndex!] = _buildStyledTab(wrappedTabs[_currentIndex!], true, animation);
        wrappedTabs[previousIndex] = _buildStyledTab(wrappedTabs[previousIndex], false, animation);
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final tabIndex = _currentIndex!;
        final Animation<double> centerAnimation = _DragAnimation(_controller!, tabIndex);
        wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], true, centerAnimation);
        if (_currentIndex! > 0) {
          final tabIndex = _currentIndex! - 1;
          final Animation<double> previousAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, previousAnimation);
        }
        if (_currentIndex! < widget.tabs.length - 1) {
          final tabIndex = _currentIndex! + 1;
          final Animation<double> nextAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, nextAnimation);
        }
      }
    }

    final tabCount = widget.tabs.length;
    for (var index = 0; index < tabCount; index += 1) {
      wrappedTabs[index] = InkWell(
        mouseCursor: widget.mouseCursor ?? SystemMouseCursors.click,
        onTap: () { _handleTap(index); },
        enableFeedback: widget.enableFeedback ?? true,
        overlayColor: widget.overlayColor,
        child: Stack(
          children: <Widget>[
            wrappedTabs[index],
            Semantics(
              selected: index == _currentIndex,
              label: localizations.tabLabel(tabIndex: index + 1, tabCount: tabCount),
            ),
          ],
        ),
      );
      if (!widget.isScrollable) {
        wrappedTabs[index] = Expanded(child: wrappedTabs[index]);
      }
    }

    Widget tabBar = CustomPaint(
      foregroundPainter: _indicatorPainter,
      child: _TabStyle(
        selectedBackgroundColor: widget.selectedBackgroundColor,
        unSelectedBackgroundColor: widget.unSelectedBackgroundColor,
        animation: kAlwaysDismissedAnimation,
        selected: false,
        labelColor: widget.labelColor,
        unselectedLabelColor: widget.unselectedLabelColor,
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        child: _TabLabelBar(
          onPerformLayout: _saveTabOffsets,
          children: wrappedTabs,
        ),
      ),
    );

    if (widget.isScrollable) {
      _scrollController ??= _TabBarScrollController(this);
      tabBar = SingleChildScrollView(
        dragStartBehavior: widget.dragStartBehavior,
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        padding: widget.padding,
        physics: widget.physics,
        child: tabBar,
      );
    } else if (widget.padding != null) {
      tabBar = Padding(
        padding: widget.padding!,
        child: tabBar,
      );
    }

    return tabBar;
  }
}

