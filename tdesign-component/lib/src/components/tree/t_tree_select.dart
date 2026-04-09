import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

typedef TTreeSelectChangeEvent = void Function(List<dynamic>, int level);

class TSelectOption {
  TSelectOption({
    required this.label,
    required this.value,
    this.children = const [],
    this.multiple = false,
    this.maxLines = 1,
    this.columnWidth,
  }) : assert(maxLines > 0, 'maxLines must be greater than 0');

  /// 标签
  final String label;

  /// 值
  final dynamic value;

  /// 子选项
  List<TSelectOption> children;

  /// 当前子项支持多选
  final bool multiple;

  /// 最大显示行数
  final int maxLines;

  /// 自定义宽度，允许用户指定每个选项的宽度
  final double? columnWidth;
}

enum TTreeSelectStyle {
  normal,
  outline,
}

class TTreeSelect extends StatefulWidget {
  const TTreeSelect({
    Key? key,
    this.options = const [],
    this.defaultValue = const [],
    this.onChange,
    this.multiple = false,
    this.style = TTreeSelectStyle.normal,
    this.height = 336,
    this.outwardCornerRadius = 9,
  }) : super(key: key);

  /// 展示的选项列表
  final List<TSelectOption> options;

  /// 初始值，对应options中的value值
  final List<dynamic> defaultValue;

  /// 选中值发生变化
  final TTreeSelectChangeEvent? onChange;

  /// 高度
  final double height;

  /// 支持多选
  final bool multiple;

  /// 一级菜单样式
  final TTreeSelectStyle style;

  /// 一级菜单选中项的外弯折圆角半径，默认为 9
  final double outwardCornerRadius;

  @override
  State<TTreeSelect> createState() => _TTreeSelectState();
}

class _TTreeSelectState extends State<TTreeSelect> {
  ScrollController controller2 = ScrollController();
  ScrollController controller3 = ScrollController();

  List<dynamic> values = [];

  int get currentLevel => values.length + 1;

  dynamic get firstValue => values.isNotEmpty ? values[0] : null;

  dynamic get secondValue => values.length >= 2 ? values[1] : null;

  dynamic get thirdValue => values.length >= 3 ? values[2] : null;

  List<TSelectOption> get firstOptions => widget.options;

  List<TSelectOption> get secondOptions => maxLevel() <= 1 || values.isEmpty
      ? []
      : firstOptions
          .firstWhere((opt) => opt.value == firstValue,
              orElse: () => TSelectOption(value: -1, label: '', children: []))
          .children;

  List<TSelectOption> get thirdOptions => maxLevel() <= 2 || currentLevel < 3
      ? []
      : secondOptions
          .firstWhere((opt) => opt.value == secondValue,
              orElse: () => TSelectOption(value: -1, label: '', children: []))
          .children;

  @override
  void initState() {
    super.initState();

    values = List.from(widget.defaultValue);
    if (values.isEmpty && widget.options.isNotEmpty) {
      final option = widget.options[0];
      values.add(
          (widget.multiple || option.multiple) ? [option.value] : option.value);
    }
  }

  @override
  void dispose() {
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TTreeSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部传入的 defaultValue 发生变化时，更新 values
    if (widget.defaultValue != oldWidget.defaultValue) {
      values = List.from(widget.defaultValue);
    }
  }

