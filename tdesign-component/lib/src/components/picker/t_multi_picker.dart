import 'dart:math';

import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

import '../../util/context_extension.dart';
import 'no_wave_behavior.dart';

typedef MultiPickerCallback = void Function(List selected);

/// 列选项变化时的回调类型
/// [columnIndex] 发生变化的列索引
/// [selectedData] 当前各列已选中的数据
/// 返回值：columnIndex+1 列需要展示的新数据列表
typedef LinkedPickerColumnChangedCallback = Future<List> Function(
  int columnIndex,
  List selectedData,
);

/// 项之间无联动的多项选择器
class TMultiPicker extends StatelessWidget {
  /// 选择器标题
  final String? title;

  /// 选择器确认按钮回调
  final MultiPickerCallback? onConfirm;

  /// 选择器取消按钮回调
  final MultiPickerCallback? onCancel;

  /// todo 选择器数据改变时回调
  final MultiPickerCallback? onChange;

  /// 选择器的数据源
  final List<List<String>> data;

  /// 选择器List的视窗高度，默认200
  final double pickerHeight;

  /// 选择器List视窗中item个数，pickerHeight / pickerItemCount，即item高度
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

  /// 是否显示头部内容
  final bool header;

  static const _pickerTitleHeight = 56.0;

  const TMultiPicker({
    this.title,
    required this.onConfirm,
    this.onCancel,
    this.onChange,
    required this.data,
    this.pickerHeight = 200,
    this.pickerItemCount = 5,
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
    this.header = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataLength = data.length;

    var indexes = initialIndexes ?? List.generate(dataLength, (i) => 0);

    var controllers = List.generate(
      dataLength,
      (i) => FixedExtentScrollController(initialItem: indexes[i]),
    );

    final maxWidth = MediaQuery.of(context).size.width;

    return Container(
      width: maxWidth,
      padding: padding ??
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: backgroundColor ?? TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
              topRadius ?? TTheme.of(context).radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header) _buildHeader(context, controllers),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: customSelectWidget ??
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: TTheme.of(context).bgColorSecondaryContainer,
                        borderRadius: BorderRadius.all(
                            Radius.circular(TTheme.of(context).radiusDefault)),
                      ),
                    ),
              ),
              // 列表
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                height: pickerHeight,
                width: maxWidth,
                child: Row(
                  children: List.generate(
                    dataLength,
                    (i) => Expanded(child: _buildList(context, i, controllers)),
                  ),
                ),
              ),
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
                        colors: [
                          TTheme.of(context).bgColorContainer,
                          TTheme.of(context).bgColorContainer.withOpacity(0)
                        ],
                      ),
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
                        colors: [
                          TTheme.of(context).bgColorContainer,
                          TTheme.of(context).bgColorContainer.withOpacity(0)
                        ],
                      ),
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

  Widget _buildHeader(
    BuildContext context,
    List<FixedExtentScrollController> controllers,
  ) {
    final padding = TTheme.of(context).spacer16;

    return Container(
      padding: EdgeInsets.only(
        left: leftPadding ?? padding,
        right: rightPadding ?? padding,
        top: topPadding ?? padding,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: titleDividerColor ?? Colors.transparent,
          ),
        ),
      ),
      height: getTitleHeight(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 左边按钮
          GestureDetector(
              onTap: () {
                if (onCancel != null) {
                  onCancel!(controllers
                      .map((controller) => controller.selectedItem)
                      .toList());
                } else {
                  Navigator.of(context).pop();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: TText(
                leftText ?? context.resource.cancel,
                style: leftTextStyle ??
                    TextStyle(
                        fontSize: TTheme.of(context).fontBodyLarge!.size,
                        color: TTheme.of(context).textColorSecondary),
              )),

          /// 中间title
          Expanded(
            child: Center(
              child: TText(
                title ?? '',
                style: centerTextStyle ??
                    TextStyle(
                        fontSize: TTheme.of(context).fontTitleLarge!.size,
                        fontWeight: FontWeight.w600,
                        color: TTheme.of(context).textColorPrimary),
              ),
            ),
          ),

          // 右边按钮
          GestureDetector(
            onTap: () {
              if (onConfirm != null) {
                onConfirm!(controllers
                    .map((controller) => controller.selectedItem)
                    .toList());
              }
            },
            behavior: HitTestBehavior.opaque,
            child: TText(
              rightText ?? context.resource.confirm,
              style: rightTextStyle ??
                  TextStyle(
                      fontSize: TTheme.of(context).fontBodyLarge!.size,
                      color: TTheme.of(context).brandNormalColor),
            ),
          ),
        ],
      ),
    );
  }

  double getTitleHeight() => titleHeight ?? _pickerTitleHeight;

  Widget _buildList(
    context,
    int position,
    List<FixedExtentScrollController> controllers,
  ) {
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
                        child: TItemWidget(
                          colIndex: position,
                          index: index,
                          key: UniqueKey(),
                          itemHeight: pickerHeight / pickerItemCount,
                          content: data[position][index],
                          itemDistanceCalculator: itemDistanceCalculator,
                          fixedExtentScrollController: controllers[position],
                          itemBuilder: itemBuilder,
                        ));
                  })),
        ));
  }
}

