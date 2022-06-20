import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import 'no_wave_behavior.dart';
import 'td_item_widget.dart';

typedef MultiPickerCallback = void Function(List<int> selected);

/// 项之间无联动的多项选择器
class TDMultiPicker extends StatelessWidget {
  /// 选择器标题
  final String? title;

  /// 选择器确认按钮回调
  final MultiPickerCallback? onConfirm;

  /// 选择器取消按钮回调
  final MultiPickerCallback? onCancel;

  /// 选择器的数据源
  final List<List<String>> data;

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

  final double? titleHeight;
  final double? topPadding;
  final double? leftPadding;
  final double? rightPadding;
  final Color? titleDividerColor;
  final Color? backgroundColor;
  final double? topRadius;
  final ItemDistanceCalculator? itemDistanceCalculator;

  /// 适配padding
  final EdgeInsets? padding;

  /// 若为null表示全部从零开始
  List<int>? initialIndexes;

  late List<FixedExtentScrollController> controllers;

  TDMultiPicker(
      {required this.title,
      required this.onConfirm,
      this.onCancel,
      required this.data,
      required this.pickerHeight,
      required this.pickerItemCount,
      this.initialIndexes,
      this.leftTextStyle,
      this.rightTextStyle,
      this.centerTextStyle,
      this.titleHeight,
      this.topPadding,
      this.leftPadding,
      this.rightPadding,
      this.titleDividerColor,
      this.backgroundColor,
      this.topRadius,
      this.padding,
      this.itemDistanceCalculator,
      this.customSelectWidget,
      Key? key})
      : super(key: key) {
    int lines = data.length;
    if (initialIndexes == null) {
      initialIndexes = [for (int i = 0; i < lines; i++) 0];
    }
    controllers = [
      for (int i = 0; i < lines; i++)
        FixedExtentScrollController(initialItem: initialIndexes![i])
    ];
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Container(
      width: maxWidth,
      padding: padding ?? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: backgroundColor ?? TDTheme.of(context).whiteColor1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius ?? 0),
          topRight: Radius.circular(topRadius ?? 0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(context),
          Container(
            width: maxWidth,
            height: 0.5,
            color: titleDividerColor ?? TDTheme.of(context).fontGyColor3,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              customSelectWidget?? Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(
                      color: TDTheme.of(context).fontGyColor3, width: 0.5),
                  bottom: BorderSide(
                      color: TDTheme.of(context).fontGyColor3, width: 0.5),
                )),
              ),

              /// 列表
              Container(
                  height: pickerHeight,
                  width: maxWidth,
                  child: Row(
                    children: [
                      for (int i = 0; i < data.length; i++)
                        Expanded(
                          child: buildList(context, i),
                        )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: leftPadding ?? 16, right: rightPadding ?? 16),

      /// 减去分割线的空间
      height: getTitleHeight() - 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 左边按钮
          GestureDetector(
              onTap: () {
                if (onCancel != null) {
                  onCancel!([
                    for (int i = 0; i < controllers.length; i++)
                      controllers[i].selectedItem
                  ]);
                }
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: TDText(
                '取消',
                style: leftTextStyle?? TextStyle(
                  fontSize: TDTheme.of(context).fontM!.size,
                  color: TDTheme.of(context).fontGyColor2
                ),
              )),

          /// 中间title
          Expanded(
            child: title == null
                ? Container()
                : Center(
                    child: TDText(
                      title,
                      style: centerTextStyle ?? TextStyle(
                        fontSize: TDTheme.of(context).fontM!.size,
                        fontWeight: FontWeight.w600,
                        color: TDTheme.of(context).fontGyColor1
                      ),
                    ),
                  ),
          ),

          /// 右边按钮
          GestureDetector(
            onTap: () {
              if (onConfirm != null) {
                onConfirm!([
                  for (int i = 0; i < controllers.length; i++)
                    controllers[i].selectedItem
                ]);
              }
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: TDText(
              '确定',
              style: rightTextStyle?? TextStyle(
                  fontSize: TDTheme.of(context).fontM!.size,
                  color: TDTheme.of(context).brandNormalColor
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => titleHeight ?? 48;

  Widget buildList(context, int whichLine) {
    double maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ScrollConfiguration(
          behavior: NoWaveBehavior(),
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / pickerItemCount,
              diameterRatio: 100,
              controller: controllers[whichLine],
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: data[whichLine].length,
                  builder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          index: index,
                          itemHeight: pickerHeight / pickerItemCount,
                          content: data[whichLine][index],
                          itemDistanceCalculator: itemDistanceCalculator,
                          fixedExtentScrollController: controllers[whichLine],
                        ));
                  })),
        ));
  }
}

/// 多项联动选择器
class TDMultiLinkedPicker extends StatefulWidget {
  /// 选择器标题
  final String? title;

  /// 选择器确认按钮回调
  final MultiPickerCallback? onConfirm;

  /// 选择器取消按钮回调
  final MultiPickerCallback? onCancel;

  /// 若为null表示全部从零开始
  final List<int>? initialIndexes;

  /// 选择器的数据源
  final List<dynamic> data;

  /// 选择器List的视窗高度
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

  final double? titleHeight;
  final double? topPadding;
  final double? leftPadding;
  final double? rightPadding;
  final Color? titleDividerColor;
  final Color? backgroundColor;
  final double? topRadius;
  final ItemDistanceCalculator? itemDistanceCalculator;

