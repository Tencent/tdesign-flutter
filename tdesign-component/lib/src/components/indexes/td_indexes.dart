import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';
import 'sticky_header/widgets/sliver_sticky_header.dart';
import 'td_indexes_anchor.dart';

/// 索引
class TDIndexes extends StatefulWidget {
  const TDIndexes({
    Key? key,
    this.indexList,
    this.indexListMaxHeight,
    this.indexKeySize = 20,
    this.sticky = true,
    this.stickyOffset = 0,
    this.capsuleTheme = false,
    this.reverse = false,
    this.onChange,
    this.onSelect,
    required this.builderContent,
    this.builderAnchor,
  }) : super(key: key);

  /// 索引字符列表。不传默认 A-Z
  final List<String>? indexList;

  /// 索引列表最大高度，默认屏幕高度的80%
  final double? indexListMaxHeight;

  /// 索引编码的尺寸
  final double? indexKeySize;

  /// 锚点是否吸顶
  final bool? sticky;

  /// 锚点吸顶时与顶部的距离
  final double? stickyOffset;

  /// 锚点是否为胶囊式样式
  final bool? capsuleTheme;

  /// 反方向滚动置顶
  final bool? reverse;

  /// 索引发生变更时触发事件
  final void Function(String index)? onChange;

  /// 点击侧边栏时触发事件
  final void Function(String index)? onSelect;

  /// 内容自定义构建
  final Widget? Function(BuildContext context, String index) builderContent;

  /// 锚点自定义构建
  final Widget? Function(BuildContext context, String index, bool isPinnedToTop)? builderAnchor;

  @override
  _TDIndexesState createState() => _TDIndexesState();
}

class _TDIndexesState extends State<TDIndexes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final indexList = widget.indexList ?? _azList();
    return Container(
      color: TDTheme.of(context).whiteColor1,
      child: Stack(
        children: [
          CustomScrollView(
            reverse: widget.reverse ?? false,
            slivers: _slivers(indexList),
          )
        ],
      ),
    );
  }

  List<Widget> _slivers(List<String> indexList) {
    final capsuleTheme = widget.capsuleTheme ?? false;
    return indexList
        .mapWidthIndex(
          (e, index) => SliverStickyHeader.builder(
            sticky: widget.sticky ?? true,
            pinnedOffset: capsuleTheme ? TDTheme.of(context).spacer8 : widget.stickyOffset ?? 0,
            builder: (context, state) => TDIndexesAnchor(
              text: e,
              capsuleTheme: capsuleTheme,
              isPinned: state.isPinned,
              builderAnchor: widget.builderAnchor,
              index: index,
              sticky: widget.sticky ?? true,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => widget.builderContent(context, e),
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
}

// Positioned(
//   right: TDTheme.of(context).spacer8,
//   top: 0,
//   bottom: 0,
//   child: Align(
//     alignment: Alignment.center,
//     child: ConstrainedBox(
//       constraints: BoxConstraints(maxHeight: widget.indexListMaxHeight ?? screenHeight * 0.8),
//       child: ListView.builder(
//         itemCount: indexList.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: widget.indexKeySize,
//             height: widget.indexKeySize,
//             // decoration: BoxDecoration(
//             //   borderRadius: BorderRadius.circular(TDTheme.of(context).radiusCircle),
//             //   color: TDTheme.of(context).brandColor7,
//             // ),
//             child: TDText(indexList[index]),
//           );
//         },
//       ),
//     ),
//   ),
// ),
