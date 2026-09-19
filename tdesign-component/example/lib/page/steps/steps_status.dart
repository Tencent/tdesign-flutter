part of 'steps_page.dart';

extension _StepsStatusModule on _TStepsPageState {
  ExampleModule get _stepsStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        desc: 'Error 错误状态',
        padding: _stepsItemPadding,
        builder: _buildErrorStates,
        methodName: '_buildErrorStates',
      ),
    ],
  );
}
