import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'picker_item.dart';
import 'picker_option.dart';
import 'wheel_behavior.dart';

/// 滚轮透视比例（越大越平）。
@internal
const double kWheelDiameterRatio = 3;

/// disabled 项修正动画 - 距离 ≤ 2 时的时长
@internal
const int kCorrectAnimShortMs = 200;

/// disabled 项修正动画 - 距离 > 2 时的时长
@internal
const int kCorrectAnimLongMs = 350;

/// 距离阈值：≤ 2 使用短动画，> 2 使用长动画
@internal
const int kCorrectAnimDistanceThreshold = 2;

/// 单列滚轮（独立 [State]，数据变化时只重建本列）。
///
/// 包含禁用项自动修正动画：当滚动结束时停留在 disabled 项上，
/// 会自动动画滚动到最近的 enabled 项，并通过 [onAnimationComplete] 回调通知。
/// `onSelectedItemChanged` 与 `onAnimationComplete` 在物理落点修正时可能同 index
/// 重复触发，本 Widget 用 `_lastNotifiedIndex` 在 `onAnimationComplete` 路径上
/// dedup（H2 修复），保证 `onChange` 不会被业务收到两次。
@internal
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
  final List<TPickerOption> options;
  final FixedExtentScrollController controller;
  final double itemHeight;
  final bool disabled;
  final ScrollBehavior? scrollBehavior;
  final ItemBuilderType? itemBuilder;
  final void Function(int col, int index, List<TPickerOption> data)
      onItemSelected;
  final bool Function(
    ScrollNotification notification,
    int col,
    List<TPickerOption> data,
  )? onScrollEnd;

  /// 禁用项修正动画完成时触发（仅在 `onSelectedItemChanged` 未先行通知时调
  /// 用，dedup 见 `_animateToNearestEnabled`）
  final void Function(int col, int index, List<TPickerOption> data)?
      onAnimationComplete;

  @override
  State<WheelColumn> createState() => WheelColumnState();
}

@internal
class WheelColumnState extends State<WheelColumn> {
  static final _defaultScrollBehavior = WheelBehavior();

  late List<TPickerOption> _options;
  late FixedExtentScrollController _controller;

  /// 标记是否正在动画修正中，防止重复触发
  bool _isAnimating = false;

  /// 最近一次经 `onSelectedItemChanged` 通知过的 index；用于
  /// `_animateToNearestEnabled` 的 `.then` 去重（H2 修复）。
  int? _lastNotifiedIndex;

  ScrollBehavior get _scrollBehavior =>
      widget.scrollBehavior ?? _defaultScrollBehavior;

  /// 是否正在动画修正中
  bool get isAnimating => _isAnimating;

  /// 防御性读取当前选中项索引。
  ///
  /// `FixedExtentScrollController.selectedItem` 在列首次 build 完成前不可用
  /// （`positions` 尚未填充），此时会抛断言。本方法封装回退：在 ListView 尚未挂载
  /// 的第一帧返回 0（与 `FixedExtentScrollController(initialItem: 0)` 行为一致），
  /// 不抛错，专供外层 build 阶段（如无障碍文案预览）调用。
  int get currentSelectedIndex {
    if (_options.isEmpty) {
      return 0;
    }
    if (!_controller.hasClients) {
      return 0;
    }
    final idx = _controller.selectedItem;
    if (idx < 0 || idx >= _options.length) {
      return 0;
    }
    return idx;
  }

  @override
  void initState() {
    super.initState();
    _options = widget.options;
    _controller = widget.controller;
  }

  @override
  void didUpdateWidget(WheelColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 与 oldWidget.options 比 ref 无法发现外部原地 addAll；以 State 内 _options 为准
    if (listEquals(_options, widget.options) &&
        _controller == widget.controller) {
      return;
    }
    applyColumnUpdate(
      options: widget.options,
      controller: widget.controller,
    );
  }

