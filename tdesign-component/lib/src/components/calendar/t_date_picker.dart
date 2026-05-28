import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../picker/no_wave_behavior.dart';
import 'date_picker_model.dart';

/// 日期/时间选择器（供 TCalendar 内部使用）
///
/// 精简版，仅提供 TCalendar 时间选择器所需功能（自绘滚轮 + [DatePickerModel]）。
/// 新代码请直接使用 [TDateTimePicker]（基于 [TPicker] 与 `DateTimePickerSnapshot`）。
///
/// 与对外选择器并存期间，若修正日期范围、闰月等边界行为，请评估是否需同步修改
/// `DateTimePickerSnapshot`，直至日历迁移到共享数据层。
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
            padding: EdgeInsets.symmetric(
                horizontal: TTheme.of(context).spacer16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    widget.leftText ?? context.resource.cancel,
                    style: TextStyle(
                        color: TTheme.of(context).textColorSecondary),
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
                    style: TextStyle(
                        color: TTheme.of(context).brandNormalColor),
                  ),
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
                    borderRadius: BorderRadius.circular(
                        TTheme.of(context).radiusDefault),
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
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: NoWaveBehavior(),
        child: ListWheelScrollView.useDelegate(
          itemExtent:
              _pickerHeight / (widget.pickerItemCount ?? 5),
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

/// 私有：calendar 内嵌选择器的单 item 渲染。
///
/// 与对外的 `TItemWidget` 行为一致（选中加粗 + 主色，非选中常规字重 + 占位
/// 色），但不依赖其 API——这里只在 calendar 私有 picker 用，没必要绑定
/// 上层 ValueListenable / styleResolver 协议。
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
