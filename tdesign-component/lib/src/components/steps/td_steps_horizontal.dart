import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_horizontal_item.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条，水平步骤
class TDStepsHorizontal extends StatelessWidget {
  final List<TDStepsItemData> steps;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;
  const TDStepsHorizontal({
    super.key,
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
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
          readOnly: readOnly,
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }

}

