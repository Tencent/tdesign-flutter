import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'button')
class LargeButtonExample extends StatelessWidget {
  const LargeButtonExample({super.key});
  TButton _buildLargeButton(BuildContext context) {
    return TButton(
      child: const Text('按钮48'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () => _onTap(context),
    );
  }

  TButton _buildMediumButton(BuildContext context) {
    return TButton(
      child: const Text('按钮40'),
      size: TButtonSize.medium,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () => _onTap(context),
    );
  }

  TButton _buildSmallButton(BuildContext context) {
    return TButton(
      child: const Text('按钮32'),
      size: TButtonSize.small,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () => _onTap(context),
    );
  }

  TButton _buildExtraSmallButton(BuildContext context) {
    return TButton(
      child: const Text('按钮28'),
      size: TButtonSize.extraSmall,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    TToast.showText('点击了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        children: [
          Builder(builder: _buildLargeButton),
          Builder(builder: _buildMediumButton),
          Builder(builder: _buildSmallButton),
          Builder(builder: _buildExtraSmallButton),
        ],
      ),
    );
  }
}
