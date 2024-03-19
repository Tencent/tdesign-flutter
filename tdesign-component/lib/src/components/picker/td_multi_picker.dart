import 'dart:math';

import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

import 'no_wave_behavior.dart';

typedef MultiPickerCallback = void Function(List selected);

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

  /// 标题高度
  final double? titleHeight;

  /// 顶部填充
  final double? topPadding;

  /// 左边填充
  final double? leftPadding;

  /// 右边填充
  final double? rightPadding;

  /// 标题分割线颜色
  final Color? titleDividerColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 顶部圆角
  final double? topRadius;

  /// 不同距离自选项计算策略
  final ItemDistanceCalculator? itemDistanceCalculator;

  /// 适配padding
  final EdgeInsets? padding;

  /// 若为null表示全部从零开始
  final List<int>? initialIndexes;

  static const _pickerTitleHeight = 56.0;

  const TDMultiPicker(
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
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lines = data.length;
    var indexes = initialIndexes ?? [for (var i = 0; i < lines; i++) 0];
    var controllers = <FixedExtentScrollController>[
      for (var i = 0; i < lines; i++)
        FixedExtentScrollController(initialItem: indexes[i])
    ];
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
      width: maxWidth,
      padding: padding ?? EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: backgroundColor ?? TDTheme.of(context).whiteColor1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius ?? TDTheme.of(context).radiusExtraLarge),
          topRight: Radius.circular(topRadius ?? TDTheme.of(context).radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(context, controllers),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: customSelectWidget ?? Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor1,
                      borderRadius: BorderRadius.all(Radius.circular(TDTheme.of(context).radiusDefault))
                  ),
                ),
              ),
              // 列表
              Container(
                padding: const EdgeInsets.only(left: 32, right: 32),
                height: pickerHeight,
                width: maxWidth,
                child: Row(
                  children: [
                    for (var i = 0; i < data.length; i++)
                      Expanded(
                        child: buildList(context, i, controllers),
                      )
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
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [TDTheme.of(context).whiteColor1, TDTheme.of(context).whiteColor1.withOpacity(0)]
                        )
                    ),
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
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [TDTheme.of(context).whiteColor1, TDTheme.of(context).whiteColor1.withOpacity(0)]
                        )
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context, List<FixedExtentScrollController> controllers) {
    return Container(
      padding:
          EdgeInsets.only(left: leftPadding ?? 16, right: rightPadding ?? 16),
      height: getTitleHeight(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 左边按钮
          GestureDetector(
              onTap: () {
                if (onCancel != null) {
                  onCancel!([
                    for (var i = 0; i < controllers.length; i++)
                      controllers[i].selectedItem
                  ]);
                } else {
                  Navigator.of(context).pop();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: TDText(
                '取消',
                style: leftTextStyle?? TextStyle(
                  fontSize: TDTheme.of(context).fontBodyLarge!.size,
                  color: TDTheme.of(context).fontGyColor2
                ),
              )),

          // 中间title
          Expanded(
            child: title == null
                ? Container()
                : Center(
                    child: TDText(
                      title,
                      style: centerTextStyle ?? TextStyle(
                        fontSize: TDTheme.of(context).fontTitleLarge!.size,
                        fontWeight: FontWeight.w600,
                        color: TDTheme.of(context).fontGyColor1
                      ),
                    ),
                  ),
          ),

          // 右边按钮
          GestureDetector(
            onTap: () {
              if (onConfirm != null) {
                onConfirm!([
                  for (var i = 0; i < controllers.length; i++)
                    controllers[i].selectedItem
                ]);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: TDText(
              '确定',
              style: rightTextStyle?? TextStyle(
                  fontSize: TDTheme.of(context).fontBodyLarge!.size,
                  color: TDTheme.of(context).brandNormalColor
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => titleHeight ?? _pickerTitleHeight;

  Widget buildList(context, int position, List<FixedExtentScrollController> controllers) {
    var maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ScrollConfiguration(
          behavior: NoWaveBehavior(),
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / pickerItemCount,
              diameterRatio: 100,
              controller: controllers[position],
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: data[position].length,
                  builder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          index: index,
                          itemHeight: pickerHeight / pickerItemCount,
                          content: data[position][index],
                          itemDistanceCalculator: itemDistanceCalculator,
                          fixedExtentScrollController: controllers[position],
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

  /// 选中数据
  final List selectedData;

  /// 选择器的数据源
  final Map data;

  /// 最大列数
  final int columnNum;

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

  /// 标题高度
  final double? titleHeight;

  /// 顶部填充
  final double? topPadding;

  /// 左边填充
  final double? leftPadding;

  /// 右边填充
  final double? rightPadding;

  /// 标题分割线颜色
  final Color? titleDividerColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 顶部圆角
  final double? topRadius;

  /// 不同距离自选项计算策略
  final ItemDistanceCalculator? itemDistanceCalculator;

  const TDMultiLinkedPicker({
    this.title,
    required this.onConfirm,
    this.onCancel,
    required this.selectedData,
    required this.data,
    required this.columnNum,
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

  static const _pickerTitleHeight = 56.0;

  @override
  void initState() {
    super.initState();
    pickerHeight = widget.pickerHeight;
    model = MultiLinkedPickerModel(
        data: widget.data, columnNum: widget.columnNum, initialData: widget.selectedData);
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
          buildTitle(context),
          SizedBox(
            height: widget.pickerHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: widget.customSelectWidget ?? Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: TDTheme.of(context).grayColor1,
                        borderRadius: BorderRadius.all(Radius.circular(TDTheme.of(context).radiusDefault))
                    ),
                  ),
                ),

                // 列表
                Container(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    height: pickerHeight,
                    width: maxWidth,
                    child: Row(
                      children: [
                        for (var i = 0; i < widget.columnNum; i++)
                          Expanded(
                            child: buildList(context, i),
                          )
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
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [TDTheme.of(context).whiteColor1, TDTheme.of(context).whiteColor1.withOpacity(0)]
                          )
                      ),
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
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [TDTheme.of(context).whiteColor1, TDTheme.of(context).whiteColor1.withOpacity(0)]
                          )
                      ),
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

  Widget buildList(context, int position) {
    // position参数表示这个第几列
    var maxWidth = MediaQuery.of(context).size.width;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ScrollConfiguration(
          behavior: NoWaveBehavior(),
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / widget.pickerItemCount,
              diameterRatio: 100,
              controller: model.controllers[position],
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  // 刷新此列右边的所有数据
                  model.refreshPresentDataAndController(position, index, false);

                  // 使用动态高度，强制列表组件的state刷新，以展现更新的数据，详见下方链接
                  // FIX:https://github.com/flutter/flutter/issues/22999
                  pickerHeight =
                      pickerHeight - Random().nextDouble() / 100000000;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: model.presentData[position].length,
                  builder: (context, index) {
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          index: index,
                          itemHeight: pickerHeight / widget.pickerItemCount,
                          content:
                              model.presentData[position][index].toString(),
                          fixedExtentScrollController:
                              model.controllers[position],
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
          // 左边按钮
          GestureDetector(
              onTap: () {
                if (widget.onCancel != null) {
                  widget.onCancel!(model.selectedData);
                } else {
                  Navigator.of(context).pop();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: TDText(
                '取消',
                style: widget.leftTextStyle ?? TextStyle(
                  fontSize: TDTheme.of(context).fontBodyLarge!.size,
                  color: TDTheme.of(context).fontGyColor2,
                ),
              )),

          // 中间title
          Expanded(
            child: widget.title == null
                ? Container()
                : Center(
                    child: TDText(
                      widget.title,
                      style: widget.centerTextStyle ?? TextStyle(
                        fontSize: TDTheme.of(context).fontTitleLarge!.size,
                        fontWeight: FontWeight.w700,
                        color: TDTheme.of(context).fontGyColor1
                      ),
                    ),
                  ),
          ),

          // 右边按钮
          GestureDetector(
            onTap: () {
              if (widget.onConfirm != null) {
                widget.onConfirm!(model.selectedData);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: TDText(
              '确定',
              style: widget.rightTextStyle ?? TextStyle(
                fontSize: TDTheme.of(context).fontBodyLarge!.size,
                color: TDTheme.of(context).brandNormalColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => widget.titleHeight ?? _pickerTitleHeight;
}

class MultiLinkedPickerModel {
  /// 占位字符
  static const placeData = '';

  /// 总的数据
  late Map data;

  /// 选中数据下标
  late List<int> selectedIndexes;

  /// 总列数
  late int columnNum;

  /// 选中数据
  late List selectedData;

  late List<FixedExtentScrollController> controllers = [];

  /// 每一列展示的数据
  late List<List> presentData = [];

  MultiLinkedPickerModel({
    required this.data,
    required this.columnNum,
    required List initialData,
  }) {
    selectedData = [];
    selectedIndexes = [];
    for (var i = 0; i < columnNum; ++i) {
      if (i >= initialData.length) {
        selectedData.add('');
      } else {
        selectedData.add(initialData[i]);
      }
      selectedIndexes.add(0);
    }
    _init(initialData);
  }

  void _init(List initialData) {
    int pIndex;
    controllers.clear();
    presentData.clear();
    for (var i = 0; i < columnNum; ++i) {
      pIndex = 0;
      if (i == 0) {
        // 第一列
        pIndex = data.keys.toList().indexOf(selectedData[i]);
        if (pIndex < 0) {
          selectedData[i] = data.keys.first;
          pIndex = 0;
        }
        selectedIndexes[i] = pIndex;
        presentData.add(data.keys.toList());
      } else {
        // 其他列
        dynamic date = findNextData(i);
        if (date is Map) {
          pIndex = date.keys.toList().indexOf(selectedData[i]);
          if (pIndex < 0) {
            selectedData[i] = date.keys.first;
            pIndex = 0;
          }
          presentData.add(date.keys.toList());
        } else if (date is List) {
          pIndex = date.indexOf(selectedData[i]);
          if (pIndex < 0) {
            selectedData[i] = date.first;
            pIndex = 0;
          }
          presentData.add(date);
        } else {
          selectedData[i] = date;
          pIndex = 0;
          presentData.add([date]);
        }
        selectedIndexes[i] = pIndex;
      }
      controllers.add(FixedExtentScrollController(initialItem: pIndex));
    }
  }
  /// 对应位置的下一列数据
  dynamic findNextData(int position) {
    dynamic nextData;
    for (var i = 0; i < position; i++) {
      if (i == 0) {
        nextData = data[selectedData[0]];
      } else {
        dynamic data = nextData[selectedData[i]];
        if (data is Map) {
          nextData = data;
        } else if (data is List) {
          nextData = data;
        } else {
          nextData = [data];
        }
      }
      if (!(nextData is Map) && (i < position - 1)) {
        return [placeData];
      }
    }
    return nextData;
  }

  /// [position] 变动的列
  /// [selectedIndex] 对应选中的index
  /// [jump] 是否需要jumpToItem
  void refreshPresentDataAndController(int position, int selectedIndex, bool jump) {
    // 新选中的数据
    var selectValue = presentData[position][selectedIndex];
    // 更新选中的数据
    selectedData[position] = selectValue;
    selectedIndexes[position] = selectedIndex;
    if (jump) {
      controllers[position].jumpToItem(selectedIndex);
    }
    // 如果不是最后一列 数据的变动都会造成剩下列的更新
    if (position < columnNum - 1) {
      if (presentData[position].length == 1 && presentData[position].first == placeData) {
        presentData[position + 1] = [placeData];
      } else {
        presentData[position + 1] = findColumnData(position + 1);
      }
      refreshPresentDataAndController(position + 1, 0, true);
    }
  }

  /// 寻找对应位置数据
  List findColumnData(int position) {
    dynamic nextData;
    for (var i = 0; i < position; i++) {
      if (i == 0) {
        nextData = data[selectedData[0]];
      } else {
        dynamic data = nextData[selectedData[i]];
        if (data is Map) {
          nextData = data;
        } else if (data is List) {
          nextData = data;
        } else {
          nextData = [data];
        }
      }
      // 如果是map并且是最后一列 返回对应key
      if ((nextData is Map) && (i == position - 1)) {
        return nextData.keys.toList();
      }

      // 如果数据还没有到最后就已经不是Map
      if (!(nextData is Map) && (i < position - 1)) {
        return [placeData];
      }
    }
    return nextData;
  }

}
