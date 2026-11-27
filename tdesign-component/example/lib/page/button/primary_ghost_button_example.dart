import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

@ExampleCode(group: 'button')
class PrimaryGhostButtonExample extends StatelessWidget {
  const PrimaryGhostButtonExample({super.key});
  TButton _buildPrimaryGhostButton(BuildContext context) {
    return TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorPreset: TButtonColorPreset.primary,
      onPressed: () => _onTap(context),
      child: const Text('幽灵按钮'),
    );
  }

  TButton _buildDangerGhostButton(BuildContext context) {
    return TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorPreset: TButtonColorPreset.danger,
      onPressed: () => _onTap(context),
      child: const Text('幽灵按钮'),
    );
  }

  TButton _buildDefaultGhostButton(BuildContext context) {
    return TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.ghost,
      colorPreset: TButtonColorPreset.defaultTheme,
      onPressed: () => _onTap(context),
      child: const Text('幽灵按钮'),
    );
  }

  void _onTap(BuildContext context) {
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