  /// 命令式刷新本列 options / controller，不重建其它列。
  void applyColumnUpdate({
    required List<TPickerOption> options,
    required FixedExtentScrollController controller,
  }) {
    // 与外层 didUpdateWidget 重复 guard：applyColumnUpdate 还有从 picker
    // 命令式调用的入口（不经过 didUpdateWidget），需自带防御性短路。
    if (listEquals(_options, options) && _controller == controller) {
      return;
    }
    final previousController = _controller;
    setState(() {
      _options = options;
      _controller = controller;
      // 切 controller 时清空 dedup 缓存：旧 controller 的 _lastNotifiedIndex
      // 与新 controller 数值上重合时,_animateToNearestEnabled 的
      // `if (_lastNotifiedIndex == target) return;` 会误判为已通知,
      // 漏掉一次 onChange(onAnimationComplete 路径)。极端低概率但状态
      // 本应与 controller 同寿命,一行清零根治。
      if (!identical(previousController, controller)) {
        _lastNotifiedIndex = null;
      }
    });
    if (!identical(previousController, controller)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!identical(_controller, previousController)) {
          previousController.dispose();
        }
      });
    }
  }

  /// 命令式触发动画修正到最近 enabled 项（一般由 scroll end 内部调用）
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

  /// 无障碍手势用：严格上一/下一格（与 Flutter `CupertinoPicker._handleIncrease`
  /// 同款契约 —— 一次只移动一格，**不跨 disabled**）。
  ///
  /// disabled 项的修正由 [animateToNearestEnabled]（即物理滚动结束后的修正流程）
  /// 统一处理，a11y 路径保持"按一下=移一格"的心智模型纯净。
  /// 边界时返回 false（外层可据此关闭 increase/decrease 语义）。
  bool nudge(int delta) {
    if (_options.isEmpty || _isAnimating || widget.disabled) {
      return false;
    }
    // H3 防御：与 currentSelectedIndex 同款，controller 在首次 build 完
    // 成前无 client，selectedItem 会抛断言（_handleScrollEnd 早于 ListView
    // 挂载触发时可能命中此分支）。
    if (!_controller.hasClients) {
      return false;
    }
    final current = _controller.selectedItem;
    if (current < 0 || current >= _options.length) {
      return false;
    }
    final target = current + delta;
    if (target < 0 || target >= _options.length) {
      return false;
    }
    _controller.jumpToItem(target);
    widget.onItemSelected(widget.colIndex, target, _options);
    return true;
  }

  /// 从 [start] 出发搜索最近一个 enabled 索引（双向同时推进，先命中者胜出；
  /// 同距离偏向前向）。
  ///
  /// 仅供 [animateToNearestEnabled] 内部使用（disabled 项修正动画）：
  /// a11y 的 `onIncrease` / `onDecrease` 不调用此方法（严格 ±1 步进，
  /// disabled 修正由 controller notify 后统一处理）。
  /// 全 disabled 或无可达项时返回 -1。
  static int nearestEnabledIndex(List<TPickerOption> data, int start) {
    for (var s = 1; s < data.length; s++) {
      final forward = start + s;
      if (forward < data.length && !data[forward].disabled) {
        return forward;
      }
      final backward = start - s;
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
        if (!mounted) {
          return;
        }
        _isAnimating = false;
        // H2 dedup：动画过程中 `onSelectedItemChanged` 已经在落点触发过
        // `onItemSelected`，这里再调 `onAnimationComplete` 会让父组件
        // 重复收到同 index 的 onChange。命中 dedup 时跳过。
        if (_lastNotifiedIndex == target) {
          return;
        }
        widget.onAnimationComplete?.call(widget.colIndex, target, _options);
      }).catchError((Object e, StackTrace stack) {
        debugPrint('WheelColumn animation interrupted: $e');
        _isAnimating = false;
      });
    });
  }

  /// 滚动结束后：若停在 disabled 项上则修正到最近 enabled
  void _handleScrollEnd() {
    if (widget.disabled || _options.isEmpty || _isAnimating) {
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

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      _handleScrollEnd();
    }
    final onScrollEnd = widget.onScrollEnd;
    if (onScrollEnd != null) {
      return onScrollEnd(notification, widget.colIndex, _options);
    }
    return false;
  }

  /// 拦截 `onSelectedItemChanged` 回调，记录最近一次通知的 index，
  /// 供 [_animateToNearestEnabled] 在动画结束时做 H2 dedup。
  void _handleSelectedItemChange(int index) {
    _lastNotifiedIndex = index;
    widget.onItemSelected(widget.colIndex, index, _options);
  }

  @override
  Widget build(BuildContext context) {
    if (_options.isEmpty) {
      return const SizedBox.shrink();
    }

    final wheel = ListWheelScrollView.useDelegate(
      itemExtent: widget.itemHeight,
      diameterRatio: kWheelDiameterRatio,
      controller: _controller,
      physics: widget.disabled
          ? const NeverScrollableScrollPhysics()
          : const FixedExtentScrollPhysics(),
      onSelectedItemChanged: widget.disabled
          ? null
          : _handleSelectedItemChange,
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

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: _scrollBehavior,
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: wheel,
        ),
      ),
    );
  }
}
