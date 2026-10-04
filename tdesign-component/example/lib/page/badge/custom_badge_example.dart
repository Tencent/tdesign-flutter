import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class CustomBadgeExample extends StatelessWidget {
  const CustomBadgeExample({super.key});

  Widget _buildCustomBadge(BuildContext context) => TBadge.custom(
    badge: Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: context.tTheme.errorColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TText(
        'NEW',
        font: context.tTheme.fontMarkExtraSmall,
        style: TextStyle(color: context.tTheme.textColorAnti),
      ),
    ),
    child: TButton(
      shape: TButtonShape.square,
      size: TButtonSize.large,
      icon: const Icon(TIcons.notification),
      onPressed: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildCustomBadge(context);
  }
}