/// 多项联动选择器
class TMultiLinkedPicker extends StatefulWidget {
  /// 选择器标题
  final String? title;

  /// 选择器确认按钮回调
  final MultiPickerCallback? onConfirm;

  /// 选择器取消按钮回调
  final MultiPickerCallback? onCancel;

  /// todo 选择器数据改变时回调
  final MultiPickerCallback? onChange;

  /// 选中数据
  final List selectedData;

  /// 选择器的数据源
  final Map data;

  /// 最大列数
  final int columnNum;

  /// 选择器List的视窗高度
  final double pickerHeight;

  /// 选择器List视窗中item个数，pickerHeight / pickerItemCount，即item高度
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

  /// 是否显示头部内容
  final bool header;

  /// 列选项变化时的回调，用于动态加载下一列数据
  ///
  /// 当第 [columnIndex] 列选项发生变化时，调用此回调获取第 [columnIndex]+1 列的数据。
  /// 若不提供，则沿用 [data] Map 中的数据（向后兼容）。
  final LinkedPickerColumnChangedCallback? onColumnChanged;

  const TMultiLinkedPicker({
    this.title,
    required this.onConfirm,
    this.onCancel,
    this.onChange,
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
    this.header = true,
    this.onColumnChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TMultiLinkedPickerState();
}

class _TMultiLinkedPickerState extends State<TMultiLinkedPicker> {
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
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      width: maxWidth,
      padding: widget.padding ??
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
              widget.topRadius ?? TTheme.of(context).radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.header) _buildHeader(context),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.customSelectWidget ??
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: TTheme.of(context).bgColorSecondaryContainer,
                          borderRadius: BorderRadius.all(Radius.circular(
                              TTheme.of(context).radiusDefault))),
                    ),
              ),

              // 列表
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  height: pickerHeight,
                  width: maxWidth,
                  child: Row(
                    children: List.generate(
                      widget.columnNum,
                      (i) => Expanded(child: buildList(context, i)),
                    ),
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
                        colors: [
                          TTheme.of(context).bgColorContainer,
                          TTheme.of(context).bgColorContainer.withOpacity(0)
                        ],
                      ),
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
                        colors: [
                          TTheme.of(context).bgColorContainer,
                          TTheme.of(context).bgColorContainer.withOpacity(0)
                        ],
                      ),
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

  Widget buildList(context, int position) {
    // position参数表示这个第几列
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
                  final hasCallback = widget.onColumnChanged != null &&
                      position < widget.columnNum - 1;
                  setState(() {
                    model.refreshPresentDataAndController(
                      position,
                      index,
                      false,
                      cascadeNext: !hasCallback,
                    );
                    if (index >= model.presentData[position].length - 5 &&
                        model.hasMoreData[position]) {
                      if (model.loadMoreData(position)) {
                        // 延迟一下再刷新，避免连续setState
                        Future.delayed(const Duration(milliseconds: 50), () {
                          if (mounted) {
                            setState(() {});
                          }
                        });
                      }
                    }

                    /// todo 通过随机数改变高度来触发UI刷新，这是hack式的解决方案！有待优化！
                    /// fix https://github.com/flutter/flutter/issues/22999
                    pickerHeight =
                        pickerHeight - Random().nextDouble() / 100000000;
                  });

                  if (hasCallback) {
                    _loadNextColumnData(position);
                  }
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                  childCount: model.presentData[position].length +
                      (model.hasMoreData[position] ? 1 : 0),
                  builder: (context, index) {
                    // 展示加载中占位
                    if (model.isLoading[position] &&
                        index == 0 &&
                        model.presentData[position].length == 1 &&
                        model.presentData[position].first ==
                            MultiLinkedPickerModel.placeData) {
                      return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        child: Text(
                          context.resource.loadingWithPoint,
                          style: TextStyle(
                            color: TTheme.of(context).textColorPlaceholder,
                          ),
                        ),
                      );
                    }
                    if (index >= model.presentData[position].length) {
                      // 加载更多指示器
                      return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        child: Text(
                          context.resource.loadingWithPoint,
                          style: TextStyle(
                            color: TTheme.of(context).textColorPlaceholder,
                          ),
                        ),
                      );
                    }
                    if (index < 0 ||
                        index >= model.presentData[position].length) {
                      return Container();
                    }
                    return Container(
                        alignment: Alignment.center,
                        height: pickerHeight / widget.pickerItemCount,
                        width: maxWidth,
                        child: TItemWidget(
                          colIndex: position,
                          index: index,
                          itemHeight: pickerHeight / widget.pickerItemCount,
                          content:
                              model.presentData[position][index].toString(),
                          fixedExtentScrollController:
                              model.controllers[position],
                          itemDistanceCalculator: widget.itemDistanceCalculator,
                          itemBuilder: widget.itemBuilder,
                        ));
                  })),
        ),
      ),
    );
  }

  /// 调用 [widget.onColumnChanged] 异步加载下一列数据
  Future<void> _loadNextColumnData(int columnIndex) async {
    final nextColumn = columnIndex + 1;
    setState(() {
      model.resetColumnsAfter(columnIndex);
      model.setLoading(nextColumn, true);
    });
    try {
      final newData =
          await widget.onColumnChanged!(columnIndex, model.selectedData);
      if (!mounted) return;
      setState(() {
        model.updateColumnData(nextColumn, newData);
        model.setLoading(nextColumn, false);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        model.updateColumnData(nextColumn, []);
        model.setLoading(nextColumn, false);
      });
    }
  }

  Widget _buildHeader(BuildContext context) {
    final padding = TTheme.of(context).spacer16;

    return Container(
      padding: EdgeInsets.only(
        left: widget.leftPadding ?? padding,
        right: widget.rightPadding ?? padding,
        top: widget.topPadding ?? padding,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: widget.titleDividerColor ?? Colors.transparent,
          ),
        ),
      ),
      height: getTitleHeight() - 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 左边按钮
          GestureDetector(
              onTap: () {
                if (widget.onCancel != null) {
                  widget.onCancel!(model.selectedData);
                } else {
                  Navigator.of(context).pop();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: TText(
                widget.leftText ?? context.resource.cancel,
                style: widget.leftTextStyle ??
                    TextStyle(
                      fontSize: TTheme.of(context).fontBodyLarge!.size,
                      color: TTheme.of(context).textColorSecondary,
                    ),
              )),

          /// 中间title
          Expanded(
            child: Center(
              child: TText(
                widget.title ?? '',
                style: widget.centerTextStyle ??
                    TextStyle(
                      fontSize: TTheme.of(context).fontTitleLarge!.size,
                      fontWeight: FontWeight.w700,
                      color: TTheme.of(context).textColorPrimary,
                    ),
              ),
            ),
          ),

          /// 右边按钮
          GestureDetector(
            onTap: () {
              if (widget.onConfirm != null) {
                widget.onConfirm!(model.selectedData);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: TText(
              widget.rightText ?? context.resource.confirm,
              style: widget.rightTextStyle ??
                  TextStyle(
                    fontSize: TTheme.of(context).fontBodyLarge!.size,
                    color: TTheme.of(context).brandNormalColor,
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

  /// 添加一个常量定义每页加载数量
  static const int pageSize = 10;

  /// 每列的当前页码
  late List<int> currentPages;

  /// 每列是否还有更多数据
  late List<bool> hasMoreData;

  /// 每列的总数据量
  late List<int> totalCounts;

  /// 每列是否正在异步加载数据
  late List<bool> isLoading;

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
    isLoading = List.generate(columnNum, (_) => false);
    for (var i = 0; i < columnNum; ++i) {
      if (i >= initialData.length) {
        selectedData.add('');
      } else {
        selectedData.add(initialData[i]?.toString() ?? '');
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
        currentLevelData = _getNextLevelDataPaginated(0, 0);
        if (currentLevelData.isEmpty) {
          currentLevelData = [placeData];
        }
      } else {
        currentLevelData = _getNextLevelDataPaginated(i, 0);
      }
      // 处理选中项
      var selectedIndex = currentLevelData.indexOf(selectedData[i]);
      if (selectedIndex < 0) {
        selectedData[i] =
            currentLevelData.isNotEmpty ? currentLevelData.first : placeData;
        selectedIndex = 0;
      }
      selectedIndexes[i] = selectedIndex;
      presentData[i] = currentLevelData;
      // 创建控制器
      controllers.add(FixedExtentScrollController(
          initialItem: selectedIndex.clamp(0, currentLevelData.length - 1)));
    }
  }

  List _getNextLevelDataPaginated(int level, int page) {
    try {
      dynamic currentData = data;
      for (var i = 0; i < level; i++) {
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
      if (start >= allData.length) {
        return [];
      }
      if (end > allData.length) {
        end = allData.length;
      }
      hasMoreData[level] = end < allData.length;
      return allData.sublist(start, end);
    } catch (e) {
      return [placeData];
    }
  }

  bool loadMoreData(int columnIndex) {
    if (columnIndex >= columnNum || !hasMoreData[columnIndex]) {
      return false;
    }
    List newData;
    int nextPage = currentPages[columnIndex] + 1;
    if (columnIndex == 0) {
      newData = _getNextLevelDataPaginated(0, nextPage);
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
  /// [cascadeNext] 是否自动级联更新后续列（默认 true）；
  ///   传 false 时仅更新当前列的选中状态，后续列由外部的 [LinkedPickerColumnChangedCallback] 负责
  void refreshPresentDataAndController(
    int position,
    int selectedIndex,
    bool jump, {
    bool cascadeNext = true,
  }) {
    // 严格的边界检查
    if (position >= presentData.length ||
        selectedIndex >= presentData[position].length ||
        position >= controllers.length) {
      return;
    }
    selectedIndex = selectedIndex.clamp(0, presentData[position].length - 1);
    var selectValue = presentData[position][selectedIndex];
    // 更新选中的数据
    selectedData[position] = selectValue;
    selectedIndexes[position] = selectedIndex;
    if (jump) {
      controllers[position].jumpToItem(selectedIndex);
    }
    // 检查是否需要预加载更多数据
    if (selectedIndex >= presentData[position].length - 5 &&
        hasMoreData[position]) {
      loadMoreData(position);
    }
    if (cascadeNext && position < columnNum - 1) {
      List nextColumnData;
      if (presentData[position].length == 1 &&
          presentData[position].first == placeData) {
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

  /// 将 [columnIndex] 之后的所有列重置为占位状态
  /// 重置后 hasMoreData 设为 false，避免在动态加载期间额外展示"加载更多"指示器
  void resetColumnsAfter(int columnIndex) {
    for (var i = columnIndex + 1; i < columnNum; i++) {
      while (presentData.length <= i) {
        presentData.add([placeData]);
      }
      presentData[i] = [placeData];
      currentPages[i] = 0;
      hasMoreData[i] = false;
      if (i < controllers.length) {
        controllers[i].jumpToItem(0);
      }
    }
  }

  /// 将 [columnIndex] 列的展示数据更新为 [newData]
  ///
  /// 若 [newData] 为空，则使用占位符 [placeData]。
  /// 同时将该列 controller 重置到第 0 项。
  void updateColumnData(int columnIndex, List newData) {
    while (presentData.length <= columnIndex) {
      presentData.add([placeData]);
    }
    final data = newData.isEmpty ? [placeData] : newData;
    presentData[columnIndex] = data;
    currentPages[columnIndex] = 0;
    hasMoreData[columnIndex] = false;
    while (controllers.length <= columnIndex) {
      controllers.add(FixedExtentScrollController(initialItem: 0));
    }
    controllers[columnIndex].jumpToItem(0);
    if (columnIndex < selectedData.length) {
      selectedData[columnIndex] =
          data.isNotEmpty ? data.first : placeData;
      selectedIndexes[columnIndex] = 0;
    }
  }

  /// 设置 [columnIndex] 列的加载状态
  void setLoading(int columnIndex, bool loading) {
    if (columnIndex >= 0 && columnIndex < columnNum) {
      isLoading[columnIndex] = loading;
    }
  }
}
