import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class NumberMessageBadgeExample extends StatelessWidget {
  const NumberMessageBadgeExample({super.key});

  Widget _buildNumberMessageBadge(BuildContext context) => TBadge(
    label: '8',
    child: TText('消息', font: context.tTheme.fontBodyLarge),
  );

  Widget _buildNumberIconBadge(BuildContext context) =>
      const TBadge(label: '8', child: Icon(TIcons.notification));

  Widget _buildNumberButtonBadge(BuildContext context) => TBadge(
    label: '8',
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
        Builder(builder: _buildNumberMessageBadge),
        const SizedBox(width: 48),
        Builder(builder: _buildNumberIconBadge),
        const SizedBox(width: 48),
        Builder(builder: _buildNumberButtonBadge),
      ],
    );
  }
}
