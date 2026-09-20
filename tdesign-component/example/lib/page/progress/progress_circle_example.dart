import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'progress')
class ProgressCircleExample extends StatelessWidget {
  const ProgressCircleExample({super.key});

  Widget _buildCircle(BuildContext context) {
    return TProgress(variant: TProgressVariant.circular, value: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircle(context);
  }
}
