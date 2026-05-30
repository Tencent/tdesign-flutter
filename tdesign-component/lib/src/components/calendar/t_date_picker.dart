import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../date_time_picker/t_date_time_picker_internal.dart';
import '../date_time_picker/t_date_time_picker_wheel.dart';
import '../picker/no_wave_behavior.dart';
import 'date_picker_model.dart';

/// 日期/时间选择器（供 TCalendar 内部使用）
///
/// 默认复用 [DateTimePickerWheel] 与 `DateTimePickerSnapshot` 数据层；
/// `useWeekDay` / [DatePickerModel.filterItems] 非空时回退自绘滚轮。
/// 新代码请直接使用 [TDateTimePicker]。
class TDatePicker extends StatefulWidget {
  final String? title;
  final String? leftText;
  final String? rightText;
  final DatePickerModel model;
  final double? pickerHeight;
  final int? pickerItemCount;
  final bool? isTimeUnit;
  final void Function(Map<String, int>)? onConfirm;
  final void Function(int wheelIndex, int index)? onSelectedItemChanged;

  const TDatePicker({
    super.key,
    this.title,
    this.leftText,
    this.rightText,
    required this.model,
    this.pickerHeight,
    this.pickerItemCount,
    this.isTimeUnit,
    this.onConfirm,
    this.onSelectedItemChanged,
  });

  @override
  State<TDatePicker> createState() => _TDatePickerState();
}

class _TDatePickerState extends State<TDatePicker> {
  late double _pickerHeight;
  late int _itemCount;

  @override
  void initState() {
    super.initState();
    _pickerHeight = widget.pickerHeight ?? 178;
    _itemCount = widget.pickerItemCount ?? 5;
    widget.model.init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) _buildToolbar(context),
        if (widget.model.usesLegacyWheel)
          _buildLegacyWheel()
        else
          _buildSnapshotWheel(context),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: TTheme.of(context).spacer16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              widget.leftText ?? context.resource.cancel,
              style: TextStyle(color: TTheme.of(context).textColorSecondary),
            ),
          ),
          Text(
            widget.title ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () {
              widget.onConfirm?.call(widget.model.selected);
              Navigator.pop(context);
            },
            child: Text(
              widget.rightText ?? context.resource.confirm,
              style: TextStyle(color: TTheme.of(context).brandNormalColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnapshotWheel(BuildContext context) {
    final snapshot = widget.model.snapshot;
    if (snapshot == null) {
      return SizedBox(height: _pickerHeight);
    }
    final labels = DateTimePickerLabels.fromResource(context.resource);
    return DateTimePickerWheel(
      snapshot: snapshot,
      labels: labels,
      start: widget.model.rangeStart,
      end: widget.model.rangeEnd,
      showWeek: false,
      steps: null,
      renderLabel: null,
      height: _pickerHeight,
      itemCount: _itemCount,
      onChanged: (next, _) {
        widget.model.applySnapshot(next);
        widget.onSelectedItemChanged?.call(0, 0);
      },
    );
  }

  Widget _buildLegacyWheel() {
    return SizedBox(
      height: _pickerHeight,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: (_pickerHeight - _pickerHeight / _itemCount) / 2,
            left: 16,
            right: 16,
            child: Builder(
              builder: (context) => Container(
                height: _pickerHeight / _itemCount,
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorSecondaryContainer,
                  borderRadius: BorderRadius.circular(
                    TTheme.of(context).radiusDefault,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: List.generate(
                widget.model.controllers.length,
                (i) => Expanded(child: _buildLegacyColumn(i)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegacyColumn(int colIndex) {
    final data = widget.model.data[colIndex];
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: NoWaveBehavior(),
        child: ListWheelScrollView.useDelegate(
          itemExtent: _pickerHeight / _itemCount,
          diameterRatio: 100,
          controller: widget.model.controllers[colIndex],
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            if (colIndex < widget.model.data.length - 1) {
              widget.model.refreshDataAndController(colIndex);
            }
            widget.onSelectedItemChanged?.call(colIndex, index);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: data.length,
            builder: (context, index) {
              return _TDatePickerItem(
                content: data[index].toString(),
                controller: widget.model.controllers[colIndex],
                index: index,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 私有：calendar 遗留自绘滚轮的单 item 渲染。
class _TDatePickerItem extends StatelessWidget {
  const _TDatePickerItem({
    required this.content,
    required this.controller,
    required this.index,
  });

  final String content;
  final FixedExtentScrollController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          int selected;
          try {
            selected = controller.selectedItem;
          } catch (_) {
            selected = 0;
          }
          final isSelected = selected == index;
          return Center(
            child: TText(
              content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: theme.fontBodyLarge?.size ?? 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? theme.textColorPrimary
                    : theme.textColorPlaceholder,
              ),
            ),
          );
        },
      ),
    );
  }
}
