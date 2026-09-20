import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'button')
class DefaultFillButtonExample extends StatefulWidget {
  const DefaultFillButtonExample({super.key});

  @override
  State<DefaultFillButtonExample> createState() =>
      _DefaultFillButtonExampleState();
}

class _DefaultFillButtonExampleState extends State<DefaultFillButtonExample> {
  TButton _buildDefaultFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  TButton _buildDefaultStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  TButton _buildDefaultTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.defaultTheme,
      onPressed: _onTap,
    );
  }

  TButton _buildPrimaryFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  TButton _buildPrimaryStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  TButton _buildPrimaryTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      onPressed: _onTap,
    );
  }

  TButton _buildDangerFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  TButton _buildDangerStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  TButton _buildDangerTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.danger,
      onPressed: _onTap,
    );
  }

  TButton _buildLightFillButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorScheme: TButtonColorScheme.light,
      onPressed: _onTap,
    );
  }

  TButton _buildLightStrokeButton(BuildContext context) {
    return TButton(
      child: const Text('描边按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.light,
      onPressed: _onTap,
    );
  }

  TButton _buildLightTextButton(BuildContext context) {
    return TButton(
      child: const Text('文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.light,
      onPressed: _onTap,
    );
  }

  void _onTap() {
    TToast.showText('点击了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Builder(builder: _buildDefaultFillButton),
        Builder(builder: _buildDefaultStrokeButton),
        Builder(builder: _buildDefaultTextButton),
        Builder(builder: _buildPrimaryFillButton),
        Builder(builder: _buildPrimaryStrokeButton),
        Builder(builder: _buildPrimaryTextButton),
        Builder(builder: _buildDangerFillButton),
        Builder(builder: _buildDangerStrokeButton),
        Builder(builder: _buildDangerTextButton),
        Builder(builder: _buildLightFillButton),
        Builder(builder: _buildLightStrokeButton),
        Builder(builder: _buildLightTextButton),
      ],
    );
  }
}
