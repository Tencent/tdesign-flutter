import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_steps_vertical_item.dart';

/// Steps步骤条，垂直步骤
class TStepsVertical extends StatelessWidget {
  final List<TStepsItemData> steps;
  final int activeIndex;
  final TStepsStatus status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;

  const TStepsVertical({
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
    List<Widget> stepsVerticalItem = steps.asMap().entries.map((item) {
      return TStepsVerticalItem(
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
