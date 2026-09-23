import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'checkbox')
class DisabledCheckboxExample extends StatelessWidget {
  const DisabledCheckboxExample({super.key});

  Widget _disabledCheckbox(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(variant: TCheckboxVariant.circle),
      ),
      child: const Column(
        children: [
          TCheckbox(value: true, title: '选项禁用-已选'),
          TCheckbox(value: false, title: '选项禁用-默认', showDivider: false),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _disabledCheckbox(context);
  }
}
