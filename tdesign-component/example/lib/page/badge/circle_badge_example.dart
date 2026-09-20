import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class CircleBadgeExample extends StatelessWidget {
  const CircleBadgeExample({super.key});

  Widget _buildCircleBadge(BuildContext context) => const TBadge(
    label: '8',
    offset: Offset(2, -2),
    child: Icon(TIcons.notification),
  );

  @override
  Widget build(BuildContext context) {
    return _buildCircleBadge(context);
  }
}
