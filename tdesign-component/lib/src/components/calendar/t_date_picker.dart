import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../picker/no_wave_behavior.dart';
import 'date_picker_model.dart';

/// 日期/时间选择器（供 TCalendar 内部使用）
///
/// 精简版，仅提供 TCalendar 时间选择器所需功能
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

  @override
  void initState() {
    super.initState();
    _pickerHeight = widget.pickerHeight ?? 178;
    widget.model.init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: TTheme.of(context).spacer16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(widget.leftText ?? '取消', style: TextStyle(color: TTheme.of(context).textColorSecondary)),
                ),
                Text(widget.title ?? '', style: TextStyle(fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: () {
                    widget.onConfirm?.call(widget.model.selected);
                    Navigator.pop(context);
                  },
                  child: Text(widget.rightText ?? '确认', style: TextStyle(color: TTheme.of(context).brandNormalColor)),
                ),
              ],
            ),
          ),
        SizedBox(
          height: _pickerHeight,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: (_pickerHeight - 40) / 2,
                left: 16,
                right: 16,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: TTheme.of(context).bgColorSecondaryContainer,
                    borderRadius: BorderRadius.circular(TTheme.of(context).radiusDefault),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: List.generate(
                    widget.model.controllers.length,
                    (i) => Expanded(child: _buildColumn(i)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(int colIndex) {
    final data = widget.model.data[colIndex];
    if (data.isEmpty) return const SizedBox.shrink();

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: NoWaveBehavior(),
        child: ListWheelScrollView.useDelegate(
          itemExtent: _pickerHeight / (widget.pickerItemCount ?? 5),
          diameterRatio: 100,
          controller: widget.model.controllers[colIndex],
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            // 联动刷新
            if (colIndex < widget.model.data.length - 1) {
              widget.model.refreshDataAndController(colIndex);
            }
            widget.onSelectedItemChanged?.call(colIndex, index);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: data.length,
            builder: (context, index) {
              final content = data[index].toString();
              return Container(
                alignment: Alignment.center,
                height: _pickerHeight / (widget.pickerItemCount ?? 5),
                width: double.infinity,
                child: TItemWidget(
                  content: content,
                  fixedExtentScrollController: widget.model.controllers[colIndex],
                  colIndex: colIndex,
                  index: index,
                  itemHeight: _pickerHeight / (widget.pickerItemCount ?? 5),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
