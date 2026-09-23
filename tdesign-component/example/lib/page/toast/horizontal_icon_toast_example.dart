import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'toast')
class HorizontalIconToastExample extends StatelessWidget {
  const HorizontalIconToastExample({super.key});

  Widget _buildHorizontalIconToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带横向图标'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showIconText(
            '带横向图标',
            icon: TIcons.check_circle,
            direction: IconTextDirection.horizontal,
            context: context,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalIconToast(context);
  }
}
