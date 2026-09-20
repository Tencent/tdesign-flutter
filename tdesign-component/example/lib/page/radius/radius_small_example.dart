import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radius')
class RadiusSmallExample extends StatelessWidget {
  const RadiusSmallExample({super.key});

  Widget _buildRadiusSmall(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRadiusSmall(context);
  }
}
