import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radius')
class RadiusLargeExample extends StatelessWidget {
  const RadiusLargeExample({super.key});

  Widget _buildRadiusLarge(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRadiusLarge(context);
  }
}
