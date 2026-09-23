import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'empty')
class IconEmptyExample extends StatelessWidget {
  const IconEmptyExample({super.key});

  Widget _iconEmpty(BuildContext context) {
    return const TEmpty(emptyText: '描述文字');
  }

  @override
  Widget build(BuildContext context) {
    return _iconEmpty(context);
  }
}
