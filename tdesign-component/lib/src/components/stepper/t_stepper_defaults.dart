import 't_stepper_types.dart';

// One geometry definition serves normal rendering and theme interpolation.
typedef StepperGeometry = ({
  double controlSize,
  double inputWidth,
  double iconSize,
  double fontSize,
});

StepperGeometry stepperGeometry(TStepperSize? size) => switch (size) {
  TStepperSize.small => (
    controlSize: 20,
    inputWidth: 34,
    iconSize: 12,
    fontSize: 10,
  ),
  TStepperSize.large => (
    controlSize: 26,
    inputWidth: 45,
    iconSize: 20,
    fontSize: 16,
  ),
  TStepperSize.medium ||
  null => (controlSize: 24, inputWidth: 38, iconSize: 16, fontSize: 12),
};

const stepperSpacing = 4.0;
const stepperBorderWidth = 1.0;
