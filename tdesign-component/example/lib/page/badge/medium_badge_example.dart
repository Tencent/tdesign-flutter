import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'badge')
class MediumBadgeExample extends StatelessWidget {
  const MediumBadgeExample({super.key});

  Widget _buildMediumBadge(BuildContext context) => const TBadge(
    label: '8',
    size: TBadgeSize.medium,
    child: TAvatar(
      size: TAvatarSize.medium,
      image: AssetImage('assets/img/t_avatar_1.png'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildMediumBadge(context);
  }
}
