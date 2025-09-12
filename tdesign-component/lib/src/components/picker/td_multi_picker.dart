import 'dart:math';

import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

import '../../util/context_extension.dart';
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

  /// 右侧按钮文案
  final String? rightText;

  /// 左侧按钮文案
  final String? leftText;

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

  /// 自定义item构建
  final ItemBuilderType? itemBuilder;

  static const _pickerTitleHeight = 56.0;

  const TDMultiPicker(
      {required this.title,
        required this.onConfirm,
        this.onCancel,
        required this.data,
        required this.pickerHeight,
        required this.pickerItemCount,
        this.initialIndexes,
        this.rightText,
        this.leftText,
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
        this.itemBuilder,
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
      padding: EdgeInsets.only(
        left: leftPadding ?? 16,
        right: rightPadding ?? 16,
        top: topPadding ?? 16,
      ),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: titleDividerColor ?? Colors.transparent,
            )
        ),
      ),
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
                leftText ?? context.resource.cancel,
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
              rightText ?? context.resource.confirm,
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
                        key: UniqueKey(),
                        alignment: Alignment.center,
                        height: pickerHeight / pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          colIndex: position,
                          index: index,
                          key: UniqueKey(),
                          itemHeight: pickerHeight / pickerItemCount,
                          content: data[position][index],
                          itemDistanceCalculator: itemDistanceCalculator,
                          fixedExtentScrollController: controllers[position],
                          itemBuilder: itemBuilder,
                        )
                    );
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

  /// 右侧按钮文案
  final String? rightText;

  /// 左侧按钮文案
  final String? leftText;

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

  /// 自定义item构建
  final ItemBuilderType? itemBuilder;

  /// 是否保留相同选项
  final bool keepSameSelection;

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
    this.rightText,
    this.leftText,
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
    this.itemBuilder,
    this.keepSameSelection = false,
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
      data: widget.data,
      columnNum: widget.columnNum,
      initialData: widget.selectedData,
      keepSameSelection: widget.keepSameSelection,
    );
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
                Padding(//选项
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
    var maxWidth = MediaQuery.of(context).size.width;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollConfiguration(
        behavior: NoWaveBehavior(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            // 滚动到底部加载更多
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent - 10) {
                if (model.loadMoreData(position)) {
                  setState(() {});
                }
              }
            }
            return false;
          },
          child: ListWheelScrollView.useDelegate(
              itemExtent: pickerHeight / widget.pickerItemCount,
              diameterRatio: 100,
              controller: model.controllers[position],
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                if (index >= 0 && index < model.presentData[position].length) {
                  setState(() {
                    model.refreshPresentDataAndController(position, index, false);
                    if (index >= model.presentData[position].length - 5 &&
                        model.hasMoreData[position]) {
                      if (model.loadMoreData(position)) {
                        // 延迟一下再刷新，避免连续setState
                        Future.delayed(Duration(milliseconds: 50), () {
                          if (mounted) setState(() {});
                        });
                      }
                    }
                    pickerHeight = pickerHeight - Random().nextDouble() / 100000000;
                  });
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: model.presentData[position].length +
                      (model.hasMoreData[position] ? 1 : 0),
                  builder: (context, index) {
                    if (index >= model.presentData[position].length) {
                      // 加载更多指示器
                      return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        child: Text('加载中...', style: TextStyle(color: Colors.grey)),
                      );
                    }
                    if (index < 0 || index >= model.presentData[position].length) {
                      return Container();
                    }
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        width: maxWidth,
                        child: TDItemWidget(
                          colIndex: position,
                          index: index,
                          itemHeight: pickerHeight / widget.pickerItemCount,
                          content: model.presentData[position][index].toString(),
                          fixedExtentScrollController: model.controllers[position],
                          itemDistanceCalculator: widget.itemDistanceCalculator,
                          itemBuilder: widget.itemBuilder,
                        ));
                  }
              )
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: widget.leftPadding ?? 16,
        right: widget.rightPadding ?? 16,
        top: widget.topPadding ?? 16,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: widget.titleDividerColor ?? Colors.transparent,
              )
          )
      ),
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
                widget.leftText ?? context.resource.cancel,
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
              widget.rightText ?? context.resource.confirm,
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

  /// 是否保留相同选项
  bool keepSameSelection = false;

  // 添加一个常量定义每页加载数量
  static const int pageSize = 10;
  // 每列的当前页码
  late List<int> currentPages;
  // 每列是否还有更多数据
  late List<bool> hasMoreData;
  // 每列的总数据量
  late List<int> totalCounts;

  MultiLinkedPickerModel({
    required this.data,
    required this.columnNum,
    required List initialData,
    this.keepSameSelection = false,
  }) {
    selectedData = [];
    selectedIndexes = [];
    currentPages = List.generate(columnNum, (_) => 0);
    hasMoreData = List.generate(columnNum, (_) => true);
    totalCounts = List.generate(columnNum, (_) => 0);
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
    controllers.clear();
    presentData.clear();
    for (var i = 0; i < columnNum; ++i) {
      if (i >= presentData.length) {
        presentData.add([placeData]);
      }
      List currentLevelData;
      if (i == 0) {
        currentLevelData = _getNextLevelDataPaginated(0,0);
        if (currentLevelData.isEmpty) {
          currentLevelData = [placeData];
        }
      } else {
        currentLevelData = _getNextLevelDataPaginated(i, 0);
      }
      // 处理选中项
      int selectedIndex = currentLevelData.indexOf(selectedData[i]);
      if (selectedIndex < 0) {
        selectedData[i] = currentLevelData.isNotEmpty ? currentLevelData.first : placeData;
        selectedIndex = 0;
      }
      selectedIndexes[i] = selectedIndex;
      presentData[i] = currentLevelData;
      // 创建控制器
      controllers.add(FixedExtentScrollController(
          initialItem: selectedIndex.clamp(0, currentLevelData.length - 1)
      ));
    }
  }

  List _getNextLevelDataPaginated(int level, int page) {
    try {
      dynamic currentData = data;
      for (int i = 0; i < level; i++) {
        if (currentData is Map && currentData.containsKey(selectedData[i])) {
          currentData = currentData[selectedData[i]];
        } else {
          return [placeData];
        }
      }
      List allData;
      if (currentData is Map) {
        allData = currentData.keys.toList();
      } else if (currentData is List) {
        allData = currentData;
      } else {
        allData = [currentData?.toString() ?? placeData];
      }
      totalCounts[level] = allData.length;
      int start = page * pageSize;
      int end = start + pageSize;
      if (start >= allData.length) return [];
      if (end > allData.length) end = allData.length;
      hasMoreData[level] = end < allData.length;
      return allData.sublist(start, end);
    } catch (e) {
      return [placeData];
    }
  }

  bool loadMoreData(int columnIndex) {
    if (columnIndex >= columnNum || !hasMoreData[columnIndex]) return false;
    List newData;
    int nextPage = currentPages[columnIndex] + 1;
    if (columnIndex == 0) {
      newData = _getNextLevelDataPaginated(0,nextPage);
    } else {
      newData = _getNextLevelDataPaginated(columnIndex, nextPage);
    }
    if (newData.isNotEmpty) {
      presentData[columnIndex].addAll(newData);
      currentPages[columnIndex] = nextPage;
      return true;
    } else {
      hasMoreData[columnIndex] = false;
    }
    return false;
  }

  /// [position] 变动的列
  /// [selectedIndex] 对应选中的index
  /// [jump] 是否需要jumpToItem
  void refreshPresentDataAndController(int position, int selectedIndex, bool jump) {
    // 严格的边界检查
    if (position >= presentData.length ||
        selectedIndex >= presentData[position].length ||
        position >= controllers.length) {
      return;
    }
    selectedIndex = selectedIndex.clamp(0, presentData[position].length - 1);
    var selectValue = presentData[position][selectedIndex];
    selectedData[position] = selectValue;
    selectedIndexes[position] = selectedIndex;
    if (jump) {
      controllers[position].jumpToItem(selectedIndex);
    }
    // 检查是否需要预加载更多数据
    if (selectedIndex >= presentData[position].length - 5 && hasMoreData[position]) {
      loadMoreData(position);
    }
    if (position < columnNum - 1) {
      List nextColumnData;
      if (presentData[position].length == 1 && presentData[position].first == placeData) {
        nextColumnData = [placeData];
      } else {
        nextColumnData = _getNextLevelDataPaginated(position + 1, 0);
        currentPages[position + 1] = 0;
        hasMoreData[position + 1] = true;
      }
      if (nextColumnData.isEmpty) {
        nextColumnData = [placeData];
      }
      while (presentData.length <= position + 1) {
        presentData.add([placeData]);
      }
      presentData[position + 1] = nextColumnData;
      while (controllers.length <= position + 1) {
        controllers.add(FixedExtentScrollController(initialItem: 0));
      }
      refreshPresentDataAndController(position + 1, 0, true);
    }
  }
}
