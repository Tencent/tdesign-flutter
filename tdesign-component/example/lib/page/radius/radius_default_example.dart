import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radius')
class RadiusDefaultExample extends StatelessWidget {
  const RadiusDefaultExample({super.key});

  Widget _buildRadiusDefault(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.brandNormalColor,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRadiusDefault(context);
  }
}
