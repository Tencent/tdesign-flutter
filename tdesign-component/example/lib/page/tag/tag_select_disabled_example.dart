import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class TagSelectDisabledExample extends StatelessWidget {
  const TagSelectDisabledExample({super.key});

  Widget _buildSelectDisabled(BuildContext context) {
    return const TSelectTag('禁用标签', value: false, onChanged: null);
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelectDisabled(context);
  }
}
