import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/picker/no_wave_behavior.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter/src/util/string_util.dart';

import 'td_item_widget.dart';

typedef void DatePickerCallback(Map<String, int> selected);

/// 时间选择器
class TDDatePicker extends StatefulWidget {
  final String title; // 选择器标题
  final DatePickerCallback? onConfirm; // 选择器确认按钮回调
  final DatePickerCallback? onCancel; // 选择器取消按钮回调
  final bool useYear;
  final bool useMonth;
  final bool useDay;
  final bool useHour;
  final bool useMinute;
  final bool useSecond;
  final List<int> dateStart;
  final List<int> dateEnd;
  final Color? backgroundColor;
  final Color? titleDividerColor;
  final double? topRadius;
  final double? titleHeight;
  final double? leftPadding;
  final double? rightPadding;

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

  const TDDatePicker(
      {required this.title,
      required this.onConfirm,
      this.onCancel,
      this.backgroundColor,
      this.titleDividerColor,
      this.topRadius,
      this.titleHeight,
      this.leftPadding,
      this.rightPadding,
      this.leftTextStyle,
      this.rightTextStyle,
      this.centerTextStyle,
      this.customSelectWidget,
      required this.useYear,
      required this.useMonth,
      required this.useDay,
      required this.useHour,
      required this.useMinute,
      required this.useSecond,
      this.pickerHeight = 200,
      required this.pickerItemCount,
      required this.dateStart,
      required this.dateEnd,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDDatePickerState();
}

class _TDDatePickerState extends State<TDDatePicker> {
  late DatePickerModel model;

  double pickerHeight = 0;

  @override
  void initState() {
    super.initState();
    pickerHeight = widget.pickerHeight;
    model = DatePickerModel(
        useYear: widget.useYear,
        useMonth: widget.useMonth,
        useDay: widget.useDay,
        useHour: widget.useHour,
        useMinute: widget.useMinute,
        useSecond: widget.useSecond,
        dateStart: widget.dateStart,
        dateEnd: widget.dateEnd);
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Container(
      width: maxWidth,
      height: getTitleHeight() + pickerHeight,
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
          buildTitle(context),
          Container(
            width: maxWidth,
            height: 0.5,
            color: widget.titleDividerColor ?? TDTheme.of(context).fontGyColor3,
          ),
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.customSelectWidget ?? Container(
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(
                        color: TDTheme.of(context).fontGyColor3, width: 0.5),
                    bottom: BorderSide(
                        color: TDTheme.of(context).fontGyColor3, width: 0.5),
                  )),
                ),
                Container(
                    height: pickerHeight,
                    padding: EdgeInsets.only(bottom: 14),
                    width: maxWidth,
                    child: Row(
                      children: [
                        model.useYear
                            ? Expanded(child: buildList(context, 0))
                            : Container(),
                        model.useMonth
                            ? Expanded(child: buildList(context, 1))
                            : Container(),
                        model.useDay
                            ? Expanded(child: buildList(context, 2))
                            : Container(),
                        model.useHour
                            ? Expanded(child: buildList(context, 3))
                            : Container(),
                        model.useMinute
                            ? Expanded(child: buildList(context, 4))
                            : Container(),
                        model.useSecond
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
    double maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ScrollConfiguration(
          behavior: NoWaveBehavior(),
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / widget.pickerItemCount,
              diameterRatio: 100,
              controller: model.controllers[whichline],
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                if (whichline == 0 || whichline == 1) {
                  // 年月的改变会引起日的改变, 年的改变会引起月的改变
                  setState(() {
                    if (whichline == 0) {
                      model.refreshMonthDataAndController();
                    }
                    model.refreshDayDataAndController();

                    /// 使用动态高度，强制列表组件的state刷新，以展现更新的数据，详见下方链接
                    /// FIX:https://github.com/flutter/flutter/issues/22999
                    pickerHeight =
                        pickerHeight - Random().nextDouble() / 100000000;
                  });
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: model.data[whichline].length,
                  builder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          index: index,
                          itemHeight: pickerHeight / widget.pickerItemCount,
                          content: model.data[whichline][index].toString() +
                              model.mapping[whichline],
                          fixedExtentScrollController:
                              model.controllers[whichline],
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
                  Map<String, int> selected = {
                    "year": widget.useYear
                        ? model.yearFixedExtentScrollController.selectedItem +
                            model.data[0][0]
                        : -1,
                    "month": widget.useMonth
                        ? model.monthFixedExtentScrollController.selectedItem +
                            model.data[1][0]
                        : -1,
                    "day": widget.useDay
                        ? model.dayFixedExtentScrollController.selectedItem +
                            model.data[2][0]
                        : -1,
                    "hour": widget.useHour
                        ? model.hourFixedExtentScrollController.selectedItem
                        : -1,
                    "minute": widget.useMinute
                        ? model.minuteFixedExtentScrollController.selectedItem
                        : -1,
                    "second": widget.useSecond
                        ? model.secondFixedExtentScrollController.selectedItem
                        : -1,
                  };
                  widget.onCancel!(selected);
                }
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: TDText(
                "取消",
                  customStyle: widget.leftTextStyle?? TextStyle(
                      fontSize: TDTheme.of(context).fontM!.size,
                      color: TDTheme.of(context).fontGyColor2
                  )
              )),

          /// 中间title
          Expanded(
            child: widget.title == null
                ? Container()
                : Center(
                    child: TDText(
                      widget.title,
                      customStyle: widget.centerTextStyle ?? TextStyle(
                        fontSize: TDTheme.of(context).fontM!.size,
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
                Map<String, int> selected = {
                  "year": widget.useYear
                      ? model.yearFixedExtentScrollController.selectedItem +
                          model.data[0][0]
                      : -1,
                  "month": widget.useMonth
                      ? model.monthFixedExtentScrollController.selectedItem +
                          model.data[1][0]
                      : -1,
                  "day": widget.useDay
                      ? model.dayFixedExtentScrollController.selectedItem +
                          model.data[2][0]
                      : -1,
                  "hour": widget.useHour
                      ? model.hourFixedExtentScrollController.selectedItem
                      : -1,
                  "minute": widget.useMinute
                      ? model.minuteFixedExtentScrollController.selectedItem
                      : -1,
                  "second": widget.useSecond
                      ? model.secondFixedExtentScrollController.selectedItem
                      : -1,
                };
                widget.onConfirm!(selected);
              }
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: TDText(
              "确认",
              customStyle: widget.rightTextStyle?? TextStyle(
                  fontSize: TDTheme.of(context).fontM!.size,
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
  }) {
    setInitialTime();
    setInitialMonthData();
    setInitialDayData();
    setControllers();
    addListener();
  }

  void setInitialTime() {
    DateTime now = DateTime.now();
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
    int selectedYear = yearIndex + data[0][0];
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
    int selectedYear = yearIndex + data[0][0];
    int selectedMonth = monthIndex + data[1][0];
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
}
