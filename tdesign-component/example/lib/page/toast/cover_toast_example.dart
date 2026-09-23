import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'toast')
class CoverToastExample extends StatelessWidget {
  const CoverToastExample({super.key});

  Widget _buildCoverToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('禁止滑动和点击'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '禁止滑动和点击',
            context: context,
            overlay: const TOverlayConfig(
              showOverlay: true,
              opacity: 0.4,
              preventTap: true,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCoverToast(context);
  }
}
