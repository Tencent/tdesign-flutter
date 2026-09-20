import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'button')
class PrimaryGhostButtonExample extends StatefulWidget {
  const PrimaryGhostButtonExample({super.key});

  @override
  State<PrimaryGhostButtonExample> createState() =>
      _PrimaryGhostButtonExampleState();
}

class _PrimaryGhostButtonExampleState extends State<PrimaryGhostButtonExample> {
  TButton _buildPrimaryGhostButton(BuildContext context) {
    return TButton(
      child: const Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  TButton _buildDangerGhostButton(BuildContext context) {
    return TButton(
      child: const Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  TButton _buildDefaultGhostButton(BuildContext context) {
    return TButton(
      child: const Text('幽灵按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  void _onTap() {
    TToast.showText('点击了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      color: context.tTheme.grayColor14,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          Builder(builder: _buildPrimaryGhostButton),
          Builder(builder: _buildDangerGhostButton),
          Builder(builder: _buildDefaultGhostButton),
        ],
      ),
    );
  }
}
