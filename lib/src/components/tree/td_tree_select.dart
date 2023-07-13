import 'package:flutter/material.dart';
import '../../../td_export.dart';

typedef TDTreeSelectChangeEvent = void Function(List<int>, int level);

class TDSelectOption {
  TDSelectOption(
      {required this.label, required this.value, this.children = const []});

  final String label;
  final int value;
  List<TDSelectOption> children;
}

class TDTreeSelect extends StatefulWidget {
  const TDTreeSelect(
      {Key? key,
      this.options = const [],
      this.value = const [],
      this.onChange,
      this.height = 336})
      : super(key: key);

  /// 展示的选项列表
  final List<TDSelectOption> options;

  /// 初始值，对应options中的value值
  final List<int> value;

  /// 选中值发生变化
  final TDTreeSelectChangeEvent? onChange;

  /// 高度
  final double height;

  @override
  State<TDTreeSelect> createState() => _TDTreeSelectState();
}

class _TDTreeSelectState extends State<TDTreeSelect> {
  ScrollController controller2 = ScrollController();
  ScrollController controller3 = ScrollController();

  List<int> values = [];
  int get currentLevel => values.length + 1;
  int? get firstValue => values.isNotEmpty ? values[0] : null;
  int? get secondValue => values.length >= 2 ? values[1] : null;
  int? get thirdValue => values.length >= 3 ? values[2] : null;

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

    values = List.from(widget.value);
  }

  int maxLevel() {
    if (widget.options.isEmpty) {
      return 1;
    }

    var secondLevelOptions = widget.options
        .takeWhile((element) => element.children.isNotEmpty)
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
                  controller2.jumpTo(0);
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
              var selected = (level == 2 ? secondValue : thirdValue) ==
                  displayOptions[index].value;

              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (level == 2) {
                        switch (values.length) {
                          case 1:
                            values.add(displayOptions[index].value);
                            break;
                          case 2:
                            values[1] = displayOptions[index].value;
                            controller3.jumpTo(0);
                            break;
                          default:
                            values[1] = displayOptions[index].value;
                            values.removeLast();
                            controller3.jumpTo(0);
                        }
                      } else {
                        switch (values.length) {
                          case 1:
                          case 2:
                            values.add(displayOptions[index].value);
                            break;
                          default:
                            values[2] = displayOptions[index].value;
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
                            textColor: !lastColumn && selected
                                ? const Color.fromRGBO(0, 82, 217, 1)
                                : const Color.fromRGBO(0, 0, 0, 0.9),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Visibility(
                            visible: lastColumn && selected,
                            child: const SizedBox(
                              width: 56,
                              height: 56,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  TDIcons.check,
                                  color: Color.fromRGBO(0, 82, 217, 1),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ));
            }));
  }
}
