import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDPicker {
  /// 显示时间选择器
  static void showDatePicker(
    context, {
    required String title,
    required DatePickerCallback? onConfirm,
    DatePickerCallback? onCancel,
    bool useYear = true,
    bool useMonth = true,
    bool useDay = true,
    bool useHour = false,
    bool useMinute = false,
    bool useSecond = false,
    bool useWeekDay = false,
    Color? barrierColor,
    List<int> dateStart = const [1970, 1, 1],
    List<int>? dateEnd,
    List<int>? initialDate,
    String? rightText,
    String? leftText,
    TextStyle? leftTextStyle,
    TextStyle? centerTextStyle,
    TextStyle? rightTextStyle,
    Color? titleDividerColor,
    Widget? customSelectWidget,
    Duration duration = const Duration(milliseconds: 100),
    double pickerHeight = 200,
    bool isTimeUnit = true,
    Function(int wheelIndex, int index)? onSelectedItemChanged,
    int pickerItemCount = 5,
    List<int> Function(DateTypeKey key, List<int> nums)? filterItems,
    ItemBuilderType? itemBuilder,
  }) {
    if (dateEnd == null || initialDate == null) {
      var now = DateTime.now();
      // 如果未指定结束时间，则取当前时间
      dateEnd ??= [now.year, now.month, now.day];
      initialDate ??= [now.year, now.month, now.day];
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      enableDrag: false,
      builder: (context) {
        return TDDatePicker(
          title: title,
          onConfirm: onConfirm,
          onCancel: onCancel,
          rightText: rightText,
          leftText: leftText,
          leftTextStyle: leftTextStyle,
          centerTextStyle: centerTextStyle,
          rightTextStyle: rightTextStyle,
          titleDividerColor: titleDividerColor,
          isTimeUnit: isTimeUnit,
          customSelectWidget: customSelectWidget,
          model: DatePickerModel(
            useYear: useYear,
            useMonth: useMonth,
            useDay: useDay,
            useWeekDay: useWeekDay,
            useHour: useHour,
            useMinute: useMinute,
            useSecond: useSecond,
            dateStart: dateStart,
            dateEnd: dateEnd!,
            dateInitial: initialDate,
            filterItems: filterItems,
          ),
          pickerHeight: pickerHeight,
          pickerItemCount: pickerItemCount,
          onSelectedItemChanged: onSelectedItemChanged,
          itemBuilder: itemBuilder,
        );
      },
    );
  }

  /// 显示多级选择器
  static void showMultiPicker(
    context, {
    String? title,
    required MultiPickerCallback? onConfirm,
    MultiPickerCallback? onCancel,
    required List<List<String>> data,
    double pickerHeight = 200,
    int pickerItemCount = 5,
    List<int>? initialIndexes,
    String? rightText,
    String? leftText,
    TextStyle? leftTextStyle,
    TextStyle? centerTextStyle,
    TextStyle? rightTextStyle,
    double? titleHeight,
    double? topPadding,
    double? leftPadding,
    double? rightPadding,
    Color? titleDividerColor,
    Color? backgroundColor,
    double? topRadius,
    EdgeInsets? padding,
    Widget? customSelectWidget,
    ItemBuilderType? itemBuilder,

    /// todo 未传参
    Duration duration = const Duration(milliseconds: 100),
    Color? barrierColor,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      builder: (context) {
        return TDMultiPicker(
          title: title,
          onConfirm: onConfirm,
          onCancel: onCancel,
          data: data,
          pickerHeight: pickerHeight,
          pickerItemCount: pickerItemCount,
          initialIndexes: initialIndexes,
          rightText: rightText,
          leftText: leftText,
          leftTextStyle: leftTextStyle,
          rightTextStyle: rightTextStyle,
          centerTextStyle: centerTextStyle,
          titleHeight: titleHeight,
          topPadding: topPadding,
          leftPadding: leftPadding,
          rightPadding: rightPadding,
          titleDividerColor: titleDividerColor,
          backgroundColor: backgroundColor,
          topRadius: topRadius,
          padding: padding,
          itemBuilder: itemBuilder,
          customSelectWidget: customSelectWidget,
        );
      },
    );
  }

  /// 显示多级联动选择器
  //     required this.selectedData,
  static void showMultiLinkedPicker(
    context, {
    String? title,
    required MultiPickerCallback? onConfirm,
    MultiPickerCallback? onCancel,
    required List initialData,
    required Map data,
    required int columnNum,
    double pickerHeight = 200,
    int pickerItemCount = 5,
    Widget? customSelectWidget,
    String? rightText,
    String? leftText,
    TextStyle? leftTextStyle,
    TextStyle? centerTextStyle,
    TextStyle? rightTextStyle,
    double? titleHeight,
    double? topPadding,
    double? leftPadding,
    double? rightPadding,
    Color? titleDividerColor,
    Color? backgroundColor,
    double? topRadius,
    EdgeInsets? padding,
    ItemBuilderType? itemBuilder,
    // ItemDistanceCalculator? itemDistanceCalculator,
    bool keepSameSelection = false,
    Color? barrierColor,

    /// todo 未传参
    Duration duration = const Duration(milliseconds: 100),
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      builder: (context) {
        return TDMultiLinkedPicker(
          title: title,
          onConfirm: onConfirm,
          onCancel: onCancel,
          selectedData: initialData,
          data: data,
          columnNum: columnNum,
          pickerHeight: pickerHeight,
          pickerItemCount: pickerItemCount,
          rightText: rightText,
          leftText: leftText,
          leftTextStyle: leftTextStyle,
          rightTextStyle: rightTextStyle,
          centerTextStyle: centerTextStyle,
          titleHeight: titleHeight,
          topPadding: topPadding,
          leftPadding: leftPadding,
          rightPadding: rightPadding,
          titleDividerColor: titleDividerColor,
          backgroundColor: backgroundColor,
          topRadius: topRadius,
          padding: padding,
          itemBuilder: itemBuilder,
          customSelectWidget: customSelectWidget,
          keepSameSelection: keepSameSelection,
          // itemDistanceCalculator: itemDistanceCalculator,
        );
      },
    );
  }
}
