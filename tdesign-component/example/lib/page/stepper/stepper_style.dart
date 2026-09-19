part of 'stepper_page.dart';

extension _StepperStyleModule on _TStepperPageState {
  ExampleModule get _stepperStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '步进器样式',
        center: false,
        methodName: 'StepperVariantsExample',
        builder: (_) => _container(const StepperVariantsExample()),
      ),
      ExampleItem(
        desc: '步进器尺寸',
        center: false,
        methodName: 'StepperSizesExample',
        builder: (_) => _container(const StepperSizesExample()),
      ),
    ],
  );
}
