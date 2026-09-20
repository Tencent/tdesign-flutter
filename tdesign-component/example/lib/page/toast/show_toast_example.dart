import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'toast')
class ShowToastExample extends StatelessWidget {
  const ShowToastExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('显示提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '轻提示文字内容',
            context: context,
            duration: TToast.infiniteDuration,
            toastId: 'manual-close-demo',
          );
        },
      ),
    );
  }
}
