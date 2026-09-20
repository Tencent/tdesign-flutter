import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'toast')
class WarningToastExample extends StatelessWidget {
  const WarningToastExample({super.key});

  Widget _buildWarningToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('警告提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showWarning(
            '警告文案',
            direction: IconTextDirection.vertical,
            context: context,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWarningToast(context);
  }
}
