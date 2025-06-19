import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

typedef TDTreeSelectChangeEvent = void Function(List<dynamic>, int level);

class TDSelectOption {
  TDSelectOption(
      {required this.label, required this.value, this.children = const [], this.multiple = false});

  /// 标签
  final String label;

  /// 值
  final int value;

  /// 子选项
  List<TDSelectOption> children;

  /// 当前子项支持多选
  final bool multiple;
}

enum TDTreeSelectStyle {
  normal,
  outline,
}

class TDTreeSelect extends StatefulWidget {
  const TDTreeSelect(
      {Key? key,
      this.options = const [],
      this.defaultValue = const [],
      this.onChange,
      this.multiple = false,
      this.style = TDTreeSelectStyle.normal,
      this.height = 336})
      : super(key: key);

  /// 展示的选项列表
  final List<TDSelectOption> options;

  /// 初始值，对应options中的value值
  final List<dynamic> defaultValue;

  /// 选中值发生变化
  final TDTreeSelectChangeEvent? onChange;

  /// 高度
  final double height;

  /// 支持多选
  final bool multiple;

  /// 一级菜单样式
  final TDTreeSelectStyle style;

  @override
  State<TDTreeSelect> createState() => _TDTreeSelectState();
}

class _TDTreeSelectState extends State<TDTreeSelect> {
  ScrollController controller2 = ScrollController();
  ScrollController controller3 = ScrollController();

  List<dynamic> values = [];
  int get currentLevel => values.length + 1;
  int? get firstValue => values.isNotEmpty ? values[0] : null;
  dynamic get secondValue => values.length >= 2 ? values[1] : null;
  dynamic get thirdValue => values.length >= 3 ? values[2] : null;

  List<TDSelectOption> get firstOptions => widget.options;
  List<TDSelectOption> get secondOptions => maxLevel() <= 1 || values.isEmpty
      ? []
      : firstOptions
          .firstWhere((opt) => opt.value == firstValue,
              orElse: () => TDSelectOption(value: -1, label: '', children: []))
          .children;
  List<TDSelectOption> get thirdOptions => maxLevel() <= 2 || currentLevel < 3
      ? []
      : secondOptions
          .firstWhere((opt) => opt.value == secondValue,
              orElse: () => TDSelectOption(value: -1, label: '', children: []))
          .children;

  @override
  void initState() {
    super.initState();

    values = List.from(widget.defaultValue);
    if (values.isEmpty && widget.options.isNotEmpty) {
      final option = widget.options[0];
      values.add((widget.multiple || option.multiple) ? [option.value] : option.value);
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
    return Row(
      children: [
        SizedBox(
          width: 106,
          child: TDSideBar(
            height: widget.height,
            value: firstValue,
            style: widget.style == TDTreeSelectStyle.outline
                ? TDSideBarStyle.outline
                : TDSideBarStyle.normal,
            children: widget.options
                .map((ele) => TDSideBarItem(
                      value: ele.value,
                      label: ele.label,
                    ))
                .toList(),
            onSelected: (value) {
              setState(() {
                if (values.isEmpty) {
                  values.add(value);
                } else {
                  values = [value];
                  if (controller2.hasClients) {
                    controller2.jumpTo(0);
                  }
                }

                if (widget.onChange != null) {
                  widget.onChange!(values, 1);
                }
              });
            },
          ),
        ),
        Expanded(
            child: Container(
          height: widget.height,
          decoration: const BoxDecoration(color: Colors.white),
          child: _buildRightParts(context),
        ))
      ],
    );
  }

  Widget _buildRightParts(BuildContext context) {
    return Visibility(
        visible: maxLevel() >= 2,
        child: maxLevel() == 2
            ? Container(
                child: _buildNextColumn(context, level: 2),
              )
            : Row(
                children: [
                  SizedBox(
                    width: 103,
                    child:
                        _buildNextColumn(context, level: 2, lastColumn: false),
                  ),
                  Expanded(child: _buildNextColumn(context, level: 3))
                ],
              ));
  }

  Widget _buildNextColumn(BuildContext context,
      {int level = 2, bool lastColumn = true}) {
    var displayOptions = level == 2 ? secondOptions : thirdOptions;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView.builder(
            controller: level == 2 ? controller2 : controller3,
            itemExtent: 56,
            itemCount: displayOptions.length,
            itemBuilder: (BuildContext ctx, int index) {
              var currentValue = displayOptions[index].value;
              final isMultiple = widget.multiple ? widget.multiple : displayOptions[index].multiple;
              // 判断是否被选中
              var selected = false;
              if (isMultiple) {
                if (level == 2) {
                  if (maxLevel() == 2) {
                    selected = secondValue != null
                        ? (secondValue as List<int>).contains(currentValue)
                        : false;
                  } else {
                    selected = secondValue == currentValue;
                  }
                } else {
                  selected = thirdValue != null
                      ? (thirdValue as List<int>).contains(currentValue)
                      : false;
                }
              } else {
                selected =
                    (level == 2 ? secondValue : thirdValue) == currentValue;
              }

              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (level == 2) {
                        switch (values.length) {
                          case 1:
                            values.add(isMultiple
                                ? [currentValue]
                                : currentValue);
                            break;
                          case 2:
                            if (isMultiple) {
                              var hasContains = (values[1] as List<int>)
                                  .contains(currentValue);
                              if (hasContains) {
                                (values[1] as List<int>).remove(currentValue);
                              } else {
                                (values[1] as List<int>).add(currentValue);
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
                            values.add(isMultiple
                                ? [currentValue]
                                : currentValue);
                            break;
                          default:
                            if (isMultiple) {
                              var hasContains = (values[2] as List<int>)
                                  .contains(currentValue);
                              if (hasContains) {
                                (values[2] as List<int>).remove(currentValue);
                              } else {
                                (values[2] as List<int>).add(currentValue);
                              }
                            } else {
                              values[2] = currentValue;
                            }
                        }
                      }

                      if (widget.onChange != null) {
                        widget.onChange!(values, level);
                      }
                    });
                  },
                  child: SizedBox(
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, bottom: 16),
                          child: TDText(
                            displayOptions[index].label,
                            textColor: (!lastColumn && selected)
                                ?  TDTheme.of(context).brandNormalColor
                                : const Color.fromRGBO(0, 0, 0, 0.9),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: (!lastColumn && selected)
                                    ? FontWeight.w600
                                    : FontWeight.w400),
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
                                  TDIcons.check,
                                  color: TDTheme.of(context).brandNormalColor,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ));
            }));
  }
}
