part of 'stepper_page.dart';

extension _StepperStatusModule on _TStepperPageState {
  ExampleModule get _stepperStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        desc: '最大最小状态',
        center: false,
        methodName: 'StepperBoundsExample',
        builder: (_) => _container(const StepperBoundsExample()),
      ),
      ExampleItem(
        desc: '禁用状态',
        center: false,
        methodName: 'StepperDisabledExample',
        builder: (_) => _container(const StepperDisabledExample()),
      ),
    ],
  );
}
