/*
 * Created by dorayhong@tencent.com on 6/4/23.
 */

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_collapse_panel.dart';
import 't_collapse_theme_data.dart';
import 't_collapse_types.dart';
import 't_inset_divider.dart';
import 't_nonanimated_expand_icon.dart';

/// 折叠面板列表组件，需配合 [TCollapsePanel] 使用
class TCollapse<T extends Object> extends StatefulWidget {
  const TCollapse({
    required this.children,
    this.mode = TCollapseMode.multiple,
    this.variant,
    this.onExpansionChanged,
    this.animationDuration,
    this.elevation,
    this.value,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  /// 折叠面板列表的子组件
  final List<TCollapsePanel<T>> children;

  /// 折叠面板模式
  final TCollapseMode mode;

  /// 折叠面板视觉形态。未设置时从 [TCollapseThemeData.variant] 读取。
  final TCollapseVariant? variant;

  /// 折叠面板列表的回调函数；
  /// 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded
  final ExpansionPanelCallback? onExpansionChanged;

  /// 折叠面板列表的动画时长
  final Duration? animationDuration;

  /// 折叠面板列表的阴影
  final double? elevation;

  /// 手风琴模式下当前展开面板的 value
  final T? value;

  /// 手风琴模式下 value 变更回调
  final ValueChanged<T?>? onChanged;

  @override
  State<TCollapse<T>> createState() => _TCollapseState<T>();
}

class _TCollapseState<T extends Object> extends State<TCollapse<T>> {
  /// 从 Theme 子树读取 L4 默认值
  TCollapseThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TCollapseThemeData>();

  bool get _isAccordion => widget.mode == TCollapseMode.accordion;

  bool _isCardStyle(BuildContext context) {
    final theme = _theme(context);
    return (widget.variant ?? theme?.variant ?? TCollapseVariant.block) ==
        TCollapseVariant.card;
  }

  @override
  void initState() {
    super.initState();

    if (!_isAccordion) {
      return;
    }

    assert(_allPanelsHaveValue(),
        'When allowing only one panel to be open, every panel must have a value.');
    assert(_allPanelsHaveDistinctValues(),
        'When allowing only one panel to be open, every panel must have a distinct value.');
  }

  @override
  void didUpdateWidget(TCollapse<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isAccordion) {
      return;
    }

    assert(_allPanelsHaveValue(),
        'When allowing only one panel to be open, every panel must have a value.');
    assert(_allPanelsHaveDistinctValues(),
        'When allowing only one panel to be open, every panel must have a distinct value.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final animationDuration = widget.animationDuration ??
        theme?.animationDuration ??
        kThemeAnimationDuration;
    final elevation = widget.elevation ?? theme?.elevation ?? 0;
    final panels = <Widget>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      final isLastChild = index == widget.children.length - 1;
      final child = widget.children[index];
      final isExpanded = _isChildExpanded(index);
      final isInteractive = !child.disabled &&
          (widget.onExpansionChanged != null ||
              (_isAccordion && widget.onChanged != null));
      final cardBorderRadius = theme?.cardBorderRadius ??
          BorderRadius.circular(context.tTheme.radiusLarge);
      final borderRadius = _isCardStyle(context)
          ? _createRadius(index, cardBorderRadius)
          : BorderRadius.zero;
      final bgColor = child.backgroundColor ??
          theme?.backgroundColor ??
          context.tTheme.bgColorContainer;
      final childValue = child.value;
      final panelKey = child.key ??
          (_isAccordion && childValue != null
              ? ValueKey<T>(childValue)
              : ValueKey<int>(index));
      final header = _buildHeader(
        context,
        child,
        index,
        isExpanded,
        isInteractive,
        animationDuration,
        borderRadius,
      );
      final body =
          _buildBody(context, child, isExpanded, animationDuration, theme);

      panels.add(Material(
        key: panelKey,
        color: bgColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (child.placement == TCollapsePlacement.top) body,
            header,
            if (child.placement == TCollapsePlacement.bottom) body,
            if (!isLastChild)
              TInsetDivider(color: _dividerColor(context, theme)),
          ],
        ),
      ));
    }

    final cardBorderRadius = theme?.cardBorderRadius ??
        BorderRadius.circular(context.tTheme.radiusLarge);
    Widget collapse = Material(
      elevation: elevation,
      color: theme?.backgroundColor ?? context.tTheme.bgColorContainer,
      borderRadius: _isCardStyle(context) ? cardBorderRadius : null,
      clipBehavior: _isCardStyle(context) ? Clip.antiAlias : Clip.none,
      child: Column(mainAxisSize: MainAxisSize.min, children: panels),
    );

    if (_isCardStyle(context)) {
      collapse = Padding(
        padding: theme?.cardMargin ??
            EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
        child: collapse,
      );
    }

