import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';

export 'sticky_header/widgets/sliver_sticky_header.dart';
export 'td_indexes_anchor.dart';
export 'td_indexes_list.dart';

/// 索引
class TDIndexes extends StatefulWidget {
  const TDIndexes({
    Key? key,
    this.indexList,
    this.indexListMaxHeight = 0.8,
    this.sticky = true,
    this.stickyOffset = 0,
    this.capsuleTheme = false,
    this.reverse = false,
    this.scrollController,
    this.onChange,
    this.onSelect,
    required this.builderContent,
    this.builderAnchor,
    this.builderIndex,
  }) : super(key: key);

  /// 索引字符列表。不传默认 A-Z
  final List<String>? indexList;

  /// 索引列表最大高度（父容器高度的百分比，默认0.8）
  final double? indexListMaxHeight;

  /// 锚点是否吸顶
  final bool? sticky;

  /// 锚点吸顶时与顶部的距离
  final double? stickyOffset;

  /// 锚点是否为胶囊式样式
  final bool? capsuleTheme;

  /// 反方向滚动置顶
  final bool? reverse;

  /// 滚动控制器
  final ScrollController? scrollController;

  /// 索引发生变更时触发事件
  final void Function(String index)? onChange;

  /// 点击侧边栏时触发事件
  final void Function(String index)? onSelect;

  /// 内容自定义构建
  final Widget? Function(BuildContext context, String index) builderContent;

  /// 锚点自定义构建
  final Widget? Function(BuildContext context, String index, bool isPinnedToTop)? builderAnchor;

  /// 索引文本自定义构建，包括索引激活左侧提示
  final Widget Function(BuildContext context, String index, bool isActive)? builderIndex;

  @override
  _TDIndexesState createState() => _TDIndexesState();
}

class _TDIndexesState extends State<TDIndexes> {
  late List<String> _indexList;
  late ValueNotifier<String> _activeIndex;
  final _anchorKeys = <String, BuildContext>{};
  final _contentKeys = <String, BuildContext>{};
  var _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _indexList = widget.indexList ?? _azList();
    _activeIndex = ValueNotifier(_indexList.getOrNull(0) ?? '');
  }

  @override
  void didUpdateWidget(TDIndexes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indexList != oldWidget.indexList) {
      _indexList = widget.indexList ?? _azList();
      _activeIndex = ValueNotifier(_indexList.getOrNull(0) ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      child: Stack(
        children: [
          CustomScrollView(
            controller: widget.scrollController,
            reverse: widget.reverse ?? false,
            slivers: _slivers(),
          ),
          TDIndexesList(
            indexList: _indexList,
            activeIndex: _activeIndex,
            onSelect: (index, isUp) {
              widget.onSelect?.call(index);
              widget.onChange?.call(index);
              _scrollToTarget(index, isUp);
            },
            indexListMaxHeight: widget.indexListMaxHeight ?? 0.8,
            builderIndex: widget.builderIndex,
          ),
        ],
      ),
    );
  }

  List<Widget> _slivers() {
    final capsuleTheme = widget.capsuleTheme ?? false;
    final stickyOffset = widget.stickyOffset ?? 0;
    _anchorKeys.clear();
    _contentKeys.clear();
    return _indexList.map((e) {
      return SliverStickyHeader.builder(
        sticky: widget.sticky ?? true,
        pinnedOffset: capsuleTheme ? TDTheme.of(context).spacer8 + stickyOffset : stickyOffset,
        builder: (context, state) {
          _anchorKeys[e] = context;
          if (state.isPinned && _activeIndex.value != e && !_isAnimating) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _activeIndex.value = e;
              widget.onChange?.call(e);
            });
          }
          return TDIndexesAnchor(
            text: e,
            capsuleTheme: capsuleTheme,
            activeIndex: _activeIndex,
            builderAnchor: widget.builderAnchor,
            sticky: widget.sticky ?? true,
          );
        },
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              _contentKeys[e] = context;
              final content = widget.builderContent(context, e);
              if (capsuleTheme) {
                return Padding(
                  padding: EdgeInsets.only(top: TDTheme.of(context).spacer8),
                  child: content,
                );
              }
              return content;
            },
            childCount: 1,
          ),
        ),
      );
    }).toList();
  }

  List<String> _azList() {
    final azList = <String>[];
    for (var i = 65; i <= 90; i++) {
      azList.add(String.fromCharCode(i));
    }
    return azList;
  }

  void _scrollToTarget(String index, bool isUp) {
    final targetContext = isUp ? _anchorKeys[index] : _contentKeys[index];
    if (targetContext == null) {
      return;
    }
    _isAnimating = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        targetContext,
      ).then((value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _isAnimating = false;
        });
      });
    });
  }
}
