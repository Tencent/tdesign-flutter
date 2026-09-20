import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radius')
class RadiusExtraLargeExample extends StatelessWidget {
  const RadiusExtraLargeExample({super.key});

  Widget _buildRadiusExtraLarge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusExtraLarge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRadiusExtraLarge(context);
  }
}
