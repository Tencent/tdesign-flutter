import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class SquareBadgeExample extends StatelessWidget {
  const SquareBadgeExample({super.key});

  Widget _buildSquareBadge(BuildContext context) => const TBadge(
    label: '8',
    variant: TBadgeVariant.square,
    offset: Offset(2, -2),
    child: Icon(TIcons.notification),
  );

  @override
  Widget build(BuildContext context) {
    return _buildSquareBadge(context);
  }
}
