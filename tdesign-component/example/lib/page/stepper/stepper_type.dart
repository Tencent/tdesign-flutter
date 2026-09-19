part of 'stepper_page.dart';

extension _StepperTypeModule on _TStepperPageState {
  ExampleModule get _stepperTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '基础步进器',
        center: false,
        methodName: 'StepperBaseExample',
        builder: (_) => _container(const StepperBaseExample()),
      ),
    ],
  );
}
