import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'shadows')
class ShadowsTopExample extends StatelessWidget {
  const ShadowsTopExample({super.key});

  Widget _buildShadowsTop(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsTop,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildShadowsTop(context);
  }
}
