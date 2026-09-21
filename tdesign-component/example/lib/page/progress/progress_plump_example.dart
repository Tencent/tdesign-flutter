import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'progress')
class ProgressPlumpExample extends StatelessWidget {
  const ProgressPlumpExample({super.key});

  Widget _buildPlump(BuildContext context) {
    return TProgress.plump(value: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlump(context);
  }
}
