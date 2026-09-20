import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'shadows')
class ShadowsBaseExample extends StatelessWidget {
  const ShadowsBaseExample({super.key});

  Widget _buildShadowsBase(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        boxShadow: context.tTheme.shadowsBase,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildShadowsBase(context);
  }
}
