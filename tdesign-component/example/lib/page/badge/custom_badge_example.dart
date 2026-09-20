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
        color: context.tTheme.errorNormalColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TText(
        'NEW',
        font: context.tTheme.fontMarkExtraSmall,
        textColor: context.tTheme.textColorAnti,
      ),
    ),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TButtonThemeData(shape: TButtonShape.square)),
      child: TButton(
        size: TButtonSize.large,
        icon: const Icon(TIcons.notification),
        onPressed: () {},
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildCustomBadge(context);
  }
}
