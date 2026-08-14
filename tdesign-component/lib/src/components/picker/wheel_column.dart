import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'picker_item.dart';
import 't_picker_types.dart';
import 'wheel_behavior.dart';

@internal
const double kWheelDiameterRatio = 3;

const int _correctionDurationMs = 200;

/// Picker 与 DateTimePicker 共用的单列滚轮。
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
  final TPickerItemBuilder? itemBuilder;
  final void Function(
          int columnIndex, int itemIndex, List<TPickerOption> options)
      onItemSelected;
  final bool Function(
    ScrollNotification notification,
    int columnIndex,
    List<TPickerOption> options,
  )? onScrollEnd;
  final void Function(
    int columnIndex,
    int itemIndex,
    List<TPickerOption> options,
  )? onAnimationComplete;

  @override
  State<WheelColumn> createState() => WheelColumnState();
}

@internal
class WheelColumnState extends State<WheelColumn> {
  static final _defaultScrollBehavior = WheelBehavior();

  late List<TPickerOption> _options;
  late FixedExtentScrollController _controller;
  bool _correcting = false;
  int? _lastNotifiedIndex;

  @override
  void initState() {
    super.initState();
    _options = widget.options;
    _controller = widget.controller;
  }

  @override
  void didUpdateWidget(covariant WheelColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    applyColumnUpdate(options: widget.options, controller: widget.controller);
  }

  /// 更新列数据。滚动控制器的创建和释放始终由父组件负责。
  void applyColumnUpdate({
    required List<TPickerOption> options,
    required FixedExtentScrollController controller,
  }) {
    if (listEquals(_options, options) && identical(_controller, controller)) {
      return;
    }
    setState(() {
      _options = options;
      if (!identical(_controller, controller)) {
        _controller = controller;
        _lastNotifiedIndex = null;
        _correcting = false;
      }
    });
  }

  /// 将当前列严格移动一项，越界、禁用或尚未挂载时返回 false。
  bool nudge(int delta) {
    if (_options.isEmpty ||
        _correcting ||
        widget.disabled ||
        !_controller.hasClients) {
      return false;
    }
    final target = _controller.selectedItem + delta;
    if (target < 0 || target >= _options.length) {
      return false;
    }
    _controller.jumpToItem(target);
    _notifySelected(target);
    return true;
  }

  /// 查找距 [start] 最近的可用项，同距离时优先后方项。
  static int nearestEnabledIndex(List<TPickerOption> options, int start) {
    for (var distance = 1; distance < options.length; distance++) {
      final forward = start + distance;
      if (forward < options.length && !options[forward].disabled) {
        return forward;
      }
      final backward = start - distance;
      if (backward >= 0 && !options[backward].disabled) {
        return backward;
      }
    }
    return -1;
  }

  void _correctDisabledSelection() {
    if (widget.disabled ||
        _options.isEmpty ||
        _correcting ||
        !_controller.hasClients) {
      return;
    }
    final current = _controller.selectedItem;
    if (!_options[current].disabled) {
      return;
    }
    final target = nearestEnabledIndex(_options, current);
    if (target < 0) {
      return;
    }
    _correcting = true;
    _controller
        .animateToItem(
      target,
      duration: const Duration(milliseconds: _correctionDurationMs),
      curve: Curves.easeOutCubic,
    )
        .then((_) {
      if (!mounted) {
        return;
      }
      _correcting = false;
      if (_lastNotifiedIndex != target) {
        widget.onAnimationComplete?.call(widget.colIndex, target, _options);
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      _correctDisabledSelection();
    }
    return widget.onScrollEnd?.call(notification, widget.colIndex, _options) ??
        false;
  }

  void _notifySelected(int index) {
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
      onSelectedItemChanged: widget.disabled ? null : _notifySelected,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: _options.length,
        builder: (_, index) => PickerItemWidget(
          option: _options[index],
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
        behavior: widget.scrollBehavior ?? _defaultScrollBehavior,
        child: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: wheel,
        ),
      ),
    );
  }
}
