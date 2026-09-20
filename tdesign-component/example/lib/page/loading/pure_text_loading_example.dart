import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'loading')
class PureTextLoadingExample extends StatelessWidget {
  const PureTextLoadingExample({super.key});

  /// 纯文字
  Widget _buildPureTextLoading(BuildContext context) =>
      const TLoading(icon: null, text: '加载中...');

  @override
  Widget build(BuildContext context) {
    return _buildPureTextLoading(context);
  }
}
