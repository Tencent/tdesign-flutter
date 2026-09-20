import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'switch')
class SwitchLabelExample extends StatelessWidget {
  const SwitchLabelExample({super.key});

  Widget _buildLabel(BuildContext context) => const TCellGroup(
    cells: [
      TCell(
        title: Text('带文字开关'),
        note: SwitchLabelExampleStatefulSwitch(
          initialValue: true,
          variant: TSwitchVariant.text,
          openText: '开',
          closeText: '关',
        ),
      ),
      TCell(
        title: Text('带图标开关'),
        note: SwitchLabelExampleStatefulSwitch(
          initialValue: true,
          variant: TSwitchVariant.icon,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return _buildLabel(context);
  }
}

class SwitchLabelExampleStatefulSwitch extends StatefulWidget {
  const SwitchLabelExampleStatefulSwitch({
    super.key,
    this.initialValue = false,
    this.size,
    this.variant,
    this.openText,
    this.closeText,
  });

  final bool initialValue;
  final TSwitchSize? size;
  final TSwitchVariant? variant;
  final String? openText;
  final String? closeText;

  @override
  State<SwitchLabelExampleStatefulSwitch> createState() =>
      SwitchLabelExampleStatefulSwitchState();
}

class SwitchLabelExampleStatefulSwitchState
    extends State<SwitchLabelExampleStatefulSwitch> {
  late bool value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return TSwitch(
      value: value,
      size: widget.size,
      variant: widget.variant,
      openText: widget.openText,
      closeText: widget.closeText,
      onChanged: (next) => setState(() => value = next),
    );
  }
}
