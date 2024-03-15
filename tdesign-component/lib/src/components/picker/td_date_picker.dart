import 'dart:math';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'no_wave_behavior.dart';

typedef DatePickerCallback = void Function(Map<String, int> selected);

/// 时间选择器
class TDDatePicker extends StatefulWidget {

  const TDDatePicker(
      {required this.title,
        required this.onConfirm,
        this.rightText = '确认',
        this.leftText = '取消',
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

  /// 选择器标题
  final String title;

  /// 右侧按钮文案
  final String rightText;

  /// 左侧按钮文案
  final String leftText;

  /// 选择器确认按钮回调
  final DatePickerCallback? onConfirm;

  /// 选择器取消按钮回调
  final DatePickerCallback? onCancel;

  /// 背景颜色
  final Color? backgroundColor;

  /// 标题分割线颜色
  final Color? titleDividerColor;

  /// 顶部圆角
  final double? topRadius;

  /// 标题高度
  final double? titleHeight;

  /// 左边填充
  final double? leftPadding;

  /// 右边填充
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

  /// 数据模型
  final DatePickerModel model;

  @override
  State<StatefulWidget> createState() => _TDDatePickerState();
}

class _TDDatePickerState extends State<TDDatePicker> {
  double pickerHeight = 0;
  static const _pickerTitleHeight = 56.0;

  @override
  void initState() {
    super.initState();
    pickerHeight = widget.pickerHeight;
  }

  bool useAll() {
    if(widget.model.useYear
        && widget.model.useMonth
        && widget.model.useDay
        && widget.model.useHour
        && widget.model.useMinute
        && widget.model.useSecond) {
      return true;
    }
    return false;
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
          topLeft: Radius.circular(widget.topRadius ?? TDTheme.of(context).radiusExtraLarge),
          topRight: Radius.circular(widget.topRadius ?? TDTheme.of(context).radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            child: buildTitle(context),
            visible: widget.showTitle == true,
          ),
          SizedBox(
            height: pickerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: widget.customSelectWidget ??
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: TDTheme.of(context).grayColor1,
                            borderRadius: const BorderRadius.all(Radius.circular(6))),
                      ),
                ),
                Container(
                    height: pickerHeight,
                    width: maxWidth,
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: Row(
                      children: [
                        widget.model.useYear
                            ? useAll()
                            ? SizedBox(
                          child: buildList(context, 0),
                          width: 64,
                        )
                            : Expanded(child: buildList(context, 0))
                            : Container(),
                        widget.model.useMonth ? Expanded(child: buildList(context, 1)) : Container(),
                        widget.model.useDay ? Expanded(child: buildList(context, 2)) : Container(),
                        widget.model.useWeekDay ? Expanded(child: buildList(context, 3)) : Container(),
                        widget.model.useHour ? Expanded(child: buildList(context, 4)) : Container(),
                        widget.model.useMinute ? Expanded(child: buildList(context, 5)) : Container(),
                        widget.model.useSecond ? Expanded(child: buildList(context, 6)) : Container(),
                      ],
                    )),
                // 蒙层
                Positioned(
                  top: 0,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: _pickerTitleHeight,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                            TDTheme.of(context).whiteColor1,
                            TDTheme.of(context).whiteColor1.withOpacity(0)
                          ])),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: _pickerTitleHeight,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                            TDTheme.of(context).whiteColor1,
                            TDTheme.of(context).whiteColor1.withOpacity(0)
                          ])),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildList(context, int whichLine) {
    /// whichLine参数表示这个列表表示的是年，还是月还是日......
    var maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ScrollConfiguration(
          behavior: NoWaveBehavior(),
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / widget.pickerItemCount,
              diameterRatio: 100,
              controller: widget.model.controllers[whichLine],
              physics: whichLine == 3 ? const NeverScrollableScrollPhysics() : const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                if (whichLine == 0 || whichLine == 1 || whichLine == 2) {
                  // 年月的改变会引起日的改变, 年的改变会引起月的改变
                  setState(() {
                    switch (whichLine) {
                      case 0:
                        widget.model.refreshMonthDataAndController();
                        widget.model.refreshDayDataAndController();
                        if (widget.model.useWeekDay) {
                          widget.model.refreshWeekDayDataAndController();
                        }
                        break;
                      case 1:
                        widget.model.refreshDayDataAndController();
                        if (widget.model.useWeekDay) {
                          widget.model.refreshWeekDayDataAndController();
                        }
                        break;
                      case 2:
                        if (widget.model.useWeekDay) {
                          widget.model.refreshWeekDayDataAndController();
                        }
                        break;
                    }

                    /// 使用动态高度，强制列表组件的state刷新，以展现更新的数据，详见下方链接
                    /// FIX:https://github.com/flutter/flutter/issues/22999
                    pickerHeight = pickerHeight - Random().nextDouble() / 100000000;
                  });
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.model.data[whichLine].length,
                  builder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          index: index,
                          itemHeight: pickerHeight / widget.pickerItemCount,
                          content: whichLine == 3
                              ? widget.model.mapping[whichLine] +
                              widget.model.weekMap[widget.model.data[whichLine][index] - 1]
                              : widget.model.data[whichLine][index].toString() + widget.model.mapping[whichLine],
                          fixedExtentScrollController: widget.model.controllers[whichLine],
                          itemDistanceCalculator: widget.itemDistanceCalculator,
                        ));
                  })),
        ));
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: widget.leftPadding ?? 16, right: widget.rightPadding ?? 16),

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
                        ? widget.model.yearFixedExtentScrollController.selectedItem + widget.model.data[0][0]
                        : -1,
                    'month': widget.model.useMonth
                        ? widget.model.monthFixedExtentScrollController.selectedItem + widget.model.data[1][0]
                        : -1,
                    'day': widget.model.useDay
                        ? widget.model.dayFixedExtentScrollController.selectedItem + widget.model.data[2][0]
                        : -1,
                    'weekDay': widget.model.useWeekDay
                        ? widget.model.weekDayFixedExtentScrollController.selectedItem + widget.model.data[3][0]
                        : -1,
                    'hour': widget.model.useHour ? widget.model.hourFixedExtentScrollController.selectedItem : -1,
                    'minute': widget.model.useMinute ? widget.model.minuteFixedExtentScrollController.selectedItem : -1,
                    'second': widget.model.useSecond ? widget.model.secondFixedExtentScrollController.selectedItem : -1,
                  };
                  widget.onCancel!(selected);
                } else {
                  Navigator.of(context).pop();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: TDText(widget.leftText,
                  style: widget.leftTextStyle ??
                      TextStyle(fontSize: TDTheme.of(context).fontBodyLarge!.size, color: TDTheme.of(context).fontGyColor2))),

          /// 中间title
          Expanded(
            child: Center(
              child: TDText(
                widget.title,
                style: widget.centerTextStyle ??
                    TextStyle(
                      fontSize: 18,
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
                      ? widget.model.yearFixedExtentScrollController.selectedItem + widget.model.data[0][0]
                      : -1,
                  'month': widget.model.useMonth
                      ? widget.model.monthFixedExtentScrollController.selectedItem + widget.model.data[1][0]
                      : -1,
                  'day': widget.model.useDay
                      ? widget.model.dayFixedExtentScrollController.selectedItem + widget.model.data[2][0]
                      : -1,
                  'weekDay': widget.model.useWeekDay
                      ? widget.model.weekDayFixedExtentScrollController.selectedItem + widget.model.data[3][0]
                      : -1,
                  'hour': widget.model.useHour ? widget.model.hourFixedExtentScrollController.selectedItem : -1,
                  'minute': widget.model.useMinute ? widget.model.minuteFixedExtentScrollController.selectedItem : -1,
                  'second': widget.model.useSecond ? widget.model.secondFixedExtentScrollController.selectedItem : -1,
                };
                widget.onConfirm!(selected);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: TDText(
              widget.rightText,
              style: widget.rightTextStyle ??
                  TextStyle(fontSize: TDTheme.of(context).fontBodyLarge!.size, color: TDTheme.of(context).brandNormalColor),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => widget.titleHeight ?? _pickerTitleHeight;
}

// 时间选择器的数据类
class DatePickerModel {
  bool useYear;
  bool useMonth;
  bool useDay;
  bool useWeekDay;
  bool useHour;
  bool useMinute;
  bool useSecond;
  List<int> dateStart;
  List<int> dateEnd;
  List<int>? dateInitial;

  final mapping = ['年', '月', '日', '周', '时', '分', '秒'];
  final weekMap = ['一', '二', '三', '四', '五', '六', '日'];

  late DateTime initialTime;

  /// 这四项随滑动而更新，注意初始化
  late int yearIndex;
  late int monthIndex;
  late int dayIndex;
  late int weekDayIndex;

  late List<List<int>> data = [
    List.generate(dateEnd[0] - dateStart[0] + 1, (index) => index + dateStart[0]),
    [],
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
  late FixedExtentScrollController weekDayFixedExtentScrollController;
  late FixedExtentScrollController hourFixedExtentScrollController;
  late FixedExtentScrollController minuteFixedExtentScrollController;
  late FixedExtentScrollController secondFixedExtentScrollController;

  DatePickerModel(
      {required this.useYear,
        required this.useMonth,
        required this.useDay,
        required this.useHour,
        required this.useMinute,
        required this.useWeekDay,
        required this.useSecond,
        required this.dateStart,
        required this.dateEnd,
        this.dateInitial}) {
    assert(!useWeekDay || (!useSecond && !useMinute && !useHour), 'WeekDay can only used with Year, Month and Day!');
    setInitialTime();
    setInitialMonthData();
    setInitialDayData();
    setInitialWeekDayData();
    setControllers();
    addListener();
  }

  void setInitialTime() {
    var startTime = DateTime(dateStart[0], dateStart[1], dateStart[2], 0, 0, 0);
    var endTime = DateTime(dateEnd[0], dateEnd[1], dateEnd[2], 0, 0, 0);
    if (dateInitial != null) {
      initialTime = DateTime(
          dateInitial![0],
          dateInitial![1],
          dateInitial![2],
          dateInitial!.length > 3 ? dateInitial![3] : 0,
          dateInitial!.length > 4 ? dateInitial![4] : 0,
          dateInitial!.length > 5 ? dateInitial![5] : 0);
      if (initialTime.isBefore(startTime)) {
        initialTime = startTime;
      } else if (initialTime.isAfter(endTime)) {
        initialTime = endTime;
      }
      return;
    }

    var now = DateTime.now();
    if (now.isBefore(startTime)) {
      initialTime = DateTime(dateStart[0], dateStart[1], dateStart[2], now.hour, now.minute, now.second);
    } else if (now.isAfter(endTime)) {
      initialTime = DateTime(dateEnd[0], dateEnd[1], dateEnd[2], now.hour, now.minute, now.second);
    } else {
      initialTime = now;
    }
  }

  void setInitialMonthData() {
    if (dateEnd[0] == dateStart[0]) {
      data[1] = List.generate(dateEnd[1] - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (initialTime.year == dateStart[0]) {
      data[1] = List.generate(12 - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (initialTime.year == dateEnd[0]) {
      data[1] = List.generate(dateEnd[1], (index) => index + 1);
    } else {
      data[1] = List.generate(12, (index) => index + 1);
    }
  }

  void setInitialDayData() {
    if (dateEnd[0] == dateStart[0] && dateEnd[1] == dateStart[1]) {
      data[2] = List.generate(dateEnd[2] - dateStart[2] + 1, (index) => index + dateStart[2]);
    } else if (initialTime.year == dateStart[0] && initialTime.month == dateStart[1]) {
      data[2] = List.generate(
          DateTime(initialTime.year, initialTime.month + 1, 0).day - dateStart[2] + 1, (index) => index + dateStart[2]);
    } else if (initialTime.year == dateEnd[0] && initialTime.month == dateEnd[1]) {
      data[2] = List.generate(dateEnd[2], (index) => index + 1);
    } else {
      data[2] = List.generate(DateTime(initialTime.year, initialTime.month + 1, 0).day, (index) => index + 1);
    }
  }

  void setInitialWeekDayData() {
    data[3] = [1, 2, 3, 4, 5, 6, 7];
  }

  void setControllers() {
    /// 初始化Index
    yearIndex = initialTime.year - data[0][0];
    monthIndex = initialTime.month - data[1][0];
    dayIndex = initialTime.day - data[2][0];
    weekDayIndex = initialTime.weekday - 1;

    controllers = [
      FixedExtentScrollController(initialItem: yearIndex),
      FixedExtentScrollController(initialItem: monthIndex),
      FixedExtentScrollController(initialItem: dayIndex),
      FixedExtentScrollController(initialItem: weekDayIndex),
      FixedExtentScrollController(initialItem: initialTime.hour),
      FixedExtentScrollController(initialItem: initialTime.minute),
      FixedExtentScrollController(initialItem: initialTime.second)
    ];
    yearFixedExtentScrollController = controllers[0];
    monthFixedExtentScrollController = controllers[1];
    dayFixedExtentScrollController = controllers[2];
    weekDayFixedExtentScrollController = controllers[3];
    hourFixedExtentScrollController = controllers[4];
    minuteFixedExtentScrollController = controllers[5];
    secondFixedExtentScrollController = controllers[6];
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
    weekDayFixedExtentScrollController.addListener(() {
      weekDayIndex = weekDayFixedExtentScrollController.selectedItem;
    });
  }

  void refreshMonthDataAndController() {
    var selectedYear = yearIndex + data[0][0];
    if (dateEnd[0] == dateStart[0]) {
      data[1] = List.generate(dateEnd[1] - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (selectedYear == dateStart[0]) {
      data[1] = List.generate(12 - dateStart[1] + 1, (index) => index + dateStart[1]);
    } else if (selectedYear == dateEnd[0]) {
      data[1] = List.generate(dateEnd[1], (index) => index + 1);
    } else {
      data[1] = List.generate(12, (index) => index + 1);
    }
    monthFixedExtentScrollController.jumpToItem(monthIndex > data[1].length - 1 ? data[1].length - 1 : monthIndex);
  }

  void refreshDayDataAndController() {
    /// 在刷新日数据时，年月数据已经是最新的
    var selectedYear = yearIndex + data[0][0];
    var selectedMonth = monthIndex + data[1][0];
    if (dateEnd[0] == dateStart[0] && dateEnd[1] == dateStart[1]) {
      data[2] = List.generate(dateEnd[2] - dateStart[2] + 1, (index) => index + dateStart[2]);
    } else if (selectedYear == dateStart[0] && selectedMonth == dateStart[1]) {
      data[2] = List.generate(
          DateTime(selectedYear, selectedMonth + 1, 0).day - dateStart[2] + 1, (index) => index + dateStart[2]);
    } else if (selectedYear == dateEnd[0] && selectedMonth == dateEnd[1]) {
      data[2] = List.generate(dateEnd[2], (index) => index + 1);
    } else {
      data[2] = List.generate(DateTime(selectedYear, selectedMonth + 1, 0).day, (index) => index + 1);
    }
    dayFixedExtentScrollController.jumpToItem(dayIndex > data[2].length - 1 ? data[2].length - 1 : dayIndex);
  }

  void refreshWeekDayDataAndController() {
    var date = DateTime(data[0][yearFixedExtentScrollController.selectedItem],
        data[1][monthFixedExtentScrollController.selectedItem], data[2][dayFixedExtentScrollController.selectedItem]);
    weekDayFixedExtentScrollController.jumpToItem(date.weekday - 1);
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
