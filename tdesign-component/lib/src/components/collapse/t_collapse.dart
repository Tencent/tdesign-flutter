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

/// 折叠面板列表组件，需配合 [TCollapsePanel] 使用
class TCollapse<T extends Object> extends StatefulWidget {
  const TCollapse({
    required this.children,
    required this.value,
    this.mode = TCollapseMode.multiple,
    this.variant,
    this.animationDuration,
    this.elevation,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  /// 折叠面板列表的子组件
  final List<TCollapsePanel<T>> children;

  /// 折叠面板模式
  final TCollapseMode mode;

  /// 折叠面板视觉形态。未设置时从 [TCollapseThemeData.variant] 读取。
  final TCollapseVariant? variant;

  /// 折叠面板列表的动画时长
  final Duration? animationDuration;

  /// 折叠面板列表的阴影
  final double? elevation;

  /// 当前展开面板的值列表，是所有模式唯一的展开状态源。
  ///
  /// 列表中的值必须唯一，并与唯一的 [TCollapsePanel.value] 匹配。
  /// [TCollapseMode.accordion] 模式最多允许一个值。
  final List<T> value;

  /// 展开值列表变更回调。
  ///
  /// 回调返回点击后的完整、不可修改列表。为 null 时整组不可交互，并使用禁用
  /// 视觉和语义；单项仍可通过 [TCollapsePanel.disabled] 禁用。
  final ValueChanged<List<T>>? onChanged;

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
    _debugAssertValidContract();
  }

  @override
  void didUpdateWidget(TCollapse<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _debugAssertValidContract();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final animationDuration =
        widget.animationDuration ??
        theme?.animationDuration ??
        kThemeAnimationDuration;
    final elevation = widget.elevation ?? theme?.elevation ?? 0;
    final panels = <Widget>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      final isLastChild = index == widget.children.length - 1;
      final child = widget.children[index];
      final isExpanded = widget.value.contains(child.value);
      final isDisabled = widget.onChanged == null || child.disabled;
      final isInteractive = !isDisabled;
      final cardBorderRadius =
          theme?.cardBorderRadius ??
          BorderRadius.circular(context.tTheme.radiusLarge);
      final borderRadius = _isCardStyle(context)
          ? _createRadius(index, cardBorderRadius)
          : BorderRadius.zero;
      final bgColor =
          child.backgroundColor ??
          theme?.backgroundColor ??
          context.tTheme.bgColorContainer;
      final panelKey = child.key ?? ValueKey<T>(child.value);
      final header = _buildHeader(
        context,
        child,
        isExpanded,
        isInteractive,
        isDisabled,
        animationDuration,
        borderRadius,
      );
      final body = _buildBody(
        context,
        child,
        isExpanded,
        animationDuration,
        theme,
      );

      panels.add(
        Material(
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
        ),
      );
    }

    final cardBorderRadius =
        theme?.cardBorderRadius ??
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
        padding:
            theme?.cardMargin ??
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

  void _handlePressed(TCollapsePanel<T> child, bool isExpanded) {
    final nextValue = isExpanded
        ? widget.value.where((value) => value != child.value).toList()
        : _isAccordion
        ? <T>[child.value]
        : <T>[...widget.value, child.value];
    widget.onChanged?.call(List<T>.unmodifiable(nextValue));
  }

  Widget _buildHeader(
    BuildContext context,
    TCollapsePanel<T> child,
    bool isExpanded,
    bool isInteractive,
    bool isDisabled,
    Duration animationDuration,
    BorderRadius borderRadius,
  ) {
    final titleWidget = _buildTitleWidget(
      context,
      child,
      isExpanded,
      isDisabled,
    );
    final trailingWidget = _buildTrailingWidget(
      context,
      child,
      isExpanded,
      isDisabled,
    );
    final expandIconWidget = _buildExpandIconWidget(
      context,
      child,
      isExpanded,
      isDisabled,
      hasTrailing: trailingWidget != null,
    );
    final onTap = isInteractive
        ? () => _handlePressed(child, isExpanded)
        : null;
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
                      minHeight: kMinInteractiveDimension,
                    ),
                    child: titleWidget,
                  ),
                ),
                if (trailingWidget != null) trailingWidget,
                if (expandIconWidget != null) expandIconWidget,
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
    Widget content = DefaultTextStyle(
      style: _contentTextStyle(context, theme),
      child: Padding(
        padding:
            theme?.contentPadding ?? EdgeInsets.all(context.tTheme.spacer16),
        child: child.body,
      ),
    );
    if (child.bodyHeight != null) {
      content = SizedBox(height: child.bodyHeight, child: content);
    }
    final divider = TInsetDivider(color: _dividerColor(context, theme));
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: child.placement == TCollapsePlacement.top
            ? [content, divider]
            : [divider, content],
      ),
      firstCurve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: animationDuration,
    );
  }

  Widget _buildTitleWidget(
    BuildContext context,
    TCollapsePanel<T> child,
    bool isExpanded,
    bool isDisabled,
  ) {
    final theme = _theme(context);
    final style = isDisabled
        ? _disabledHeaderTextStyle(context, theme)
        : _headerTextStyle(context, theme);
    final iconColor = isDisabled
        ? theme?.disabledIconColor ?? context.tTheme.textDisabledColor
        : theme?.iconColor ?? context.tTheme.textColorPlaceholder;
    return ListTile(
      leading: child.leadingBuilder == null
          ? null
          : IconTheme(
              data: IconThemeData(color: iconColor),
              child: child.leadingBuilder!(context, isExpanded),
            ),
      title: DefaultTextStyle(
        style: style,
        child: child.headerBuilder(context, isExpanded),
      ),
    );
  }

  Widget? _buildTrailingWidget(
    BuildContext context,
    TCollapsePanel<T> child,
    bool isExpanded,
    bool isDisabled,
  ) {
    final builder = child.trailingBuilder;
    if (builder == null) {
      return null;
    }
    final theme = _theme(context);
    final color = isDisabled
        ? theme?.disabledIconColor ?? context.tTheme.textDisabledColor
        : theme?.iconColor ?? context.tTheme.textColorPlaceholder;
    return DefaultTextStyle(
      style: _contentTextStyle(context, theme).copyWith(color: color),
      child: IconTheme(
        data: IconThemeData(color: color),
        child: builder(context, isExpanded),
      ),
    );
  }

  Widget? _buildExpandIconWidget(
    BuildContext context,
    TCollapsePanel<T> child,
    bool isExpanded,
    bool isDisabled, {
    required bool hasTrailing,
  }) {
    final builder = child.expandIconBuilder;
    if (builder == null) {
      if (!hasTrailing) {
        return null;
      }
      return SizedBox(width: context.tTheme.spacer16);
    }
    final theme = _theme(context);
    final iconColor = isDisabled
        ? theme?.disabledIconColor ?? context.tTheme.textDisabledColor
        : theme?.iconColor ?? context.tTheme.textColorPlaceholder;
    return Padding(
      padding: hasTrailing
          ? EdgeInsetsDirectional.only(
              end: context.tTheme.spacer16,
              top: context.tTheme.spacer16,
              bottom: context.tTheme.spacer16,
            )
          : EdgeInsets.all(context.tTheme.spacer16),
      child: IconTheme(
        data: IconThemeData(color: iconColor, size: 24),
        child: builder(context, isExpanded),
      ),
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
    final materialStyle =
        ListTileTheme.of(context).titleTextStyle ??
        Theme.of(context).tExplicitTextTheme?.titleMedium;
    return tokenStyle.merge(materialStyle).merge(theme?.headerTextStyle);
  }

  TextStyle _disabledHeaderTextStyle(
    BuildContext context,
    TCollapseThemeData? theme,
  ) {
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
        .merge(Theme.of(context).tExplicitTextTheme?.bodyMedium)
        .merge(context.tExplicitDefaultTextStyle)
        .merge(theme?.contentTextStyle);
  }

  Color _dividerColor(BuildContext context, TCollapseThemeData? theme) {
    return theme?.dividerColor ??
        DividerTheme.of(context).color ??
        context.tTheme.componentStrokeColor;
  }

  void _debugAssertValidContract() {
    assert(
      widget.children.map((child) => child.value).toSet().length ==
          widget.children.length,
      'Every TCollapsePanel must have a distinct value.',
    );
    assert(
      widget.value.toSet().length == widget.value.length,
      'TCollapse.value must not contain duplicate values.',
    );
    assert(
      widget.value.every(
        (value) => widget.children.any((child) => child.value == value),
      ),
      'Every value in TCollapse.value must match a TCollapsePanel.value.',
    );
    assert(
      !_isAccordion || widget.value.length <= 1,
      'TCollapseMode.accordion allows at most one expanded value.',
    );
  }
}
