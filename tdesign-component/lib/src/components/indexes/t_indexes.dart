import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/iterable_ext.dart';
import 'sticky_header/sticky_header_widget.dart';
import 't_indexes_anchor.dart';
import 't_indexes_list.dart';
import 't_indexes_theme_data.dart';

export 'sticky_header/sticky_header_widget.dart';
export 't_indexes_anchor.dart';
export 't_indexes_list.dart';

/// 索引
class TIndexes extends StatefulWidget {
  const TIndexes({
    Key? key,
    this.indexList,
    this.initialIndex,
    this.indexListMaxHeight,
    this.sticky = true,
    this.stickyOffset = 0,
    this.capsuleTheme = false,
    this.reverse = false,
    this.scrollController,
    this.onChanged,
    this.onSelect,
    required this.builderContent,
    this.builderAnchor,
    this.builderIndex,
  }) : assert(
         indexListMaxHeight == null ||
             indexListMaxHeight > 0 && indexListMaxHeight <= 1,
         'indexListMaxHeight must be greater than 0 and no greater than 1.',
       ),
       super(key: key);

  /// 索引字符列表。不传默认 A-Z；默认值要求 [builderContent] 能处理 A-Z 全部索引，自定义数据建议显式传入
  final List<String>? indexList;

  /// 初始激活索引。为空时使用 [indexList] 的第一项
  ///
  /// 仅在组件首次创建时生效；后续活动索引由滚动位置派生。
  final String? initialIndex;

  /// 索引列表最大高度（父容器高度的百分比，默认 0.8）
  final double? indexListMaxHeight;

  /// 锚点是否吸顶
  final bool sticky;

  /// 锚点吸顶时与顶部的距离
  final double stickyOffset;

  /// 锚点是否为胶囊式样式
  final bool capsuleTheme;

  /// 是否反向滚动
  final bool reverse;

  /// 滚动控制器
  final ScrollController? scrollController;

  /// 索引发生变更时触发事件
  final void Function(String index)? onChanged;

  /// 点击侧边栏时触发事件
  final void Function(String index)? onSelect;

  /// 内容自定义构建
  final Widget? Function(BuildContext context, String index) builderContent;

  /// 锚点自定义构建
  final Widget? Function(
    BuildContext context,
    String index,
    bool isPinnedToTop,
  )?
  builderAnchor;

  /// 索引文本自定义构建，包括索引激活左侧提示
  final Widget Function(BuildContext context, String index, bool isActive)?
  builderIndex;

  @override
  _TIndexesState createState() => _TIndexesState();
}

class _TIndexesState extends State<TIndexes> {
  late List<String> _indexList;
  late ValueNotifier<String> _activeIndex;
  late ScrollController _scrollController;
  var _ownsScrollController = false;
  final _anchorKeys = <String, BuildContext>{};
  final _contentKeys = <String, BuildContext>{};
  var _isAnimating = false;
  var _scrollTaskId = 0;

