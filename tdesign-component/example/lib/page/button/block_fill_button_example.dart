import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'button')
class BlockFillButtonExample extends StatelessWidget {
  const BlockFillButtonExample({super.key});
  Widget _buildBlockFillButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('填充按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () => _onTap(context),
      ),
    );
  }

  void _onTap(BuildContext context) {
    TToast.showText('点击了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBlockFillButton(context);
  }
}
