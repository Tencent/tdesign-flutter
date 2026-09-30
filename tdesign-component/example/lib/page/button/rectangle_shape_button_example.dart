import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'button')
class RectangleShapeButtonExample extends StatelessWidget {
  const RectangleShapeButtonExample({super.key});
  Widget _buildRectangleShapeButton(BuildContext context) {
    return TButton(
      shape: TButtonShape.rectangle,
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorPreset: TButtonColorPreset.primary,
      onPressed: () => _onTap(context),
    );
  }

  Widget _buildSquareIconButton(BuildContext context) {
    return TButton(
      shape: TButtonShape.square,
      icon: const Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorPreset: TButtonColorPreset.primary,
      onPressed: () => _onTap(context),
    );
  }

  Widget _buildRoundButton(BuildContext context) {
    return TButton(
      shape: TButtonShape.round,
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorPreset: TButtonColorPreset.primary,
      onPressed: () => _onTap(context),
    );
  }

  Widget _buildCircleButton(BuildContext context) {
    return TButton(
      shape: TButtonShape.circle,
      icon: const Icon(TIcons.app),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorPreset: TButtonColorPreset.primary,
      onPressed: () => _onTap(context),
    );
  }

  Widget _buildBlockShapeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('填充按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.fill,
        colorPreset: TButtonColorPreset.primary,
        style: const ButtonStyle(
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        onPressed: () => _onTap(context),
      ),
    );
  }

  void _onTap(BuildContext context) {
    TToast.showText('点击了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 16,
            children: [
              Builder(builder: _buildRectangleShapeButton),
              Builder(builder: _buildSquareIconButton),
              Builder(builder: _buildRoundButton),
              Builder(builder: _buildCircleButton),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Builder(builder: _buildBlockShapeButton),
      ],
    );
  }
}
