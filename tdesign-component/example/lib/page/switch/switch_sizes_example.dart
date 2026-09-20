import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'switch')
class SwitchSizesExample extends StatelessWidget {
  const SwitchSizesExample({super.key});

  Widget _buildSizes(BuildContext context) => const TCellGroup(
    cells: [
      TCell(
        title: Text('大尺寸 32'),
        note: SwitchSizesExampleStatefulSwitch(
          initialValue: true,
          size: TSwitchSize.large,
        ),
      ),
      TCell(
        title: Text('中尺寸 28'),
        note: SwitchSizesExampleStatefulSwitch(initialValue: true),
      ),
      TCell(
        title: Text('小尺寸 24'),
        note: SwitchSizesExampleStatefulSwitch(
          initialValue: true,
          size: TSwitchSize.small,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return _buildSizes(context);
  }
}

class SwitchSizesExampleStatefulSwitch extends StatefulWidget {
  const SwitchSizesExampleStatefulSwitch({
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
  State<SwitchSizesExampleStatefulSwitch> createState() =>
      SwitchSizesExampleStatefulSwitchState();
}

class SwitchSizesExampleStatefulSwitchState
    extends State<SwitchSizesExampleStatefulSwitch> {
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