  int maxLevel() {
    if (widget.options.isEmpty) {
      return 1;
    }
    var secondLevelOptions = widget.options
        .where((element) => element.children.isNotEmpty)
        .map((ele) => ele.children)
        .toList();
    if (secondLevelOptions.isEmpty) {
      return 1;
    }

    var hasThirdLevel = secondLevelOptions
        .any((list) => list.any((element) => element.children.isNotEmpty));

    return hasThirdLevel ? 3 : 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: TTheme.of(context).bgColorContainer,
        height: widget.height,
        child: Row(
          children: [
            /// 一级菜单
            Container(
              width: _getLevelWidth(widget.options, 1) ?? 106,
              color: TTheme.of(context).bgColorSecondaryContainer,
              child: ListView.builder(
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isSelected = firstValue == option.value;
                  // 判断上一个和下一个选项是否被选中
                  final isPrevSelected = index > 0 &&
                      firstValue == widget.options[index - 1].value;
                  final isNextSelected =
                      index < widget.options.length - 1 &&
                          firstValue == widget.options[index + 1].value;

                  return GestureDetector(
                    onTap: () {
                      // todo 点击一级菜单时直接重置整个 values 数组可能导致二级或三级选择的数据丢失
                      setState(() {
                        if (values.isEmpty) {
                          values.add(option.value);
                        } else {
                          values = [option.value];
                          if (controller2.hasClients) {
                            controller2.jumpTo(0);
                          }
                        }
                        widget.onChange?.call(values, 1);
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? TTheme.of(context).bgColorContainer
                                : null,
                            border: isSelected &&
                                    widget.style == TTreeSelectStyle.outline
                                ? Border(
                                    left: BorderSide(
                                      color:
                                          TTheme.of(context).brandNormalColor,
                                      width: 3,
                                    ),
                                  )
                                : null,
                          ),
                          child: Text(
                            option.label,
                            maxLines: option.maxLines,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:
                                  TTheme.of(context).fontBodyLarge?.size ?? 16,
                              color: isSelected
                                  ? TTheme.of(context).brandNormalColor
                                  : TTheme.of(context).textColorPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        // 未选中项：如果上一个是选中项，在右上角画向外弯折圆角
                        if (!isSelected && isPrevSelected)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CustomPaint(
                              size: Size(widget.outwardCornerRadius, widget.outwardCornerRadius),
                              painter: _OutwardCornerPainter(
                                color:
                                    TTheme.of(context).bgColorContainer,
                                corner: _Corner.topRight,
                              ),
                            ),
                          ),
                        // 未选中项：如果下一个是选中项，在右下角画向外弯折圆角
                        if (!isSelected && isNextSelected)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CustomPaint(
                              size: Size(widget.outwardCornerRadius, widget.outwardCornerRadius),
                              painter: _OutwardCornerPainter(
                                color:
                                    TTheme.of(context).bgColorContainer,
                                corner: _Corner.bottomRight,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// 右侧 二、三级菜单
            Expanded(child: _buildRightParts(context))
          ],
        ));
  }

  Widget _buildRightParts(BuildContext context) {
    // 判断是否应该显示三级菜单
    final showThirdLevel = values.length >= 2 &&
        secondOptions
            .any((opt) => opt.value == secondValue && opt.children.isNotEmpty);

    return Row(
      children: [
        showThirdLevel
            ? SizedBox(
                width: _getLevelWidth(secondOptions, 2) ?? 103,
                child: _buildNextColumn(context, level: 2, lastColumn: false),
              )
            : Expanded(
                child: _buildNextColumn(context, level: 2),
              ),
        if (showThirdLevel)
          // 三级菜单
          _getLevelWidth(thirdOptions, 3) != null
              ? SizedBox(
                  width: _getLevelWidth(thirdOptions, 3),
                  child: _buildNextColumn(context, level: 3),
                )
              : Expanded(
                  child: _buildNextColumn(context, level: 3),
                ),
      ],
    );
  }

  double? _getLevelWidth(List<TSelectOption> options, int level) {
    for (final option in options) {
      if (option.columnWidth != null) {
        return option.columnWidth;
      }
    }
    return null;
  }

  Widget _buildNextColumn(BuildContext context,
      {int level = 2, bool lastColumn = true}) {
    var displayOptions = level == 2 ? secondOptions : thirdOptions;

    return LayoutBuilder(
      builder: (context, constraints) {
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.builder(
            controller: level == 2 ? controller2 : controller3,
            itemCount: displayOptions.length,
            itemBuilder: (BuildContext ctx, int index) {
              var currentValue = displayOptions[index].value;
              final isMultiple = widget.multiple
                  ? widget.multiple
                  : displayOptions[index].multiple;
              final maxLines = displayOptions[index].maxLines;
              var selected = false;
              if (isMultiple) {
                if (level == 2) {
                  if (maxLevel() == 2) {
                    selected = secondValue != null
                        ? (secondValue as List<dynamic>).contains(currentValue)
                        : false;
                  } else {
                    selected = secondValue == currentValue;
                  }
                } else {
                  selected = thirdValue != null
                      ? (thirdValue as List<dynamic>).contains(currentValue)
                      : false;
                }
              } else {
                selected =
                    (level == 2 ? secondValue : thirdValue) == currentValue;
              }

              return Container(
                constraints: BoxConstraints(
                  minHeight: 56,
                  maxWidth: constraints.maxWidth,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    /// todo 逻辑过于冗余，待优化
                    setState(() {
                      if (level == 2) {
                        switch (values.length) {
                          case 1:
                            values.add(
                                isMultiple ? [currentValue] : currentValue);
                            break;
                          case 2:
                            if (isMultiple) {
                              var hasContains = (values[1] as List<dynamic>)
                                  .contains(currentValue);
                              if (hasContains) {
                                (values[1] as List<dynamic>).remove(currentValue);
                              } else {
                                (values[1] as List<dynamic>).add(currentValue);
                              }
                            } else {
                              values[1] = currentValue;
                            }
                            if (controller3.hasClients) {
                              controller3.jumpTo(0);
                            }
                            break;
                          default:
                            values[1] = currentValue;
                            values.removeLast();
                            if (controller3.hasClients) {
                              controller3.jumpTo(0);
                            }
                        }
                      } else {
                        switch (values.length) {
                          case 1:
                          case 2:
                            values.add(
                                isMultiple ? [currentValue] : currentValue);
                            break;
                          default:
                            if (isMultiple) {
                              var hasContains = (values[2] as List<dynamic>)
                                  .contains(currentValue);
                              if (hasContains) {
                                (values[2] as List<dynamic>).remove(currentValue);
                              } else {
                                (values[2] as List<dynamic>).add(currentValue);
                              }
                            } else {
                              values[2] = currentValue;
                            }
                        }
                      }
                      widget.onChange?.call(values, level);
                    });
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 16, bottom: 16),
                            child: Text(
                              displayOptions[index].label,
                              maxLines: maxLines,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: (!lastColumn && selected)
                                    ? TTheme.of(context).brandNormalColor
                                    : TTheme.of(context).textColorPrimary,
                                fontWeight: (!lastColumn && selected)
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: lastColumn && selected,
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                TIcons.check,
                                color: TTheme.of(context).brandNormalColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// 向外弯折圆角的位置枚举
enum _Corner {
  topRight,
  bottomRight,
}

/// 自定义画笔：绘制向外弯折的圆角效果
/// 原理：在选中项的右上角/右下角绘制一个填充色的矩形，然后用白色圆弧挖出一个反向圆角
class _OutwardCornerPainter extends CustomPainter {
  final Color color;
  final _Corner corner;

  _OutwardCornerPainter({required this.color, required this.corner});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final r = size.width;

    switch (corner) {
      case _Corner.topRight:
        // 从右上角开始，画一个矩形区域，然后用圆弧挖出向外弯折的效果
        path.moveTo(0, 0);
        path.lineTo(r, 0);
        path.lineTo(r, r);
        path.arcToPoint(
          Offset(0, 0),
          radius: Radius.circular(r),
          clockwise: false,
        );
        path.close();
        break;
      case _Corner.bottomRight:
        // 从右下角开始，画一个矩形区域，然后用圆弧挖出向外弯折的效果
        path.moveTo(r, 0);
        path.lineTo(r, r);
        path.lineTo(0, r);
        path.arcToPoint(
          Offset(r, 0),
          radius: Radius.circular(r),
          clockwise: false,
        );
        path.close();
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OutwardCornerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.corner != corner;
  }
}
