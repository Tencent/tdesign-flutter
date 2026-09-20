import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'progress')
class ProgressLinearExample extends StatelessWidget {
  const ProgressLinearExample({super.key});

  Widget _buildLinear(BuildContext context) {
    return TProgress(variant: TProgressVariant.linear, value: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return _buildLinear(context);
  }
}
