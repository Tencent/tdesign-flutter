import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_horizontal_item.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条，水平步骤
class TDStepsHorizontal extends StatelessWidget {
  final List<StepsItemData> steps;
  final int activeIndex;
  final StepsStatus status;
  final bool simple;
  const TDStepsHorizontal({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
  });

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;
    List<Widget> stepsHorizontalItem = steps.asMap().entries.map((item){
      return Expanded(
        flex: 1,
        child: TDStepsHorizontalItem(
          index: item.key,
          data: item.value,
          stepsCount: stepsCount,
          activeIndex: activeIndex,
          status: status,
          simple: simple,
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }

}

