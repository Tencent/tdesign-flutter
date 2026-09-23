import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'toast')
class VerticalIconToastExample extends StatelessWidget {
  const VerticalIconToastExample({super.key});

  Widget _buildVerticalIconToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带竖向图标'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showIconText(
            '带竖向图标',
            icon: TIcons.check_circle,
            direction: IconTextDirection.vertical,
            context: context,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVerticalIconToast(context);
  }
}
