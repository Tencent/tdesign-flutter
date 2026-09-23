import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class DotMessageBadgeExample extends StatelessWidget {
  const DotMessageBadgeExample({super.key});

  Widget _buildDotMessageBadge(BuildContext context) => TBadge(
    variant: TBadgeVariant.dot,
    offset: const Offset(-1, 1),
    child: TText('消息', font: context.tTheme.fontBodyLarge),
  );

  Widget _buildDotIconBadge(BuildContext context) => const TBadge(
    variant: TBadgeVariant.dot,
    offset: Offset(-1, 1),
    child: Icon(TIcons.notification),
  );

  Widget _buildDotButtonBadge(BuildContext context) => TBadge(
    variant: TBadgeVariant.dot,
    offset: const Offset(-1, 1),
    child: TButton(
      size: TButtonSize.large,
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
      ),
      onPressed: () {},
      child: const Text('按钮'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Builder(builder: _buildDotMessageBadge),
        const SizedBox(width: 48),
        Builder(builder: _buildDotIconBadge),
        const SizedBox(width: 48),
        Builder(builder: _buildDotButtonBadge),
      ],
    );
  }
}
