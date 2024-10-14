import 'dart:math';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';

export 'sticky_header/sticky_header_widget.dart';
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
  late ScrollController _scrollController;
  final _anchorKeys = <String, BuildContext>{};
  final _contentKeys = <String, BuildContext>{};
  var _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _indexList = widget.indexList ?? _azList();
    _activeIndex = ValueNotifier(_indexList.getOrNull(0) ?? '');
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void didUpdateWidget(TDIndexes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indexList != oldWidget.indexList) {
      _indexList = widget.indexList ?? _azList();
      _activeIndex = ValueNotifier(_indexList.getOrNull(0) ?? '');
    }
    if (widget.scrollController != oldWidget.scrollController) {
      _scrollController.dispose();
      _scrollController = widget.scrollController ?? ScrollController();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            reverse: widget.reverse ?? false,
            slivers: _slivers(),
          ),
          TDIndexesList(
            indexList: _indexList,
            activeIndex: _activeIndex,
            onSelect: (newIndex, oldIndex) {
              widget.onSelect?.call(newIndex);
              widget.onChange?.call(newIndex);
              _scrollToTarget(newIndex, oldIndex);
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
      final isPinnedOffset = capsuleTheme && _activeIndex.value == e;
      return SliverStickyHeader.builder(
        sticky: widget.sticky ?? true,
        pinnedOffset: isPinnedOffset ? TDTheme.of(context).spacer8 + stickyOffset : stickyOffset,
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
        sliver: SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              _contentKeys[e] = context;
              return Padding(
                padding: isPinnedOffset ? EdgeInsets.only(top: TDTheme.of(context).spacer8) : EdgeInsets.zero,
                child: widget.builderContent(context, e),
              );
            },
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

  void _scrollToTarget(String newIndex, String oldIndex) {
    _isAnimating = true;

    /// isUp: 是否（手指）向上滑动
    final isUp = _indexList.indexOf(newIndex) > _indexList.indexOf(oldIndex);
    if (isUp) {
      var index = oldIndex;
      final contentRenderBox = _contentKeys[index]?.findRenderObject() as RenderBox?;
      if (contentRenderBox != null) {
        final contentHeight = contentRenderBox.size.height;
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final targetOffset =
            contentRenderBox.localToGlobal(Offset(0, contentHeight), ancestor: context.findRenderObject());
        final scrollOffset = targetOffset.dy + _scrollController.offset;
        _scrollController.jumpTo(min(maxScrollExtent, scrollOffset));
      }
      index = _indexList[_indexList.indexOf(index) + 1];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (index != newIndex) {
          _scrollToTarget(newIndex, index);
        } else {
          _isAnimating = false;
        }
      });
    } else {
      final anchorContext = _anchorKeys[newIndex];
      if (anchorContext != null) {
        Scrollable.ensureVisible(anchorContext).then((value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _isAnimating = false;
          });
        });
      }
    }
  }
}
