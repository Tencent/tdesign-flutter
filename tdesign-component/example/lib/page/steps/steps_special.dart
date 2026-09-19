part of 'steps_page.dart';

extension _StepsSpecialModule on _TStepsPageState {
  ExampleModule get _stepsSpecialModule => ExampleModule(
    title: '特殊类型',
    children: [
      ExampleItem(
        desc: 'Vertical Customize Steps 垂直自定义步骤条',
        padding: _stepsItemPadding,
        builder: _buildVerticalSelectable,
        methodName: '_buildVerticalSelectable',
      ),
      ExampleItem(
        desc: 'Read-only Steps 纯展示步骤条',
        padding: _stepsItemPadding,
        builder: _buildDisplaySteps,
        methodName: '_buildDisplaySteps',
      ),
    ],
  );
}
