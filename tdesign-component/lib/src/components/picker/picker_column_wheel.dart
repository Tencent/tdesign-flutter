import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'no_wave_behavior.dart';
import 't_item_widget.dart';
import 't_picker_option.dart';

/// 滚轮透视比例（越大越平）。
const double kPickerWheelDiameterRatio = 3;

/// 单列滚轮（独立 [State]，数据变化时只重建本列）。
class PickerColumnWheel extends StatefulWidget {
  const PickerColumnWheel({
    required super.key,
    required this.colIndex,
    required this.options,
    required this.controller,
    required this.itemHeight,
    required this.disabled,
    required this.onItemSelected,
    this.scrollBehavior,
    this.itemBuilder,
    this.itemDistanceCalculator,
    this.onScrollEnd,
  });

  final int colIndex;
  final List<TPickerOption> options;
  final FixedExtentScrollController controller;
  final double itemHeight;
  final bool disabled;
  final ScrollBehavior? scrollBehavior;
  final ItemBuilderType? itemBuilder;
  final ItemDistanceCalculator? itemDistanceCalculator;
  final void Function(int col, int index, List<TPickerOption> data)
      onItemSelected;
  final bool Function(
    ScrollNotification notification,
    int col,
    List<TPickerOption> data,
  )? onScrollEnd;

  @override
  State<PickerColumnWheel> createState() => PickerColumnWheelState();
}

class PickerColumnWheelState extends State<PickerColumnWheel> {
  static final _defaultScrollBehavior = NoWaveBehavior();

  late List<TPickerOption> _options;
  late FixedExtentScrollController _controller;

  ScrollBehavior get _scrollBehavior =>
      widget.scrollBehavior ?? _defaultScrollBehavior;

  @override
  void initState() {
    super.initState();
    _options = widget.options;
    _controller = widget.controller;
  }

  @override
  void didUpdateWidget(PickerColumnWheel oldWidget) {
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
    required List<TPickerOption> options,
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

  @override
  Widget build(BuildContext context) {
    if (_options.isEmpty) {
      return const SizedBox.shrink();
    }

    final wheel = ListWheelScrollView.useDelegate(
      key: ValueKey<int>(_options.length),
      itemExtent: widget.itemHeight,
      diameterRatio: kPickerWheelDiameterRatio,
      controller: _controller,
      physics: widget.disabled
          ? const NeverScrollableScrollPhysics()
          : const FixedExtentScrollPhysics(),
      onSelectedItemChanged: widget.disabled
          ? null
          : (index) =>
              widget.onItemSelected(widget.colIndex, index, _options),
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: _options.length,
        builder: (_, index) => TItemWidget(
          content: _options[index].label,
          fixedExtentScrollController: _controller,
          colIndex: widget.colIndex,
          index: index,
          itemHeight: widget.itemHeight,
          disabled: _options[index].disabled,
          itemBuilder: widget.itemBuilder,
          itemDistanceCalculator: widget.itemDistanceCalculator,
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