  /// A-Z 字母字符列表
  static final List<String> _defaultAZList = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );

  /// 从 ThemeData 解析有效值
  TIndexesThemeData _resolveTheme() {
    return Theme.of(context).extension<TIndexesThemeData>() ??
        const TIndexesThemeData();
  }

  /// 统一的索引变更回调
  void _notifyChange(String index) {
    widget.onChanged?.call(index);
  }

  void _setScrollController(ScrollController? controller) {
    _ownsScrollController = controller == null;
    _scrollController = controller ?? ScrollController();
  }

  @override
  void initState() {
    super.initState();
    _indexList = widget.indexList ?? _defaultAZList;
    assert(
      _indexList.toSet().length == _indexList.length,
      'indexList values must be unique.',
    );
    assert(
      widget.initialIndex == null || _indexList.contains(widget.initialIndex),
      'initialIndex must be included in indexList.',
    );
    final firstIndex = _indexList.getOrNull(0) ?? '';
    _activeIndex = ValueNotifier(widget.initialIndex ?? firstIndex);
    _setScrollController(widget.scrollController);
    if (_activeIndex.value != firstIndex) {
      _isAnimating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollToTarget(_activeIndex.value, firstIndex);
        }
      });
    }
  }

  @override
  void didUpdateWidget(TIndexes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indexList != oldWidget.indexList) {
      _indexList = widget.indexList ?? _defaultAZList;
      assert(
        _indexList.toSet().length == _indexList.length,
        'indexList values must be unique.',
      );
      assert(
        widget.initialIndex == null || _indexList.contains(widget.initialIndex),
        'initialIndex must be included in indexList.',
      );
      final oldActiveIndex = _activeIndex;
      _activeIndex = ValueNotifier(
        _indexList.contains(oldActiveIndex.value)
            ? oldActiveIndex.value
            : widget.initialIndex ?? _indexList.getOrNull(0) ?? '',
      );
      oldActiveIndex.dispose();
    }
    if (widget.scrollController != oldWidget.scrollController) {
      if (_ownsScrollController) {
        _scrollController.dispose();
      }
      _setScrollController(widget.scrollController);
    }
  }

  @override
  void dispose() {
    _scrollTaskId++;
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    _activeIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme();
    return Container(
      color: context.tTheme.bgColorContainer,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            reverse: widget.reverse,
            slivers: _slivers(),
          ),
          TIndexesList(
            indexList: _indexList,
            activeIndex: _activeIndex,
            onSelect: (newIndex, oldIndex) {
              widget.onSelect?.call(newIndex);
              _notifyChange(newIndex);
              _scrollToTarget(newIndex, oldIndex);
            },
            indexListMaxHeight:
                widget.indexListMaxHeight ?? theme.indexListMaxHeight ?? 0.8,
            builderIndex: widget.builderIndex,
          ),
        ],
      ),
    );
  }

  List<Widget> _slivers() {
    final capsuleTheme = widget.capsuleTheme;
    final stickyOffset = widget.stickyOffset;
    final sticky = widget.sticky;
    _anchorKeys.clear();
    _contentKeys.clear();
    return _indexList.map((e) {
      final isPinnedOffset = capsuleTheme && _activeIndex.value == e;
      return SliverStickyHeader.builder(
        sticky: sticky,
        pinnedOffset: isPinnedOffset
            ? context.tTheme.spacer8 + stickyOffset
            : stickyOffset,
        builder: (context, state) {
          _anchorKeys[e] = context;
          if (state.isPinned && _activeIndex.value != e && !_isAnimating) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              _activeIndex.value = e;
              _notifyChange(e);
            });
          }
          return TIndexesAnchor(
            text: e,
            capsuleTheme: capsuleTheme,
            activeIndex: _activeIndex,
            builderAnchor: widget.builderAnchor,
            sticky: sticky,
          );
        },
        sliver: SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              _contentKeys[e] = context;
              return Padding(
                padding: isPinnedOffset
                    ? EdgeInsets.only(top: context.tTheme.spacer8)
                    : EdgeInsets.zero,
                child: widget.builderContent(context, e),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  void _scrollToTarget(String newIndex, String oldIndex, [int? taskId]) {
    final currentTaskId = taskId ?? ++_scrollTaskId;
    _isAnimating = true;

    /// isUp: 是否（手指）向上滑动
    final isUp = _indexList.indexOf(newIndex) > _indexList.indexOf(oldIndex);
    if (isUp) {
      var index = oldIndex;
      final contentRenderBox =
          _contentKeys[index]?.findRenderObject() as RenderBox?;
      if (contentRenderBox != null) {
        final contentHeight = contentRenderBox.size.height;
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final targetOffset = contentRenderBox.localToGlobal(
          Offset(0, contentHeight),
          ancestor: context.findRenderObject(),
        );
        final scrollOffset = targetOffset.dy + _scrollController.offset;
        _scrollController.jumpTo(min(maxScrollExtent, scrollOffset));
      }
      index = _indexList[_indexList.indexOf(index) + 1];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || currentTaskId != _scrollTaskId) {
          return;
        }
        if (index != newIndex) {
          _scrollToTarget(newIndex, index, currentTaskId);
        } else {
          _isAnimating = false;
        }
      });
    } else {
      final anchorContext = _anchorKeys[newIndex];
      if (anchorContext != null) {
        Scrollable.ensureVisible(anchorContext).then((value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || currentTaskId != _scrollTaskId) {
              return;
            }
            _isAnimating = false;
          });
        });
      } else {
        _isAnimating = false; // coverage:ignore-line
      }
    }
  }
}
