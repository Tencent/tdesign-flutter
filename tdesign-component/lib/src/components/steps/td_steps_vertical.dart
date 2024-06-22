import 'package:flutter/material.dart';
import 'package:tdesign_flutter/src/components/steps/td_steps_horizontal_item.dart';
import '../../../tdesign_flutter.dart';

/// Steps步骤条，垂直步骤
class TDStepsVertical extends StatelessWidget {
  final List<StepsItemData> steps;
  const TDStepsVertical({super.key, required this.steps,});

  @override
  Widget build(BuildContext context) {
    // final stepsCount = steps.length;
    List<Widget> stepsHorizontalItem = steps.asMap().entries.map((item){
      return Expanded(
        flex: 1,
        child: Container(),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }

}

