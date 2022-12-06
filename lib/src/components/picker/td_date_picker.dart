import 'dart:math';

import 'package:flutter/material.dart';

import '../../../td_export.dart';
import 'no_wave_behavior.dart';

typedef DatePickerCallback = void Function(Map<String, int> selected);

/// 时间选择器
class TDDatePicker extends StatefulWidget {
  final String title; // 选择器标题
  final DatePickerCallback? onConfirm; // 选择器确认按钮回调
  final DatePickerCallback? onCancel; // 选择器取消按钮回调
  final Color? backgroundColor;
  final Color? titleDividerColor;
  final double? topRadius;
  final double? titleHeight;
  final double? leftPadding;
  final double? rightPadding;

  /// 根据距离计算字体颜色、透明度、粗细
  final ItemDistanceCalculator? itemDistanceCalculator;

  /// 选择器List的视窗高度，默认200
  final double pickerHeight;

  /// 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度
  final int pickerItemCount;

  /// 自定义选择框样式
  final Widget? customSelectWidget;

  /// 自定义左侧文案样式
  final TextStyle? leftTextStyle;

  /// 自定义右侧文案样式
  final TextStyle? rightTextStyle;

  /// 自定义中间文案样式
  final TextStyle? centerTextStyle;

  /// 适配padding
  final EdgeInsets? padding;

  /// 是否展示标题
  final bool showTitle;

  final DatePickerModel model;