  const TDMultiLinkedPicker({
    this.title,
    required this.onConfirm,
    this.onCancel,
    this.initialIndexes,
    required this.data,
    this.pickerHeight = 200,
    this.pickerItemCount = 5,
    this.customSelectWidget,
    this.leftTextStyle,
    this.rightTextStyle,
    this.centerTextStyle,
    this.titleHeight,
    this.topPadding,
    this.leftPadding,
    this.rightPadding,
    this.titleDividerColor,
    this.backgroundColor,
    this.topRadius,
    this.padding,
    this.itemDistanceCalculator,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDMultiLinkedPickerState();
}

class _TDMultiLinkedPickerState extends State<TDMultiLinkedPicker> {
  late MultiLinkedPickerModel model;

  double pickerHeight = 0;

  @override
  void initState() {
    super.initState();
    pickerHeight = widget.pickerHeight;
    model = MultiLinkedPickerModel(
        data: widget.data, initialIndexes: widget.initialIndexes);
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
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
          buildTitle(context),
          Container(
            width: maxWidth,
            height: 0.5,
            color: widget.titleDividerColor ?? TDTheme.of(context).fontGyColor3,
          ),
          Container(
            height: widget.pickerHeight,
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

                /// 列表
                Container(
                    height: pickerHeight,
                    width: maxWidth,
                    child: Row(
                      children: [
                        for (int i = 0; i < widget.data.length; i++)
                          Expanded(
                            child: buildList(context, i),
                          )
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildList(context, int whichLine) {
    /// whichLine参数表示这个第几列
    double maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ScrollConfiguration(
          behavior: NoWaveBehavior(),
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / widget.pickerItemCount,
              diameterRatio: 100,
              controller: model.controllers[whichLine],
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  /// 刷新此列右边的所有数据
                  model.refreshPresentDataAndController(whichLine);

                  /// 使用动态高度，强制列表组件的state刷新，以展现更新的数据，详见下方链接
                  /// FIX:https://github.com/flutter/flutter/issues/22999
                  pickerHeight =
                      pickerHeight - Random().nextDouble() / 100000000;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: model.presentData[whichLine].length,
                  builder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          index: index,
                          itemHeight: pickerHeight / widget.pickerItemCount,
                          content:
                              model.presentData[whichLine][index].toString(),
                          fixedExtentScrollController:
                              model.controllers[whichLine],
                          itemDistanceCalculator: widget.itemDistanceCalculator,
                        ));
                  })),
        ));
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.leftPadding ?? 16, right: widget.rightPadding ?? 16),
      height: getTitleHeight() - 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 左边按钮
          GestureDetector(
              onTap: () {
                if (widget.onCancel != null) {
                  widget.onCancel!([
                    for (int i = 0; i < model.controllers.length; i++)
                      model.controllers[i].selectedItem
                  ]);
                }
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: TDText(
                '取消',
                style: widget.leftTextStyle ?? TextStyle(
                  fontSize: TDTheme.of(context).fontM!.size,
                  color: TDTheme.of(context).fontGyColor2,
                ),
              )),

          /// 中间title
          Expanded(
            child: widget.title == null
                ? Container()
                : Center(
                    child: TDText(
                      widget.title,
                      style: widget.centerTextStyle ?? TextStyle(
                        fontSize: TDTheme.of(context).fontM!.size,
                        fontWeight: FontWeight.w600,
                        color: TDTheme.of(context).fontGyColor1
                      ),
                    ),
                  ),
          ),

          /// 右边按钮
          GestureDetector(
            onTap: () {
              if (widget.onConfirm != null) {
                widget.onConfirm!([
                  for (int i = 0; i < model.controllers.length; i++)
                    model.controllers[i].selectedItem
                ]);
              }
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: TDText(
              '确定',
              style: widget.rightTextStyle ?? TextStyle(
                fontSize: TDTheme.of(context).fontM!.size,
                color: TDTheme.of(context).brandNormalColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => widget.titleHeight ?? 48;
}

class MultiLinkedPickerModel {
  /// 总的数据
  late List<dynamic> data;
  late List<int>? initialIndexes;
  late List<FixedExtentScrollController> controllers;

  /// 每一列展示的数据
  late List<List<String>> presentData;

  MultiLinkedPickerModel({
    required this.data,
    this.initialIndexes,
  }) {
    int lines = data.length;
    if (initialIndexes == null) {
      initialIndexes = [for (int i = 0; i < lines; i++) 0];
    }
    controllers = [
      for (int i = 0; i < lines; i++)
        FixedExtentScrollController(initialItem: initialIndexes![i])
    ];
    setInitialData();
  }

  void setInitialData() {
    presentData = [];
    presentData.add(data[0]);
    for (int i = 1; i < data.length; i++) {
      var temp = data[i];
      for (int j = 0; j < i; j++) {
        temp = temp[initialIndexes![j]];
      }
      presentData.add(temp);
    }
  }

  void refreshPresentDataAndController(int whichline) {
    /// 一列变动，这一列右边所有数据都要变动
    for (int i = whichline + 1; i < data.length; i++) {
      var temp = data[i];
      for (int j = 0; j < i; j++) {
        temp = temp[controllers[j].selectedItem];
      }
      presentData[i] = temp;

      /// 改变数据后立刻改变controller的指向位置，保证下一列在更新数据时获取到正确的位置
      controllers[i].jumpToItem(
          controllers[i].selectedItem > presentData[i].length - 1
              ? presentData[i].length - 1
              : controllers[i].selectedItem);
    }
  }
}
