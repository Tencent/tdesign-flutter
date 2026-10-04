import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'button')
class RectangleIconButtonExample extends StatelessWidget {
  const RectangleIconButtonExample({super.key});
  TButton _buildRectangleIconButton(BuildContext context) {
    return TButton(
      child: const Text('填充按钮'),
      icon: const Icon(TIcons.app),
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

  TButton _buildLoadingIconButton(BuildContext context) {
    return TButton(
      child: const Text('加载中'),
      icon: const TLoading(size: 24, icon: TLoadingIcon.circle),
      size: TButtonSize.large,
      variant: TButtonVariant.fill,
      colorPreset: TButtonColorPreset.primary,
      onPressed: () => _onTap(context),
    );
  }

  void _onTap(BuildContext context) {
    TToast.showText('点击了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          Builder(builder: _buildRectangleIconButton),
          Builder(builder: _buildSquareIconButton),
          Builder(builder: _buildLoadingIconButton),
        ],
      ),
    );
  }
}
