import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'progress')
class ProgressMicroCircleExample extends StatelessWidget {
  const ProgressMicroCircleExample({super.key});

  Widget _buildMicroCircle(BuildContext context) {
    return TProgress(variant: TProgressVariant.microCircular, value: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMicroCircle(context);
  }
}