    return collapse;
  }

  BorderRadius _createRadius(int index, BorderRadius radius) {
    final isFirst = index == 0;
    final isLast = index == widget.children.length - 1;
    if (isFirst && isLast) {
      return radius;
    }
    if (isFirst) {
      return BorderRadius.only(
        topLeft: radius.topLeft,
        topRight: radius.topRight,
      );
    }
    if (isLast) {
      return BorderRadius.only(
        bottomLeft: radius.bottomLeft,
        bottomRight: radius.bottomRight,
      );
    }

    return BorderRadius.zero;
  }

  bool _isChildExpanded(int index) {
    final child = widget.children[index];

    if (_isAccordion) {
      return widget.value == child.value;
    }

    return child.isExpanded;
  }

  void _handlePressed(int index, bool isExpanded) {
    widget.onExpansionChanged?.call(index, isExpanded);

    if (!_isAccordion) {
      return;
    }

    widget.onChanged?.call(isExpanded ? null : widget.children[index].value);
  }

  Widget _buildHeader(
    BuildContext context,
    TCollapsePanel<T> child,
    int index,
    bool isExpanded,
    bool isInteractive,
    Duration animationDuration,
    BorderRadius borderRadius,
  ) {
    final titleWidget = _buildTitleWidget(context, child, isExpanded);
    final expandIconWidget = _buildExpandIconWidget(context, child, isExpanded);
    final onTap =
        isInteractive ? () => _handlePressed(index, isExpanded) : null;
    final hasExplicitSemanticsLabel = child.semanticsLabel != null;
    return MergeSemantics(
      child: Semantics(
        label: child.semanticsLabel,
        button: true,
        enabled: isInteractive,
        expanded: isExpanded,
        onTap: hasExplicitSemanticsLabel ? onTap : null,
        child: InkWell(
          borderRadius: borderRadius,
          excludeFromSemantics: hasExplicitSemanticsLabel,
          onTap: onTap,
          child: ExcludeSemantics(
            excluding: hasExplicitSemanticsLabel,
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.fastOutSlowIn,
                    constraints: const BoxConstraints(
                        minHeight: kMinInteractiveDimension),
                    child: titleWidget,
                  ),
                ),
                expandIconWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TCollapsePanel<T> child,
    bool isExpanded,
    Duration animationDuration,
    TCollapseThemeData? theme,
  ) {
    final content = DefaultTextStyle(
      style: _contentTextStyle(context, theme),
      child: Padding(
        padding:
            theme?.contentPadding ?? EdgeInsets.all(context.tTheme.spacer16),
        child: child.body,
      ),
    );
    final divider = TInsetDivider(color: _dividerColor(context, theme));
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: child.placement == TCollapsePlacement.top
            ? [content, divider]
            : [divider, content],
      ),
      firstCurve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: animationDuration,
    );
  }

  Widget _buildTitleWidget(
      BuildContext context, TCollapsePanel<T> child, bool isExpanded) {
    final theme = _theme(context);
    final style = child.disabled
        ? _disabledHeaderTextStyle(context, theme)
        : _headerTextStyle(context, theme);
    return ListTile(
      title: DefaultTextStyle(
        style: style,
        child: child.headerBuilder(context, isExpanded),
      ),
    );
  }

  Widget _buildExpandIconWidget(
    BuildContext context, TCollapsePanel<T> child, bool isExpanded) {
    final theme = _theme(context);
    final iconColor = child.disabled
        ? theme?.disabledIconColor ?? context.tTheme.textDisabledColor
        : theme?.iconColor ?? context.tTheme.textColorPlaceholder;
    final expandedIcon = TNonAnimatedExpandIcon(
      isExpanded: isExpanded,
      color: iconColor,
      padding: child.expandIconTextBuilder != null
          ? EdgeInsetsDirectional.only(
              end: context.tTheme.spacer16,
              top: context.tTheme.spacer16,
              bottom: context.tTheme.spacer16,
            )
          : EdgeInsets.all(context.tTheme.spacer16),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (child.expandIconTextBuilder != null)
          Text(
            child.expandIconTextBuilder!(context, isExpanded),
            textAlign: TextAlign.end,
            style: TextStyle(color: iconColor),
          ),
        expandedIcon,
      ],
    );
  }

  TextStyle _headerTextStyle(BuildContext context, TCollapseThemeData? theme) {
    final font = context.tTheme.fontBodyLarge;
    final tokenStyle = TextStyle(
      color: context.tTheme.textColorPrimary,
      fontSize: font?.size ?? 16,
      height: font?.height ?? 1.5,
      fontWeight: font?.fontWeight ?? FontWeight.w400,
    );
    final materialStyle = ListTileTheme.of(context).titleTextStyle ??
        Theme.of(context).textTheme.titleMedium;
    return tokenStyle.merge(materialStyle).merge(theme?.headerTextStyle);
  }

  TextStyle _disabledHeaderTextStyle(
      BuildContext context, TCollapseThemeData? theme) {
    return _headerTextStyle(context, theme)
        .copyWith(color: context.tTheme.textDisabledColor)
        .merge(theme?.disabledHeaderTextStyle);
  }

  TextStyle _contentTextStyle(BuildContext context, TCollapseThemeData? theme) {
    final font = context.tTheme.fontBodyMedium;
    final tokenStyle = TextStyle(
      color: context.tTheme.textColorPrimary,
      fontSize: font?.size ?? 14,
      height: font?.height ?? 1.5,
      fontWeight: font?.fontWeight ?? FontWeight.w400,
    );
    return tokenStyle
        .merge(Theme.of(context).textTheme.bodyMedium)
        .merge(DefaultTextStyle.of(context).style)
        .merge(theme?.contentTextStyle);
  }

  Color _dividerColor(BuildContext context, TCollapseThemeData? theme) {
    return theme?.dividerColor ??
        DividerTheme.of(context).color ??
        context.tTheme.componentStrokeColor;
  }

  bool _allPanelsHaveValue() {
    return widget.children.every((TCollapsePanel<T> child) {
      return child.value != null;
    });
  }

  bool _allPanelsHaveDistinctValues() {
    final valueSet = <T?>{};
    return widget.children.every((TCollapsePanel<T> child) {
      if (!valueSet.add(child.value)) {
        return false;
      }
      return true;
    });
  }
}
