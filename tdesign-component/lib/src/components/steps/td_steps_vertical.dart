import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_vertical_item.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条，垂直步骤
class TDStepsVertical extends StatelessWidget {
  final List<TDStepsItemData> steps;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;
  const TDStepsVertical({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    required this.verticalSelect,
  });

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;
    List<Widget> stepsVerticalItem = steps.asMap().entries.map((item){
      return TDStepsVerticalItem(
        index: item.key,
        data: item.value,
        stepsCount: stepsCount,
        activeIndex: activeIndex,
        status: status,
        simple: simple,
        readOnly: readOnly,
        verticalSelect: verticalSelect,
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: stepsVerticalItem,
    );
  }

}

