import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'picker_item.dart';
import 'picker_option.dart';
import 'wheel_behavior.dart';

/// 滚轮透视比例（越大越平）。
const double kWheelDiameterRatio = 3;

/// disabled 项修正动画 - 距离 ≤ 2 时的时长
const int kCorrectAnimShortMs = 200;

/// disabled 项修正动画 - 距离 > 2 时的时长
const int kCorrectAnimLongMs = 350;

/// 距离阈值：≤ 2 使用短动画，> 2 使用长动画
const int kCorrectAnimDistanceThreshold = 2;

/// 单列滚轮（独立 [State]，数据变化时只重建本列）。
///
/// 包含禁用项自动修正动画：当滚动结束时停留在 disabled 项上，
/// 会自动动画滚动到最近的 enabled 项，并通过 [onAnimationComplete] 回调通知。
class WheelColumn extends StatefulWidget {
  const WheelColumn({
    required super.key,
    required this.colIndex,
    required this.options,
    required this.controller,
    required this.itemHeight,
    required this.disabled,
    required this.onItemSelected,
    this.scrollBehavior,
    this.itemBuilder,
    this.onScrollEnd,
    this.onAnimationComplete,
  });

  final int colIndex;
  final List<PickerOption> options;
  final FixedExtentScrollController controller;
  final double itemHeight;
  final bool disabled;
  final ScrollBehavior? scrollBehavior;
  final ItemBuilderType? itemBuilder;
  final void Function(int col, int index, List<PickerOption> data)
      onItemSelected;
  final bool Function(
    ScrollNotification notification,
    int col,
    List<PickerOption> data,
  )? onScrollEnd;

  /// 禁用项修正动画完成时触发
  final void Function(int col, int index, List<PickerOption> data)?
      onAnimationComplete;

  @override
  State<WheelColumn> createState() => WheelColumnState();
}

class WheelColumnState extends State<WheelColumn> {
  static final _defaultScrollBehavior = WheelBehavior();

  late List<PickerOption> _options;
  late FixedExtentScrollController _controller;

  /// 标记是否正在动画修正中，防止重复触发
  bool _isAnimating = false;

  ScrollBehavior get _scrollBehavior =>
      widget.scrollBehavior ?? _defaultScrollBehavior;

  /// 是否正在动画修正中
  bool get isAnimating => _isAnimating;

  @override
  void initState() {
    super.initState();
    _options = widget.options;
    _controller = widget.controller;
  }

  @override
  void didUpdateWidget(WheelColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(oldWidget.options, widget.options) &&
        oldWidget.controller == widget.controller) {
      return;
    }
    applyColumnUpdate(
      options: widget.options,
      controller: widget.controller,
    );
  }

  /// 命令式刷新本列 options / controller，不重建其它列。
  void applyColumnUpdate({
    required List<PickerOption> options,
    required FixedExtentScrollController controller,
  }) {
    if (listEquals(_options, options) && _controller == controller) {
      return;
    }
    final previousController = _controller;
    setState(() {
      _options = options;
      _controller = controller;
    });
    if (!identical(previousController, controller)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!identical(_controller, previousController)) {
          previousController.dispose();
        }
      });
    }
  }

  /// 命令式触发动画修正到最近 enabled 项
  void animateToNearestEnabled() {
    if (_options.isEmpty || _isAnimating) {
      return;
    }
    final currentIndex = _controller.selectedItem;
    if (currentIndex < 0 ||
        currentIndex >= _options.length ||
        !_options[currentIndex].disabled) {
      return;
    }
    _animateToNearestEnabled(currentIndex);
  }

  /// 从 [start] 出发双向搜索最近一个 enabled 索引，全 disabled 时返回 -1
  ///
  /// 双向同时推进，先命中者胜出；若同距离，偏向前向。
  static int nearestEnabledIndex(List<PickerOption> data, int start) {
    for (var step = 1; step < data.length; step++) {
      final forward = start + step;
      if (forward < data.length && !data[forward].disabled) {
        return forward;
      }
      final backward = start - step;
      if (backward >= 0 && !data[backward].disabled) {
        return backward;
      }
    }
    return -1;
  }

  void _animateToNearestEnabled(int currentIndex) {
    if (!mounted || _options.isEmpty) {
      return;
    }
    final target = nearestEnabledIndex(_options, currentIndex);
    if (target < 0 || target == currentIndex) {
      return;
    }

    if (!_isAnimating) {
      _isAnimating = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isAnimating) {
        return;
      }
      final c = _controller;
      final newIndex = c.selectedItem;
      // 动画调度到这一帧前，用户可能已经手动滚到 enabled 项了
      if (newIndex >= 0 &&
          newIndex < _options.length &&
          !_options[newIndex].disabled) {
        _isAnimating = false;
        return;
      }

      final distance = (target - newIndex).abs();
      final ms = distance <= kCorrectAnimDistanceThreshold
          ? kCorrectAnimShortMs
          : kCorrectAnimLongMs;
      c
          .animateToItem(
        target,
        duration: Duration(milliseconds: ms),
        curve: Curves.easeOutCubic,
      )
          .then((_) {
        if (mounted) {
          _isAnimating = false;
          widget.onAnimationComplete?.call(widget.colIndex, target, _options);
        }
      }).catchError((Object e, StackTrace stack) {
        debugPrint('WheelColumn animation interrupted: $e');
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_options.isEmpty) {
      return const SizedBox.shrink();
    }

    final wheel = ListWheelScrollView.useDelegate(
      key: ValueKey<int>(_options.length),
      itemExtent: widget.itemHeight,
      diameterRatio: kWheelDiameterRatio,
      controller: _controller,
      physics: widget.disabled
          ? const NeverScrollableScrollPhysics()
          : const FixedExtentScrollPhysics(),
      onSelectedItemChanged: widget.disabled
          ? null
          : (index) => widget.onItemSelected(widget.colIndex, index, _options),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: _options.length,
        builder: (_, index) => PickerItemWidget(
          content: _options[index].label,
          fixedExtentScrollController: _controller,
          colIndex: widget.colIndex,
          index: index,
          itemHeight: widget.itemHeight,
          disabled: _options[index].disabled,
          itemBuilder: widget.itemBuilder,
        ),
      ),
    );

    final onScrollEnd = widget.onScrollEnd;
    final scrollChild = onScrollEnd == null
        ? wheel
        : NotificationListener<ScrollNotification>(
            onNotification: (notification) =>
                onScrollEnd(notification, widget.colIndex, _options),
            child: wheel,
          );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: _scrollBehavior,
        child: scrollChild,
      ),
    );
  }
}
