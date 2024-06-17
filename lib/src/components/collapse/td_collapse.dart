/*
 * Created by dorayhong@tencent.com on 6/4/23.
 */

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import 'td_collapse_panel_body.dart';
import 'td_collapse_panel_header.dart';
import 'td_collapse_salted_key.dart';
import 'td_inset_divider.dart';

/// 折叠面板的组件样式
enum TDCollapseStyle {
  /// Block 通栏风格
  block,

  /// Card 卡片风格
  card
}

/// 折叠面板列表组件，需配合 [TDCollapsePanel] 使用
class TDCollapse extends StatefulWidget {
  const TDCollapse({
    required this.children,
    this.style = TDCollapseStyle.block,
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.elevation = 0,
    Key? key,
  })  : _allowOnlyOnePanelOpen = false,
        initialOpenPanelValue = null,
        super(key: key);

  const TDCollapse.accordion({
    required this.children,
    this.style = TDCollapseStyle.block,
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.elevation = 0,
    this.initialOpenPanelValue,
    Key? key,
  })  : _allowOnlyOnePanelOpen = true,
        super(key: key);

  /// 折叠面板列表的样式
  /// - [TDCollapseStyle.block] 通栏风格
  /// - [TDCollapseStyle.card] 卡片风格
  final TDCollapseStyle style;

  /// 折叠面板列表的子组件
  final List<TDCollapsePanel> children;

  /// 折叠面板列表的回调函数；
  /// 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded
  final ExpansionPanelCallback? expansionCallback;

  /// 折叠面板列表的动画时长
  final Duration animationDuration;

  /// 折叠面板列表的阴影
  final double elevation;

  /// 折叠面板列表的默认展开面板的值；
  /// 当使用 [TDCollapse.accordion] 时，此值生效
  final Object? initialOpenPanelValue;

  final bool _allowOnlyOnePanelOpen;

  @override
  State createState() => _TDCollapseState();
}

class _TDCollapseState extends State<TDCollapse> {
  TDCollapsePanel? _currentOpenPanel;

  @override
  void initState() {
    super.initState();

    if (!widget._allowOnlyOnePanelOpen) {
      return;
    }

    assert(_allPanelsHaveValue(),
        'When allowing only one panel to be open, every panel must have a value.');
    assert(_allPanelsHaveDistinctValues(),
        'When allowing only one panel to be open, every panel must have a distinct value.');

    if (widget.initialOpenPanelValue != null) {
      _currentOpenPanel = _searchPanelByValue(widget.initialOpenPanelValue);
    }
  }

  @override
  void didUpdateWidget(TDCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget._allowOnlyOnePanelOpen) {
      _currentOpenPanel = null;
      return;
    }

    assert(_allPanelsHaveValue(),
        'When allowing only one panel to be open, every panel must have a value.');
    assert(_allPanelsHaveDistinctValues(),
        'When allowing only one panel to be open, every panel must have a distinct value.');

    // when the widget is updated to accordion mode
    // we need to initialize the current open panel to defaultOpenPanelValue
    if (!oldWidget._allowOnlyOnePanelOpen) {
      _currentOpenPanel = _searchPanelByValue(widget.initialOpenPanelValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <MergeableMaterialItem>[];

    for (var index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) &&
          index != 0 &&
          !_isChildExpanded(index - 1)) {
        items.add(_buildGap(context, index * 2 - 1));
      }

      final isLastChild = index == widget.children.length - 1;
      final child = widget.children[index];

      final borderRadius =
          _isCardStyle() ? _createRadius(index) : BorderRadius.zero;

      final sliceKey =
          TDCollapseSaltedKey<BuildContext, int>(context, index * 2);

      items.add(
        MaterialSlice(
          key: sliceKey,
          color: child.backgroundColor,
          child: Column(
            key:
                sliceKey, // to prevent collapse state change when parent rebuild
            children: [
              TDCollapsePanelHeader(
                index: index,
                animationDuration: widget.animationDuration,
                borderRadius: borderRadius,
                headerBuilder: child.headerBuilder,
                expandIconTextBuilder: child.expandIconTextBuilder,
                isExpanded: _isChildExpanded(index),
                onPress: _handlePressed,
              ),
              TDCollapsePanelBody(
                animationDuration: widget.animationDuration,
                body: child.body,
                isExpanded: _isChildExpanded(index),
              ),
              if (!isLastChild) const TDInsetDivider()
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && !isLastChild) {
        items.add(_buildGap(context, index * 2 + 1));
      }
    }

    Widget collapse = MergeableMaterial(
      hasDividers: false,
      elevation: widget.elevation,
      children: items,
    );

    if (_isCardStyle()) {
      collapse = Container(
        child: ClipRRect(
          child: collapse,
          borderRadius: BorderRadius.circular(TDTheme.of(context).radiusLarge),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: TDTheme.of(context).spacer16,
        ),
      );
    }

    return collapse;
  }

  MergeableMaterialItem _buildGap(BuildContext context, int value) {
    return MaterialGap(
      size: 0.0,
      key: TDCollapseSaltedKey<BuildContext, int>(context, value),
    );
  }

  BorderRadius _createRadius(int index) {
    final radius = Radius.circular(TDTheme.of(context).radiusLarge);

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

  bool _isCardStyle() {
    return widget.style == TDCollapseStyle.card;
  }

  bool _isChildExpanded(int index) {
    final child = widget.children[index];

    if (widget._allowOnlyOnePanelOpen) {
      return _currentOpenPanel?.value == child.value;
    }

    return child.isExpanded;
  }

  void _handlePressed(int index, bool isExpanded) {
    widget.expansionCallback?.call(index, isExpanded);

    if (!widget._allowOnlyOnePanelOpen) {
      return;
    }

    // collapse the current open panel by calling its expansion callback to false
    for (var childIndex = 0;
        childIndex < widget.children.length;
        childIndex += 1) {
      final curChild = widget.children[childIndex];
      if (widget.expansionCallback != null &&
          childIndex != index &&
          curChild.value == _currentOpenPanel?.value) {
        widget.expansionCallback!(childIndex, false);
      }
    }

    setState(() {
      _currentOpenPanel = isExpanded ? null : widget.children[index];
    });
  }

  bool _allPanelsHaveValue() {
    return widget.children.every((TDCollapsePanel child) {
      return child.value != null;
    });
  }

  bool _allPanelsHaveDistinctValues() {
    final valueSet = <Object?>{};
    return widget.children.every((TDCollapsePanel child) {
      if (!valueSet.add(child.value)) {
        return false;
      }
      return true;
    });
  }

  TDCollapsePanel? _searchPanelByValue(Object? value) {
    for (var index = 0; index < widget.children.length; index += 1) {
      final child = widget.children[index];
      if (child.value == value) {
        return child;
      }
    }
    return null;
  }
}
