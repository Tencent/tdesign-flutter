import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class BubbleBadgeExample extends StatelessWidget {
  const BubbleBadgeExample({super.key});

  Widget _buildBubbleBadge(BuildContext context) => TBadge(
    label: '领取积分',
    variant: TBadgeVariant.bubble,
    offset: const Offset(8, 0),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TButtonThemeData(shape: TButtonShape.square)),
      child: TButton(
        size: TButtonSize.large,
        icon: const Icon(TIcons.shop),
        onPressed: () {},
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildBubbleBadge(context);
  }
}