   const TDDatePicker(
      {required this.title,
      required this.onConfirm,
      this.onCancel,
      this.backgroundColor,
      this.titleDividerColor,
      this.topRadius,
      this.titleHeight,
      this.padding,
      this.leftPadding,
      this.rightPadding,
      this.leftTextStyle,
      this.rightTextStyle,
      this.centerTextStyle,
      this.customSelectWidget,
      this.itemDistanceCalculator,
      required this.model,
      this.showTitle = true,
      this.pickerHeight = 200,
      required this.pickerItemCount,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDDatePickerState();
}

class _TDDatePickerState extends State<TDDatePicker> {

  double pickerHeight = 0;

  @override
  void initState() {
    super.initState();
    pickerHeight = widget.pickerHeight;
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
      width: maxWidth,
      padding: widget.padding ?? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topRadius ?? 0),
          topRight: Radius.circular(widget.topRadius ?? 0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(child: buildTitle(context), visible: widget.showTitle == true,),
          Container(
            width: maxWidth,
            height: 0.5,
            color: widget.titleDividerColor ?? TDTheme.of(context).fontGyColor3,
          ),
          SizedBox(
            height: pickerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.customSelectWidget ?? Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(
                        color: TDTheme.of(context).fontGyColor3, width: 0.5),
                    bottom: BorderSide(
                        color: TDTheme.of(context).fontGyColor3, width: 0.5),
                  )),
                ),
                SizedBox(
                    height: pickerHeight,
                    width: maxWidth,
                    child: Row(
                      children: [
                        widget.model.useYear
                            ? Expanded(child: buildList(context, 0))
                            : Container(),
                        widget.model.useMonth
                            ? Expanded(child: buildList(context, 1))
                            : Container(),
                        widget.model.useDay
                            ? Expanded(child: buildList(context, 2))
                            : Container(),
                        widget.model.useHour
                            ? Expanded(child: buildList(context, 3))
                            : Container(),
                        widget.model.useMinute
                            ? Expanded(child: buildList(context, 4))
                            : Container(),
                        widget.model.useSecond
                            ? Expanded(child: buildList(context, 5))
                            : Container(),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildList(context, int whichline) {
    /// whichline参数表示这个列表表示的是年，还是月还是日......
    var maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ScrollConfiguration(
          behavior: NoWaveBehavior(),
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / widget.pickerItemCount,
              diameterRatio: 100,
              controller: widget.model.controllers[whichline],
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                if (whichline == 0 || whichline == 1) {
                  // 年月的改变会引起日的改变, 年的改变会引起月的改变
                  setState(() {
                    if (whichline == 0) {
                      widget.model.refreshMonthDataAndController();
                    }
                    widget.model.refreshDayDataAndController();

                    /// 使用动态高度，强制列表组件的state刷新，以展现更新的数据，详见下方链接
                    /// FIX:https://github.com/flutter/flutter/issues/22999
                    pickerHeight =
                        pickerHeight - Random().nextDouble() / 100000000;
                  });
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.model.data[whichline].length,
                  builder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          index: index,
                          itemHeight: pickerHeight / widget.pickerItemCount,
                          content: widget.model.data[whichline][index].toString() +
                              widget.model.mapping[whichline],
                          fixedExtentScrollController:
                              widget.model.controllers[whichline],
                          itemDistanceCalculator: widget.itemDistanceCalculator,
                        ));
                  })),
        ));
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.leftPadding ?? 16, right: widget.rightPadding ?? 16),

      /// 减去分割线的空间
      height: getTitleHeight() - 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 左边按钮
          GestureDetector(
              onTap: () {
                if (widget.onCancel != null) {
                  var selected = <String, int>{
                    'year': widget.model.useYear
                        ? widget.model.yearFixedExtentScrollController.selectedItem +
                            widget.model.data[0][0]
                        : -1,
                    'month': widget.model.useMonth
                        ? widget.model.monthFixedExtentScrollController.selectedItem +
                            widget.model.data[1][0]
                        : -1,
                    'day': widget.model.useDay
                        ? widget.model.dayFixedExtentScrollController.selectedItem +
                            widget.model.data[2][0]
                        : -1,
                    'hour': widget.model.useHour
                        ? widget.model.hourFixedExtentScrollController.selectedItem
                        : -1,
                    'minute': widget.model.useMinute
                        ? widget.model.minuteFixedExtentScrollController.selectedItem
                        : -1,
                    'second': widget.model.useSecond
                        ? widget.model.secondFixedExtentScrollController.selectedItem
                        : -1,
                  };
                  widget.onCancel!(selected);
                }
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: TDText(
                '取消',
                  style: widget.leftTextStyle?? TextStyle(
                      fontSize: TDTheme.of(context).fontBodyLarge!.size,
                      color: TDTheme.of(context).fontGyColor2
                  )
              )),

          /// 中间title
          Expanded(
            child: Center(
                    child: TDText(
                      widget.title,
                      style: widget.centerTextStyle ?? TextStyle(
                        fontSize: TDTheme.of(context).fontBodyLarge!.size,
                        fontWeight: FontWeight.w600,
                        color: TDTheme.of(context).fontGyColor1,
                      ),
                    ),
                  ),
          ),

          /// 右边按钮
          GestureDetector(
            onTap: () {
              if (widget.onConfirm != null) {
                var selected = <String, int>{
                  'year': widget.model.useYear
                      ? widget.model.yearFixedExtentScrollController.selectedItem +
                          widget.model.data[0][0]
                      : -1,
                  'month': widget.model.useMonth
                      ? widget.model.monthFixedExtentScrollController.selectedItem +
                          widget.model.data[1][0]
                      : -1,
                  'day': widget.model.useDay
                      ? widget.model.dayFixedExtentScrollController.selectedItem +
                          widget.model.data[2][0]
                      : -1,
                  'hour': widget.model.useHour
                      ? widget.model.hourFixedExtentScrollController.selectedItem
                      : -1,
                  'minute': widget.model.useMinute
                      ? widget.model.minuteFixedExtentScrollController.selectedItem
                      : -1,
                  'second': widget.model.useSecond
                      ? widget.model.secondFixedExtentScrollController.selectedItem
                      : -1,
                };
                widget.onConfirm!(selected);
              }
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: TDText(
              '确认',
              style: widget.rightTextStyle?? TextStyle(
                  fontSize: TDTheme.of(context).fontBodyLarge!.size,
                  color: TDTheme.of(context).brandNormalColor
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => widget.titleHeight ?? 48;
}

// 时间选择器的数据类
class DatePickerModel {
  bool useYear;
  bool useMonth;
  bool useDay;
  bool useHour;
  bool useMinute;
  bool useSecond;
  List<int> dateStart;
  List<int> dateEnd;
  List<int>? dateInitial;

  final mapping = ['年', '月', '日', '时', '分', '秒'];

  late DateTime initialTime;

  /// 这三项随滑动而更新，注意初始化
  late int yearIndex;
  late int monthIndex;
  late int dayIndex;

  late List<List<int>> data = [
    List.generate(
        dateEnd[0] - dateStart[0] + 1, (index) => index + dateStart[0]),
    [],
    [],
    List.generate(24, (index) => index),
    List.generate(60, (index) => index),
    List.generate(60, (index) => index),
  ];
  late var controllers;
  late FixedExtentScrollController yearFixedExtentScrollController;
  late FixedExtentScrollController monthFixedExtentScrollController;
  late FixedExtentScrollController dayFixedExtentScrollController;
  late FixedExtentScrollController hourFixedExtentScrollController;
  late FixedExtentScrollController minuteFixedExtentScrollController;
  late FixedExtentScrollController secondFixedExtentScrollController;

  DatePickerModel({
    required this.useYear,
    required this.useMonth,
    required this.useDay,
    required this.useHour,
    required this.useMinute,
    required this.useSecond,
    required this.dateStart,
    required this.dateEnd,
    this.dateInitial
  }) {
    setInitialTime();
    setInitialMonthData();
    setInitialDayData();
    setControllers();
    addListener();
  }

  void setInitialTime() {
    var startTime = DateTime(dateStart[0], dateStart[1], dateStart[2], 0, 0, 0);
    var endTime = DateTime(dateEnd[0], dateEnd[1], dateEnd[2], 0, 0, 0);
    if (dateInitial != null) {
      initialTime = DateTime(dateInitial![0], dateInitial![1], dateInitial![2], 0, 0, 0);
      if (initialTime.isBefore(startTime)) {
        initialTime = startTime;
      } else if (initialTime.isAfter(endTime)) {
        initialTime = endTime;
      }
      return;
    }
    var now = DateTime.now();
    if (now.year * 500 + now.month * 40 + now.day <
        dateStart[0] * 500 + dateStart[1] * 40 + dateStart[2]) {
      initialTime = DateTime(dateStart[0], dateStart[1], dateStart[2], now.hour,
          now.minute, now.second);
    } else if (now.year * 500 + now.month * 40 + now.day >
        dateEnd[0] * 500 + dateEnd[1] * 40 + dateEnd[2]) {
      initialTime = DateTime(
          dateEnd[0], dateEnd[1], dateEnd[2], now.hour, now.minute, now.second);
    } else {
      initialTime = now;
    }
  }

  void setInitialMonthData() {
    if (dateEnd[0] == dateStart[0]) {
      data[1] = List.generate(
          dateEnd[1] - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (initialTime.year == dateStart[0]) {
      data[1] =
          List.generate(12 - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (initialTime.year == dateEnd[0]) {
      data[1] = List.generate(dateEnd[1], (index) => index + 1);
    } else {
      data[1] = List.generate(12, (index) => index + 1);
    }
  }

  void setInitialDayData() {
    if (dateEnd[0] == dateStart[0] && dateEnd[1] == dateStart[1]) {
      data[2] = List.generate(
          dateEnd[2] - dateStart[2] + 1, (index) => index + dateStart[2]);
    } else if (initialTime.year == dateStart[0] &&
        initialTime.month == dateStart[1]) {
      data[2] = List.generate(
          DateTime(initialTime.year, initialTime.month + 1, 0).day -
              dateStart[2] +
              1,
          (index) => index + dateStart[2]);
    } else if (initialTime.year == dateEnd[0] &&
        initialTime.month == dateEnd[1]) {
      data[2] = List.generate(dateEnd[2], (index) => index + 1);
    } else {
      data[2] = List.generate(
          DateTime(initialTime.year, initialTime.month + 1, 0).day,
          (index) => index + 1);
    }
  }

  void setControllers() {
    /// 初始化Index
    yearIndex = initialTime.year - data[0][0];
    monthIndex = initialTime.month - data[1][0];
    dayIndex = initialTime.day - data[2][0];
    controllers = [
      FixedExtentScrollController(initialItem: yearIndex),
      FixedExtentScrollController(initialItem: monthIndex),
      FixedExtentScrollController(initialItem: dayIndex),
      FixedExtentScrollController(initialItem: initialTime.hour),
      FixedExtentScrollController(initialItem: initialTime.minute),
      FixedExtentScrollController(initialItem: initialTime.second)
    ];
    yearFixedExtentScrollController = controllers[0];
    monthFixedExtentScrollController = controllers[1];
    dayFixedExtentScrollController = controllers[2];
    hourFixedExtentScrollController = controllers[3];
    minuteFixedExtentScrollController = controllers[4];
    secondFixedExtentScrollController = controllers[5];
  }

  void addListener() {
    /// 给年月日加上监控
    yearFixedExtentScrollController.addListener(() {
      yearIndex = yearFixedExtentScrollController.selectedItem;
    });
    monthFixedExtentScrollController.addListener(() {
      monthIndex = monthFixedExtentScrollController.selectedItem;
    });
    dayFixedExtentScrollController.addListener(() {
      dayIndex = dayFixedExtentScrollController.selectedItem;
    });
  }

  void refreshMonthDataAndController() {
    var selectedYear = yearIndex + data[0][0];
    if (dateEnd[0] == dateStart[0]) {
      data[1] = List.generate(
          dateEnd[1] - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (selectedYear == dateStart[0]) {
      data[1] =
          List.generate(12 - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (selectedYear == dateEnd[0]) {
      data[1] = List.generate(dateEnd[1], (index) => index + 1);
    } else {
      data[1] = List.generate(12, (index) => index + 1);
    }
    monthFixedExtentScrollController.jumpToItem(
        monthIndex > data[1].length - 1 ? data[1].length - 1 : monthIndex);
  }

  void refreshDayDataAndController() {
    /// 在刷新日数据时，年月数据已经是最新的
    var selectedYear = yearIndex + data[0][0];
    var selectedMonth = monthIndex + data[1][0];
    if (dateEnd[0] == dateStart[0] && dateEnd[1] == dateStart[1]) {
      data[2] = List.generate(
          dateEnd[2] - dateStart[2] + 1, (index) => index + dateStart[2]);
    } else if (selectedYear == dateStart[0] && selectedMonth == dateStart[1]) {
      data[2] = List.generate(
          DateTime(selectedYear, selectedMonth + 1, 0).day - dateStart[2] + 1,
          (index) => index + dateStart[2]);
    } else if (selectedYear == dateEnd[0] && selectedMonth == dateEnd[1]) {
      data[2] = List.generate(dateEnd[2], (index) => index + 1);
    } else {
      data[2] = List.generate(DateTime(selectedYear, selectedMonth + 1, 0).day,
          (index) => index + 1);
    }
    dayFixedExtentScrollController.jumpToItem(
        dayIndex > data[2].length - 1 ? data[2].length - 1 : dayIndex);
  }

  Map<String, int> getSelectedMap() {
    var map = <String, int>{
      'year': yearIndex + data[0][0],
      'month': monthIndex + data[1][0],
      'day' : dayIndex + data[2][0],
    };
    return map;
  }

}

