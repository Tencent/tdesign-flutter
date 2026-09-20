import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'shadows')
class ShadowsMiddleExample extends StatelessWidget {
  const ShadowsMiddleExample({super.key});

  Widget _buildShadowsMiddle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsMiddle,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildShadowsMiddle(context);
  }
}
