/*
 * Created by dorayhong@tencent.com on 6/4/23.
 */

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_collapse_panel.dart';
import 't_collapse_salted_key.dart';
import 't_collapse_theme_data.dart';
import 't_collapse_types.dart';
import 't_inset_divider.dart';
import 't_nonanimated_expand_icon.dart';

/// 折叠面板列表组件，需配合 [TCollapsePanel] 使用
class TCollapse<T extends Object> extends StatefulWidget {
  const TCollapse({
    required this.children,
    this.mode = TCollapseMode.multiple,
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
    return theme?.variant == TCollapseVariant.card;
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
    final items = <MergeableMaterialItem>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) &&
          index != 0 &&
          !_isChildExpanded(index - 1)) {
        items.add(_buildGap(context, index * 2 - 1));
      }

      final isLastChild = index == widget.children.length - 1;
      final child = widget.children[index];

      final titleWidget = _buildTitleWidget(context, child, index);
      final expandIconWidget = _buildExpandIconWidget(context, child, index);

      final borderRadius =
          _isCardStyle(context) ? _createRadius(index) : BorderRadius.zero;

      final bgColor = child.backgroundColor ??
          theme?.backgroundColor ??
          context.tTheme.bgColorContainer;

      items.add(
        MaterialSlice(
            key: TCollapseSaltedKey<BuildContext, int>(context, index * 2),
            color: bgColor,
            child: Column(
              key: TCollapseSaltedKey<BuildContext, int>(context, index * 2),
              children: [
                MergeSemantics(
                  child: InkWell(
                    borderRadius: borderRadius,
                    onTap: () => _handlePressed(index, _isChildExpanded(index)),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: animationDuration,
                            curve: Curves.fastOutSlowIn,
                            margin: EdgeInsets.zero,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: kMinInteractiveDimension,
                              ),
                              child: titleWidget,
                            ),
                          ),
                        ),
                        expandIconWidget,
                      ],
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: Container(height: 0.0),
                  secondChild: Column(
                    children: [
                      const TInsetDivider(),
                      Container(
                        padding: EdgeInsets.all(context.tTheme.spacer16),
                        child: child.body,
                      ),
                    ],
                  ),
                  firstCurve:
                      const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                  secondCurve:
                      const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                  sizeCurve: Curves.fastOutSlowIn,
                  crossFadeState: _isChildExpanded(index)
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: animationDuration,
                ),
                if (!isLastChild) const TInsetDivider()
              ],
            )),
      );

      if (_isChildExpanded(index) && !isLastChild) {
        items.add(_buildGap(context, index * 2 + 1));
      }
    }

    Widget collapse = MergeableMaterial(
      hasDividers: false,
      elevation: elevation,
      children: items,
    );

    if (_isCardStyle(context)) {
      collapse = Container(
        child: ClipRRect(
          child: collapse,
          borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: context.tTheme.spacer16,
        ),
      );
    }

    return collapse;
  }

  MergeableMaterialItem _buildGap(BuildContext context, int value) {
    return MaterialGap(
      size: 0.0,
      key: TCollapseSaltedKey<BuildContext, int>(context, value),
    );
  }

  BorderRadius _createRadius(int index) {
    final radius = Radius.circular(context.tTheme.radiusLarge);

    final isFirst = index == 0;
    if (isFirst) {
      return BorderRadius.only(topLeft: radius, topRight: radius);
    }

    final isLast = index == widget.children.length - 1;
    if (isLast) {
      return BorderRadius.only(bottomLeft: radius, bottomRight: radius);
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

  Widget _buildTitleWidget(
      BuildContext context, TCollapsePanel<T> child, int index) {
    final titleWidget = child.headerBuilder(context, _isChildExpanded(index));
    return ListTile(
      title: titleWidget,
    );
  }

  Widget _buildExpandIconWidget(
      BuildContext context, TCollapsePanel<T> child, int index) {
    Widget expandedIcon = Container(
      key: TCollapseSaltedKey<BuildContext, int>(context, index * 2),
      margin: const EdgeInsetsDirectional.all(0.0),
      child: TNonAnimatedExpandIcon(
        isExpanded: _isChildExpanded(index),
        padding: child.expandIconTextBuilder != null
            ? EdgeInsets.only(
                right: context.tTheme.spacer16,
                top: context.tTheme.spacer16,
                bottom: context.tTheme.spacer16,
                left: 0,
              )
            : EdgeInsets.all(context.tTheme.spacer16),
      ),
    );

    return Row(
      children: [
        if (child.expandIconTextBuilder != null)
          Text(child.expandIconTextBuilder!(context, _isChildExpanded(index)),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: context.tTheme.textColorPlaceholder,
              )),
        expandedIcon,
      ],
    );
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
