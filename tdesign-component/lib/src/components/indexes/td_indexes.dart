import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';
import 'sticky_header/widgets/sliver_sticky_header.dart';
import 'td_indexes_anchor.dart';
import 'td_indexes_list.dart';

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
    this.scrollDuration = const Duration(milliseconds: 200),
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

  /// 滚动动画时长
  final Duration? scrollDuration;

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

  /// 索引文本自定义构建
  final Widget Function(BuildContext context, String index, bool isActive)? builderIndex;

  @override
  _TDIndexesState createState() => _TDIndexesState();
}

class _TDIndexesState extends State<TDIndexes> {
  late ScrollController scrollController;
  late List<String> indexList;
  late List<GlobalKey> anchorKeys;
  late ValueNotifier<String> activeIndex;
  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
    // scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    // scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TDIndexes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      // scrollController.removeListener(onScroll);
      scrollController.dispose();
      scrollController = widget.scrollController ?? ScrollController();
      // scrollController.addListener(onScroll);
    }
  }

  @override
  Widget build(BuildContext context) {
    indexList = widget.indexList ?? _azList();
    anchorKeys = indexList.map((e) => GlobalKey()).toList();
    activeIndex = ValueNotifier(indexList.getOrNull(0) ?? '');
    return Container(
      color: TDTheme.of(context).whiteColor1,
      child: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            reverse: widget.reverse ?? false,
            slivers: _slivers(),
          ),
          TDIndexesList(
            indexList: indexList,
            activeIndex: activeIndex,
            onSelect: (index) {
              widget.onSelect?.call(index);
              _scrollToTarget(index);
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
    return indexList
        .mapWidthIndex(
          (e, index) => SliverStickyHeader.builder(
            sticky: widget.sticky ?? true,
            pinnedOffset: capsuleTheme ? TDTheme.of(context).spacer8 + stickyOffset : stickyOffset,
            builder: (context, state) {
              if (state.isPinned && activeIndex.value != e) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  activeIndex.value = e;
                });
              }
              return TDIndexesAnchor(
                key: anchorKeys[index],
                text: e,
                capsuleTheme: capsuleTheme,
                isPinned: state.isPinned,
                builderAnchor: widget.builderAnchor,
                index: index,
                sticky: widget.sticky ?? true,
              );
            },
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
          ),
        )
        .toList();
  }

  List<String> _azList() {
    final azList = <String>[];
    for (var i = 65; i <= 90; i++) {
      azList.add(String.fromCharCode(i));
    }
    return azList;
  }

  void _scrollToTarget(String index) {
    final targetKey = anchorKeys[indexList.indexOf(index)];
    final renderBox = targetKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    scrollController.animateTo(
      position.dy + scrollController.offset,
      duration: widget.scrollDuration ?? const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  // void onScroll() {}
}
